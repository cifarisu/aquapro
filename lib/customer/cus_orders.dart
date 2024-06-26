// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import "package:aquapro/customer/cus_cancelled.dart";
import "package:aquapro/customer/cus_completed.dart";
import "package:aquapro/customer/cus_navbar.dart";
import "package:aquapro/customer/cus_toPay.dart";
import "package:aquapro/widget/widget_support.dart";
import "package:flutter/material.dart";

class cusOrders extends StatefulWidget {
  const cusOrders({super.key});

  @override
  State<cusOrders> createState() => _cusOrdersState();
}

class _cusOrdersState extends State<cusOrders> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title:  Text('Orders', style: AppWidget.boldTextFieldStyle(),),
          leading: GestureDetector(
          onTap: () {
           Navigator.push(
                  context, MaterialPageRoute(builder: (context) => CusNavbar()));
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
                  text: "To Pay",
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
          children: <Widget>[cusToPay(), cusCompleted(), cusCancelled()],
        ),
      ),
    );
  }
}
