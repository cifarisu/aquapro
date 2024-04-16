import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class cusCompleted extends StatefulWidget {
  const cusCompleted({Key? key});

  @override
  State<cusCompleted> createState() => _cusCompletedState();
}

class _cusCompletedState extends State<cusCompleted> {
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
                      .where('status',
                          whereIn: ['Completed']) // Filter by status
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
                                  Text(
                                    '${store['name']}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Row(
                                    children: [
                                      Text(
                                        'Order ID: ',
                                        style: TextStyle(fontSize: 14),
                                      ),
                                      Text(
                                        '${order['orderId']}',
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        'Status: ',
                                        style: TextStyle(fontSize: 14),
                                      ),
                                      Text(
                                        '${order['status']}',
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
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
                                                    Text.rich(
                                                      TextSpan(
                                                        text: "Item: ",
                                                        children: <TextSpan>[
                                                          TextSpan(
                                                            text:
                                                                '${item['itemName']}',
                                                            style: TextStyle(
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Row(
                                                      children: [
                                                        Text(
                                                          'Quantity: ',
                                                          style: TextStyle(
                                                              fontSize: 14),
                                                        ),
                                                        Text(
                                                          '${item['quantity']}',
                                                          style: TextStyle(
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ],
                                                    ),
                                                    Row(
                                                      children: [
                                                        Text(
                                                          'Total: ',
                                                          style: TextStyle(
                                                              fontSize: 14),
                                                        ),
                                                        Text(
                                                          'Php ${item['total']}',
                                                          style: TextStyle(
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ],
                                                    ),
                                                    Row(
                                                      children: [
                                                        Text(
                                                          'Type: ',
                                                          style: TextStyle(
                                                              fontSize: 14),
                                                        ),
                                                        Text(
                                                          '${item['type']}',
                                                          style: TextStyle(
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
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
                                  SizedBox(
                                    height: 15,
                                  ),
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
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
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
