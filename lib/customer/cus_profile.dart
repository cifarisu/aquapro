import "package:aquapro/widget/widget_support.dart";
import "package:flutter/material.dart";

class cusProfile extends StatefulWidget {
  const cusProfile({super.key});

  @override
  State<cusProfile> createState() => _cusProfileState();
}

class _cusProfileState extends State<cusProfile> {
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