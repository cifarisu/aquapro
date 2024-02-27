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
      body: Form(
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
