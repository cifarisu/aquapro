import 'dart:async';
import 'package:aquapro/widget/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RiderTracking extends StatefulWidget {
  const RiderTracking({Key? key}) : super(key: key);

  @override
  State<RiderTracking> createState() => RiderTrackingState();
}

class RiderTrackingState extends State<RiderTracking> {
  final Completer<GoogleMapController> _controller = Completer();

  List<LatLng> locations = []; // Now this will be populated from Firebase
  List<List<LatLng>> polylineCoordinates = [];
  LocationData? currentLocation;
  BitmapDescriptor sourceIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor destinationIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor currentLocationIcon = BitmapDescriptor.defaultMarker;

  bool showMap = false; // Add this line
  late String? currentUserId;

  @override
  void initState() {
    super.initState();
    getCurrentUserId();
    getCurrentLocation(); // Start getting current location
    setCustomMarker(); // Set custom marker for current location
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
      LocationData locationData = await location.getLocation();
      setState(() {
        currentLocation = locationData;
      });
    } catch (e) {
      print("Error getting current location: $e");
    }

    location.onLocationChanged.listen((newLoc) async {
      setState(() {
        currentLocation = newLoc;
      });

      GoogleMapController googleMapController = await _controller.future;

      googleMapController.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
          zoom: 16,
          target: LatLng(newLoc.latitude!, newLoc.longitude!),
        ),
      ));
    });
  }

  void getPolyPoints() async {
    PolylinePoints polylinePoints = PolylinePoints();

    List<LatLng> route = [];
    for (int i = 0; i < locations.length - 1; i++) {
      LatLng source = locations[i];
      LatLng destination = locations[i + 1];

      PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        google_api_key,
        PointLatLng(source.latitude, source.longitude),
        PointLatLng(destination.latitude, destination.longitude),
      );

      if (result.points.isNotEmpty) {
        result.points.forEach(
          (PointLatLng point) =>
              route.add(LatLng(point.latitude, point.longitude)),
        );
      }
    }

    polylineCoordinates.add(route);
    setState(() {});
  }

  void setCustomMarker() {
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration.empty, "images/Badge.png")
        .then(
      (icon) {
        currentLocationIcon = icon;
      },
    );
  }

  Future<void> getLocationsFromFirebase() async {
    print('Fetching data from Firebase...');
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('Tracking')
          .where('riderId', isEqualTo: currentUserId)
          .get();

      Map<String, dynamic>? data = snapshot.docs.isNotEmpty
          ? snapshot.docs.first.data() as Map<String, dynamic>?
          : null;

      if (data != null) {
        var indexedNodes = data['indexedNodes'];
        var result = data['result'];

        if (indexedNodes != null && result != null) {
          print('indexedNodes: $indexedNodes');
          print('result: $result');

          List<LatLng> unorderedLocations = [];
          for (var node in indexedNodes.values) {
            unorderedLocations.add(LatLng(node.latitude, node.longitude));
          }

          var bestRoute = result['Best Route'];
          print('Best Route: $bestRoute');

          for (var index in bestRoute) {
            locations.add(unorderedLocations[index]);
          }

          var runningTime = result['Running Time'];
          print('Running Time: $runningTime');

          var totalDistance = result['Total Distance'];
          print('Total Distance: $totalDistance');

          getPolyPoints();
        } else {
          print('Indexed nodes or result is null');
        }
      } else {
        print('No data found in document');
      }

      print('Finished fetching data from Firebase');
    } catch (e) {
      print('Failed to fetch data from Firebase: $e');
    }
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
      body: showMap
          ? Stack(
              children: <Widget>[
                Container(
                  height: 500,
                  width: 500,
                  child: GoogleMap(
                    mapType: MapType.normal,
                    initialCameraPosition: CameraPosition(
                        target: LatLng(currentLocation!.latitude!,
                            currentLocation!.longitude!),
                        zoom: 13),
                    polylines: {
                      for (List<LatLng> route in polylineCoordinates)
                        Polyline(
                          polylineId: PolylineId("route"),
                          points: route,
                          color: primaryColor,
                          width: 6,
                        ),
                    },
                    markers: {
                      if (currentLocation != null)
                        Marker(
                          markerId: MarkerId("currentLocation"),
                          icon: currentLocationIcon,
                          position: LatLng(currentLocation!.latitude!,
                              currentLocation!.longitude!),
                        ),
                      for (LatLng location in locations)
                        Marker(
                          markerId: MarkerId(location.toString()),
                          icon: destinationIcon,
                          position: location,
                        )
                    },
                    onMapCreated: (mapController) {
                      if (!_controller.isCompleted) {
                        _controller.complete(mapController);
                      }
                    },
                  ),
                ),
                Positioned(
                  bottom: 50,
                  right: 10,
                  child: FloatingActionButton(
                    onPressed: () async {
                      await getLocationsFromFirebase();
                      getPolyPoints();
                    },
                    child: Icon(Icons.refresh),
                  ),
                ),
              ],
            )
          : Center(
              child: ElevatedButton(
                onPressed: () async {
                  await getLocationsFromFirebase();
                  getPolyPoints();
                  setState(() {
                    showMap = true;
                  });
                },
                child: Text('View Results'),
              ),
            ),
    );
  }
}
