import 'package:aquapro/pages/order_traking_page.dart';
import 'package:aquapro/trialapi/tryingCRUD.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class InputCoordinatesPage extends StatefulWidget {
  @override
  _InputCoordinatesPageState createState() => _InputCoordinatesPageState();
}

class _InputCoordinatesPageState extends State<InputCoordinatesPage> {
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
    fetchGroup('Group1').then((List<User> users) {
      for (User user in users) {
        _nameControllers.add(TextEditingController(text: user.name));
        _coordinatesControllers.add(TextEditingController(text: user.coordinates.join(', ')));
      }
    });
    fetchShopCoordinates('Shop-1').then((List<double> coordinates) {
      _nameControllers.add(TextEditingController(text: 'Shop-1'));
      _coordinatesControllers.add(TextEditingController(text: coordinates.join(', ')));
    });
  }

  @override
  void dispose() {
    for (var controller in _nameControllers) {
      controller.dispose();
    }
    for (var controller in _coordinatesControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<List<User>> fetchGroup(String groupName) async {
    final querySnapshot = await FirebaseFirestore.instance
      .collection('orders')
      .where('group', isEqualTo: groupName)
      .get();

    return querySnapshot.docs.map((doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      GeoPoint coordinatesGeoPoint = data['coordinates'];
      List<double> coordinatesList = [coordinatesGeoPoint.latitude, coordinatesGeoPoint.longitude];
      return User(
        name: data['name'],
        coordinates: coordinatesList,
      );
    }).toList();
  }

  Future<List<double>> fetchShopCoordinates(String shopId) async {
    final docSnapshot = await FirebaseFirestore.instance
      .collection('water station')
      .doc(shopId)
      .get();

    Map<String, dynamic> data = docSnapshot.data() as Map<String, dynamic>;
    GeoPoint coordinatesGeoPoint = data['coordinates'];
    List<double> coordinatesList = [coordinatesGeoPoint.latitude, coordinatesGeoPoint.longitude];
    
    return coordinatesList;
  }

  Future<void> _sendCoordinates() async {
    setState(() {
      isLoading = true;
    });

    Map<String, List<double>> nodes = {};
    Map<String, GeoPoint> indexedNodes = {};
    for (int i = 0; i < _nameControllers.length; i++) {
      List<String> coordinatesList = _coordinatesControllers[i].text.split(', ');
      List<double> coordinates = coordinatesList.map((coordinate) => double.parse(coordinate)).toList();
      nodes[_nameControllers[i].text] = coordinates;
      indexedNodes['$i'] = GeoPoint(coordinates[0], coordinates[1]);
    }
    final response = await http.post(
      Uri.parse('http://10.0.2.2:5000/'),  // replace with your Flask app's URL
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: json.encode(nodes),
    );

    if (response.statusCode == 200) {
      print('Sending data: ${json.encode(nodes)}');
      print('Coordinates sent successfully.');
      print('Response body: ${response.body}');
      result = json.decode(response.body);
      setState(() {
        resultText = result.toString();
        showSecondButton = true;
      });

      // Save the results and indexedNodes to Firestore
      String docId = 'Shop-1,Group2';  // replace with your actual ID
      final docResult = FirebaseFirestore.instance.collection('results').doc(docId);
      await docResult.set({
        'result': result,
        'indexedNodes': indexedNodes,
      });

    } else {
      print('Failed to send coordinates.');
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Input Coordinates'),
      ),
      body: isLoading ? Center(child: CircularProgressIndicator()) : Column(
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
                                labelText: 'Name ${index + 1}',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
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
                                labelText: 'Coordinates ${index + 1}',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
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
                await fetchGroup('Group1').then((List<User> users) {
                  for (User user in users) {
                    _nameControllers.add(TextEditingController(text: user.name));
                    _coordinatesControllers.add(TextEditingController(text: user.coordinates.join(', ')));
                  }
                });
                await fetchShopCoordinates('Shop-1').then((List<double> coordinates) {
                  _nameControllers.add(TextEditingController(text: 'Shop-1'));
                  _coordinatesControllers.add(TextEditingController(text: coordinates.join(', ')));
                });

                // Update the UI
                setState(() {});
              },
              child: Text('Get Order Details'),
            ),
          ],
          Text(resultText),  // Move this line here
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                await _sendCoordinates();
              }
            },
            child: Icon(Icons.send),
          ),
          SizedBox(height: 10),
          FloatingActionButton(
            onPressed: () {
              setState(() {
                _nameControllers.add(TextEditingController());
                _coordinatesControllers.add(TextEditingController());
              });
            },
            child: Icon(Icons.add),
          ),
          if (showSecondButton) ...[
            SizedBox(height: 10),
            FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => tryCRUD()),
                );
              },
              child: Icon(Icons.navigate_next),
            ),
          ],
        ],
      ),
    );
  }
}

class User {
  String id;
  final String name;
  final List<double> coordinates;

  User({
    this.id = '',
    required this.name,
    required this.coordinates,
  });
  
  Map<String, dynamic> toJson() =>{
    'id': id,
    'name': name,
    'coordinates': coordinates,
  };
}
