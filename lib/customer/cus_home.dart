// ignore_for_file: prefer_const_constructors

import 'package:aquapro/pages/details.dart';
import 'package:aquapro/widget/widget_support.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';


class CusHome extends StatefulWidget {
  const CusHome({super.key});

  @override
  State<CusHome> createState() => _CusHomeState();
}


class _CusHomeState extends State<CusHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold (
      body: Container(
        width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xff81e6eb), Color(0xfffffff)
              ]),),
        child: Container(
         
         
        margin: const EdgeInsets.only(top: 60.0, left: 10.0, right: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Browse", style: AppWidget.HeadlineTextFeildStyle()),
                Column(children: [
                  Container(
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(10)),
                  child: Icon(Icons.map_rounded, color: Colors.white, size: 40,),
                  ),
                  Text("Open Maps", style: AppWidget.SmallTextFeildStyle(),)
                ],),
                
              ],
            ),
            SizedBox(height: 40,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Nearest Water Refilling Stations", 
                  style: AppWidget.BlackTextFeildStyle(),
                ),
                Text(
                  "View all>", 
                  style: AppWidget.BlueTextFeildStyle(),
                ),
             ]
            ),
            SizedBox(height: 20.0,),
            SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                  child: Row(children: [
                    GestureDetector(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>Details()));
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
                                    style:AppWidget.boldTextFieldStyle()
                                      
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
                                          "BUCIT Road, Brgy.1,            Em's Barrio, Legazpi City", 
                                          style: AppWidget.SmallTextFeildStyle(),
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
                                          style: AppWidget.SmallTextFeildStyle(),
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
                                          "6:00 am - 6:00 pm                 (Mon - Sat)", 
                                          style: AppWidget.SmallTextFeildStyle(),
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
                    SizedBox(width: 15.0,),
                    GestureDetector(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>Details()));
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
                                    child: Image.asset("images/Albay Water.jpg", fit: BoxFit.fill),
                                  ),
                                  SizedBox(height: 5.0,),
                                  Text("Albay Water Refilling Station",
                                    textAlign: TextAlign.center, 
                                    style:AppWidget.boldTextFieldStyle()
                                      
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
                                          "Marquez St. Brgy. 15 Ilawod East, Legazpi City", 
                                          style: AppWidget.SmallTextFeildStyle(),
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
                                          "0992-320-3706", 
                                          style: AppWidget.SmallTextFeildStyle(),
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
                                          "7:00 am - 7:00 pm \n(Sun - Sat)", 
                                          style: AppWidget.SmallTextFeildStyle(),
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
                    SizedBox(width: 15.0,),
                    GestureDetector(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>Details()));
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
                                    child: Image.asset("images/Heaven's Spring.jpg", fit: BoxFit.fill),
                                  ),
                                  SizedBox(height: 5.0,),
                                  Text("Heaven's Spring Water Refilling Station",
                                    textAlign: TextAlign.center, 
                                    style:AppWidget.boldTextFieldStyle()
                                      
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
                                          "Balintawak St. Brgy 7 Baño, \nEm's Barrio, Legazpi City", 
                                          style: AppWidget.SmallTextFeildStyle(),
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
                                          "0908-936-3818", 
                                          style: AppWidget.SmallTextFeildStyle(),
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
                                          "8:00 am - 5:00 pm \n(Sun - Sat)", 
                                          style: AppWidget.SmallTextFeildStyle(),
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
                  ],),
              ),
              SizedBox(height: 40,),
              Text(
                  "Categories", 
                  style: AppWidget.BlackTextFeildStyle(),
              ),
              SizedBox(height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
               
                    GestureDetector(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>Details()));
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
                    SizedBox(width: 15.0,),
                    GestureDetector(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>Details()));
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
                    SizedBox(width: 15.0,),
                    GestureDetector(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>Details()));
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
                  ],),
          


        ],
        ),
        ),
      
      
      ),
      
      

    );
  }
}