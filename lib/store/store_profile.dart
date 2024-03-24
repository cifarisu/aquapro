import "package:aquapro/widget/widget_support.dart";
import "package:flutter/material.dart";

class StoreProfile extends StatefulWidget {
  const StoreProfile({super.key});

  @override
  State<StoreProfile> createState() => _StoreProfileState();
}

class _StoreProfileState extends State<StoreProfile> {
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