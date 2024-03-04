import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class InputCoordinatesPage extends StatefulWidget {
  @override
  _InputCoordinatesPageState createState() => _InputCoordinatesPageState();
}

class _InputCoordinatesPageState extends State<InputCoordinatesPage> {
  final _formKey = GlobalKey<FormState>();
  List<TextEditingController> _nameControllers = [TextEditingController(text: 'waterstation')];
  List<TextEditingController> _coordinatesControllers = [TextEditingController()];
  Map<String, dynamic> result = {};
  String resultText = '';

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

  Future<void> _sendCoordinates() async {
    Map<String, List<double>> nodes = {};
    for (int i = 0; i < _nameControllers.length; i++) {
      List<String> coordinatesList = _coordinatesControllers[i].text.split(', ');
      nodes[_nameControllers[i].text] = coordinatesList.map((coordinate) => double.parse(coordinate)).toList();
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
    } else {
      print('Failed to send coordinates.');
    }

  }

  Future<void> _getResults() async {
    try {
      final response = await http.get(
        Uri.parse('http://10.0.2.2:5000/results'),  // replace with your Flask app's URL
      );

      if (response.statusCode == 200) {
        result = json.decode(response.body);
        print('Received results: $result');  // Print the results
        setState(() {
          resultText = result.toString();
        });
        print('Received results successfully.');
        print('Response body: $result');
      } else {
        print('Failed to get results. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('An error occurred: $e');
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