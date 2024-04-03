import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class cusToPay extends StatefulWidget {
  const cusToPay({Key? key});

  @override
  State<cusToPay> createState() => _cusToPayState();
}

class _cusToPayState extends State<cusToPay> {
  late String? currentUserId;
  int total = 1;

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
          stream: FirebaseFirestore.instance.collection('Store').snapshots(),
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

            // Display orders from all stores
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                var store = snapshot.data!.docs[index];

                return StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('Store')
                      .doc(store.id)
                      .collection('Orders')
                      .where('customerId', isEqualTo: currentUserId)
                      .where('status', whereIn: [
                    'Pending',
                    'To Deliver',
                    'To Pick-up'
                  ]) // Filter by status
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> orderSnapshot) {
                    if (orderSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (orderSnapshot.hasError) {
                      return Center(
                          child: Text('Error: ${orderSnapshot.error}'));
                    }
                    if (orderSnapshot.data == null ||
                        orderSnapshot.data!.docs.isEmpty) {
                      return SizedBox.shrink();
                    }

                    // Display orders for the current user in this store
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            'Store Name: ${store['name']}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: orderSnapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            var order = orderSnapshot.data!.docs[index];
                            var items = order['items'] as List<dynamic>;

                            return Container(
                              margin: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 20),
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
                                    'Status: ${order['status']}',
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  ListView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: items.length,
                                    itemBuilder: (context, index) {
                                      var item = items[index];
                                      return Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
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
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'Item: ${item['itemName']}',
                                                      style: TextStyle(
                                                          fontSize: 14),
                                                    ),
                                                    Text(
                                                      'Quantity: ${item['quantity']}',
                                                      style: TextStyle(
                                                          fontSize: 14),
                                                    ),
                                                    Text(
                                                      'Total: ${item['total']}',
                                                      style: TextStyle(
                                                          fontSize: 14),
                                                    ),
                                                    Text(
                                                      'Type: ${item['type']}',
                                                      style: TextStyle(
                                                          fontSize: 14),
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
                                      showDialog<String>(
                                        context: context,
                                        builder: (BuildContext context) =>
                                            AlertDialog(
                                          title: Text('Cancel Order'),
                                          content: Text(
                                              'Are you sure you want to cancel your order?'),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(
                                                    context, 'Cancel');
                                              },
                                              child: Text('Cancel'),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                // Update order status to "Cancelled"
                                                FirebaseFirestore.instance
                                                    .collection('Store')
                                                    .doc(store.id)
                                                    .collection('Orders')
                                                    .doc(order.id)
                                                    .update({
                                                  'status': 'Cancelled'
                                                }).then((_) {
                                                  Navigator.pop(
                                                      context, 'Continue');
                                                }).catchError((error) {
                                                  print(
                                                      "Failed to cancel order: $error");
                                                  // Handle error accordingly
                                                });
                                              },
                                              child: Text('Continue'),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                    child: Text(
                                      'Cancel Order',
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
