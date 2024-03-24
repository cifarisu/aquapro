// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import "package:aquapro/pages/details.dart";
import "package:aquapro/widget/widget_support.dart";
import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:flutter/widgets.dart";

class RiderHome extends StatefulWidget {
  const RiderHome({super.key});

  @override
  State<RiderHome> createState() => _RiderHomeState();
}

class _RiderHomeState extends State<RiderHome> {
  
  @override
  Widget build(BuildContext context) {
     var _screenHeight = MediaQuery.of(context).size.height/1.2;
    return Scaffold(
      
      
      appBar: AppBar(
        toolbarHeight: 60,
        backgroundColor: Color(0xff81e6eb),
        flexibleSpace: SafeArea(
          
          
            child: Column(
              
              children: [
                 SizedBox(height: 10,),
                  Row(
                    
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(width: 25,),
                      Text(
                        "Active Orders",
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                 
                ],),
          )),
      body: Container(
            padding: EdgeInsets.only(left: 25, top: 10, right: 25, bottom: 20),
            alignment: Alignment.topLeft,
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xff81e6eb), Color(0xffffffff)]),
            ),
            child: Text("Active Orders", style: AppWidget.boldTextFieldStyle(),),)
    );
  }
}
