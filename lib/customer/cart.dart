import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Cart extends StatefulWidget {
  const Cart({Key? key});

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> with TickerProviderStateMixin {
  late TabController _tabController;

  String? currentUserId;

  Map<String, bool> selectedItems = {};
  double totalPrice = 0.0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
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

  Future<void> updateQuantity(String docId, int newQuantity) async {
    await FirebaseFirestore.instance
        .collection('Customer')
        .doc(currentUserId)
        .collection('Cart')
        .doc(docId)
        .update({'quantity': newQuantity});
  }

  Future<void> deleteProduct(String docId) async {
    await FirebaseFirestore.instance
        .collection('Customer')
        .doc(currentUserId)
        .collection('Cart')
        .doc(docId)
        .delete();
  }

  Future<void> checkOut() async {
    final userDoc =
        await FirebaseFirestore.instance.collection('Customer').doc(currentUserId).get();

    // Start a Firestore transaction
    await FirebaseFirestore.instance.runTransaction((transaction) async {
      final cartSnapshot = await FirebaseFirestore.instance
          .collection('Customer')
          .doc(currentUserId)
          .collection('Cart')
          .get();

      // Create a map to hold order data grouped by storeId
      Map<String, List<Map<String, dynamic>>> ordersByStore = {};

      cartSnapshot.docs.forEach((doc) async {
        if (selectedItems.containsKey(doc.id) && selectedItems[doc.id]!) {
          final storeId = doc['storeId'];

          // Construct order item data
          Map<String, dynamic> orderItemData = {
            'itemName': doc['name'],
            'quantity': doc['quantity'],
            'price': doc['price'],
            'type': doc['type'],
          };

          // Create or update order list for the store
          if (!ordersByStore.containsKey(storeId)) {
            ordersByStore[storeId] = [];
          }
          ordersByStore[storeId]!.add(orderItemData);

          // Delete the item from the cart
          await doc.reference.delete();
        }
      });

      // Add orders to Firestore for each store
      ordersByStore.forEach((storeId, orderItems) async {
        final orderId =
            FirebaseFirestore.instance.collection('Store').doc(storeId).collection('Orders').doc().id;

        // Construct order data
        Map<String, dynamic> orderData = {
          'orderId': orderId,
          'customerId': currentUserId,
          'items': orderItems, // Include list of items in the order
          'customerName': userDoc['name'],
          'address': userDoc['address'],
          'coordinates': userDoc['coordinates'],
          'phone': userDoc['phone'],
          'timestamp': FieldValue.serverTimestamp(),
        };

        // Add the order under the 'Orders' collection of the store
        await FirebaseFirestore.instance.collection('Store').doc(storeId).collection('Orders').doc(orderId).set(orderData);
      });
    });
  }

  Widget _buildCartItem(String docId, String url, String name, int quantity, double price, String type) {
    return Container(
      padding: EdgeInsets.only(bottom: 10, left: 15, top: 10),
      color: Colors.white,
      child: Row(
        children: [
          Checkbox(
            value: selectedItems.containsKey(docId) ? selectedItems[docId] : false,
            onChanged: (bool? value) {
              setState(() {
                selectedItems[docId] = value!;
                if (value == true) {
                  totalPrice += quantity * price;
                } else {
                  totalPrice -= quantity * price;
                }
              });
            },
            checkColor: Colors.white,
            activeColor: Color(0xff0eb4f3),
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
                url,
                fit: BoxFit.fitHeight,
              ),
            ),
          ),
          SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: TextStyle(
                  fontFamily: "Times New Roman",
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: () async {
                      setState(() {
                        if (quantity > 1) {
                          quantity--;
                          updateQuantity(docId, quantity).then((_) {
                            setState(() {});
                          });
                        }
                      });
                    },
                    icon: Icon(Icons.remove),
                  ),
                  Text(
                    '$quantity',
                    style: TextStyle(
                      fontFamily: "Times New Roman",
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    onPressed: () async {
                      setState(() {
                        quantity++;
                        updateQuantity(docId, quantity).then((_) {
                          setState(() {});
                        });
                      });
                    },
                    icon: Icon(Icons.add),
                  ),
                ],
              ),
              Text("$price PHP | $type")
            ],
          ),
          IconButton(
            onPressed: () {
              setState(() {
                deleteProduct(docId);
              });
            },
            icon: Column(
              children: [
                Icon(
                  Icons.delete_outlined,
                  size: 25,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
        toolbarHeight: 90,
        shape: Border(bottom: BorderSide(color: Color(0xffbfbdbc), width: 2)),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Color(0xfff2f2f2),
        child: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('Customer').doc(currentUserId).collection('Cart').snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Center(
                child: Text("No items in cart"),
              );
            }
            totalPrice = 0.0;
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                var document = snapshot.data!.docs[index];
                String docId = document.id;
                String storeName = document['storeName'];
                String url = document['url'];
                String name = document['name'];
                int quantity = document['quantity'];
                double price = document['price'];
                String type = document['type'];

                if (selectedItems.containsKey(docId) && selectedItems[docId]!) {
                  totalPrice += quantity * price;
                }

                if (index == 0 || storeName != snapshot.data!.docs[index - 1]['storeName']) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.only(left: 10, top: 10),
                        child: Text(
                          storeName,
                          style: TextStyle(
                            fontFamily: 'Times New Roman',
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      _buildCartItem(docId, url, name, quantity, price, type),
                    ],
                  );
                } else {
                  return _buildCartItem(docId, url, name, quantity, price, type);
                }
              },
            );
          },
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.only(left: 10, right: 10),
        height: 80,
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
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
                  ' Php ${totalPrice.toStringAsFixed(2)}',
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
                builder: (BuildContext context) => AlertDialog(
                  actionsPadding: EdgeInsets.only(bottom: 10),
                  contentPadding: EdgeInsets.only(top: 30),
                  backgroundColor: Colors.white,
                  content: SingleChildScrollView(
                    child: ListBody(
                      children: <Widget>[
                        Text(
                          'Are you sure you want to reserve the selected items?',
                          style: TextStyle(fontSize: 17),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: 2,
                          color: Color(0xffbfbdbc),
                        )
                      ],
                    ),
                  ),
                  actions: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TextButton(
                          onPressed: () {
                            checkOut();
                            Navigator.pop(context, 'Continue');
                          },
                          child: Text(
                            'Continue',
                            style: TextStyle(
                              color: Color(0xff0eb4f3),
                              fontSize: 20,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context, 'Cancel'),
                          child: Text(
                            'Cancel',
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 20,
                            ),
                            textAlign: TextAlign.center,
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
            ),
          ],
        ),
      ),
    );
  }
}
