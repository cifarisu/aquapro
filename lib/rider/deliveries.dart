// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import "package:aquapro/customer/cus_cancelled.dart";
import "package:aquapro/customer/cus_completed.dart";
import "package:aquapro/customer/cus_toPay.dart";
import "package:aquapro/rider/rider_accepted.dart";
import "package:aquapro/rider/rider_completed.dart";
import "package:aquapro/rider/rider_returned.dart";
import "package:aquapro/widget/widget_support.dart";
import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";

class Deliveries extends StatefulWidget {
  const Deliveries({super.key});

  @override
  State<Deliveries> createState() => _DeliveriesState();
}

class _DeliveriesState extends State<Deliveries> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Color(0xff81e6eb),
            flexibleSpace: SafeArea(
              child: Column(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 55,
                      ),
                      Text(
                        "Deliveries",
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
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
          child: Column(children: [
            Expanded(
              child: ListView(
                children: [
                  GestureDetector(
                    child: Container(
                      child: Column(
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
                                      constraints:
                                          BoxConstraints(maxWidth: 230),
                                      child: Text("Adrian Jones Abache",
                                          style: TextStyle(
                                              fontFamily: 'Times New Roman',
                                              fontSize: 15),
                                          overflow: TextOverflow.ellipsis),
                                    ),
                                    Container(
                                      constraints:
                                          BoxConstraints(maxWidth: 230),
                                      child: Text(
                                          "Barangay 2, Em's Barrio Sout, Legazpi City",
                                          style: TextStyle(
                                              fontFamily: 'Times New Roman',
                                              fontSize: 15),
                                          overflow: TextOverflow.ellipsis),
                                    ),
                                    Container(
                                      constraints:
                                          BoxConstraints(maxWidth: 230),
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
                                GestureDetector(
                                  onTap: () => showDialog<String>(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        AlertDialog(
                                      contentPadding: EdgeInsets.only(
                                          top: 30, left: 10, right: 10, bottom: 20),
                                      backgroundColor: Colors.white,
                                      content: SingleChildScrollView(
                                        child: ListBody(
                                          children: <Widget>[
                                            Row(
                                              children: [
                                                Container(
                                                    child: Image.asset(
                                                  "images/profile.png",
                                                  height: 120,
                                                )),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    Container(
                                                      constraints:
                                                          BoxConstraints(
                                                              maxWidth: 230),
                                                      child: Text(
                                                          "Adrian Jones Abache",
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  'Times New Roman',
                                                              fontSize: 15),
                                                          overflow: TextOverflow
                                                              .ellipsis),
                                                    ),
                                                    Container(
                                                      constraints:
                                                          BoxConstraints(
                                                              maxWidth: 250),
                                                      child: Text(
                                                        "Barangay 2, Em's Barrio South, Legazpi City",
                                                        style: TextStyle(
                                                            fontFamily:
                                                                'Times New Roman',
                                                            fontSize: 15),
                                                      ),
                                                    ),
                                                    Container(
                                                      constraints:
                                                          BoxConstraints(
                                                              maxWidth: 230),
                                                      child: Text("09954464587",
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  'Times New Roman',
                                                              fontSize: 15),
                                                          overflow: TextOverflow
                                                              .ellipsis),
                                                    )
                                                  ],
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                              'Orders',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20),
                                              textAlign: TextAlign.left,
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Container(
                                              padding: EdgeInsets.only(bottom: 15),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Container(
                                                    height: 100,
                                                    padding: EdgeInsets.all(5),
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                20),
                                                        color: Color.fromARGB(
                                                            0, 0, 0, 0),
                                                        border: Border.all(
                                                          width: 3,
                                                          color:
                                                              Color(0xff0EB4F3),
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
                                                    width: 16.0,
                                                  ),
                                                  Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.start,
                                                    children: [
                                                      Container(
                                                          child: Text(
                                                              "New Round Container w/ water x1",
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      "Times New Roman",
                                                                  fontSize: 12,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w800))),
                                                      Container(
                                                          child: Text(
                                                              "Php " +
                                                                  "230.00" +
                                                                  "     |     " +
                                                                  "Deliver",
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      "Callibri",
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400))),
                                                      Container(
                                                          child: Text(
                                                              "Undelivered",
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      "Callibri",
                                                                  fontSize: 15,
                                                                  color: Color(
                                                                      0xffff3131)))),
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Container(
                                                  height: 100,
                                                  padding: EdgeInsets.all(5),
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                      color: Color.fromARGB(
                                                          0, 0, 0, 0),
                                                      border: Border.all(
                                                        width: 3,
                                                        color:
                                                            Color(0xff0EB4F3),
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
                                                  width: 16.0,
                                                ),
                                                Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                        child: Text(
                                                            "New Round Container w/ water x1",
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    "Times New Roman",
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w800))),
                                                    Container(
                                                        child: Text(
                                                            "Php " +
                                                                "230.00" +
                                                                "     |     " +
                                                                "Deliver",
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    "Callibri",
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400))),
                                                    Container(
                                                        child: Text(
                                                            "Undelivered",
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    "Callibri",
                                                                fontSize: 15,
                                                                color: Color(
                                                                    0xffff3131)))),
                                                  ],
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  child: Container(
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
                                  ),
                                )
                              ],
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text("Completed",
                                  style: TextStyle(
                                      fontFamily: 'Callibri',
                                      fontSize: 17,
                                      color: Color(0xff0eb4f3),
                                      decoration: TextDecoration.underline,
                                      decorationColor: Color(0xff0eb4f3),
                                      decorationThickness: 2,
                                      fontWeight: FontWeight.w400)),
                              SizedBox(
                                width: 30,
                              ),
                              Text("Cancelled",
                                  style: TextStyle(
                                      fontFamily: 'Callibri',
                                      fontSize: 17,
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
          ]),
        ));
  }
}
