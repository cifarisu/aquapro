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

  List<LatLng> locations = [];
  List<List<LatLng>> polylineCoordinates = [];
  LocationData? currentLocation;
  BitmapDescriptor sourceIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor destinationIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor currentLocationIcon = BitmapDescriptor.defaultMarker;

  bool showMap = false;
  late String? currentUserId;
  int currentRouteIndex = 0;

  late StreamSubscription<LocationData> _locationSubscription;

  @override
  void initState() {
    super.initState();
    getCurrentUserId();
    getCurrentLocation();
    setCustomMarker();
  }

  @override
  void dispose() {
    super.dispose();
    _locationSubscription
        .cancel(); // Cancel the subscription when the widget is disposed
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

    _locationSubscription = location.onLocationChanged.listen((newLoc) async {
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

    polylineCoordinates.clear();

    for (int i = 0; i < locations.length - 1; i++) {
      LatLng source = locations[i];
      LatLng destination = locations[i + 1];

      try {
        PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
          google_api_key,
          PointLatLng(source.latitude, source.longitude),
          PointLatLng(destination.latitude, destination.longitude),
        );

        List<LatLng> route = [];

        if (result.points.isNotEmpty) {
          result.points.forEach(
            (PointLatLng point) =>
                route.add(LatLng(point.latitude, point.longitude)),
          );
        } else {
          print(
              "Failed to get route between ${source.toString()} and ${destination.toString()}");
        }

        polylineCoordinates.add(route);
      } catch (e, stackTrace) {
        print("Error getting polyline points: $e");
        print("Stack Trace: $stackTrace");
      }
    }

    setState(() {});
  }

  void setCustomMarker() {
    BitmapDescriptor.fromAssetImage(
      ImageConfiguration.empty,
      "images/Badge.png",
    ).then((icon) {
      currentLocationIcon = icon;
    });
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

          var sortedKeys = indexedNodes.keys.toList()..sort();

          List<LatLng> unorderedLocations = [];
          for (var key in sortedKeys) {
            var node = indexedNodes[key];
            unorderedLocations.add(LatLng(node.latitude, node.longitude));
          }

          var bestRoute = result['Best Route'];
          print('Best Route: $bestRoute');

          for (var index in bestRoute) {
            locations.add(unorderedLocations[index]);
          }

          getPolyPoints();
        } else {
          print('Indexed nodes or result is null');
        }
      } else {
        print('No data found in document');
      }

      print('Finished fetching data from Firebase');
    } catch (e, stackTrace) {
      print('Failed to fetch data from Firebase: $e');
      print('Stack Trace: $stackTrace');
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
                if (currentLocation != null) // Null check added here
                  GoogleMap(
                    mapType: MapType.normal,
                    initialCameraPosition: CameraPosition(
                      target: LatLng(
                          currentLocation!.latitude!,
                          currentLocation!
                              .longitude!), // Accessing properties after null check
                      zoom: 13,
                    ),
                    polylines: {
                      for (int i = 0; i <= currentRouteIndex; i++)
                        if (polylineCoordinates.length > i &&
                            polylineCoordinates[i].isNotEmpty)
                          Polyline(
                            polylineId: PolylineId("route$i"),
                            points: polylineCoordinates[i],
                            color: Colors.blue,
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
                        ),
                    },
                    onMapCreated: (mapController) {
                      if (!_controller.isCompleted) {
                        _controller.complete(mapController);
                      }
                    },
                  ),
                Positioned(
                  bottom: 50,
                  right: 10,
                  child: Row(
                    children: <Widget>[
                      IconButton(
                        onPressed: () {
                          if (currentRouteIndex > 0) {
                            setState(() {
                              currentRouteIndex--;
                            });
                          } else {
                            // Loop back to the end of the sequence
                            setState(() {
                              currentRouteIndex = locations.length - 1;
                            });
                          }
                        },
                        icon: Icon(Icons.arrow_back),
                      ),
                      SizedBox(width: 10),
                      IconButton(
                        onPressed: () {
                          if (currentRouteIndex < locations.length - 1) {
                            setState(() {
                              currentRouteIndex++;
                            });
                          } else {
                            // Loop back to the beginning of the sequence
                            setState(() {
                              currentRouteIndex = 0;
                            });
                          }
                        },
                        icon: Icon(Icons.arrow_forward),
                      ),
                    ],
                  ),
                ),
              ],
            )
          : Center(
              child: ElevatedButton(
                onPressed: () async {
                  await getLocationsFromFirebase();
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
