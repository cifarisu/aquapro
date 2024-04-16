import 'package:flutter/material.dart';
import 'dart:async';
import 'package:aquapro/widget/constants.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'rider_navbar.dart'; // import RiderHome.dart file

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
  late Timer _timer;
  late NavigatorState _navigator;

  @override
  void initState() {
    super.initState();
    getCurrentUserId();
    getCurrentLocation();
    setCustomMarker();
    startLocationTimer();
  }

  @override
  void dispose() {
    super.dispose();
    _locationSubscription.cancel();
    _timer.cancel();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _navigator = Navigator.of(context);
  }

  void startLocationTimer() {
    _timer = Timer.periodic(Duration(seconds: 5), (timer) {
      if (currentLocation != null && currentUserId != null) {
        saveCurrentLocationToFirebase(currentLocation!, currentUserId!);
      }
    });
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
      bool serviceEnabled = await location.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await location.requestService();
        if (!serviceEnabled) {
          return;
        }
      }

      PermissionStatus permissionGranted = await location.hasPermission();
      if (permissionGranted == PermissionStatus.denied) {
        permissionGranted = await location.requestPermission();
        if (permissionGranted != PermissionStatus.granted) {
          return;
        }
      }

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

      if (_controller.isCompleted) {
        GoogleMapController googleMapController = await _controller.future;
        googleMapController.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(
            zoom: 16,
            target: LatLng(newLoc.latitude!, newLoc.longitude!),
          ),
        ));
      }
    });
  }

  Future<void> saveCurrentLocationToFirebase(
      LocationData locationData, String userId) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Tracking')
          .where('riderId', isEqualTo: userId)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot documentSnapshot = querySnapshot.docs.first;
        String documentId = documentSnapshot.id;

        await FirebaseFirestore.instance
            .collection('Tracking')
            .doc(documentId)
            .update({
          'currentLocation':
              GeoPoint(locationData.latitude!, locationData.longitude!)
        });
        print('Current location saved to Firebase: $locationData');
      } else {
        print('No document found for riderId: $userId');
      }
    } catch (e) {
      print('Error saving current location to Firebase: $e');
    }
  }

  void setCustomMarker() {
    BitmapDescriptor.fromAssetImage(
      ImageConfiguration.empty,
      "images/Badge.png",
    ).then((icon) {
      currentLocationIcon = icon;
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

  Future<void> deleteDeliveryDocument() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Tracking')
          .where('riderId', isEqualTo: currentUserId)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot documentSnapshot = querySnapshot.docs.first;
        String documentId = documentSnapshot.id;

        await FirebaseFirestore.instance
            .collection('Tracking')
            .doc(documentId)
            .delete();
        print('Delivery document deleted from Firestore');
      } else {
        print('No document found for riderId: $currentUserId');
      }
    } catch (e) {
      print('Error deleting delivery document: $e');
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
                GoogleMap(
                  mapType: MapType.normal,
                  initialCameraPosition: CameraPosition(
                    target: LatLng(
                      currentLocation?.latitude ?? 0.0,
                      currentLocation?.longitude ?? 0.0,
                    ),
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
                        position: LatLng(
                          currentLocation!.latitude!,
                          currentLocation!.longitude!,
                        ),
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
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(1),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: IconButton(
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
                      ),
                      SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text('Confirm End Delivery'),
                              content: Text(
                                  'Are you sure you want to end the delivery?'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    await deleteDeliveryDocument();
                                    Navigator.of(context).pop();
                                    // Navigate to RiderNavBar after confirming end of delivery
                                    _navigator.pushReplacement(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                RiderNavbar()));
                                  },
                                  child: Text('Confirm'),
                                ),
                              ],
                            ),
                          );
                        },
                        child: Text('End Delivery'),
                      ),
                      SizedBox(width: 10),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(1),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: IconButton(
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
