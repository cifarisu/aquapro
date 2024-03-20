// ignore_for_file: prefer_const_constructors

import "package:aquapro/pages/home.dart";
import "package:aquapro/pages/login.dart";
import "package:aquapro/pages/signup.dart";
import "package:aquapro/widget/widget_support.dart";
import "package:flutter/material.dart";

class chooseLocation extends StatefulWidget {
  const chooseLocation({super.key});

  @override
  State<chooseLocation> createState() => _chooseLocationState();
}

class _chooseLocationState extends State<chooseLocation> {
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
              colors: [Color(0xff81e6eb), Color(0xffffffff)]),
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
            )),
            SizedBox(
              height: 30,
            ),
            Text("Hi, nice to meet you!",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins')),
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
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const Home()));
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                width: 370,
                height: 70,
                decoration: BoxDecoration(
                    color: Color.fromARGB(0, 0, 0, 0),
                    border: Border.all(
                      width: 5,
                      color: Color(0xff0EB4F3),
                    )),
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
                      )),
                      SizedBox(
                        width: 15,
                      ),
                      Text("Use current location",
                          style: TextStyle(
                              color: Color(0xff0EB4F3),
                              fontSize: 20.0,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            GestureDetector(
                onTap: () {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (context) => Home()));
                },
                child: Text("Select Manually",
                    style: TextStyle(
                        fontSize: 18,
                        decoration: TextDecoration.underline,
                        fontWeight: FontWeight.w800,
                        fontFamily: "Times New Roman"))),
          ],
        ),
      ),
    );
  }
}
