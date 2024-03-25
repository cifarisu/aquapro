import 'dart:async';
import 'package:aquapro/customer/cus_navbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class CusManualLocation extends StatefulWidget {
  const CusManualLocation({super.key});

  @override
  State<CusManualLocation> createState() => _CusManualLocationState();
}

class _CusManualLocationState extends State<CusManualLocation> {
  final locationController = Location();
  LatLng? currentPosition;
  Completer<GoogleMapController> _controller = Completer();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async => await fetchLocationUpdates());
  }

  @override
  Widget build(BuildContext context) => Stack(
        children: [
          currentPosition == null
              ? const Center(child: CircularProgressIndicator())
              : GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: currentPosition!,
                    zoom: 13,
                  ),
                  onCameraMove: (CameraPosition position) {
                    currentPosition = position.target;
                  },
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                  },
                ),
          Center(
            child: Icon(Icons.location_on, size: 30.0, color: Colors.red),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
  onPressed: () {
    if (currentPosition != null) {
      // Save the coordinates to Firebase
      CollectionReference customers = FirebaseFirestore.instance.collection('Customer');
      String uid = FirebaseAuth.instance.currentUser!.uid;
      customers.doc(uid).update({
        'coordinates': GeoPoint(currentPosition!.latitude, currentPosition!.longitude),
      });
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CusNavbar()),
    );
  },
  child: const Text('Save'),
),

            ),
          ),
        ],
      );

  Future<void> fetchLocationUpdates() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await locationController.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await locationController.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await locationController.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await locationController.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    locationController.onLocationChanged.listen((currentLocation) {
      if (currentLocation.latitude != null && currentLocation.longitude != null) {
        setState(() {
          currentPosition = LatLng(
            currentLocation.latitude!,
            currentLocation.longitude!,
          );
        });
      }
    });
  }
}
