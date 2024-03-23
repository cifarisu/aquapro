// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import "package:flutter/material.dart";

class cusCompleted extends StatefulWidget {
  const cusCompleted({super.key});

  @override
  State<cusCompleted> createState() => _cusCompletedState();
}

class _cusCompletedState extends State<cusCompleted> {
  int total = 1;
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
              colors: [Color(0xff81e6eb), Color(0xffffffff)]),
        ),
        child: 
        Container(
                      padding: EdgeInsets.only(left: 5, right: 5, top: 30,),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            
                            SizedBox(width: 14.0,),
                            Container(
                              padding: EdgeInsets.all(5),
                               decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Color.fromARGB(0, 0, 0, 0),
                                  border: Border.all(
                                    width: 3,
                                    color: Color(0xff0EB4F3),
                                  )),
                              child: ClipRRect(
                                child: Image.asset(
                                "images/flat.png",
                                height: 120, 
                                width: 120, 
                                fit: BoxFit.cover,),
                              ),
                            ),
                            SizedBox(width: 20.0,),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(height: 8.0,),
                              Container(
                                width: MediaQuery.of(context).size.width/1.6,
                                child: Text("Joylan Water Refilling Station",
                                style: TextStyle(fontFamily: "Times New Roman", fontSize: 15, fontWeight: FontWeight.w600))
                              ),
                              SizedBox(height: 5.0,),
                              Container(
                                width: MediaQuery.of(context).size.width/1.6,
                                child: Text("Refill Slim Container" + "     x" + total.toString(),
                                style: TextStyle(fontFamily: "Times New Roman", fontSize: 13, fontWeight: FontWeight.w800))
                              ),
                              SizedBox(height: 3.0,),
                              Container(
                                width: MediaQuery.of(context).size.width/1.6,
                                child: Text("Php " + "35.00" + "     |     " + "Deliver",
                                style: TextStyle(fontFamily: "Callibri", fontSize: 14, fontWeight: FontWeight.w400))
                              ),
                             SizedBox(height: 8.0,),
                              Row(
                                children: [
                                    Text(
                                      "COMPLETED",
                                      style: TextStyle(
                                        fontFamily: 'Callibri',
                                        fontSize: 14,
                                        color: Color(0xff0EB4F3),
                                        fontWeight: FontWeight.w500
                                      ),
                                  ),
                                  SizedBox(width: 40.0,),
                                  Text(
                                      "RATE",
                                      style: TextStyle(
                                        fontFamily: 'Callibri',
                                        fontSize: 14,
                                        color: Color(0xffff3131),
                                        decoration: TextDecoration.underline,
                                        decorationColor: Color(0xffff3131),
                                        decorationThickness: 2 ,
                                        fontWeight: FontWeight.w400
                                      ),
                                  ),
                                  SizedBox(width: 115.0,),
                                ],
                              )
                             
                              
                            ],)
                          ],
                        ),
                    ),

      ),
    );
  }
}