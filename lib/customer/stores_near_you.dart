// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import "package:aquapro/customer/cus_stores.dart";
import "package:aquapro/pages/details.dart";
import "package:aquapro/widget/widget_support.dart";
import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:flutter/widgets.dart";

class StoresNearYou extends StatefulWidget {
  const StoresNearYou({super.key});

  @override
  State<StoresNearYou> createState() => _StoresNearYouState();
}

class _StoresNearYouState extends State<StoresNearYou> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
     extendBodyBehindAppBar: true,
        appBar: AppBar(
          shadowColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          scrolledUnderElevation: 0,
          titleSpacing: -3,
          leading: GestureDetector(
          onTap: (){
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back_ios_new_outlined, color:
            Colors.black,
            )),
          backgroundColor: Colors.transparent,
          title: Text(
            "Stores Near You",
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: Container(
           padding: EdgeInsets.only( top: 120,),
        alignment: Alignment.topLeft,
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xff81e6eb), Color(0xffffffff)]),
        ),
         child: 
         Container(
          padding: EdgeInsets.only( top: 15, left: 55, right: 55 ),
          decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Color.fromARGB(255, 255, 255, 255),
                      ),
           child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              
            Expanded(
              
              child: ListView(
                padding: EdgeInsets.only(top: 15),
                children: [
                  GestureDetector(onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>Stores()));
                      },
                      child: Container(
                        margin: EdgeInsets.all(5),
                      
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Color(0xff0EB4F3), 
                            width: 3
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Material(
                          
                          elevation: 5.0,
                          borderRadius: BorderRadius.circular(20),
                          
                          child: Container(
                            constraints: BoxConstraints(minWidth: 330, maxWidth: 330),
                            padding: EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    alignment: Alignment.topCenter,
                                    width: MediaQuery.of(context).size.height,
                                    child: Image.asset("images/Joylan.png", fit: BoxFit.fill),
                                  ),
                                  SizedBox(height: 5.0,),
                                  Text("Joylan Water Refilling Station",
                                    textAlign: TextAlign.center, 
                                    style:TextStyle(fontFamily: 'Times New Roman', fontSize: 16, fontWeight: FontWeight.bold)
                                      
                                      ),
                                  SizedBox(height: 5.0,),
                                  
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      
                                      Icon(Icons.location_on, color: Color(0xff0EB4F3), size: 30,),
                                      SizedBox(width: 8),
                                      Container(
                                        constraints: BoxConstraints(maxWidth: 240),
                                        child: Text(
                                          "BUCIT Road, Brgy.1, Em's Barrio, Legazpi City", 
                                          style: TextStyle(fontFamily: 'Callibri', fontSize: 13, fontWeight: FontWeight.w500),
                                        ),
                                      )
                                    ],
                                  ),
                                   SizedBox(height: 12.0,),
                                   Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    
                                    children: [
                                      SizedBox(width:2),
                                      
                                      Container(
                                        constraints: BoxConstraints(maxWidth: 25, minWidth: 25, minHeight: 25),
                                        decoration: BoxDecoration(color: Color(0xff0EB4F3), borderRadius: BorderRadius.circular(20),),
                                        child: Icon(Icons.phone, color: Colors.white, size: 20, ),
                                      ),
                                      
                                      SizedBox(width: 13),
                                      Container(
                                        constraints: BoxConstraints(maxWidth: 240),
                                        child: Text(
                                          "0920-875-7490", 
                                          style: TextStyle(fontFamily: 'Callibri', fontSize: 13, fontWeight: FontWeight.w500),
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(height: 12.0,),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        child: Icon(Icons.access_time, color: Color(0xff0EB4F3), size: 30, ),
                                      ),
                                      
                                      SizedBox(width: 10),
                                      Container(
                                        constraints: BoxConstraints(maxWidth: 230),
                                        child: Text(
                                          "6:00 am - 6:00 pm  (Mon - Sat)", 
                                          style: TextStyle(fontFamily: 'Callibri', fontSize: 13, fontWeight: FontWeight.w500),
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
                  SizedBox(height: 20,),
                  GestureDetector(onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>Stores()));
                      },
                      child: Container(
                        margin: EdgeInsets.all(5),
                      
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Color(0xff0EB4F3), 
                            width: 3
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Material(
                          
                          elevation: 5.0,
                          borderRadius: BorderRadius.circular(20),
                          
                          child: Container(
                            constraints: BoxConstraints(minWidth: 330, maxWidth: 330),
                            padding: EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    alignment: Alignment.topCenter,
                                    width: MediaQuery.of(context).size.height,
                                    child: Image.asset("images/Joylan.png", fit: BoxFit.fill),
                                  ),
                                  SizedBox(height: 5.0,),
                                  Text("Joylan Water Refilling Station",
                                    textAlign: TextAlign.center, 
                                    style:TextStyle(fontFamily: 'Times New Roman', fontSize: 16, fontWeight: FontWeight.bold)
                                      
                                      ),
                                  SizedBox(height: 5.0,),
                                  
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      
                                      Icon(Icons.location_on, color: Color(0xff0EB4F3), size: 30,),
                                      SizedBox(width: 8),
                                      Container(
                                        constraints: BoxConstraints(maxWidth: 240),
                                        child: Text(
                                          "BUCIT Road, Brgy.1, Em's Barrio, Legazpi City", 
                                          style: TextStyle(fontFamily: 'Callibri', fontSize: 13, fontWeight: FontWeight.w500),
                                        ),
                                      )
                                    ],
                                  ),
                                   SizedBox(height: 12.0,),
                                   Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    
                                    children: [
                                      SizedBox(width:2),
                                      
                                      Container(
                                        constraints: BoxConstraints(maxWidth: 25, minWidth: 25, minHeight: 25),
                                        decoration: BoxDecoration(color: Color(0xff0EB4F3), borderRadius: BorderRadius.circular(20),),
                                        child: Icon(Icons.phone, color: Colors.white, size: 20, ),
                                      ),
                                      
                                      SizedBox(width: 13),
                                      Container(
                                        constraints: BoxConstraints(maxWidth: 240),
                                        child: Text(
                                          "0920-875-7490", 
                                          style: TextStyle(fontFamily: 'Callibri', fontSize: 13, fontWeight: FontWeight.w500),
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(height: 12.0,),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        child: Icon(Icons.access_time, color: Color(0xff0EB4F3), size: 30, ),
                                      ),
                                      
                                      SizedBox(width: 10),
                                      Container(
                                        constraints: BoxConstraints(maxWidth: 230),
                                        child: Text(
                                          "6:00 am - 6:00 pm  (Mon - Sat)", 
                                          style: TextStyle(fontFamily: 'Callibri', fontSize: 13, fontWeight: FontWeight.w500),
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
                ],
              ),
            ),
                   ]),
         ),
        ));
  }
}
