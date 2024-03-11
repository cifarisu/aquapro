import 'dart:async';
import 'package:aquapro/widget/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OrderTrackingPage extends StatefulWidget {
  const OrderTrackingPage({Key? key}) : super(key: key);

  @override
  State<OrderTrackingPage> createState() => OrderTrackingPageState();
}

class OrderTrackingPageState extends State<OrderTrackingPage> {
  final Completer<GoogleMapController> _controller = Completer();

  List<LatLng> locations = []; // Now this will be populated from Firebase

  List<List<LatLng>> polylineCoordinates = [];
  LocationData? currentLocation;

  BitmapDescriptor sourceIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor destinationIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor currentLocationIcon = BitmapDescriptor.defaultMarker; 

  bool showMap = false; // Add this line

  @override
  void initState() {
    getCurrentLocation();
    setCustomMarker();
    super.initState();
  }

  void getCurrentLocation() async {
    Location location = Location();

    location.getLocation().then((locationData) {
      setState(() {
        currentLocation = locationData;
      });
    });

    location.onLocationChanged.listen((newLoc) async {
      setState(() {
        currentLocation = newLoc;
      });

      GoogleMapController googleMapController = await _controller.future;

      googleMapController.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
          zoom: 18,
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

      PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(google_api_key, PointLatLng(source.latitude, source.longitude),
      PointLatLng(destination.latitude, destination.longitude),
      );

      if (result.points.isNotEmpty){
        result.points.forEach((PointLatLng point) => route.add(LatLng(point.latitude, point.longitude)),);
      }
    }

    polylineCoordinates.add(route);
    setState(() {});
  }

  void setCustomMarker(){
    BitmapDescriptor.fromAssetImage(ImageConfiguration.empty, "images/Pin_source.png").then((icon){
      sourceIcon = icon;

    },
    );
    BitmapDescriptor.fromAssetImage(ImageConfiguration.empty, "images/Pin_destination.png").then((icon){
      destinationIcon = icon;

    },
    );
    BitmapDescriptor.fromAssetImage(ImageConfiguration.empty, "images/Badge.png").then((icon){
      currentLocationIcon = icon;

    },
    );
  }

  Future<void> getLocationsFromFirebase() async {
    print('Fetching data from Firebase...');
    try {
      final doc = await FirebaseFirestore.instance.collection('results').doc('Shop-1,Group1').get();
      var data = doc.data();
      if (data != null) {
        var indexedNodes = data['indexedNodes']; // assuming 'indexedNodes' is the field name in Firestore
        var result = data['result']; // assuming 'result' is the field name in Firestore

        print('indexedNodes: $indexedNodes');
        print('result: $result');

        // assuming each node in 'indexedNodes' is a GeoPoint
        List<LatLng> unorderedLocations = [];
        for (var node in indexedNodes.values) {
          unorderedLocations.add(LatLng(node.latitude, node.longitude));
        }

        // assuming 'Best Route' in 'result' is an array of numbers
        var bestRoute = result['Best Route'];
        print('Best Route: $bestRoute');

        // Create a new list of locations in the sequence specified by 'Best Route'
        for (var index in bestRoute) {
          locations.add(unorderedLocations[index]);
        }

        // assuming 'Running Time' in 'result' is a number
        var runningTime = result['Running Time'];
        print('Running Time: $runningTime');

        // assuming 'Total Distance' in 'result' is a number
        var totalDistance = result['Total Distance'];
        print('Total Distance: $totalDistance');

        // Call getPolyPoints after fetching locations from Firebase
        getPolyPoints();
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
      body: showMap ? Stack(
        children: <Widget>[
          Container(
            height: 500, // Set the height to your desired value
            width: 500, // Set the width to your desired value
            child: GoogleMap(
              mapType: MapType.normal, 
              initialCameraPosition: CameraPosition(
                target: LatLng(currentLocation!.latitude!, currentLocation!.longitude!), zoom: 18),
              polylines: {
                for (List<LatLng> route in polylineCoordinates)
                  Polyline(
                    polylineId: PolylineId("route"),
                    points: route,
                    color: primaryColor,
                    width:6,
                  ),
              },
              markers: {
                if (currentLocation != null) 
                  Marker(
                    markerId: MarkerId("currentLocation"),
                    icon: currentLocationIcon,
                    position: LatLng(
                      currentLocation!.latitude!, currentLocation!.longitude!),
                  ),
                for (LatLng location in locations)
                  Marker(
                    markerId: MarkerId(location.toString()),
                    icon: destinationIcon,
                    position: location,
                  )
              },
              onMapCreated: (mapController){
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
                getPolyPoints(); // Update the polyline points
              },
              child: Icon(Icons.refresh),
            ),
          ),
        ],
      ) : Center(
        child: ElevatedButton(
          onPressed: () async {
            await getLocationsFromFirebase();
            getPolyPoints(); // Update the polyline points
            setState(() {
              showMap = true; // Show the map after the button is clicked
            });
          },
          child: Text('View Results'),
        ),
      ),
    );
  }
}
