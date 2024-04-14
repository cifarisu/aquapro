import 'package:aquapro/widget/constants.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

class CusTracking extends StatefulWidget {
  const CusTracking({Key? key}) : super(key: key);

  @override
  State<CusTracking> createState() => CusTrackingState();
}

class CusTrackingState extends State<CusTracking> {
  final Completer<GoogleMapController> _controller = Completer();

  LatLng? customerLocation;
  LatLng? riderLocation;

  late LocationData currentLocation;
  late String currentUserId;

  late StreamSubscription<LocationData> _locationSubscription;

  Set<Polyline> _polylines = {};

  PolylinePoints polylinePoints = PolylinePoints();

  late Timer _timer;

  @override
  void initState() {
    super.initState();
    getCurrentUserId();
    getCurrentLocation();
    // Start timer to periodically update rider's location
    _timer = Timer.periodic(Duration(seconds: 7), (timer) {
      getCustomerAndRiderLocations();
    });
  }

  @override
  void dispose() {
    super.dispose();
    _locationSubscription.cancel();
    // Cancel the timer when the widget is disposed
    _timer.cancel();
  }

  void getCurrentUserId() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        currentUserId = user.uid;
      });
    }
  }

  void getCurrentLocation() async {
    Location location = Location();

    try {
      currentLocation = await location.getLocation();
    } catch (e) {
      print("Error getting current location: $e");
    }

    _locationSubscription = location.onLocationChanged.listen((newLoc) {
      setState(() {
        currentLocation = newLoc;
      });
    });
  }

  Future<void> getCustomerAndRiderLocations() async {
    try {
      // Fetch customer's coordinates
      DocumentSnapshot customerSnapshot = await FirebaseFirestore.instance
          .collection('Customer')
          .doc(currentUserId)
          .get();

      if (customerSnapshot.exists) {
        var customerGeoPoint = customerSnapshot['coordinates'];
        if (customerGeoPoint != null) {
          setState(() {
            customerLocation = LatLng(
              customerGeoPoint.latitude,
              customerGeoPoint.longitude,
            );
          });

          // Fetch rider's ID
          String riderId = await fetchRiderId();

          // Fetch rider's location based on the retrieved ID
          DocumentSnapshot riderSnapshot = await FirebaseFirestore.instance
              .collection('Tracking')
              .doc(riderId)
              .get();

          if (riderSnapshot.exists) {
            var riderGeoPoint = riderSnapshot['currentLocation'];
            if (riderGeoPoint != null) {
              setState(() {
                riderLocation = LatLng(
                  riderGeoPoint.latitude,
                  riderGeoPoint.longitude,
                );
              });
            } else {
              print('Rider coordinates not found');
            }

            if (customerLocation != null && riderLocation != null) {
              await _getPolylines();
              await _adjustCameraPosition();
            }
          } else {
            print('Rider data not found');
          }
        } else {
          print('Coordinates not found for customer');
        }
      } else {
        print('Customer data not found');
      }
    } catch (e, stackTrace) {
      print('Failed to fetch data: $e');
      print('Stack Trace: $stackTrace');
    }
  }

  Future<String> fetchRiderId() async {
    try {
      // Fetch the rider's ID from the Tracking collection using the customer's ID
      QuerySnapshot riderSnapshot =
          await FirebaseFirestore.instance.collection('Tracking').get();

      for (QueryDocumentSnapshot riderDoc in riderSnapshot.docs) {
        // Iterate over each rider's document
        Map<String, dynamic> customerDetails = riderDoc['customerDetails'];
        if (customerDetails != null) {
          // If customerDetails exists
          for (String orderId in customerDetails.keys) {
            // Iterate over each subcollection under customerDetails
            Map<String, dynamic> orderData = customerDetails[orderId];
            if (orderData['id'] == currentUserId) {
              // If the customer's ID is found in this subcollection
              return riderDoc.id; // Return the rider's ID
            }
          }
        }
      }
      print('Tracking data not found for the customer');
      return '';
    } catch (e) {
      print('Failed to fetch rider ID: $e');
      return '';
    }
  }

  Future<void> _getPolylines() async {
    try {
      PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        google_api_key,
        PointLatLng(customerLocation!.latitude, customerLocation!.longitude),
        PointLatLng(riderLocation!.latitude, riderLocation!.longitude),
      );

      if (result.points.isNotEmpty) {
        result.points.forEach((PointLatLng point) {
          _polylines.add(Polyline(
            polylineId: PolylineId('route'),
            color: Colors.blue,
            points: result.points
                .map((e) => LatLng(e.latitude, e.longitude))
                .toList(),
            width: 5,
          ));
        });
      }
    } catch (e) {
      print("Failed to get polylines: $e");
    }
  }

  Future<void> _adjustCameraPosition() async {
    final LatLngBounds bounds = LatLngBounds(
      southwest: LatLng(
        customerLocation!.latitude,
        customerLocation!.longitude,
      ),
      northeast: LatLng(
        riderLocation!.latitude,
        riderLocation!.longitude,
      ),
    );
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newLatLngBounds(bounds, 100));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Track order",
          style: TextStyle(color: Colors.black, fontSize: 16),
        ),
      ),
      body: Stack(
        children: <Widget>[
          if (customerLocation != null && riderLocation != null)
            GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: CameraPosition(
                target: LatLng(
                  (customerLocation!.latitude + riderLocation!.latitude) / 2,
                  (customerLocation!.longitude + riderLocation!.longitude) / 2,
                ),
                zoom: 15,
              ),
              markers: {
                Marker(
                  markerId: MarkerId('customer'),
                  position: customerLocation!,
                  icon: BitmapDescriptor.defaultMarkerWithHue(
                      BitmapDescriptor.hueGreen),
                ),
                Marker(
                  markerId: MarkerId('rider'),
                  position: riderLocation!,
                  icon: BitmapDescriptor.defaultMarkerWithHue(
                      BitmapDescriptor.hueRed),
                ),
              },
              polylines: _polylines,
              onMapCreated: (mapController) {
                _controller.complete(mapController);
              },
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await getCustomerAndRiderLocations();
        },
        child: Icon(Icons.refresh),
      ),
    );
  }
}
