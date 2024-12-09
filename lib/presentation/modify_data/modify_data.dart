// ignore_for_file: non_constant_identifier_names

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// this is used to modify the data which is collected by the enumerator.
class ModifyData extends StatefulWidget {
  // this is the key which is used to identify the widget.
  final String documentId;
  // constructor of the modify data which takes the document id as the parameter.
  const ModifyData({super.key, required this.documentId});

  @override
  State<ModifyData> createState() => _ModifyDataState();
}

class _ModifyDataState extends State<ModifyData> {
  // this is the current user of the app.
  final User? user = FirebaseAuth.instance.currentUser;
  // these are the current text editing controllers which are used to get the text from the text fields.
  late TextEditingController nameController;
  late TextEditingController studentIDController;
  late TextEditingController programIDController;
  late TextEditingController GPAController;
  final _formKey = GlobalKey<FormState>();
  late Future<void> fetchDataFuture;

    // this is the init state of the modify data which initializes the text editing controllers and fetches the data from the firestore.
  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    studentIDController = TextEditingController();
    programIDController = TextEditingController();
    GPAController = TextEditingController();
    fetchDataFuture = fetchData();
  }

  // this is the method which is used to delete the data from the firestore.
  void _deleteData(){
    FirebaseFirestore.instance
        .collection("collectedInformation")
        .doc(widget.documentId)
        .delete()
        .then((_) {
      if(!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Data deleted successfully!')),
      );
      Navigator.pop(context);
      Navigator.pop(context);
    });
  }
  // this is the method which is used to confirm the delete of the data. as deleting the data is a critical operation so we need to confirm the delete operation.
  void _confirmDelete(){
    showDialog(context: context, builder: (BuildContext context){
      return AlertDialog(
        title: const Text('Delete Data'),
        content: const Text('Are you sure you want to delete this data?'),
        actions: [
          TextButton(
            onPressed: (){
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
          // if the user confirms the delete operation then the data will be deleted from the firestore.
          TextButton(
            onPressed: (){
              // calls the delete data method to delete the data from the firestore.
              _deleteData();
            },
            child: const Text('Delete'),
          ),
        ],
      );
    },
    );
  }

  // this is the method which is used to fetch the data from the firestore.
  Future<void> fetchData() async {
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection("collectedInformation")
        .doc(widget.documentId)
        .get();

    // Assuming the data is nested under the 'data' field
    Map<String, dynamic> dataMap = documentSnapshot['data'] ?? {};

    setState(() {
      nameController.text = dataMap['name'] ?? '';
      studentIDController.text = dataMap['studentID'] ?? '';
      programIDController.text = dataMap['programID'] ?? '';
      GPAController.text = dataMap['gpa']?.toString() ?? '0.0';
    });
  }
  // this is the method which is used to update the data in the firestore.
  void updateData() {
    if (_formKey.currentState!.validate()) {
      FirebaseFirestore.instance
          .collection("collectedInformation")
          .doc(widget.documentId)
          .update({
        'enumeratorId': user?.uid,
        'data': {
          'name': nameController.text,
          'studentID': studentIDController.text,
          'programID': programIDController.text,
          'gpa': double.parse(GPAController.text),
        }
      }).then((_) {
        if(!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Data updated successfully!')),
        );
        Navigator.pop(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Modify Data'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (String result) {
              if (result == 'delete') {
                _confirmDelete();
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'delete',
                child: Text('Delete'),
              ),
            ],
          ),
        ],
      ),

      body: FutureBuilder(
        future: fetchDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: nameController,
                      decoration: InputDecoration(
                        labelText: 'Enter your name',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                          borderSide: const BorderSide(),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: studentIDController,
                      decoration: InputDecoration(
                        labelText: 'Student ID',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                          borderSide: const BorderSide(),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a student ID';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: programIDController,
                      decoration: InputDecoration(
                        labelText: 'Program ID',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                          borderSide: const BorderSide(),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a program ID';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: GPAController,
                      decoration: InputDecoration(
                        labelText: 'GPA',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                          borderSide: const BorderSide(),
                        ),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a GPA';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: updateData,
                      child: const Text('Save'),
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
  
  // this is the dispose method which is used to dispose the text editing controllers to free up the resources.
  @override
  void dispose() {
    nameController.dispose();
    studentIDController.dispose();
    programIDController.dispose();
    GPAController.dispose();
    super.dispose();
  }
}