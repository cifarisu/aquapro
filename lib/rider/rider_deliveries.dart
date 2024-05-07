import 'package:aquapro/rider/rider_tracking.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';

class RiderACO extends StatefulWidget {
  @override
  _RiderACOState createState() => _RiderACOState();
}

class _RiderACOState extends State<RiderACO> {
  late String? currentUserId;
  late String? storeId; // Declare storeId here
  final _formKey = GlobalKey<FormState>();
  List<TextEditingController> _nameControllers = [];
  List<TextEditingController> _coordinatesControllers = [];
  Map<String, dynamic> result = {};
  String resultText = '';
  bool showSecondButton = false;
  bool isLoading = false;

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
      fetchRiderData(); // Fetch rider data after getting current user ID
    }
  }

  Future<void> fetchRiderData() async {
    DocumentSnapshot riderSnapshot = await FirebaseFirestore.instance
        .collection('Rider')
        .doc(currentUserId) // Use currentUserId to get rider data
        .get();

    if (riderSnapshot.exists) {
      setState(() {
        storeId = riderSnapshot['storeId']; // Assign storeId here
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Details'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: Form(
                    key: _formKey,
                    child: ListView.builder(
                      itemCount: _nameControllers.length,
                      itemBuilder: (context, index) {
                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: TextFormField(
                                    controller: _nameControllers[index],
                                    decoration: InputDecoration(
                                      labelText: 'Customer Name',
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter a name.';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: TextFormField(
                                    controller: _coordinatesControllers[index],
                                    decoration: InputDecoration(
                                      labelText: 'Coordinates',
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter coordinates.';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                if (!isLoading) ...[
                  ElevatedButton(
                    onPressed: () async {
                      // Clear the previous data
                      _nameControllers.clear();
                      _coordinatesControllers.clear();

                      // Fetch the new data
                      await fetchOrders().then((List<Order> orders) {
                        for (int i = 0; i < orders.length; i++) {
                          _nameControllers.add(TextEditingController(
                              text: orders[i].customerName));
                          _coordinatesControllers.add(TextEditingController(
                              text: orders[i].coordinates.join(', ')));
                        }
                      });

                      // Update the UI
                      setState(() {});
                    },
                    child: Text('Get Order Details'),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        await _sendCoordinates();
                      }
                    },
                    child: Text('Run the Algorithm'), // Updated text
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RiderTracking()),
                      );
                    },
                    child: Text('Go to Tracking Page'),
                  ),
                ],
                Text(resultText), // Move this line here
                if (resultText.isNotEmpty) // Add this condition
                  Text(
                    'Algorithm ran successfully. You can now go to the tracking page.',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
              ],
            ),
    );
  }

  Future<List<Order>> fetchOrders() async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('Store')
        .doc(storeId)
        .collection('Orders')
        .where('status', isEqualTo: 'Out for Delivery')
        .limit(10) // Limit the query to retrieve only the first 10 documents
        .get();

    return querySnapshot.docs.map((doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      GeoPoint coordinatesGeoPoint = data['coordinates'];
      List<double> coordinatesList = [
        coordinatesGeoPoint.latitude,
        coordinatesGeoPoint.longitude
      ];
      return Order(
        customerName: data['customerName'],
        coordinates: coordinatesList,
      );
    }).toList();
  }

  Future<void> _sendCoordinates() async {
    setState(() {
      isLoading = true;
    });

    // Fetch store coordinates and rider ID
    final storeDoc =
        await FirebaseFirestore.instance.collection('Store').doc(storeId).get();
    GeoPoint storeCoordinates = storeDoc.data()!['coordinates'] as GeoPoint;

    // Fetch current rider ID
    User? user = FirebaseAuth.instance.currentUser;
    String? riderId = user != null ? user.uid : null;

    Map<String, List<double>> nodes = {};
    Map<String, GeoPoint> indexedNodes = {};
    Map<String, Map<String, dynamic>> customerDetails =
        {}; // Map to store customer details

    // Add store coordinates as the starting point (indexed as 'Order_0')
    nodes['Order_0'] = [storeCoordinates.latitude, storeCoordinates.longitude];
    indexedNodes['Order_0'] = storeCoordinates;

    // Add customer coordinates and save customer names and IDs
    final querySnapshot = await FirebaseFirestore.instance
        .collection('Store')
        .doc(storeId)
        .collection('Orders')
        .where('status', isEqualTo: 'Out for Delivery')
        .limit(10) // Limit the query to retrieve only the first 10 documents
        .get();

    int index = 1; // Start index from 1 for customer orders
    querySnapshot.docs.forEach((doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      GeoPoint coordinatesGeoPoint = data['coordinates'];
      List<double> coordinatesList = [
        coordinatesGeoPoint.latitude,
        coordinatesGeoPoint.longitude
      ];
      nodes['Order_$index'] = coordinatesList;
      indexedNodes['Order_$index'] = coordinatesGeoPoint;

      // Save customer details to the customerDetails map
      customerDetails['Order_$index'] = {
        'name': data['customerName'],
        'id': data[
            'customerId'], // Assuming the customer ID is stored as 'customerId'
      };

      index++;
    });

    // Create a document ID for the tracking data using the rider's ID
    String docId = riderId != null ? riderId : '';

    // Send coordinates to the server
    final response = await http.post(
      Uri.parse(
          'https://tweastzz.pythonanywhere.com/'), // replace with your Flask app's URL
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: json.encode(nodes),
    );

    if (response.statusCode == 200) {
      print('Sending data: ${json.encode(nodes)}');
      print('Coordinates sent successfully.');
      print('Response body: ${response.body}');
      Map<String, dynamic> result = json.decode(response.body);
      setState(() {
        resultText = result.toString();
        showSecondButton = true;
      });

      // Save the results, indexedNodes, storeId, riderId, and customer details to Firestore
      final docResult =
          FirebaseFirestore.instance.collection('Tracking').doc(docId);
      await docResult.set({
        'result': result,
        'indexedNodes': indexedNodes,
        'storeId': storeId,
        'riderId': riderId,
        'customerDetails':
            customerDetails, // Save customer details under this field
      });
    } else {
      print('Failed to send coordinates.');
    }

    setState(() {
      isLoading = false;
    });
  }
}

class Order {
  String id;
  final String customerName;
  final List<double> coordinates;

  Order({
    this.id = '',
    required this.customerName,
    required this.coordinates,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'customerName': customerName,
        'coordinates': coordinates,
      };
}

class SecondPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Second Page'),
      ),
      body: Center(
        child: Text('This is the Second Page'),
      ),
    );
  }
}
