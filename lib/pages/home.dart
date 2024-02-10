import 'package:aquapro/widget/widget_support.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold (
      body: Container(
        margin: EdgeInsets.only(top: 50.0, left: 10.0, right: 10.0),
        child: Column(children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Hello, Customer", style: AppWidget.boldTextFieldStyle()
            ),
                Container(
                  padding: EdgeInsets.all(3),
          decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(10)),
          child: Icon(Icons.shopping_cart, color: Colors.white,),
        )    
          ],
        ),
      Text("AquaPro", style: AppWidget.boldTextFieldStyle()
            ),


      ],),),

    );
  }
}