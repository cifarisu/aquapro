import "package:aquapro/widget/widget_support.dart";
import "package:flutter/material.dart";

class RiderProfile extends StatefulWidget {
  const RiderProfile({super.key});

  @override
  State<RiderProfile> createState() => _RiderProfileState();
}

class _RiderProfileState extends State<RiderProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: 
        Column(children: [
          SizedBox(height: 50,),
          Text("Profile", style: AppWidget.boldTextFieldStyle(),),
        ],)
        
      ),
    );
  }
}