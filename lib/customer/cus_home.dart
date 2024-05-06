import 'dart:async';

import 'dart:math' show asin, atan2, cos, sin, sqrt;
import 'package:aquapro/customer/cus_maps.dart';
import 'package:aquapro/customer/cus_navbar.dart';
import 'package:aquapro/customer/cus_stores.dart';
import 'package:aquapro/customer/stores_near_you.dart';
import 'package:aquapro/pages/details.dart';
import 'package:aquapro/pages/signup%20copy.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: CusHome(),
    );
  }
}

class CusHome extends StatefulWidget {
  @override
  _CusHomeState createState() => _CusHomeState();
}

class _CusHomeState extends State<CusHome> {
  late Future<Map<String, double>> userCoordinatesFuture;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    userCoordinatesFuture = getUserCoordinates();
  }

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

        // Check if the user's coordinates are outside the specified radius
        final distance = calculateDistance(userCoordinates.latitude,
            userCoordinates.longitude, 13.158766356221083, 123.735861896286);
        if (distance > 3.0) {
          // Show a message if the user's location is out of coverage area
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Location Out of Coverage Area'),
              content: Text(
                  'Your location is more than 3 km away from the coverage area.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            ),
          );
        }
      }
    }
    return coordinates;
  }

  double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const p = 0.017453292519943295; // Convert degrees to radians
    final dLat = (lat2 - lat1) * p;
    final dLon = (lon2 - lon1) * p;
    final a = sin(dLat / 2) * sin(dLat / 2) +
        cos(lat1 * p) * cos(lat2 * p) * sin(dLon / 2) * sin(dLon / 2);
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));
    final distanceInKm = 6371 * c; // Radius of the Earth in kilometers
    return distanceInKm;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<Map<String, double>>(
        future: userCoordinatesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final userCoordinates = snapshot.data!;
          final userLatitude = userCoordinates['latitude'] ?? 0.0;
          final userLongitude = userCoordinates['longitude'] ?? 0.0;

          return SingleChildScrollView(
            child: PopScope(
              canPop: false,
              onPopInvoked: (bool didPop) {
                if (!didPop) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const CusNavbar()));
                }
              },
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height - 80,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xff81e6eb), Color(0xfffffff)],
                  ),
                ),
                child: Container(
                  margin:
                      const EdgeInsets.only(top: 35.0, left: 10.0, right: 10.0),
                  child: ListView(
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Browse",
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => CusMaps()));
                            },
                            child: Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(3),
                                  decoration: BoxDecoration(
                                      color: Colors.black,
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Icon(
                                    Icons.map_rounded,
                                    color: Colors.white,
                                    size: 40,
                                  ),
                                ),
                                Text(
                                  "Open Maps",
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 40),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Nearest Water Refilling Stations",
                            style: TextStyle(
                                fontSize: MediaQuery.of(context).size.width >
                                        490
                                    ? 20
                                    : MediaQuery.of(context).size.width < 490
                                        ? 18
                                        : 16,
                                fontWeight: FontWeight.bold),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => StoresNearYou()));
                            },
                            child: Text(
                              "View all>",
                              style: TextStyle(
                                  fontSize: MediaQuery.of(context).size.width >
                                          490
                                      ? 16
                                      : MediaQuery.of(context).size.width < 490
                                          ? 14
                                          : 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('Store')
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else {
                            final List<QueryDocumentSnapshot> stores =
                                snapshot.data!.docs;

                            // Sorting stores based on distance from user's location
                            stores.sort((a, b) {
                              final aLocation = a['coordinates'] as GeoPoint;
                              final bLocation = b['coordinates'] as GeoPoint;

                              final aDistance = calculateDistance(
                                  userLatitude,
                                  userLongitude,
                                  aLocation.latitude,
                                  aLocation.longitude);
                              final bDistance = calculateDistance(
                                  userLatitude,
                                  userLongitude,
                                  bLocation.latitude,
                                  bLocation.longitude);

                              return aDistance.compareTo(bDistance);
                            });

                            return SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: stores.sublist(0, 5).map((store) {
                                  final storeId = store['id'];
                                  final name = store['name'];
                                  final address = store['address'];
                                  final contact = store['contact'];
                                  final time = store['time'];
                                  final imageUrl = store['url'];
                                  final storeLocation = store['coordinates'];

                                  final distance = calculateDistance(
                                      userLatitude,
                                      userLongitude,
                                      storeLocation.latitude,
                                      storeLocation.longitude);

                                  return GestureDetector(
                                    onTap: () async {
                                      final productsSnapshot =
                                          await FirebaseFirestore.instance
                                              .collection('Store')
                                              .doc(store.id)
                                              .collection('Products')
                                              .get();
                                      final List<DocumentSnapshot> products =
                                          productsSnapshot.docs;
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => Stores(
                                            storeId: storeId,
                                            name: name,
                                            address: address,
                                            contact: contact,
                                            time: time,
                                            imageUrl: imageUrl,
                                            products: products,
                                          ),
                                        ),
                                      );
                                    },
                                    child: SizedBox(
                                      width:
                                          330, // Set a fixed width for the container
                                      child: Container(
                                        margin: EdgeInsets.all(5),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Color(0xff0EB4F3),
                                              width: 3),
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: Material(
                                          elevation: 5.0,
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          child: ConstrainedBox(
                                            constraints: BoxConstraints(
                                              minHeight: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              // Set a fixed height for the container
                                            ),
                                            child: Container(
                                              padding: EdgeInsets.all(15),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    alignment:
                                                        Alignment.topCenter,
                                                    width:
                                                        300, // Set a fixed width for the image container
                                                    height:
                                                        150, // Set a fixed height for the image container
                                                    child: imageUrl == null
                                                        ? Placeholder()
                                                        : Image.network(
                                                            imageUrl,
                                                            fit: BoxFit.cover,
                                                            // Adjust the fit to cover the container
                                                            width:
                                                                double.infinity,
                                                            height:
                                                                double.infinity,
                                                          ),
                                                  ),
                                                  SizedBox(height: 5.0),
                                                  Text(
                                                    name,
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  SizedBox(height: 5.0),
                                                  Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Icon(Icons.location_on,
                                                          color:
                                                              Color(0xff0EB4F3),
                                                          size: 30),
                                                      SizedBox(width: 8),
                                                      Container(
                                                        constraints:
                                                            BoxConstraints(
                                                                maxWidth: 240),
                                                        child: Text(
                                                          address,
                                                          style: TextStyle(
                                                              fontSize: 16),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                  SizedBox(height: 12.0),
                                                  Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      SizedBox(width: 2),
                                                      Container(
                                                        constraints:
                                                            BoxConstraints(
                                                                maxWidth: 25,
                                                                minWidth: 25,
                                                                minHeight: 25),
                                                        decoration: BoxDecoration(
                                                            color: Color(
                                                                0xff0EB4F3),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20)),
                                                        child: Icon(Icons.phone,
                                                            color: Colors.white,
                                                            size: 20),
                                                      ),
                                                      SizedBox(width: 13),
                                                      Container(
                                                        constraints:
                                                            BoxConstraints(
                                                                maxWidth: 240),
                                                        child: Text(
                                                          contact,
                                                          style: TextStyle(
                                                              fontSize: 16),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                  SizedBox(height: 12.0),
                                                  Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Container(
                                                        child: Icon(
                                                            Icons.access_time,
                                                            color: Color(
                                                                0xff0EB4F3),
                                                            size: 30),
                                                      ),
                                                      SizedBox(width: 10),
                                                      Container(
                                                        constraints:
                                                            BoxConstraints(
                                                                maxWidth: 240),
                                                        child: Text(
                                                          time,
                                                          style: TextStyle(
                                                              fontSize: 16),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                  SizedBox(height: 15.0),
                                                  Row(
                                                    children: [
                                                      Container(
                                                        child: Icon(
                                                            Icons
                                                                .social_distance,
                                                            color: Color(
                                                                0xff0EB4F3),
                                                            size: 30),
                                                      ),
                                                      SizedBox(width: 10),
                                                      Text(
                                                        '${distance >= 1 ? "${distance.toStringAsFixed(2)} km" : "${(distance * 1000).toStringAsFixed(0)} meters"} away from you',
                                                        style: TextStyle(
                                                            fontSize: 16),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            );
                          }
                        },
                      ),
                      SizedBox(height: 40),
                      Text(
                        "Categories",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 20),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Details()));
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
                                        minWidth: 120, maxWidth: 120),
                                    padding: EdgeInsets.all(5),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          alignment: Alignment.topCenter,
                                          width: MediaQuery.of(context)
                                              .size
                                              .height,
                                          child: Image.asset("images/flat.png",
                                              fit: BoxFit.fill),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 15.0),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Details()));
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
                                        minWidth: 120, maxWidth: 120),
                                    padding: EdgeInsets.all(5),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          alignment: Alignment.topCenter,
                                          width: MediaQuery.of(context)
                                              .size
                                              .height,
                                          child: Image.asset("images/round.png",
                                              fit: BoxFit.fill),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 15.0),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Details()));
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
                                        minWidth: 120, maxWidth: 120),
                                    padding: EdgeInsets.all(5),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          alignment: Alignment.topCenter,
                                          width: MediaQuery.of(context)
                                              .size
                                              .height,
                                          child: Image.asset("images/small.png",
                                              fit: BoxFit.fill),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
