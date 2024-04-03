import 'package:aquapro/pages/login.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';

class RiderSelection extends StatefulWidget {
  const RiderSelection({Key? key});

  @override
  State<RiderSelection> createState() => _RiderSelectionState();
}

class _RiderSelectionState extends State<RiderSelection> {
  late String? currentUserId;

  @override
  void initState() {
    super.initState();
    getCurrentUserId();
  }

  void getCurrentUserId() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        currentUserId = user.uid;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xff81e6eb), Color(0xffffffff)]),
        ),
        child: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('Store').snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
              return Center(child: Text('No stores available'));
            }

            // Display stores
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                var store = snapshot.data!.docs[index];
                return Container(
                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 10),
                      Text(
                        'Store ID: ${store.id}',
                        style: TextStyle(fontSize: 14),
                      ),
                      Text(
                        'Store Name: ${store['name']}',
                        style: TextStyle(fontSize: 14),
                      ),
                      Text(
                        'Location: ${store['address']}',
                        style: TextStyle(fontSize: 14),
                      ),
                      // Add more store information here as needed
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          TextButton(
                            onPressed: () {
                              // Get the selected store ID
                              String storeId = snapshot.data!.docs[index].id;

                              // Update Firestore document with current user's information under the selected store
                              FirebaseFirestore.instance
                                  .collection('Store')
                                  .doc(storeId)
                                  .collection('Riders')
                                  .doc(currentUserId)
                                  .set({
                                // Here you can add additional user information if needed
                                'userId': currentUserId,
                              }).then((value) {
                                // Add the store's ID to Rider collection
                                FirebaseFirestore.instance
                                    .collection('Rider')
                                    .doc(currentUserId)
                                    .set({
                                  'storeId': storeId,
                                  // Add more fields as needed
                                }, SetOptions(merge: true)).then((_) {
                                  // Success
                                  print(
                                      'User added to store and Rider collection successfully');
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => LogIn()),
                                  );
                                }).catchError((error) {
                                  // Error handling
                                  print(
                                      'Failed to add user to Rider collection: $error');
                                });
                              }).catchError((error) {
                                // Error handling
                                print('Failed to add user to store: $error');
                              });
                            },
                            child: Text(
                              'Select Store',
                              style: TextStyle(color: Colors.blue),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: RiderSelection(),
  ));
}
