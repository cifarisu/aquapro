import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';

class StoreAccepted extends StatefulWidget {
  const StoreAccepted({Key? key});

  @override
  State<StoreAccepted> createState() => _StoreAcceptedState();
}

class _StoreAcceptedState extends State<StoreAccepted> {
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
              .where('status',
                  whereIn: ['To Deliver', 'To Pick-up']).snapshots(),
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
                  padding: EdgeInsets.all(10),
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
                      SizedBox(height: 10),
                      Text(
                        'Order ID: ${order['orderId']}',
                        style: TextStyle(fontSize: 14),
                      ),
                      Text(
                        'Customer Name: ${order['customerName']}',
                        style: TextStyle(fontSize: 14),
                      ),
                      Text(
                        'Contact: ${order['contact']}',
                        style: TextStyle(fontSize: 14),
                      ),
                      Text(
                        'Address: ${order['address']}',
                        style: TextStyle(fontSize: 14),
                      ),
                      Text(
                        'Status: $orderStatus',
                        style: TextStyle(fontSize: 14),
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
                                  Image.network(
                                    item['url'],
                                    height: 100,
                                    width: 100,
                                    fit: BoxFit.cover,
                                  ),
                                  SizedBox(width: 10),
                                  Flexible(
                                    // Wrap the Text widget in Flexible
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Item: ${item['itemName']}',
                                          style: TextStyle(fontSize: 14),
                                        ),
                                        Text(
                                          'Quantity: ${item['quantity']}',
                                          style: TextStyle(fontSize: 14),
                                        ),
                                        Text(
                                          'Total: ${item['total']}',
                                          style: TextStyle(fontSize: 14),
                                        ),
                                        Text(
                                          'Type: ${item['type']}',
                                          style: TextStyle(fontSize: 14),
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
                      Text(
                        'Total Amount: ${order['totalAmount']}',
                        style: TextStyle(fontSize: 14),
                      ),
                      SizedBox(height: 10),
                      TextButton(
                        onPressed: () {
                          // Update order status
                          FirebaseFirestore.instance
                              .collection('Store')
                              .doc(currentUserId)
                              .collection('Orders')
                              .doc(order.id)
                              .update({'status': orderStatus}).then((_) {
                            // Handle the action here
                          }).catchError((error) {
                            print("Failed to update order status: $error");
                            // Handle error accordingly
                          });
                        },
                        child: Text(
                          'Accept Order',
                          style: TextStyle(color: Colors.green),
                        ),
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
