// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import "package:aquapro/pages/details.dart";
import "package:aquapro/widget/widget_support.dart";
import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:flutter/widgets.dart";

class CusMaps extends StatefulWidget {
  const CusMaps({super.key});

  @override
  State<CusMaps> createState() => _CusMapsState();
}

class _CusMapsState extends State<CusMaps> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          titleSpacing: -3,
          leading: GestureDetector(
          onTap: (){
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back_ios_new_outlined, color:
            Colors.black,
            )),
          backgroundColor: Color(0xff81e6eb),
          title: Text(
            "Maps",
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: Container());
  }
}
