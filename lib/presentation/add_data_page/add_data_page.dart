// ignore_for_file: non_constant_identifier_names
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socrates/presentation/add_data_page/bloc/add_data_location_cubit.dart';
import 'package:socrates/presentation/add_data_page/bloc/add_data_location_state.dart';
import 'package:socrates/presentation/add_data_page/service/location_firebase_service.dart';
import 'package:socrates/presentation/add_data_page/service/add_data_location_service.dart';
import 'package:socrates/presentation/add_data_page/service/location_storage_service.dart';

// this is the add data page as we can see where enumerator mainly will spend their time to add the data.
class AddData extends StatelessWidget {
  const AddData({super.key});
  @override
  Widget build(BuildContext context) {
    // this is the future builder which is used to get the shared preferences of the app and then build the widget according to the shared preferences.
    return FutureBuilder<SharedPreferences>(
      future: SharedPreferences.getInstance(),
      builder: (context, snapshot) {
        // this shows the circular progress indicator if the data is not loaded yet but has the data.
        if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        // this is the location service which is used to get the location of the user.
        final locationService = AddDataLocationService();
        // this is the firebase service which is used to communicate with the firebase services.
        final firebaseService = FirebaseService();
        // this is the storage service which is used to store the geofence data of that particular enumerators assigned geofence.
        final storageService = StorageService(snapshot.data!);

        return BlocProvider(
          create: (context) => AddDataLocationCubit(
            addDataLocationService: locationService,
            storageService: storageService,
            firebaseService: firebaseService,
          )..loadGeofence(),
          child: _AddDataContent(),
        );
      },
    );
  }
}

// this the main add data where the user will interact with the app to add the data.
class _AddDataContent extends StatefulWidget {
  @override
  State<_AddDataContent> createState() => _AddDataContentState();
}

// this is the state of the add data content where the user will interact with the app to add the data.
class _AddDataContentState extends State<_AddDataContent> {
  // this is the user which is used to get the current user of the app.
  final User? user = FirebaseAuth.instance.currentUser;
  final _formKey = GlobalKey<FormState>();
  String name = "", studentID = "", programID = "";
  double? GPA;
  bool _isOverrideRequested = false;

  AddDataLocationService locationService = AddDataLocationService();

