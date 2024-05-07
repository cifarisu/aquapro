import 'package:aquapro/customer/cart.dart';
import 'package:aquapro/customer/cus_maps.dart';
import 'package:aquapro/widget/widget_support.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore
import 'package:firebase_auth/firebase_auth.dart'; // Import FirebaseAuth
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Stores extends StatefulWidget {
  final String name;
  final String address;
  final String contact;
  final String time;
  final String imageUrl;
  final String storeId;
  final List<dynamic> products;

  const Stores({
    Key? key,
    required this.name,
    required this.address,
    required this.contact,
    required this.time,
    required this.imageUrl,
    required this.products,
    required this.storeId,
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

  Map<String, int> deliverQuantities = {};
  Map<String, int> pickupQuantities = {};

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
          'Stores',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        titleSpacing: 0,
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Cart()));
            },
            child: Container(
              padding: EdgeInsets.only(right: 20),
              child: Column(
                children: [
                  Icon(
                    Icons.shopping_cart_outlined,
                    size: 50,
                  ),
                  Text(
                    'View Cart',
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
        toolbarHeight: 80,
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
                // height: 100,
                width: MediaQuery.of(context).size.width,
                child: Row(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width / 6,
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
                          width: MediaQuery.of(context).size.width * .70,
                          child: Text(
                            widget.name,
                            style: TextStyle(
                              fontFamily: 'Times New Roman',
                              fontWeight: FontWeight.bold,
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.033,
                            ),
                          ),
                        ),
                        Text(
                          "Active 9 minutes ago",
                          style: TextStyle(
                            fontFamily: 'Calibri',
                            fontSize: MediaQuery.of(context).size.width * 0.025,
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
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.025,
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
                height: MediaQuery.of(context).size.width * 0.035,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.35,
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
                          size: MediaQuery.of(context).size.width * 0.07,
                        ),
                        SizedBox(
                          width: 12,
                        ),
                        Text(
                          "Chat",
                          style: TextStyle(
                            fontFamily: 'Calibri',
                            fontSize: MediaQuery.of(context).size.width * 0.04,
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.35,
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
                          size: MediaQuery.of(context).size.width * 0.07,
                        ),
                        SizedBox(
                          width: 9,
                        ),
                        Text(
                          "Follow",
                          style: TextStyle(
                            fontFamily: 'Calibri',
                            fontSize: MediaQuery.of(context).size.width * 0.04,
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 15,
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: Color(0xffbfbdbc),
                    ),
                  ),
                ),
                child: TabBar.secondary(
                  indicatorColor: Color(0xff0eb4f3),
                  labelColor: Color(0xff0eb4f3),
                  labelStyle: TextStyle(
                    fontFamily: 'Calibri',
                    fontSize: MediaQuery.of(context).size.width * 0.045,
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
              Expanded(
                child: Container(
                  width: double.maxFinite,
                  height: 300,
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      // Placeholder for "Deliver" tab
                      ListView.builder(
                        padding: EdgeInsets.all(6),
                        itemCount: _filterProductsByType('Delivery').length,
                        itemBuilder: (BuildContext context, int index) {
                          var product =
                              _filterProductsByType('Delivery')[index];
                          String productName = product['name'];
                          double productPrice = product['price'];
                          String productImageUrl = product['url'];
                          int quantity = deliverQuantities[productName] ?? 0;
                          return Column(
                            children: [
                              Container(
                                padding: EdgeInsets.only(
                                  top: 8,
                                  bottom: 8,
                                  left: MediaQuery.of(context).size.width / 25,
                                  right: MediaQuery.of(context).size.width / 25,
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      height:
                                          MediaQuery.of(context).size.width / 4,
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
                                      width: MediaQuery.of(context).size.width /
                                          20,
                                    ),
                                    Expanded(
                                      child: Container(
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
                                                  fontSize:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          0.027,
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
                                                  fontSize:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          0.027,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                            ),
                                            SizedBox(height: 10.0),
                                            Row(
                                              children: [
                                                GestureDetector(
                                                  onTap: () {
                                                    _addToCart(
                                                      widget.name,
                                                      productName,
                                                      quantity,
                                                      productPrice,
                                                      'Delivery',
                                                      productImageUrl,
                                                      widget.storeId,
                                                    );
                                                  },
                                                  child: Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            .22,
                                                    alignment: Alignment.center,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15),
                                                      border: Border.all(
                                                        color:
                                                            Color(0xff0eb4f3),
                                                        width: 2,
                                                      ),
                                                    ),
                                                    child: Text(
                                                      "Add to Cart",
                                                      style: TextStyle(
                                                        fontSize: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.028,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color:
                                                            Color(0xff0eb4f3),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(width: 10),
                                                GestureDetector(
                                                  onTap: () {
                                                    if (quantity > 0) {
                                                      setState(() {
                                                        deliverQuantities[
                                                                productName] =
                                                            quantity - 1;
                                                      });
                                                    }
                                                  },
                                                  child: Container(
                                                    child: Icon(
                                                      Icons.remove,
                                                      size:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.05,
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  alignment: Alignment.center,
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.09,
                                                  child: Text(
                                                      quantity.toString(),
                                                      style: TextStyle(
                                                          fontFamily: 'Poppins',
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.035)),
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    setState(() {
                                                      if (quantity < 20) {
                                                        // Limit to 20
                                                        deliverQuantities[
                                                                productName] =
                                                            quantity + 1;
                                                      }
                                                    });
                                                  },
                                                  child: Container(
                                                      child: Icon(
                                                    Icons.add,
                                                    size: MediaQuery.of(context)
                                                            .size
                                                            .width *
                                                        0.05,
                                                    color: quantity < 20
                                                        ? Colors.black
                                                        : Colors
                                                            .grey, // Disable button if quantity reaches 20
                                                  )),
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              if (index == 1)
                                Column(
                                  children: [
                                    Text(
                                      "Refill", // Text to be displayed
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    SizedBox(
                                        height: 5), // Adjust spacing as needed
                                    Container(
                                      height: 2,
                                      color: Colors.black,
                                    ),
                                  ],
                                ),
                            ],
                          );
                        },
                      ),
                      // Placeholder for "Pick-up" tab
                      ListView.builder(
                        padding: EdgeInsets.all(8),
                        itemCount: _filterProductsByType('Pick-up').length,
                        itemBuilder: (BuildContext context, int index) {
                          var product = _filterProductsByType('Pick-up')[index];
                          String productName = product['name'];
                          double productPrice = product['price'];
                          String productImageUrl = product['url'];
                          int quantity = pickupQuantities[productName] ?? 0;
                          return Column(
                            children: [
                              Container(
                                padding: EdgeInsets.only(top: 8, bottom: 8),
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
                                                  onTap: () {
                                                    _addToCart(
                                                      widget.name,
                                                      productName,
                                                      quantity,
                                                      productPrice,
                                                      'Pick-up',
                                                      productImageUrl,
                                                      widget.storeId,
                                                    );
                                                  },
                                                  child: Container(
                                                    width: 95,
                                                    height: 28,
                                                    alignment: Alignment.center,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15),
                                                      border: Border.all(
                                                        color:
                                                            Color(0xff0eb4f3),
                                                        width: 2,
                                                      ),
                                                    ),
                                                    child: Text(
                                                      "Add to Cart",
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color:
                                                            Color(0xff0eb4f3),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(width: 10),
                                                GestureDetector(
                                                  onTap: () {
                                                    if (quantity > 0) {
                                                      setState(() {
                                                        pickupQuantities[
                                                                productName] =
                                                            quantity - 1;
                                                      });
                                                    }
                                                  },
                                                  child: Container(
                                                    child: Icon(
                                                      Icons.remove,
                                                      size: 18,
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                    alignment: Alignment.center,
                                                    width: 40,
                                                    child: Text(
                                                        quantity.toString(),
                                                        style: TextStyle(
                                                            fontFamily:
                                                                'Poppins',
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontSize: 14))),
                                                GestureDetector(
                                                  onTap: () {
                                                    setState(() {
                                                      if (quantity < 20) {
                                                        // Limit to 20
                                                        pickupQuantities[
                                                                productName] =
                                                            quantity + 1;
                                                      }
                                                    });
                                                  },
                                                  child: Container(
                                                    child: Icon(
                                                      Icons.add,
                                                      size: 22,
                                                      color: quantity < 20
                                                          ? Colors.black
                                                          : Colors
                                                              .grey, // Disable button if quantity reaches 20
                                                    ),
                                                  ),
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              if (index == 1)
                                Column(
                                  children: [
                                    Text(
                                      "Refill", // Text to be displayed
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    SizedBox(
                                        height: 5), // Adjust spacing as needed
                                    Container(
                                      height: 2,
                                      color: Colors.black,
                                    ),
                                  ],
                                ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<dynamic> _filterProductsByType(String type) {
    return widget.products.where((product) => product['type'] == type).toList();
  }

  void _addToCart(
    String storeName,
    String productName,
    int quantity,
    double productPrice,
    String type,
    String imageUrl,
    String storeId,
  ) async {
    try {
      // Get the currently logged-in user
      User? user = FirebaseAuth.instance.currentUser;

      // Check if the user is authenticated
      if (user != null) {
        // Get the user ID
        String userId = user.uid;

        // Generate a unique identifier for each cart item
        String cartItemId = '$storeName-$productName';

        // Add to Firestore
        final cartRef = FirebaseFirestore.instance
            .collection('Customer')
            .doc(userId)
            .collection('Cart');

        // Check if the product exists in the cart
        final productDoc = cartRef.doc(cartItemId);
        final productSnapshot = await productDoc.get();

        if (productSnapshot.exists) {
          // If the product exists, update its quantity
          await productDoc.update({
            'quantity': FieldValue.increment(quantity),
            'price': productPrice,
            'storeName': storeName,
            'type': type,
            'name': productName, // Adding the name field
            'url': imageUrl, // Adding the URL field
            'storeId': storeId, // Adding the storeId field
          });
        } else {
          // If the product doesn't exist, add it to the cart
          await productDoc.set({
            'quantity': quantity,
            'price': productPrice,
            'storeName': storeName,
            'type': type,
            'name': productName, // Adding the name field
            'url': imageUrl, // Adding the URL field
            'storeId': storeId, // Adding the storeId field
          });
        }

        // Show confirmation dialog
        showDialog(
          context: context,
          builder: (context) {
            // Schedule a delayed dismissal of the alert dialog after 3 seconds
            Future.delayed(Duration(seconds: 1), () {
              Navigator.of(context).pop(); // Close the dialog
            });

            // Return the AlertDialog widget
            return AlertDialog(
              title: Row(
                children: [
                  Text("Added to Cart"),
                  Icon(
                    Icons.done_rounded,
                    color: Color(0xff0eb4f3),
                    size: 60,
                  )
                ],
              ),
              shape: RoundedRectangleBorder(
                  side: BorderSide(color: Color(0xff0eb4f3), width: 3),
                  borderRadius: BorderRadius.all(Radius.circular(35))),
            );
          },
        );
      } else {
        // If the user is not authenticated, you can handle it accordingly
        print("User not authenticated");
      }
    } catch (error, stackTrace) {
      // Print the error and stack trace
      print('Error: $error');
      print('Stack Trace: $stackTrace');
    }
  }
}
