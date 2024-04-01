// ignore_for_file: prefer_const_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Cart2 extends StatefulWidget {
  const Cart2({super.key});

  @override
  State<Cart2> createState() => _Cart2State();
}

class _Cart2State extends State<Cart2> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    bool? isChecked = false;

    return Scaffold(
      appBar: AppBar(
        shadowColor: const Color.fromARGB(0, 0, 0, 0),
        backgroundColor: Color.fromARGB(0, 0, 0, 0),
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back_ios_new_outlined,
            color: Colors.black,
          ),
        ),
        title: Text(
          'My Cart2',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        titleSpacing: 0,
        actions: [
          Container(
            padding: EdgeInsets.only(right: 20, top: 5),
            child: Column(
              children: [
                Icon(
                  Icons.delete_outlined,
                  size: 45,
                ),
                Text(
                  'Delete',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 13,
                  ),
                  textAlign: TextAlign.start,
                )
              ],
            ),
          )
        ],
        toolbarHeight: 90,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Color(0xfff2f2f2),
        child: Container(
          child: Column(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(
                    top: BorderSide(
                      color: Color(0xffbfbdbc),
                    ),
                    bottom: BorderSide(
                      color: Color(0xffbfbdbc),
                    ),
                  ),
                ),
                child: TabBar.secondary(
                  indicatorColor: Color(0xff0eb4f3),
                  labelColor: Color(0xff0eb4f3),
                  labelStyle: TextStyle(
                    fontFamily: 'Calibri',
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                  controller: _tabController,
                  tabs: [
                    Tab(
                      text: "Deliver",
                    ),
                    Tab(
                      text: "Pick-up",
                    )
                  ],
                ),
              ),
              Container(
                height: 300,
                child: TabBarView(
                  controller: _tabController,
                  children: [
                   ListView(children: [Text("Delivery")],),
                   ListView(children: [Text("Pick-Up")],)
                ]),
              ),
               Row(
                children: <Widget>[
                  StatefulBuilder(
                    builder: (BuildContext context, StateSetter setState) {
                      return Transform.scale(
                        scale: 1.3,
                        child: Checkbox(
                          value: isChecked,
                          onChanged: (newBool) {
                            setState(() => isChecked = newBool
                            );
                          },
                          checkColor: Colors.white,
                          activeColor: Color(0xff0eb4f3),
                          
                        ),
                      );
                    }
                  )
                ],
              ),
              Row(
                children: <Widget>[
                  StatefulBuilder(
                    builder: (BuildContext context, StateSetter setState) {
                      return Transform.scale(
                        scale: 1.3,
                        child: Checkbox(
                          value: isChecked,
                          onChanged: (newBool) {
                            setState(() => isChecked = newBool
                            );
                          },
                          checkColor: Colors.white,
                          activeColor: Color(0xff0eb4f3),
                          
                        ),
                      );
                    }
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
