import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:socrates/presentation/add_data_page/add_data_page.dart';
import 'package:socrates/presentation/modify_data/modify_data.dart';

// this is the data page which is used to show the data to the user which is collected by the enumerator and when clicked on the data it will take the user to the modify data page where the user can modify the data.
class DataPage extends StatefulWidget {
  const DataPage({super.key});

  @override
  State<DataPage> createState() => _DataPageState();
}

class _DataPageState extends State<DataPage> {
  // this is the boolean which is used to show or hide the floating action button according to the user scroll.
  bool isFabVisible = true;

  @override
  Widget build(BuildContext context) {
    // this is the user which is used to get the current user of the app.
    final User? user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        // this is the stream which is used to get the data from the firestore and show it to the user. here we are getting the data from the collectedInformation collection where the enumeratorId is equal to the current user id. so only shwoing the data collected by the current user. and not by other user.
        stream: FirebaseFirestore.instance
            .collection("collectedInformation")
            .where("enumeratorId",
                isEqualTo: user?.uid) // Filter by enumeratorId
            .snapshots(),

        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          // this handles the error if there is any error in the stream.
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }
          // this shows the circular progress indicator if the data is not loaded yet but has the data.
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          // NotificationListener listens to the user scroll and shows or hides the floating action button according to the user scroll.
          return NotificationListener<UserScrollNotification>(
            onNotification: (notification) {
              // show the floating action button if the user is scrolling up and hide the floating action button if the user is scrolling down.
              if (notification.direction == ScrollDirection.forward) {
                if (!isFabVisible) {
                  setState(() {
                    isFabVisible = true;
                  });
                }
              } else if (notification.direction == ScrollDirection.reverse) {
                if (isFabVisible) {
                  setState(() {
                    isFabVisible = false;
                  });
                }
              }
              return true;
            },
            child: ListView.builder(
              // this is the listview builder which is used to build the list of data and show it to the user.
              // item count is the length of the data that is collected by the user.
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                //fetch the data from the snapshot and show it to the user.
                DocumentSnapshot documentSnapshot = snapshot.data!.docs[index];
                var data = documentSnapshot['data'];
                return ListTile(
                  title: Text("${data['name']}"),
                  // this is the onTap which is used to take the user to the modify data page where the user can modify the data.
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ModifyData(
                          documentId: documentSnapshot.id,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          );
        },
      ),
      // this is the floating action button which is used to take the user to the add data page where the user can add the data.
      floatingActionButton: isFabVisible
          ? FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddData(),
                  ),
                );
              },
              child: const Icon(Icons.add),
            )
          : null, // this null is used to hide the floating action button when the user is scrolling down.
    );
  }
}
