import 'dart:async';
import 'dart:math' show asin, cos, pi, pow, sin, sqrt;

import 'package:aquapro/customer/cus_stores.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CusMaps extends StatefulWidget {
  const CusMaps({Key? key}) : super(key: key);

  @override
  State<CusMaps> createState() => _CusMapsState();
}

class _CusMapsState extends State<CusMaps> {
  List<LatLng> originalCoordinatesList = [];
  List<LatLng> filteredCoordinatesList = [];
  Completer<GoogleMapController> _controller = Completer();
  LatLng? currentUserLocation; // Current user's location
  double filterRadius = 3.0; // Initial filter radius in kilometers
  Set<Marker> markers = {}; // Set to hold markers

  @override
  void initState() {
    super.initState();
    _fetchCoordinatesFromFirestore();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text('View Water Stations'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Stack(
          children: [
            GoogleMap(
              initialCameraPosition: currentUserLocation != null
                  ? CameraPosition(
                      target: currentUserLocation!,
                      zoom: 17,
                    )
                  : CameraPosition(
                      target: LatLng(13.139211621744149, 123.73457236435291),
                      zoom: 17,
                    ),
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
              markers: markers,
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Slider(
                        value: filterRadius,
                        min: 0.5,
                        max: 10.0,
                        divisions: 19,
                        label: filterRadius.toString(),
                        onChanged: (value) {
                          setState(() {
                            filterRadius = value;
                          });
                        },
                      ),
                    ),
                    Text('${filterRadius.toStringAsFixed(1)} km'),
                    ElevatedButton(
                      onPressed: _applyFilter,
                      child: const Text('Apply Filter'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );

  Future<void> _fetchCoordinatesFromFirestore() async {
    try {
      // Set the initial filter radius to 3.0 km
      filterRadius = 3.0;

      // Get current user's UID
      String uid = FirebaseAuth.instance.currentUser!.uid;

      // Get the document from Firestore for the current user
      DocumentSnapshot<Map<String, dynamic>> userDoc =
          await FirebaseFirestore.instance.collection('Customer').doc(uid).get();

      // Extract coordinates from the document
      GeoPoint? userGeoPoint = userDoc.data()?['coordinates'];
      if (userGeoPoint != null) {
        setState(() {
          currentUserLocation =
              LatLng(userGeoPoint.latitude, userGeoPoint.longitude);
        });
      }

      // Now fetch store coordinates
      QuerySnapshot<Map<String, dynamic>> snapshot =
          await FirebaseFirestore.instance.collection('Store').get();

      // Extract coordinates from the snapshot
      List<GeoPoint> geoPoints = snapshot.docs
          .map((doc) => doc.data()?['coordinates'] as GeoPoint?)
          .where((geoPoint) => geoPoint != null)
          .map((geoPoint) => geoPoint!)
          .toList();

      setState(() {
        originalCoordinatesList = geoPoints
            .map((geoPoint) =>
                LatLng(geoPoint.latitude, geoPoint.longitude))
            .toList();
        // Initially set filtered list to original list
        filteredCoordinatesList = List.from(originalCoordinatesList);
      });

      if (currentUserLocation != null) {
        // Adjust camera position based on the user's coordinates
        final GoogleMapController controller = await _controller.future;
        controller.animateCamera(
          CameraUpdate.newLatLng(currentUserLocation!),
        );
      }

      // Apply filter to show only locations within the specified radius
      await _applyFilter();
    } catch (error) {
      // Handle error while fetching coordinates
      print('Error fetching coordinates: $error');
    }
  }

  // Calculate distance between two LatLng points using Haversine formula
double _calculateDistance(LatLng point1, LatLng point2) {
  const double earthRadius = 6371.0; // Earth's radius in kilometers
  double lat1Radians = point1.latitude * pi / 180.0;
  double lon1Radians = point1.longitude * pi / 180.0;
  double lat2Radians = point2.latitude * pi / 180.0;
  double lon2Radians = point2.longitude * pi / 180.0;

  double lonDiff = lon2Radians - lon1Radians;
  double latDiff = lat2Radians - lat1Radians;

  double a = pow(sin(latDiff / 2), 2) +
      cos(lat1Radians) * cos(lat2Radians) * pow(sin(lonDiff / 2), 2);
  double c = 2 * asin(sqrt(a));

  return earthRadius * c;
}


  // Apply filter to show only locations within the specified radius of the current user
  Future<void> _applyFilter() async {
    if (currentUserLocation != null) {
      setState(() {
        // Filter the original list based on the current filter radius
        filteredCoordinatesList = originalCoordinatesList
            .where((coord) =>
                _calculateDistance(currentUserLocation!, coord) <= filterRadius)
            .toList();
      });

      // Update markers on the map
      _updateMarkers();
    }
  }

  // Update markers on the map based on the filtered coordinatesList
  void _updateMarkers() {
    setState(() {
      // Clear existing markers
      markers.clear();
      // Add new markers based on the filtered coordinatesList
      for (var latLng in filteredCoordinatesList) {
        markers.add(
          Marker(
            markerId: MarkerId(latLng.toString()),
            position: latLng,
            onTap: () {
              _navigateToStoreDetails(latLng);
            },
          ),
        );
      }
    });
  }

  void _navigateToStoreDetails(LatLng storeLocation) async {
    // Find the store closest to the tapped marker
    GeoPoint storeGeoPoint =
        GeoPoint(storeLocation.latitude, storeLocation.longitude);
    QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance
        .collection('Store')
        .where('coordinates', isEqualTo: storeGeoPoint)
        .limit(1)
        .get();
    if (snapshot.docs.isNotEmpty) {
      DocumentSnapshot<Map<String, dynamic>> storeDoc = snapshot.docs.first;
      // Extract store details
      String storeName = storeDoc['name'];
      String storeId = storeDoc['id'];
      String storeAddress = storeDoc['address'];
      String storeContact = storeDoc['contact'];
      String storeTime = storeDoc['time'];
      String storeImageUrl = storeDoc['url'];

      // Check if the "Products" subcollection exists
      QuerySnapshot productsSnapshot = await FirebaseFirestore.instance.collection('Store').doc(storeDoc.id).collection('Products').get();
      List<DocumentSnapshot> products = productsSnapshot.docs;

      // Navigate to Stores widget with store details
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Stores(
            name: storeName,
            storeId: storeId,
            address: storeAddress,
            contact: storeContact,
            time: storeTime,
            imageUrl: storeImageUrl,
            products: products,
            
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the widget tree
    _controller.future.then((controller) {
      controller.dispose();
    });
    super.dispose();
  }
}

void main() {
  runApp(MaterialApp(
    home: CusMaps(),
  ));
}
