import 'dart:async';

import 'package:aquapro/widget/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class OrderTrackingPage extends StatefulWidget {
  const OrderTrackingPage({Key? key}) : super(key: key);

  @override
  State<OrderTrackingPage> createState() => OrderTrackingPageState();
}

class OrderTrackingPageState extends State<OrderTrackingPage> {
  final Completer<GoogleMapController> _controller = Completer();

  static const LatLng sourceLocation = LatLng(13.138486263526069, 123.73427819974167);
  static const LatLng destination = LatLng(13.137190709035641, 123.73700332397237);

  List<LatLng> polylineCoordinates = [];

  void getPolyPoints() async {
    PolylinePoints polylinePoints = PolylinePoints();

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(google_api_key, PointLatLng(sourceLocation.latitude, sourceLocation.longitude),
    PointLatLng(destination.latitude, destination.longitude),
    );

    if (result.points.isNotEmpty){
      result.points.forEach((PointLatLng point) => polylineCoordinates.add(LatLng(point.latitude, point.longitude)),);
      setState(() {
        
      });

    }
  }


  @override
  void initState() {
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
      body: GoogleMap(mapType: MapType.normal, initialCameraPosition: CameraPosition(target: sourceLocation, zoom: 14.5),
      polylines: {
        Polyline(
          polylineId: PolylineId("route"),
          points: polylineCoordinates,
        ),
      },
      markers: {
        const Marker(
          markerId: MarkerId("source"),
          position: sourceLocation,
          ),
        const Marker(
          markerId: MarkerId("destination"),
          position: destination,
        )
      },),
    );
  }
}
