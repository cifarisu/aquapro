import 'dart:async';

import 'package:aquapro/widget/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class OrderTrackingPage extends StatefulWidget {
  const OrderTrackingPage({Key? key}) : super(key: key);

  @override
  State<OrderTrackingPage> createState() => OrderTrackingPageState();
}

class OrderTrackingPageState extends State<OrderTrackingPage> {
  final Completer<GoogleMapController> _controller = Completer();

  static const List<LatLng> locations = [LatLng(13.1389, 123.7335), LatLng(13.1438, 123.7438), LatLng(13.1458, 123.7458)]; // Add more destinations here

  List<List<LatLng>> polylineCoordinates = [];
  LocationData? currentLocation;

  BitmapDescriptor sourceIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor destinationIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor currentLocationIcon = BitmapDescriptor.defaultMarker; 

  void getCurrentLocation() async {
    Location location = Location();

    location.getLocation().then((location){
      currentLocation = location;
    },);

    GoogleMapController googleMapController = await _controller.future;

    location.onLocationChanged.listen((newLoc){
      currentLocation = newLoc;

      googleMapController.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
          zoom: 18,
          target: LatLng(newLoc.latitude!, newLoc.longitude!,))));

      setState(() {
        
      });

    },);

  }

  void getPolyPoints() async {
    PolylinePoints polylinePoints = PolylinePoints();

    for (int i = 0; i < locations.length - 1; i++) {
      LatLng source = locations[i];
      LatLng destination = locations[i + 1];

      PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(google_api_key, PointLatLng(source.latitude, source.longitude),
      PointLatLng(destination.latitude, destination.longitude),
      );

      if (result.points.isNotEmpty){
        List<LatLng> route = [];
        result.points.forEach((PointLatLng point) => route.add(LatLng(point.latitude, point.longitude)),);
        polylineCoordinates.add(route);
        setState(() {
          
        });

      }
    }
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

  @override
  void initState() {
    getCurrentLocation();
    setCustomMarker();
    getPolyPoints();
    super.initState();
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
    body: currentLocation == null ? 
    const Center(child: Text("Loading")) : 
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
              markerId: MarkerId("destination"),
              icon: destinationIcon,
              position: location,
            )
        },
        onMapCreated: (mapController){
          _controller.complete(mapController);
        },
      ),
    ),
  );
}

}