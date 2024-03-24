import 'package:aquapro/customer/cus_manualLocation.dart';
import 'package:aquapro/customer/cus_navbar.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Import the file where CusNavbar and CusManualLocation are defined
// import 'path_to_your_file.dart';

class ChooseLocation extends StatefulWidget {
  const ChooseLocation({Key? key}) : super(key: key);

  @override
  _ChooseLocationState createState() => _ChooseLocationState();
}

class _ChooseLocationState extends State<ChooseLocation> {
  String locationMessage = "No location selected";

  void _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled){
      return Future.error('Location services are disabled');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied){
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied){
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever){
      return Future.error(
        'Location permissions are permanently denied, we cannot request permission for the device.'
      );
    }

    final position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    setState(() {
      locationMessage = "Latitude: ${position.latitude}, Longitude: ${position.longitude}";
    });

    // Update the coordinates in Firebase
    CollectionReference customers = FirebaseFirestore.instance.collection('Customer');
    String uid = FirebaseAuth.instance.currentUser!.uid;
    customers.doc(uid).update({
      'coordinates': GeoPoint(position.latitude, position.longitude),
    });

    // Navigate to CusNavbar after getting the location
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CusNavbar()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xff81e6eb), Color(0xffffffff)],
          ),
        ),
        child: Column(
          children: [
            SizedBox(
              height: 110,
            ),
            Center(
              child: Image.asset(
                "images/maps_icon.png",
                width: MediaQuery.of(context).size.width / 1.4,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Text(
              "Hi, nice to meet you!",
              style: TextStyle(
                color: Colors.black,
                fontSize: 25.0,
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins',
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Text(
              "Choose your location to find water \nrefilling stations around you.",
              style: TextStyle(
                color: Colors.black,
                fontSize: 17.0,
                fontWeight: FontWeight.w500,
                fontFamily: 'Times New Roman',
              ),
              textAlign: TextAlign.center,
              maxLines: 5,
            ),
            SizedBox(
              height: 40,
            ),
            GestureDetector(
              onTap: _getCurrentLocation,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                width: 370,
                height: 70,
                decoration: BoxDecoration(
                  color: Color.fromARGB(0, 0, 0, 0),
                  border: Border.all(
                    width: 5,
                    color: Color(0xff0EB4F3),
                  ),
                ),
                child: Center(
                  child: Row(
                    children: [
                      SizedBox(
                        width: 15,
                      ),
                      Container(
                        child: Image.asset(
                          "images/location_icon.png",
                          fit: BoxFit.fitHeight,
                        ),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Text(
                        'Get Current Location',
                        style: TextStyle(
                          color: Color(0xff0EB4F3),
                          fontSize: 20.0,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CusManualLocation()),
                );
              },
              child: Text(
                'Select Manually',
                style: TextStyle(
                  fontSize: 15.0,
                  color: Colors.blue,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