  // Helper methods to update field values
  void getName(String value) => setState(() => name = value);
  void getStudentID(String value) => setState(() => studentID = value);
  void getProgramID(String value) => setState(() => programID = value);
  void getGPA(String value) => setState(() => GPA = double.tryParse(value));
  // this is the method which is used to show the geofence warning dialog to the user if the user is outside the geofence.
  void _showGeofenceWarningDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Outside Geofence'),
          content: const Text(
            'You are currently outside the designated geofence. '
            'Do you want to override and submit data anyway?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _isOverrideRequested = true;
                });
                Navigator.of(context).pop(); // Close dialog
                createData(); // Attempt to create data
              },
              child: const Text('Override'),
            ),
          ],
        );
      },
    );
  }

  // this is the method which is used to create the data and save it to the firestore.
  Future<void> createData() async {
    // this checks if the form is valid or not and if the form is not valid then it returns nothing and if the form is valid then it continues.
    if (!_formKey.currentState!.validate()) return;
    // this gets the current location state of the user.
    final locationState = context.read<AddDataLocationCubit>().state;
    // this checks if the user is inside the geofence or not and if the user is not inside the geofence then it shows the geofence warning dialog to the user.
    if (locationState.isInside == false && !_isOverrideRequested) {
      _showGeofenceWarningDialog();
      return;
    }
    // this is the entry id which is used to store the data in the firestore.
    final entryId =
        FirebaseFirestore.instance.collection("collectedInformation").doc().id;

    // Get current position directly using Geolocator
    Position? currentPosition;
    try {
      currentPosition = await Geolocator.getCurrentPosition();
    } catch (e) {
      if (kDebugMode) {
        print('Error getting current position: $e');
      }
    }
    bool isInsideGeofence = locationState.isInside ?? false;
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    DocumentReference enumeratorRef =
        _firestore.collection('Enumerators').doc(user?.uid);
    if (kDebugMode) {
      print("Enumerator ID: ${enumeratorRef.id}");
    }
    // this
    final userDoc =
        await _firestore.collection('Enumerators').doc(user?.uid).get();

    // Get the reference to the assigned geofence from the array
    final assignedGeofences = userDoc.data()?['assignedGeofences'] as List?;
    // Get the first geofence reference from the array
    final geofenceRef = assignedGeofences?.first as DocumentReference?;

    // Prepare the data to save
    final collectedData = {
      "enumeratorId": user?.uid,
      "enumeratorRef": enumeratorRef,
      "location": {
        "latitude": currentPosition?.latitude,
        "longitude": currentPosition?.longitude,
      },
      "timestamp": Timestamp.now(),
      "isInsideGeofence": isInsideGeofence,
      "geofenceRef": geofenceRef,
      "data": {
        "name": name,
        "studentID": studentID,
        "programID": programID,
        "gpa": GPA ?? 0.0,
      },
    };

    // Save data to Firestore
    await FirebaseFirestore.instance
        .collection("collectedInformation")
        .doc(entryId)
        .set(collectedData)
        .then((_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          locationState.isInside == true
              ? 'Data saved successfully!'
              : 'Data saved with geofence override',
        ),
      ));
    });

    // Resets form fields
    setState(() {
      _isOverrideRequested = false;
      name = "";
      studentID = "";
      programID = "";
      GPA = null;
    });
    _formKey.currentState!.reset();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Data'),
        actions: [
          // this button is used to check the location of the user and show the status of the location to the user,it means if the user is inside the geofence or not.
          IconButton(
            icon: const Icon(Icons.location_on),
            onPressed: () {
              context.read<AddDataLocationCubit>().checkLocation();
              if (kDebugMode) {
                print("Location checked");
              }
            },
          ),
        ],
      ),
      body: BlocBuilder<AddDataLocationCubit, LocationState>(
        builder: (context, locationState) {
          Widget geofenceStatusWidget = Container();
          if (locationState.isInside != null) {
            geofenceStatusWidget = Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                locationState.isInside!
                    ? 'You are inside the geofence'
                    : 'You are outside the geofence',
                style: TextStyle(
                  color: locationState.isInside! ? Colors.green : Colors.red,
                ),
                textAlign: TextAlign.center,
              ),
            );
          }

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    geofenceStatusWidget,
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Enter your name',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                      ),
                      validator: (value) => value == null || value.isEmpty
                          ? 'Name is required'
                          : null,
                      onChanged: getName,
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Enter Student ID',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                      ),
                      validator: (value) => value == null || value.isEmpty
                          ? 'Student ID is required'
                          : null,
                      onChanged: getStudentID,
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Enter Program ID',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                      ),
                      validator: (value) => value == null || value.isEmpty
                          ? 'Program ID is required'
                          : null,
                      onChanged: getProgramID,
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Enter GPA',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'GPA is required';
                        }
                        if (double.tryParse(value) == null) {
                          return 'GPA must be a valid number';
                        }
                        return null;
                      },
                      onChanged: getGPA,
                    ),
                    const SizedBox(height: 20),
                    // this is the button which is used to save the data to the firestore.
                    ElevatedButton(
                      onPressed: () {
                        // this makes sure that the user checked the geofence before saving the data to the firestore.
                        if (locationState.isInside == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Please check your location first'),
                            ),
                          );
                          context.read<AddDataLocationCubit>().checkLocation();
                          return;
                        }
                        // if everything goes according to the plan, then boom the data is saved to the firestore.
                        createData();
                      },
                      child: const Text('Save'),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
