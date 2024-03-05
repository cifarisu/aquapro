import 'package:aquapro/widget/widget_support.dart';
import 'package:flutter/material.dart';

class Details extends StatefulWidget {
  const Details({super.key});

  @override
  State<Details> createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(child: 
      Text("Details", style: AppWidget.HeadlineTextFeildStyle(),),
      )
      
    );
  }
}