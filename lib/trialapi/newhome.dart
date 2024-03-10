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
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Input Coordinates'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Form(
              key: _formKey,
              child: ListView.builder(
                itemCount: _nameControllers.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: <Widget>[
                      TextFormField(
                        controller: _nameControllers[index],
                        decoration: InputDecoration(
                          labelText: 'Enter name ${index + 1}',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a name.';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: _coordinatesControllers[index],
                        decoration: InputDecoration(
                          labelText: 'Enter coordinates ${index + 1}',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter coordinates.';
                          }
                          return null;
                        },
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
          Text(resultText),  // Move this line here
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                _sendCoordinates();
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
