import 'package:aquapro/customer/cus_maps.dart';
import 'package:aquapro/widget/widget_support.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Stores extends StatefulWidget {
  final String name;
  final String address;
  final String contact;
  final String time;
  final String imageUrl;
  final List<dynamic> products;

  const Stores({
    Key? key,
    required this.name,
    required this.address,
    required this.contact,
    required this.time,
    required this.imageUrl,
    required this.products,
  }) : super(key: key);

  @override
  _StoresState createState() => _StoresState();
}

class _StoresState extends State<Stores> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        shadowColor: Colors.transparent,
        backgroundColor: Colors.transparent,
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
          widget.name,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Container(
        padding: EdgeInsets.only(
          top: 120,
        ),
        alignment: Alignment.topLeft,
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xff81e6eb), Color(0xffffffff)]),
        ),
        child: Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.only(top: 15, left: 10, right: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: Color.fromARGB(255, 255, 255, 255),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.only(left: 10),
                
                height: 100,
                width: MediaQuery.of(context).size.width ,
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(5),
                      child: Image.network(
                        widget.imageUrl,
                        fit: BoxFit.fitHeight,
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          
                          width: 365,
                          child: Text(
                            widget.name,
                            style: TextStyle(
                              fontFamily: 'Times New Roman',
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                        ),
                        Text(
                          "Active 9 minutes ago",
                          style: TextStyle(
                            fontFamily: 'Calibri',
                            fontSize: 13,
                          ),
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.star_rate,
                              color: Color(0xff4cdbc4),
                              size: 23,
                            ),
                            Text(
                              "4.7/5.0     |     46 Followers",
                              style: TextStyle(
                                fontFamily: 'Calibri',
                                fontSize: 13,
                              ),
                            ),
                          ],
                        )
                      ],
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 25,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    width: 170,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                        color: Color(0xff0eb4f3),
                        width: 2,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.sms_outlined,
                          size: 33,
                        ),
                        SizedBox(
                          width: 12,
                        ),
                        Text(
                          "Chat",
                          style: TextStyle(
                            fontFamily: 'Calibri',
                            fontSize: 20,
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    width: 170,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                        color: Color(0xff0eb4f3),
                        width: 2,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add_outlined,
                          size: 30,
                        ),
                        SizedBox(
                          width: 9,
                        ),
                        Text(
                          "Follow",
                          style: TextStyle(
                            fontFamily: 'Calibri',
                            fontSize: 20,
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 25,
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: Color(0xffbfbdbc),
                    ),
                  ),
                ),
                child: TabBar(
                  indicatorColor: Color(0xff0eb4f3),
                  labelColor: Color(0xff0eb4f3),
                  labelStyle: TextStyle(
                    fontFamily: 'Calibri',
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
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
              
              Expanded(
                child: Container(
                  width: double.maxFinite,
                  height: 300,
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      // Placeholder for "Deliver" tab
                      ListView(
                        padding: EdgeInsets.all(8),
                        children: _filterProductsByType('deliver')
                            .map<Widget>((product) {
                          String productName = product['name'];
                          double productPrice = product['price'];
                          String productImageUrl = product['url'];
                          return Container(
                            padding: EdgeInsets.all(10),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: 14.0,
                                ),
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
                                    child: Image.network(
                                      productImageUrl, // Changed image path
                                      fit: BoxFit.fitHeight,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 15.0,
                                ),
                                Expanded(
                                  child: Container(
                                    height: 120,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          child: Text(
                                            productName,
                                            style: TextStyle(
                                              fontFamily: "Times New Roman",
                                              fontSize: 13,
                                              fontWeight: FontWeight.w800,
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 3.0),
                                        Container(
                                          child: Text(
                                            "Php $productPrice",
                                            style: TextStyle(
                                              fontFamily: "Calibri",
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 10.0),
                                        Row(
                                          children: [
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
                                                          'Are you sure you want to buy the',
                                                          style: TextStyle(
                                                              fontSize: 17),
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                        Text(
                                                          '1 New Slim Container w/ water',
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
                                                    TextButton(
                                                      onPressed: () =>
                                                          Navigator.pop(context,
                                                              'Continue'),
                                                      child: Text(
                                                        'Continue',
                                                        style: TextStyle(
                                                          color:
                                                              Color(0xff0eb4f3),
                                                          fontSize: 20,
                                                        ),
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                    ),
                                                    TextButton(
                                                      onPressed: () =>
                                                          Navigator.pop(context,
                                                              'Cancel'),
                                                      child: Text(
                                                        'Cancel',
                                                        style: TextStyle(
                                                          color: Colors.red,
                                                          fontSize: 20,
                                                        ),
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              child: Container(
                                                width: 100,
                                                height: 28,
                                                alignment: Alignment.center,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                  border: Border.all(
                                                    color: Color(0xff0eb4f3),
                                                    width: 2,
                                                  ),
                                                ),
                                                child: Text(
                                                  "Add to Cart",
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                    color: Color(0xff0eb4f3),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 20,
                                            ),
                                            GestureDetector(
                                              onTap: (){
                                                if (quantity > 0) {
                                                  --quantity;
                                                }
                                                
                                                setState(() {
                                                  
                                                });
                                              },
                                              child: Container(
                                                
                                                child: Icon(Icons.remove, size: 25,))), 
                                            
                                            Container(
                                              alignment: Alignment.center,
                                              width: 45,
                                            
                                              child: Text(quantity.toString(), style: AppWidget.semiBoldTextFeildStyle(),)),
                                           
                                            GestureDetector(
                                              onTap: (){
                                                ++quantity;
                                                setState(() {
                                                  
                                                });
                                              },
                                              child: Container(
                                                
                                                child: Icon(Icons.add, size: 25,)))
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                      // Placeholder for "Pick-up" tab
                      ListView(
                        padding: EdgeInsets.all(8),
                        children: _filterProductsByType('pickup')
                            .map<Widget>((product) {
                          String productName = product['name'];
                          double productPrice = product['price'];
                          String productImageUrl = product['url'];
                          return Container(
                            padding: EdgeInsets.all(10),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: 14.0,
                                ),
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
                                    child: Image.network(
                                      productImageUrl, // Changed image path
                                      fit: BoxFit.fitHeight,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 15.0,
                                ),
                                Expanded(
                                  child: Container(
                                    height: 120,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          child: Text(
                                            productName,
                                            style: TextStyle(
                                              fontFamily: "Times New Roman",
                                              fontSize: 13,
                                              fontWeight: FontWeight.w800,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 3.0,
                                        ),
                                        Container(
                                          child: Text(
                                            "Php $productPrice",
                                            style: TextStyle(
                                              fontFamily: "Calibri",
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10.0,
                                        ),
                                        Row(
                                          children: [
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
                                                          'Are you sure you want to buy the',
                                                          style: TextStyle(
                                                              fontSize: 17),
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                        Text(
                                                          '1 New Slim Container w/ water',
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
                                                    TextButton(
                                                      onPressed: () =>
                                                          Navigator.pop(context,
                                                              'Continue'),
                                                      child: Text(
                                                        'Continue',
                                                        style: TextStyle(
                                                          color:
                                                              Color(0xff0eb4f3),
                                                          fontSize: 20,
                                                        ),
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                    ),
                                                    TextButton(
                                                      onPressed: () =>
                                                          Navigator.pop(context,
                                                              'Cancel'),
                                                      child: Text(
                                                        'Cancel',
                                                        style: TextStyle(
                                                          color: Colors.red,
                                                          fontSize: 20,
                                                        ),
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              child: Container(
                                                width: 100,
                                                height: 28,
                                                alignment: Alignment.center,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                  border: Border.all(
                                                    color: Color(0xff0eb4f3),
                                                    width: 2,
                                                  ),
                                                ),
                                                child: Text(
                                                  "Add to Cart",
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                    color: Color(0xff0eb4f3),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            GestureDetector(
                                              onTap: (){
                                                if (quantity > 0) {
                                                  --quantity;
                                                }
                                                
                                                setState(() {
                                                  
                                                });
                                              },
                                              child: Container(
                                                
                                                child: Icon(Icons.remove, size: 25,))), 
                                            
                                            Container(
                                              alignment: Alignment.center,
                                              width: 45,
                                            
                                              child: Text(quantity.toString(), style: AppWidget.semiBoldTextFeildStyle(),)),
                                           
                                            GestureDetector(
                                              onTap: (){
                                                ++quantity;
                                                setState(() {
                                                  
                                                });
                                              },
                                              child: Container(
                                                
                                                child: Icon(Icons.add, size: 25,)))
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(bottom: 20),
                child: GestureDetector(
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: Color(0xff0eb4f3)),
                    height: 60,
                    width: MediaQuery.of(context).size.width,
                    child: Text('View Cart', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, fontFamily: 'Poppins', color: Colors.white),),
                  
                  ),
                ),
              )
              
            ],
          ),
          
        ),
        
      ),
      
 
    );
  }

  List<dynamic> _filterProductsByType(String type) {
    return widget.products
        .where((product) =>
            product['type'] == type || product['type'] == 'deliver&pickup')
        .toList();
  }
}