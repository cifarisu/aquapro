// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import "package:aquapro/pages/details.dart";
import "package:aquapro/widget/widget_support.dart";
import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:flutter/widgets.dart";

class StoreHome extends StatefulWidget {
  const StoreHome({super.key});

  @override
  State<StoreHome> createState() => _StoreHomeState();
}

class _StoreHomeState extends State<StoreHome> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 95,
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
                        "Orders",
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        width: 140,
                        padding: EdgeInsets.only(left: 5, right: 5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: Color.fromARGB(255, 255, 255, 255),
                        ),
                        child: Center(
                          child: Text(
                            "Accept All",
                            style: TextStyle(
                                fontFamily: 'Callibri',
                                fontSize: 18,
                                color: Color(0xff0eb4f3)),
                          ),
                        ),
                      ),
                      SizedBox(width: 25,),
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
            child: Column(
               
              children:[ Expanded(
                child: ListView(
                  children: [
                    GestureDetector(
                          child: Container(
                            child: 
                              Column(
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width ,
                                height: 100,
                                padding: EdgeInsets.only(
                                    left: 5, right: 5, top: 5, bottom: 5),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(25),
                                  color: Color.fromARGB(255, 255, 255, 255),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                        child: Image.asset(
                                      "images/profile.png",
                                      fit: BoxFit.fitHeight,
                                    )),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Container(
                                          constraints: BoxConstraints(maxWidth: 230),
                                          child: Text("Adrian Jones Abache",
                                              style: TextStyle(
                                                  fontFamily: 'Times New Roman',
                                                  fontSize: 15),
                                              overflow: TextOverflow.ellipsis),
                                        ),
                                        Container(
                                          constraints: BoxConstraints(maxWidth: 230),
                                          child: Text(
                                              "Barangay 2, Em's Barrio Sout, Legazpi City",
                                              style: TextStyle(
                                                  fontFamily: 'Times New Roman',
                                                  fontSize: 15),
                                              overflow: TextOverflow.ellipsis),
                                        ),
                                        Container(
                                          constraints: BoxConstraints(maxWidth: 230),
                                          child: Text("09954464587",
                                              style: TextStyle(
                                                  fontFamily: 'Times New Roman',
                                                  fontSize: 15),
                                              overflow: TextOverflow.ellipsis),
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Container(
                                      width: 2,
                                      height: 85,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(30),
                                        color: Color.fromARGB(255, 0, 0, 0),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 9,
                                    ),
                                    Container(
                                      height: 80,
                                      width: 70,
                                      alignment: Alignment.center,
                                      child: Text(
                                        "View\nOrders",
                                        style: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xff0eb4f3),
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text("Accept",
                                      style: TextStyle(
                                          fontFamily: 'Callibri',
                                          fontSize: 18,
                                          color: Color(0xff0eb4f3),
                                          decoration: TextDecoration.underline,
                                          decorationColor: Color(0xff0eb4f3),
                                          decorationThickness: 2,
                                          fontWeight: FontWeight.w400)),
                                  SizedBox(
                                    width: 30,
                                  ),
                                  Text("Decline",
                                      style: TextStyle(
                                          fontFamily: 'Callibri',
                                          fontSize: 18,
                                          color: Color(0xffff7058),
                                          decoration: TextDecoration.underline,
                                          decorationColor: Color(0xffff7058),
                                          decorationThickness: 2,
                                          fontWeight: FontWeight.w400)),
                                  SizedBox(
                                    width: 7,
                                  )
                                ],
                              )
                            ],
                          ),
                            
                          ),
                        ),
                        SizedBox(height: 30,),
                        GestureDetector(
                          child: Container(
                            child: 
                              Column(
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width,
                                height: 100,
                                padding: EdgeInsets.only(
                                    left: 5, right: 5, top: 5, bottom: 5),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(25),
                                  color: Color.fromARGB(255, 255, 255, 255),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                        child: Image.asset(
                                      "images/profile.png",
                                      fit: BoxFit.fitHeight,
                                    )),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Container(
                                          constraints: BoxConstraints(maxWidth: 230),
                                          child: Text("Adrian Jones Abache",
                                              style: TextStyle(
                                                  fontFamily: 'Times New Roman',
                                                  fontSize: 15),
                                              overflow: TextOverflow.ellipsis),
                                        ),
                                        Container(
                                          constraints: BoxConstraints(maxWidth: 230),
                                          child: Text(
                                              "Barangay 2, Em's Barrio Sout, Legazpi City",
                                              style: TextStyle(
                                                  fontFamily: 'Times New Roman',
                                                  fontSize: 15),
                                              overflow: TextOverflow.ellipsis),
                                        ),
                                        Container(
                                          constraints: BoxConstraints(maxWidth: 230),
                                          child: Text("09954464587",
                                              style: TextStyle(
                                                  fontFamily: 'Times New Roman',
                                                  fontSize: 15),
                                              overflow: TextOverflow.ellipsis),
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Container(
                                      width: 2,
                                      height: 85,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(30),
                                        color: Color.fromARGB(255, 0, 0, 0),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 9,
                                    ),
                                    Container(
                                      height: 80,
                                      width: 70,
                                      alignment: Alignment.center,
                                      child: Text(
                                        "View\nOrders",
                                        style: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xff0eb4f3),
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text("Accept",
                                      style: TextStyle(
                                          fontFamily: 'Callibri',
                                          fontSize: 18,
                                          color: Color(0xff0eb4f3),
                                          decoration: TextDecoration.underline,
                                          decorationColor: Color(0xff0eb4f3),
                                          decorationThickness: 2,
                                          fontWeight: FontWeight.w400)),
                                  SizedBox(
                                    width: 30,
                                  ),
                                  Text("Decline",
                                      style: TextStyle(
                                          fontFamily: 'Callibri',
                                          fontSize: 18,
                                          color: Color(0xffff7058),
                                          decoration: TextDecoration.underline,
                                          decorationColor: Color(0xffff7058),
                                          decorationThickness: 2,
                                          fontWeight: FontWeight.w400)),
                                  SizedBox(
                                    width: 7,
                                  )
                                ],
                              )
                            ],
                          ),
                            
                          ),
                        ),
                        SizedBox(height: 30,),
                        GestureDetector(
                          child: Container(
                            child: 
                              Column(
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width ,
                                height: 100,
                                padding: EdgeInsets.only(
                                    left: 5, right: 5, top: 5, bottom: 5),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(25),
                                  color: Color.fromARGB(255, 255, 255, 255),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                        child: Image.asset(
                                      "images/profile.png",
                                      fit: BoxFit.fitHeight,
                                    )),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Container(
                                          constraints: BoxConstraints(maxWidth: 230),
                                          child: Text("Adrian Jones Abache",
                                              style: TextStyle(
                                                  fontFamily: 'Times New Roman',
                                                  fontSize: 15),
                                              overflow: TextOverflow.ellipsis),
                                        ),
                                        Container(
                                          constraints: BoxConstraints(maxWidth: 230),
                                          child: Text(
                                              "Barangay 2, Em's Barrio Sout, Legazpi City",
                                              style: TextStyle(
                                                  fontFamily: 'Times New Roman',
                                                  fontSize: 15),
                                              overflow: TextOverflow.ellipsis),
                                        ),
                                        Container(
                                          constraints: BoxConstraints(maxWidth: 230),
                                          child: Text("09954464587",
                                              style: TextStyle(
                                                  fontFamily: 'Times New Roman',
                                                  fontSize: 15),
                                              overflow: TextOverflow.ellipsis),
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Container(
                                      width: 2,
                                      height: 85,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(30),
                                        color: Color.fromARGB(255, 0, 0, 0),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 9,
                                    ),
                                    Container(
                                      height: 80,
                                      width: 70,
                                      alignment: Alignment.center,
                                      child: Text(
                                        "View\nOrders",
                                        style: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xff0eb4f3),
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text("Accept",
                                      style: TextStyle(
                                          fontFamily: 'Callibri',
                                          fontSize: 18,
                                          color: Color(0xff0eb4f3),
                                          decoration: TextDecoration.underline,
                                          decorationColor: Color(0xff0eb4f3),
                                          decorationThickness: 2,
                                          fontWeight: FontWeight.w400)),
                                  SizedBox(
                                    width: 30,
                                  ),
                                  Text("Decline",
                                      style: TextStyle(
                                          fontFamily: 'Callibri',
                                          fontSize: 18,
                                          color: Color(0xffff7058),
                                          decoration: TextDecoration.underline,
                                          decorationColor: Color(0xffff7058),
                                          decorationThickness: 2,
                                          fontWeight: FontWeight.w400)),
                                  SizedBox(
                                    width: 7,
                                  )
                                ],
                              )
                            ],
                          ),
                            
                          ),
                        ),
                        
                        
                        
                        
                  ],
                ),
              ),
              ]
      ),)
    );
  }
}
