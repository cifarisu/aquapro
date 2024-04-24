import 'package:aquapro/widget/constants.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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

  BitmapDescriptor riderMarkerImage = BitmapDescriptor.defaultMarker;

  late String googleApiKey = google_api_key; // Your Google API Key

  @override
  void initState() {
    super.initState();
    getCurrentUserId();
    getCurrentLocation();
    _loadRiderMarkerImage(); // Load rider marker image
    // Start timer to periodically update rider's location and ETA
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

              // Fetch ETA using Directions API
              String eta = await fetchETA();

              // Calculate distance between customer and rider
              double distanceInMeters = await Geolocator.distanceBetween(
                customerLocation!.latitude,
                customerLocation!.longitude,
                riderLocation!.latitude,
                riderLocation!.longitude,
              );

              // Convert distance to kilometers
              double distanceInKm = distanceInMeters / 1000;

              // Show distance and ETA in a snackbar
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor:
                      Colors.lightBlue, // Set background color to light blue
                  elevation:
                      8, // Add elevation for a more pronounced appearance
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8), // Rounded corners
                  ),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Rider is ${distanceInKm < 1 ? distanceInMeters.toInt().toString() + ' meters' : distanceInKm.toStringAsFixed(2) + ' km'} away from you\nETA: $eta',
                        style:
                            TextStyle(color: Colors.white), // White text color
                      ),
                      SizedBox(height: 5),
                      Text(
                        'Note: Time may vary as the rider has multiple deliveries.',
                        style: TextStyle(
                            fontSize: 12,
                            color: Colors.white70), // Light gray text color
                      ),
                    ],
                  ),
                ),
              );

              if (customerLocation != null && riderLocation != null) {
                await _getPolylines();
                await _adjustCameraPosition();
              }
            } else {
              print('Rider coordinates not found');
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

  Future<String> fetchETA() async {
    try {
      // Fetch directions from Google Maps Directions API
      final response = await http.get(Uri.parse(
          'https://maps.googleapis.com/maps/api/directions/json?origin=${customerLocation!.latitude},${customerLocation!.longitude}&destination=${riderLocation!.latitude},${riderLocation!.longitude}&key=$googleApiKey'));

      if (response.statusCode == 200) {
        // Parse the JSON response
        Map<String, dynamic> data = json.decode(response.body);
        // Extract duration from the response
        int durationInSeconds =
            data['routes'][0]['legs'][0]['duration']['value'];
        // Convert duration to minutes
        int minutes = (durationInSeconds / 60).ceil();

        // Calculate distance between customer and rider
        double distanceInMeters = await Geolocator.distanceBetween(
          customerLocation!.latitude,
          customerLocation!.longitude,
          riderLocation!.latitude,
          riderLocation!.longitude,
        );
        // Convert distance to kilometers
        double distanceInKm = distanceInMeters / 1000;

        // Calculate ETA Interval
        String etaInterval;
        if (distanceInKm < 0.2) {
          // If distance is less than 0.2km, show a custom message
          etaInterval =
              "💧 Stay hydrated, your delivery is just around the corner!";
        } else if (minutes < 5) {
          // If ETA is less than 5 minutes, show as "Less than 5 minutes"
          etaInterval = "Less than 5 minutes";
        } else {
          // Otherwise, show the interval in 5-minute increments
          int lowerBound = ((minutes ~/ 5) * 5); // Lower bound of the interval
          int upperBound = lowerBound + 5; // Upper bound of the interval
          etaInterval = "$lowerBound-$upperBound minutes";
        }

        return etaInterval;
      } else {
        // Error handling
        print('Failed to fetch ETA: ${response.statusCode}');
        return 'N/A';
      }
    } catch (e) {
      // Error handling
      print('Failed to fetch ETA: $e');
      return 'N/A';
    }
  }

  Future<void> _getPolylines() async {
    try {
      PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        googleApiKey,
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
    double distanceInMeters = await Geolocator.distanceBetween(
      customerLocation!.latitude,
      customerLocation!.longitude,
      riderLocation!.latitude,
      riderLocation!.longitude,
    );

    if (distanceInMeters > 1000) {
      // If distance is greater than 1km, adjust camera to show both customer and rider
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
    } else {
      // If distance is less than or equal to 1km, focus only on customer and rider without zooming out too far
      final GoogleMapController controller = await _controller.future;
      controller.animateCamera(CameraUpdate.newLatLngZoom(
        LatLng(
          (customerLocation!.latitude + riderLocation!.latitude) / 2,
          (customerLocation!.longitude + riderLocation!.longitude) / 2,
        ),
        17, // Zoom level 17
      ));
    }
  }

  // Load rider marker image
  void _loadRiderMarkerImage() async {
    // Load the image for rider marker
    riderMarkerImage = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(devicePixelRatio: 2.5),
      'images/Badge.png',
    );
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
                if (riderLocation !=
                    null) // Add rider marker only if riderLocation is not null
                  Marker(
                    markerId: MarkerId('rider'),
                    position: riderLocation!,
                    icon: riderMarkerImage, // Use custom rider marker image
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
