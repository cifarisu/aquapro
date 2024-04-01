import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Cart extends StatefulWidget {
  const Cart({super.key});

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> with TickerProviderStateMixin {
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
          'My Cart',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        titleSpacing: 0,
        actions: [
          GestureDetector(
            onTap: () => showDialog<String>(
                                                context: context,
                                                builder:
                                                    (BuildContext context) =>
                                                        AlertDialog(
                                                  actionsPadding:
                                                      EdgeInsets.only(
                                                          bottom: 10),
                                                  contentPadding:
                                                      EdgeInsets.only(top: 30),
                                                  backgroundColor: Colors.white,
                                                  content:
                                                      SingleChildScrollView(
                                                    child: ListBody(
                                                      
                                                      children: <Widget>[
                                                        Container(
                                                          alignment: Alignment.center,
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                            crossAxisAlignment: CrossAxisAlignment.center,
                                                            children: [
                                                              Text(
                                                                'Are you sure you want to',
                                                                style: TextStyle(
                                                                    fontSize: 17),
                                                                textAlign:
                                                                    TextAlign.center,
                                                              ),
                                                               Text(
                                                                "Delete",
                                                            style: TextStyle(
                                                               
                                                                fontSize: 17, color: Color(0xffff3131)),
                                                            textAlign:
                                                                TextAlign.center,
                                                          ),
                                                            ],
                                                          ),
                                                        ),
                                                        Text(
                                                              'the selected Item/s',
                                                              style: TextStyle(
                                                                  fontSize: 17),
                                                              textAlign:
                                                                  TextAlign.center,
                                                            ),
                                                        SizedBox(
                                                          height: 10,
                                                        ),
                                                        Container(
                                                          width: MediaQuery.of(
                                                                  context)
                                                              .size
                                                              .width,
                                                          height: 2,
                                                          color:
                                                              Color(0xffbfbdbc),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  actions: <Widget>[
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceEvenly,
                                                      children: [
                                                        TextButton(
                                                          onPressed: () =>
                                                              Navigator.pop(
                                                                  context,
                                                                  'Continue'),
                                                          child: Text(
                                                            'Continue',
                                                            style: TextStyle(
                                                              color: Color(
                                                                  0xff0eb4f3),
                                                              fontSize: 20,
                                                            ),
                                                            textAlign: TextAlign
                                                                .center,
                                                          ),
                                                        ),
                                                        TextButton(
                                                          onPressed: () =>
                                                              Navigator.pop(
                                                                  context,
                                                                  'Cancel'),
                                                          child: Text(
                                                            'Cancel',
                                                            style: TextStyle(
                                                              color: Colors.red,
                                                              fontSize: 20,
                                                            ),
                                                            textAlign: TextAlign
                                                                .center,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
            child: Container(
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
            ),
          )
        ],
        toolbarHeight: 90,
        shape: Border(
    bottom: BorderSide(
      color: Color(0xffbfbdbc),
      width: 2
    )
  ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Color(0xfff2f2f2),
        child: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Column(
              children: [
                SizedBox(
                  height: 15,
                ),
                Expanded(
                    child: 
                  ListView(
                    children: [
                      StatefulBuilder(
                        builder: (BuildContext context, StateSetter setState) {
                          return Container(
                            padding: EdgeInsets.only(bottom: 10, left: 15, top: 10),
                            color: Colors.white,
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Transform.scale(
                                        scale: 1.3,
                                        child: 
                                        Checkbox(
                                          value: isChecked,
                                          onChanged: (bool? value) {
                                            setState(() {
                                              isChecked = value!;
                                            });
                                          },
                                          checkColor: Colors.white,
                                          activeColor: Color(0xff0eb4f3),
                                        ),
                                      ),
                                    
                                    Text(
                                      'Joylan Water Refilling Station',
                                      style: TextStyle(
                                          fontFamily: 'Times New Roman',
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    )
                                  ],
                                ),
                                Container(
                                  padding: EdgeInsets.only(top: 10, bottom: 10),
                                  child: Row(
                                    children: [
                                      StatefulBuilder(builder:
                                          (BuildContext context, StateSetter setState) {
                                        return Transform.scale(
                                          scale: 1.3,
                                          child: Checkbox(
                                            value: isChecked,
                                            onChanged: (bool? value) {
                                              setState(() {
                                                isChecked = value!;
                                              });
                                            },
                                            checkColor: Colors.white,
                                            activeColor: Color(0xff0eb4f3),
                                          ),
                                        );
                                      }),
                                      Container(
                                        height: 120,
                                        padding: EdgeInsets.all(5),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(20),
                                          color: Color.fromARGB(0, 0, 0, 0),
                                          border: Border.all(
                                            width: 3,
                                            color: Color(0xff0EB4F3),
                                          ),
                                        ),
                                        child: ClipRRect(
                                          child: Image.asset(
                                            'images/round.png', // Changed image path
                                            fit: BoxFit.fitHeight,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 15,
                                      ),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "New Slim Container w/ water",
                                            style: TextStyle(
                                                fontFamily: "Times New Roman",
                                                fontSize: 13,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text("x1",
                                              style: TextStyle(
                                                  fontFamily: "Times New Roman",
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.bold)),
                                          Text("Php 230.00" + "     |     " + "Deliver")
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 10, bottom: 10),
                                  child: Row(
                                    children: [
                                      StatefulBuilder(builder:
                                          (BuildContext context, StateSetter setState) {
                                        return Transform.scale(
                                          scale: 1.3,
                                          child: Checkbox(
                                            value: isChecked,
                                            onChanged: (bool? value) {
                                              setState(() {
                                                isChecked = value!;
                                              });
                                            },
                                            checkColor: Colors.white,
                                            activeColor: Color(0xff0eb4f3),
                                          ),
                                        );
                                      }),
                                      Container(
                                        height: 120,
                                        padding: EdgeInsets.all(5),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(20),
                                          color: Color.fromARGB(0, 0, 0, 0),
                                          border: Border.all(
                                            width: 3,
                                            color: Color(0xff0EB4F3),
                                          ),
                                        ),
                                        child: ClipRRect(
                                          child: Image.asset(
                                            'images/round.png', // Changed image path
                                            fit: BoxFit.fitHeight,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 15,
                                      ),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "New Slim Container w/ water",
                                            style: TextStyle(
                                                fontFamily: "Times New Roman",
                                                fontSize: 13,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text("x1",
                                              style: TextStyle(
                                                  fontFamily: "Times New Roman",
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.bold)),
                                          Text("Php 230.00" + "     |     " + "Pick-up")
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      StatefulBuilder(
                        builder: (BuildContext context, StateSetter setState) {
                          return Container(
                            padding: EdgeInsets.only(bottom: 10, left: 15, top: 10),
                            color: Colors.white,
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                     Transform.scale(
                                        scale: 1.3,
                                        child: Checkbox(
                                          value: isChecked,
                                          onChanged: (bool? value) {
                                            setState(() {
                                              isChecked = value!;
                                            });
                                          },
                                          checkColor: Colors.white,
                                          activeColor: Color(0xff0eb4f3),
                                        ),
                                      ),
                                    Text(
                                      'Joylan Water Refilling Station',
                                      style: TextStyle(
                                          fontFamily: 'Times New Roman',
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    )
                                  ],
                                ),
                                Container(
                                  padding: EdgeInsets.only(top: 10, bottom: 10),
                                  child: Row(
                                    children: [
                                      StatefulBuilder(builder:
                                          (BuildContext context, StateSetter setState) {
                                        return Transform.scale(
                                          scale: 1.3,
                                          child: Checkbox(
                                            value: isChecked,
                                            onChanged: (bool? value) {
                                              setState(() {
                                                isChecked = value!;
                                              });
                                            },
                                            checkColor: Colors.white,
                                            activeColor: Color(0xff0eb4f3),
                                          ),
                                        );
                                      }),
                                      Container(
                                        height: 120,
                                        padding: EdgeInsets.all(5),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(20),
                                          color: Color.fromARGB(0, 0, 0, 0),
                                          border: Border.all(
                                            width: 3,
                                            color: Color(0xff0EB4F3),
                                          ),
                                        ),
                                        child: ClipRRect(
                                          child: Image.asset(
                                            'images/round.png', // Changed image path
                                            fit: BoxFit.fitHeight,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 15,
                                      ),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "New Slim Container w/ water",
                                            style: TextStyle(
                                                fontFamily: "Times New Roman",
                                                fontSize: 13,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text("x1",
                                              style: TextStyle(
                                                  fontFamily: "Times New Roman",
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.bold)),
                                          Text("Php 230.00"  + "     |     " + "Deliver")
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                      )
                    ],
                  ),
                  
                ),
                Container(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  height: 80,
                  color: Colors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                            Transform.scale(
                              scale: 1.3,
                              child: Checkbox(
                                value: isChecked,
                                onChanged: (bool? value) {
                                  setState(() {
                                    isChecked = value!;
                                  });
                                },
                                checkColor: Colors.white,
                                activeColor: Color(0xff0eb4f3),
                              ),
                            ),
                          
                          Text(
                            "All",
                            style: TextStyle(
                                fontFamily: 'Times New Roman',
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            'Total:',
                            style: TextStyle(
                                fontFamily: 'Times New Roman',
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            ' Php 0.00',
                            style: TextStyle(
                                fontFamily: 'Times New Roman',
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                      GestureDetector(
                        onTap: () => showDialog<String>(
                                                context: context,
                                                builder:
                                                    (BuildContext context) =>
                                                        AlertDialog(
                                                  actionsPadding:
                                                      EdgeInsets.only(
                                                          bottom: 10),
                                                  contentPadding:
                                                      EdgeInsets.only(top: 30),
                                                  backgroundColor: Colors.white,
                                                  content:
                                                      SingleChildScrollView(
                                                    child: ListBody(
                                                      children: <Widget>[
                                                        Text(
                                                          'Are you sure you want to reserve the',
                                                          style: TextStyle(
                                                              fontSize: 17),
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                        Text(
                                                          "1 " +
                                                              " " +
                                                              "New Slim Container w/ water",
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 17),
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                        SizedBox(
                                                          height: 10,
                                                        ),
                                                        Container(
                                                          width: MediaQuery.of(
                                                                  context)
                                                              .size
                                                              .width,
                                                          height: 2,
                                                          color:
                                                              Color(0xffbfbdbc),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  actions: <Widget>[
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceEvenly,
                                                      children: [
                                                        TextButton(
                                                          onPressed: () =>
                                                              Navigator.pop(
                                                                  context,
                                                                  'Continue'),
                                                          child: Text(
                                                            'Continue',
                                                            style: TextStyle(
                                                              color: Color(
                                                                  0xff0eb4f3),
                                                              fontSize: 20,
                                                            ),
                                                            textAlign: TextAlign
                                                                .center,
                                                          ),
                                                        ),
                                                        TextButton(
                                                          onPressed: () =>
                                                              Navigator.pop(
                                                                  context,
                                                                  'Cancel'),
                                                          child: Text(
                                                            'Cancel',
                                                            style: TextStyle(
                                                              color: Colors.red,
                                                              fontSize: 20,
                                                            ),
                                                            textAlign: TextAlign
                                                                .center,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                        child: Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.all(5),
                          height: 50,
                          width: 140,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Color(0xff0eb4f3)),
                          child: Text(
                            "Check Out",
                            style: TextStyle(
                                fontFamily: 'Times New Roman',
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 16),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            );
          }
        ),
      ),
    );
  }
}
