// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import "package:aquapro/customer/cus_cancelled.dart";
import "package:aquapro/customer/cus_completed.dart";
import "package:aquapro/customer/cus_toPay.dart";
import "package:aquapro/rider/rider_accepted.dart";
import "package:aquapro/rider/rider_completed.dart";
import "package:aquapro/rider/rider_returned.dart";
import "package:aquapro/store/store_accepted.dart";
import "package:aquapro/store/store_completed.dart";
import "package:aquapro/store/store_cancelled.dart";
import "package:aquapro/store/store_navbar.dart";
import "package:aquapro/widget/widget_support.dart";
import "package:flutter/material.dart";

class TrackOrders extends StatefulWidget {
  const TrackOrders({super.key});

  @override
  State<TrackOrders> createState() => _TrackOrdersState();
}

class _TrackOrdersState extends State<TrackOrders> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 3,
      child: Scaffold(
        appBar: AppBar(
         title:  Text('Track Orders', style: AppWidget.boldTextFieldStyle(),),
          leading: GestureDetector(
          onTap: () {
           Navigator.push(
                  context, MaterialPageRoute(builder: (context) => StoreNavbar()));
          },
          child: Icon(
            Icons.arrow_back_ios_new_outlined,
            color: Colors.black,
          ),
        ),
            bottom: TabBar.secondary(
              labelPadding: EdgeInsets.only(
                top: 0,
              ),
              indicatorColor: Color(0xff0eb4f3),
              labelColor: Color(0xff0eb4f3),
              labelStyle: TextStyle(
                  fontFamily: 'Times New Roman',
                  fontSize: 19,
                  fontWeight: FontWeight.w600),
              tabs: <Widget>[
                Tab(
                  text: "Accepted",
                ),
                Tab(
                  text: "Completed",
                ),
                Tab(
                  text: "Cancelled",
                ),
              ],
            ),
        ),
        body: const TabBarView(
          children: <Widget>[
            StoreAccepted(),
            StoreCompleted(),
            StoreCancelled()
          ],
        ),
      ),
    );
  }
}
