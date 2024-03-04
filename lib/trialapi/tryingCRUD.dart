import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';


class tryCRUD extends StatefulWidget {
  const tryCRUD({super.key});

  @override
  State<tryCRUD> createState() => _tryCRUDState();
}

class _tryCRUDState extends State<tryCRUD> {
  final controllerName = TextEditingController();
  final controllerAge = TextEditingController();
  final controllerDate = TextEditingController();

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text('Add User'),
      ),

      body: ListView(
        padding: EdgeInsets.all(16),
        children: <Widget>[
          TextField(
            controller: controllerName,
            decoration: decoration('Name'),
          ),
          const SizedBox(height: 24),
          TextField(
            controller: controllerAge,
            decoration: decoration('Age'),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 24),
          DateTimeField(
            controller: controllerDate,
            decoration: decoration('Birthday'),
            format: DateFormat('yyyy-MM-dd'),
            onShowPicker: (context, currentValue) async {
              final date = await showDatePicker(
                context: context,
                firstDate: DateTime(1900),
                lastDate: DateTime(2100),
                initialDate: currentValue ?? DateTime.now(),
              );
              return date;
            },
          ),

        const SizedBox(height: 32),
        ElevatedButton(
          child: Text('Create'),
          onPressed: (){
            final user = User(
              name: controllerName.text,
              age: int.parse(controllerAge.text),
              birthday: DateTime.parse(controllerDate.text),
            );

            createUser(user);


          },
        )



        ],
      ),
    );


    InputDecoration decoration(String label) => InputDecoration(
      labelText: label,
      border: OutlineInputBorder(),
    );

Future createUser(User user) async {
  try {
    final docUser = FirebaseFirestore.instance.collection('users').doc();
    user.id = docUser.id;

    final json = user.toJson();
    await docUser.set(json);

    // Check if the widget is still in the tree
    if (mounted) {
      // Show a SnackBar upon successful addition to Firebase
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Successfully added to Firebase!'),
        ),
      );
    }
  } catch (e) {
    // If there's an error, show a SnackBar with the error message
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to add to Firebase: $e'),
        ),
      );
    }
  }
}


}

class User {
  String id;
  final String name;
  final int age;
  final DateTime birthday;

  User({
    this.id = '',
    required this.name,
    required this.age,
    required this.birthday,
  });
  
  Map<String, dynamic> toJson() =>{
    'id': id,
    'name': name,
    'age': age,
    'birthday': birthday,
  };
}