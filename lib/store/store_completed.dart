import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';

class StoreCompleted extends StatefulWidget {
  const StoreCompleted({Key? key});

  @override
  State<StoreCompleted> createState() => _StoreCompletedState();
}

class _StoreCompletedState extends State<StoreCompleted> {
  late String? currentUserId;

  @override
  void initState() {
    super.initState();
    getCurrentUserId();
  }

  void getCurrentUserId() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        currentUserId = user.uid;
      });
    }
  }

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
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('Store')
              .doc(currentUserId)
              .collection('Orders')
              .where('status', whereIn: ['Completed']).snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
              return Center(child: Text('No orders available'));
            }

            // Display orders for the current store
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                var order = snapshot.data!.docs[index];
                var items = order['items'] as List<dynamic>;

                // Check the statuses of all items
                bool allForPickup = true;
                bool allForDelivery = true;

                for (var item in items) {
                  if (item['type'] == 'Pickup') {
                    allForDelivery = false;
                  } else if (item['type'] == 'Delivery') {
                    allForPickup = false;
                  }
                }

                // Determine the status for the order
                String orderStatus = allForPickup
                    ? 'To Pick-up'
                    : allForDelivery
                        ? 'To Deliver'
                        : 'Pending'; // Or any other default status

                return Container(
                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  padding:
                      EdgeInsets.only(top: 20, left: 10, right: 10, bottom: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Order ID: ',
                            style: TextStyle(fontSize: 14),
                          ),
                          SizedBox(
                            width: 70,
                          ),
                          Text(
                            '${order['orderId']}',
                            style: TextStyle(
                                fontSize: 14,
                                fontFamily: 'Times New Roman',
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            'Customer Name: ',
                            style: TextStyle(fontSize: 14),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            '${order['customerName']}',
                            style: TextStyle(
                                fontSize: 14,
                                fontFamily: 'Times New Roman',
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            'Contact: ',
                            style: TextStyle(fontSize: 14),
                          ),
                          SizedBox(
                            width: 72,
                          ),
                          Text(
                            '${order['contact']}',
                            style: TextStyle(
                                fontSize: 14,
                                fontFamily: 'Times New Roman',
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            'Address: ',
                            style: TextStyle(fontSize: 14),
                          ),
                          SizedBox(
                            width: 72,
                          ),
                           Container(
                                width: MediaQuery.of(context).size.width*0.55,
                                child: Text(
                                  '${order['address']}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontFamily: 'Times New Roman',
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            'Status: ',
                            style: TextStyle(fontSize: 14),
                          ),
                          SizedBox(
                            width: 85,
                          ),
                          Text(
                            '$orderStatus',
                            style: TextStyle(
                                fontSize: 14,
                                fontFamily: 'Times New Roman',
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Text(
                        'Orders',
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Poppins'),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          var item = items[index];
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        border: Border.all(
                                            color: Color(0xff0eb4f3),
                                            width: 2)),
                                    child: Image.network(
                                      item['url'],
                                      height: 100,
                                      width: 100,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Flexible(
                                    // Wrap the Text widget in Flexible
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text.rich(
                                          TextSpan(
                                            text: "Item: ",
                                            children: <TextSpan>[
                                              TextSpan(
                                                text: '${item['itemName']}',
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              'Quantity: ',
                                              style: TextStyle(fontSize: 14),
                                            ),
                                            Text(
                                              '${item['quantity']}',
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  fontFamily: 'Times New Roman',
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              'Total: ',
                                              style: TextStyle(fontSize: 14),
                                            ),
                                            Text(
                                              '${item['total']}',
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  fontFamily: 'Times New Roman',
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              'Type: ',
                                              style: TextStyle(fontSize: 14),
                                            ),
                                            Text(
                                              '${item['type']}',
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  fontFamily: 'Times New Roman',
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
                            ],
                          );
                        },
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Text(
                            'Total Amount: ',
                            style: TextStyle(fontSize: 14),
                          ),
                          Text(
                            'Php ${order['totalAmount']}',
                            style: TextStyle(
                                fontSize: 14,
                                fontFamily: 'Times New Roman',
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
