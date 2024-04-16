import 'dart:math' show cos, sqrt, asin;

import 'package:aquapro/customer/cus_stores.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import FirebaseAuth if not already imported

class StoresNearYou extends StatefulWidget {
  const StoresNearYou({Key? key});

  @override
  State<StoresNearYou> createState() => _StoresNearYouState();
}

class _StoresNearYouState extends State<StoresNearYou> {
  final FirebaseAuth _auth = FirebaseAuth.instance; // Initialize FirebaseAuth
  double maxDistance = 3.0; // Maximum distance in kilometers
  bool sortByDistance = true; // Initially sort by shortest distance

  // Function to calculate distance between two coordinates using Haversine formula
  double distance(double lat1, double lon1, double lat2, double lon2) {
    const p = 0.017453292519943295;
    final a = 0.5 -
        cos((lat2 - lat1) * p) / 2 +
        cos(lat1 * p) * cos(lat2 * p) * (1 - cos((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a)); // 2 * R; R = 6371 km
  }

  // Method to get the currently logged-in user's coordinates
  Future<Map<String, double>> getUserCoordinates() async {
    Map<String, double> coordinates = {};
    final User? user = _auth.currentUser;
    if (user != null) {
      final userData = await FirebaseFirestore.instance
          .collection('Customer')
          .doc(user.uid)
          .get();
      final userCoordinates = userData['coordinates'] as GeoPoint?;
      if (userCoordinates != null) {
        coordinates['latitude'] = userCoordinates.latitude;
        coordinates['longitude'] = userCoordinates.longitude;
      }
    }
    return coordinates;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        shadowColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0,
        titleSpacing: -3,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back_ios_new_outlined,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.transparent,
        title: Text(
          "Stores Near You",
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              sortByDistance ? Icons.arrow_upward : Icons.arrow_downward,
              color: Colors.black,
            ),
            onPressed: () {
              setState(() {
                // Toggle sorting order
                sortByDistance = !sortByDistance;
              });
            },
          ),
        ],
      ),
      body: FutureBuilder(
        future: getUserCoordinates(),
        builder: (context, AsyncSnapshot<Map<String, double>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final userCoordinates = snapshot.data!;
          final userLatitude = userCoordinates['latitude'] ?? 0.0;
          final userLongitude = userCoordinates['longitude'] ?? 0.0;
          return Container(
            padding: EdgeInsets.only(top: 90),
            alignment: Alignment.topLeft,
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xff81e6eb), Color(0xffffffff)]),
            ),
            child: Column(
              children: [
                SizedBox(height: 20),
                Text(
                  "Max Distance: ${maxDistance.toStringAsFixed(1)} km",
                  style: TextStyle(fontSize: MediaQuery.of(context).size.width*0.033, //16
                   fontWeight: FontWeight.w500),
                ),
                Slider(
                  value: maxDistance,
                  min: 0.5,
                  max: 10.0,
                  divisions: 19,
                  label: maxDistance.toStringAsFixed(2),
                  onChanged: (value) {
                    setState(() {
                      maxDistance = value;
                    });
                  },
                ),
                SizedBox(height: 15),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.only(left: 40, right: 40, top: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.white,
                    ),
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('Store')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        }
                        if (snapshot.hasError) {
                          return Center(
                              child: Text('Error: ${snapshot.error}'));
                        }
                        final List<DocumentSnapshot> stores =
                            snapshot.data!.docs;
                        stores.sort((store1, store2) {
                          final storeLocation1 =
                              store1['coordinates'] as GeoPoint;
                          final storeLatitude1 = storeLocation1.latitude;
                          final storeLongitude1 = storeLocation1.longitude;
                          final dist1 = distance(
                            userLatitude,
                            userLongitude,
                            storeLatitude1,
                            storeLongitude1,
                          );

                          final storeLocation2 =
                              store2['coordinates'] as GeoPoint;
                          final storeLatitude2 = storeLocation2.latitude;
                          final storeLongitude2 = storeLocation2.longitude;
                          final dist2 = distance(
                            userLatitude,
                            userLongitude,
                            storeLatitude2,
                            storeLongitude2,
                          );

                          // Sort by shortest to longest distance if sortByDistance is true, otherwise longest to shortest
                          return sortByDistance
                              ? dist1.compareTo(dist2)
                              : dist2.compareTo(dist1);
                        });

                        final filteredStores = stores.where((store) {
                          final storeLocation =
                              store['coordinates'] as GeoPoint;
                          final storeLatitude = storeLocation.latitude;
                          final storeLongitude = storeLocation.longitude;
                          final dist = distance(
                            userLatitude,
                            userLongitude,
                            storeLatitude,
                            storeLongitude,
                          );
                          return dist <= maxDistance;
                        }).toList();
                        return ListView.builder(
                          padding: EdgeInsets.only(top: 10),
                          itemCount: filteredStores.length,
                          itemBuilder: (context, index) {
                            final store = filteredStores[index];
                            final storeId = store['id'];
                            final name = store['name'];
                            final address = store['address'];
                            final contact = store['contact'];
                            final time = store['time'];
                            final imageUrl = store['url'];

                            final storeLocation =
                                store['coordinates'] as GeoPoint;
                            final storeLatitude = storeLocation.latitude;
                            final storeLongitude = storeLocation.longitude;
                            final distanceToStore = distance(
                              userLatitude,
                              userLongitude,
                              storeLatitude,
                              storeLongitude,
                            );

                            return GestureDetector(
                              onTap: () async {
                                final productsSnapshot = await store.reference
                                    .collection('Products')
                                    .get();
                                final List<DocumentSnapshot> products =
                                    productsSnapshot.docs;
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Stores(
                                      name: name,
                                      address: address,
                                      contact: contact,
                                      time: time,
                                      imageUrl: imageUrl,
                                      products: products,
                                      storeId: storeId,
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                margin: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Color(0xff0EB4F3), width: 3),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Material(
                                  elevation: 5.0,
                                  borderRadius: BorderRadius.circular(20),
                                  child: Container(
                                    constraints: BoxConstraints(
                                        minWidth: 330, maxWidth: 330),
                                    padding: EdgeInsets.all(20),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          alignment: Alignment.topCenter,
                                          width: MediaQuery.of(context)
                                              .size
                                              .height,
                                          child: SizedBox(
                                            width: 330,
                                            height: 200,
                                            child: Image.network(
                                              imageUrl,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 5.0),
                                        Text(
                                          name,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontFamily: 'Times New Roman',
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(height: 5.0),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Icon(Icons.location_on,
                                                color: Color(0xff0EB4F3),
                                                size: 30),
                                            SizedBox(width: 8),
                                            Container(
                                              constraints:
                                                  BoxConstraints(maxWidth: 240),
                                              child: Text(
                                                address,
                                                style: TextStyle(
                                                    fontFamily: 'Callibri',
                                                    fontSize: MediaQuery.of(context).size.width*0.027,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            )
                                          ],
                                        ),
                                        SizedBox(height: 12.0),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(width: 2),
                                            Container(
                                              constraints: BoxConstraints(
                                                  maxWidth: 25,
                                                  minWidth: 25,
                                                  minHeight: 25),
                                              decoration: BoxDecoration(
                                                  color: Color(0xff0EB4F3),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20)),
                                              child: Icon(Icons.phone,
                                                  color: Colors.white,
                                                  size: 20),
                                            ),
                                            SizedBox(width: 13),
                                            Container(
                                              constraints:
                                                  BoxConstraints(maxWidth: 240),
                                              child: Text(
                                                contact,
                                                style: TextStyle(
                                                    fontFamily: 'Callibri',
                                                    fontSize: 13,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            )
                                          ],
                                        ),
                                        SizedBox(height: 12.0),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              child: Icon(Icons.access_time,
                                                  color: Color(0xff0EB4F3),
                                                  size: 30),
                                            ),
                                            SizedBox(width: 10),
                                            Container(
                                              constraints:
                                                  BoxConstraints(maxWidth: 230),
                                              child: Text(
                                                time,
                                                style: TextStyle(
                                                    fontFamily: 'Callibri',
                                                    fontSize: 13,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            )
                                          ],
                                        ),
                                        SizedBox(height: 10.0),
                                        Row(
                                          children: [
                                            Container(
                                              child: Icon(Icons.social_distance,
                                                  color: Color(0xff0EB4F3),
                                                  size: 30),
                                            ),
                                            SizedBox(width: 10,),
                                            Text(
                                              "Distance: ${distanceToStore.toStringAsFixed(2)} km",
                                              style: TextStyle(
                                                  fontFamily: 'Callibri',
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),

                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
