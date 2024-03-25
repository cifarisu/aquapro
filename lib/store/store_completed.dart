// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class StoreCompleted extends StatefulWidget {
  const StoreCompleted({super.key});

  @override
  State<StoreCompleted> createState() => _StoreCompletedState();
}

class _StoreCompletedState extends State<StoreCompleted> {
  int total = 1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(left: 25, top: 20, right: 25, bottom: 20),
        alignment: Alignment.topLeft,
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xff81e6eb), Color(0xffffffff)]),
        ),
        child: Container(
          child: Column(children: [
            Expanded(
              child: ListView(
                children: [
                  GestureDetector(
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      padding:
                          EdgeInsets.only(left: 5, right: 5, top: 15, bottom: 15),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color: Color.fromARGB(255, 255, 255, 255),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              SizedBox(
                                width: 25,
                              ),
                              Container(
                                  child: Image.asset(
                                "images/profile.png",
                                height: 40,
                              )),
                              SizedBox(
                                width: 10,
                              ),
                              Container(
                                constraints: BoxConstraints(maxWidth: 230),
                                child: Text("John F. Kenedy",
                                    style: TextStyle(
                                        fontFamily: 'Times New Roman',
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                    overflow: TextOverflow.ellipsis),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 14.0,
                              ),
                              Container(
                                height: 100,
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
                                    "images/round.png",
                                    height: 90,
                                    width: 90,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 17.0,
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                      child: Text(
                                          "New Round Container w/ water" +
                                              "     x" +
                                              total.toString(),
                                          style: TextStyle(
                                              fontFamily: "Times New Roman",
                                              fontSize: 12,
                                              fontWeight: FontWeight.w800))),
                                  Container(
                                      child: Text(
                                          "Php " +
                                              "230.00" +
                                              "     |     " +
                                              "Pick-up",
                                          style: TextStyle(
                                              fontFamily: "Callibri",
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400))),
                                  Container(
                                      child: Text("Completed",
                                          style: TextStyle(
                                              fontFamily: "Callibri",
                                              fontSize: 15,
                                              color: Color(0xff0eb4f3)))),
                                  
                                ],
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20,),
                  GestureDetector(
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      padding:
                          EdgeInsets.only(left: 5, right: 5, top: 15, bottom: 15),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color: Color.fromARGB(255, 255, 255, 255),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              SizedBox(
                                width: 25,
                              ),
                              Container(
                                  child: Image.asset(
                                "images/profile.png",
                                height: 40,
                              )),
                              SizedBox(
                                width: 10,
                              ),
                              Container(
                                constraints: BoxConstraints(maxWidth: 230),
                                child: Text("John F. Kenedy",
                                    style: TextStyle(
                                        fontFamily: 'Times New Roman',
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                    overflow: TextOverflow.ellipsis),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 14.0,
                              ),
                              Container(
                                height: 100,
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
                                    "images/round.png",
                                    height: 90,
                                    width: 90,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 17.0,
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                      child: Text(
                                          "New Round Container w/ water" +
                                              "     x" +
                                              total.toString(),
                                          style: TextStyle(
                                              fontFamily: "Times New Roman",
                                              fontSize: 12,
                                              fontWeight: FontWeight.w800))),
                                  Container(
                                      child: Text(
                                          "Php " +
                                              "230.00" +
                                              "     |     " +
                                              "Pick-up",
                                          style: TextStyle(
                                              fontFamily: "Callibri",
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400))),
                                  Container(
                                      child: Text("Completed",
                                          style: TextStyle(
                                              fontFamily: "Callibri",
                                              fontSize: 15,
                                              color: Color(0xff0eb4f3)))),
                                  
                                ],
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
