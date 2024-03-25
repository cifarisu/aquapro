import 'package:aquapro/customer/cus_maps.dart';
import 'package:aquapro/customer/cus_stores.dart';
import 'package:aquapro/customer/stores_near_you.dart';
import 'package:aquapro/pages/details.dart';
import 'package:aquapro/widget/widget_support.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: CusHome(),
    );
  }
}

class CusHome extends StatefulWidget {
  @override
  _CusHomeState createState() => _CusHomeState();
}

class _CusHomeState extends State<CusHome> {
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
            colors: [Color(0xff81e6eb), Color(0xfffffff)],
          ),
        ),
        child: Container(
          margin: const EdgeInsets.only(top: 60.0, left: 10.0, right: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Browse",
                    style:TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                 GestureDetector(
                  onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>CusMaps()));
                      },
                  child: Column(children: [
                    Container(
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(10)),
                    child: Icon(Icons.map_rounded, color: Colors.white, size: 40,),
                    ),
                    Text("Open Maps", style: AppWidget.SmallTextFeildStyle(),)
                  ],),
                ),
                ],
              ),
              SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Nearest Water Refilling Stations",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  GestureDetector(
                   onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>StoresNearYou()));
                      },
                  child: Text(
                    "View all>", 
                    style: AppWidget.BlueTextFeildStyle(),
                  ),
                ),
                ],
              ),
              SizedBox(height: 20),
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('Store').limit(5).snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    final List<QueryDocumentSnapshot> stores = snapshot.data!.docs;
                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: stores.map((store) {
                          final name = store['name'];
                          final address = store['address'];
                          final contact = store['contact'];
                          final time = store['time'];
                          final imageUrl = store['url'];
                          return GestureDetector(
                            onTap: () {
                               Navigator.push(context, MaterialPageRoute(builder: (context)=>Stores()));
                            },
                            child: SizedBox(
                              width: 330, // Set a fixed width for the container
                              child: Container(
                                margin: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Color(0xff0EB4F3), width: 3),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Material(
                                  elevation: 5.0,
                                  borderRadius: BorderRadius.circular(20),
                                  child: ConstrainedBox(
                                    constraints: BoxConstraints(minHeight: 500, ), // Set a fixed height for the container
                                    child: Container(
                                      padding: EdgeInsets.all(20),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            alignment: Alignment.topCenter,
                                            width: 300, // Set a fixed width for the image container
                                            height: 150, // Set a fixed height for the image container
                                            child: imageUrl == null
                                                ? Placeholder()
                                                : Image.network(
                                                    imageUrl,
                                                    fit: BoxFit.cover, // Adjust the fit to cover the container
                                                    width: double.infinity,
                                                    height: double.infinity,
                                                  ),
                                          ),
                                          SizedBox(height: 5.0),
                                          Text(
                                            name,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(height: 5.0),
                                          Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Icon(Icons.location_on, color: Color(0xff0EB4F3), size: 30),
                                              SizedBox(width: 8),
                                              Container(
                                                constraints: BoxConstraints(maxWidth: 220),
                                                child: Text(
                                                  address,
                                                  style: TextStyle(fontSize: 16),
                                                ),
                                              )
                                            ],
                                          ),
                                          SizedBox(height: 12.0),
                                          Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(width: 2),
                                              Container(
                                                constraints: BoxConstraints(maxWidth: 25, minWidth: 25, minHeight: 25),
                                                decoration: BoxDecoration(color: Color(0xff0EB4F3), borderRadius: BorderRadius.circular(20)),
                                                child: Icon(Icons.phone, color: Colors.white, size: 20),
                                              ),
                                              SizedBox(width: 13),
                                              Container(
                                                constraints: BoxConstraints(maxWidth: 240),
                                                child: Text(
                                                  contact,
                                                  style: TextStyle(fontSize: 16),
                                                ),
                                              )
                                            ],
                                          ),
                                          SizedBox(height: 12.0),
                                          Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                child: Icon(Icons.access_time, color: Color(0xff0EB4F3), size: 30),
                                              ),
                                              SizedBox(width: 10),
                                              Container(
                                                constraints: BoxConstraints(maxWidth: 230),
                                                child: Text(
                                                  time,
                                                  style: TextStyle(fontSize: 16),
                                                ),
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    );
                  }
                },
              ),
              SizedBox(height: 40),
              Text(
                "Categories",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => Details()));
                    },
                    child: Container(
                      margin: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        border: Border.all(color: Color(0xff0EB4F3), width: 3),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Material(
                        elevation: 5.0,
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          constraints: BoxConstraints(minWidth: 120, maxWidth: 120),
                          padding: EdgeInsets.all(5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                alignment: Alignment.topCenter,
                                width: MediaQuery.of(context).size.height,
                                child: Image.asset("images/flat.png", fit: BoxFit.fill),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 15.0),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => Details()));
                    },
                    child: Container(
                      margin: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        border: Border.all(color: Color(0xff0EB4F3), width: 3),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Material(
                        elevation: 5.0,
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          constraints: BoxConstraints(minWidth: 120, maxWidth: 120),
                          padding: EdgeInsets.all(5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                alignment: Alignment.topCenter,
                                width: MediaQuery.of(context).size.height,                                
                                child: Image.asset("images/round.png", fit: BoxFit.fill),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 15.0),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => Details()));
                    },
                    child: Container(
                      margin: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        border: Border.all(color: Color(0xff0EB4F3), width: 3),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Material(
                        elevation: 5.0,
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          constraints: BoxConstraints(minWidth: 120, maxWidth: 120),
                          padding: EdgeInsets.all(5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                alignment: Alignment.topCenter,
                                width: MediaQuery.of(context).size.height,
                                child: Image.asset("images/small.png", fit: BoxFit.fill),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
