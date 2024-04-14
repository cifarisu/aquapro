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
      getRiderLocation();
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
      DocumentSnapshot customerSnapshot = await FirebaseFirestore.instance
          .collection('Customer')
          .doc(currentUserId) // Replace with actual customer ID
          .get();

      DocumentSnapshot riderSnapshot = await FirebaseFirestore.instance
          .collection('Tracking')
          .doc('mSOM7n2ZYSRUBegnn4KLP4LsH9m1') // Replace with actual rider ID
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
        } else {
          print('Coordinates not found for customer');
        }
      } else {
        print('Customer data not found');
      }

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
      } else {
        print('Rider data not found');
      }

      if (customerLocation != null && riderLocation != null) {
        await _getPolylines();
        // Adjust map camera position to show both customer and rider markers
        await _adjustCameraPosition();
      }
    } catch (e, stackTrace) {
      print('Failed to fetch data: $e');
      print('Stack Trace: $stackTrace');
    }
  }

  Future<void> getRiderLocation() async {
    try {
      DocumentSnapshot riderSnapshot = await FirebaseFirestore.instance
          .collection('Tracking')
          .doc('mSOM7n2ZYSRUBegnn4KLP4LsH9m1') // Replace with actual rider ID
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
      } else {
        print('Rider data not found');
      }

      if (customerLocation != null && riderLocation != null) {
        await _getPolylines();
        // Adjust map camera position to show both customer and rider markers
        await _adjustCameraPosition();
      }
    } catch (e) {
      print('Failed to fetch rider location: $e');
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
