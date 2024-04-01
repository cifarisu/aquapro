import 'dart:io';
import 'package:aquapro/pages/login.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FutureBuilder(
        future: _initialization,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return StoreReg();
          }
          return CircularProgressIndicator();
        },
      ),
    );
  }
}

class StoreReg extends StatefulWidget {
  @override
  _StoreRegState createState() => _StoreRegState();
}

class _StoreRegState extends State<StoreReg> {
  File? _image;
  final picker = ImagePicker();
  String? _imageUrl;

  // Declare variables for user input
  String time = '';
  double latitude = 0.0;
  double longitude = 0.0;
  List<Product> products = [];

  @override
  void initState() {
    super.initState();
    // Add your products here
    products.add(Product(
        name: 'New Gallon (Round)',
        type: 'deliver&pickup',
        url:
            'https://firebasestorage.googleapis.com/v0/b/aquapro-b890e.appspot.com/o/round.png?alt=media&token=1cf52ada-6380-4511-b112-c02927ec1d0c'));
    products.add(Product(
        name: 'New Gallon (Slim)',
        type: 'deliver&pickup',
        url:
            'https://firebasestorage.googleapis.com/v0/b/aquapro-b890e.appspot.com/o/flat.png?alt=media&token=5be47884-2fbf-49b0-9e81-21910fb03b6f'));
    products.add(Product(
        name: 'Refill (Round)(Pick-up)',
        type: 'pickup',
        url:
            'https://firebasestorage.googleapis.com/v0/b/aquapro-b890e.appspot.com/o/round.png?alt=media&token=1cf52ada-6380-4511-b112-c02927ec1d0c'));
    products.add(Product(
        name: 'Refill (Slim)(Pick-up)',
        type: 'pickup',
        url:
            'https://firebasestorage.googleapis.com/v0/b/aquapro-b890e.appspot.com/o/flat.png?alt=media&token=5be47884-2fbf-49b0-9e81-21910fb03b6f'));
    products.add(Product(
        name: 'Refill (Round)(Deliver)',
        type: 'deliver',
        url:
            'https://firebasestorage.googleapis.com/v0/b/aquapro-b890e.appspot.com/o/round.png?alt=media&token=1cf52ada-6380-4511-b112-c02927ec1d0c'));
    products.add(Product(
        name: 'Refill (Slim)(Deliver)',
        type: 'deliver',
        url:
            'https://firebasestorage.googleapis.com/v0/b/aquapro-b890e.appspot.com/o/flat.png?alt=media&token=5be47884-2fbf-49b0-9e81-21910fb03b6f'));
    products.add(Product(
        name: 'Refill 15-10 Liter',
        type: 'deliver&pickup',
        url:
            'https://firebasestorage.googleapis.com/v0/b/aquapro-b890e.appspot.com/o/small.png?alt=media&token=d21b8e32-eee0-4c47-9bbf-26139a2e7dfc'));
    products.add(Product(
        name: 'Refill 8-5 Liters',
        type: 'deliver&pickup',
        url:
            'https://firebasestorage.googleapis.com/v0/b/aquapro-b890e.appspot.com/o/small.png?alt=media&token=d21b8e32-eee0-4c47-9bbf-26139a2e7dfc'));

    // Retrieve the currently logged-in user's email
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        // No need to set email and name here as they are removed
      });
    }
  }

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future uploadImageToFirebase(BuildContext context) async {
    try {
      if (_image == null) {
        print('No image selected.');
        return;
      }

      String fileName = _image!.path.split('/').last;
      Reference firebaseStorageRef = FirebaseStorage.instance.ref().child('Stores_images/$fileName');
      UploadTask uploadTask = firebaseStorageRef.putFile(_image!);
      TaskSnapshot taskSnapshot = await uploadTask;
      String imageUrl = await taskSnapshot.ref.getDownloadURL();

      print("Done: $imageUrl");
      final userId = FirebaseAuth.instance.currentUser!.uid;
      GeoPoint coordinates = GeoPoint(latitude, longitude);

      DocumentReference storeRef = FirebaseFirestore.instance.collection('Store').doc(userId);

      // Check if the document exists
      var documentSnapshot = await storeRef.get();
      if (documentSnapshot.exists) {
        // If the document exists, update the existing fields
        await storeRef.update({
          'time': time,
          'url': imageUrl,
          'coordinates': coordinates,
        });
      } else {
        // If the document doesn't exist, set the initial values
        await storeRef.set({
          'id': userId,
          'time': time,
          'url': imageUrl,
          'coordinates': coordinates,
        });
      }

      CollectionReference productsRef = storeRef.collection('Products');

      for (var product in products) {
        // Update or add each product individually
        await productsRef.doc(product.name).set({
          'name': product.name,
          'price': product.price,
          'type': product.type,
          'url': product.url,
        }, SetOptions(merge: true)); // Use merge option to update without overwriting
      }

      print('Upload successful');

      // Navigate to login page
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LogIn()),
      );
    } catch (e, stackTrace) {
      print('Error uploading image: $e');
      print('Stack trace: $stackTrace');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Firebase Storage Demo'),
      ),
      body: ListView(
        children: <Widget>[
          TextField(
            decoration: InputDecoration(
              labelText: 'Time',
            ),
            onChanged: (value) {
              time = value;
            },
          ),
          TextField(
            decoration: InputDecoration(
              labelText: 'Coordinates (latitude, longitude)',
            ),
            onChanged: (value) {
              // Parse the input string to extract latitude and longitude
              List<String> coordinates = value.split(',');
              if (coordinates.length == 2) {
                latitude = double.tryParse(coordinates[0]) ?? 0.0;
                longitude = double.tryParse(coordinates[1]) ?? 0.0;
              }
            },
          ),
          for (var product in products) ...[
            ListTile(
              title: Text(product.name),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Price',
                    ),
                    onChanged: (value) {
                      product.price = double.tryParse(value) ?? 0.0;
                    },
                  ),
                  Text(
                    'Type: ${product.type}',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'URL: ${product.url}',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ],
          FloatingActionButton(
            onPressed: getImage,
            tooltip: 'Pick Image',
            child: Icon(Icons.add_a_photo),
          ),
          SizedBox(height: 10),
          FloatingActionButton(
            onPressed: () => uploadImageToFirebase(context),
            tooltip: 'Upload Image',
            child: Icon(Icons.upload_file),
          ),
        ],
      ),
    );
  }
}

class Product {
  final String name;
  double price;
  final String type; // New field for product type
  final String url; // New field for product URL

  Product({required this.name, this.price = 0.0, required this.type, required this.url});
}
