// ignore_for_file: prefer_const_constructors

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
        name: 'New Gallon (Round)(Delivery)',
        type: 'Delivery',
        url:
            'https://firebasestorage.googleapis.com/v0/b/aquapro-b890e.appspot.com/o/round.png?alt=media&token=1cf52ada-6380-4511-b112-c02927ec1d0c'));
    products.add(Product(
        name: 'New Gallon (Slim)(Delivery)',
        type: 'Delivery',
        url:
            'https://firebasestorage.googleapis.com/v0/b/aquapro-b890e.appspot.com/o/flat.png?alt=media&token=5be47884-2fbf-49b0-9e81-21910fb03b6f'));
    products.add(Product(
        name: 'New Gallon (Round)(Pick-up)',
        type: 'Pick-up',
        url:
            'https://firebasestorage.googleapis.com/v0/b/aquapro-b890e.appspot.com/o/round.png?alt=media&token=1cf52ada-6380-4511-b112-c02927ec1d0c'));
    products.add(Product(
        name: 'New Gallon (Slim)(Pick-up)',
        type: 'Pick-up',
        url:
            'https://firebasestorage.googleapis.com/v0/b/aquapro-b890e.appspot.com/o/flat.png?alt=media&token=5be47884-2fbf-49b0-9e81-21910fb03b6f'));
    products.add(Product(
        name: 'Refill (Round)(Pick-up)',
        type: 'Pick-up',
        url:
            'https://firebasestorage.googleapis.com/v0/b/aquapro-b890e.appspot.com/o/round.png?alt=media&token=1cf52ada-6380-4511-b112-c02927ec1d0c'));
    products.add(Product(
        name: 'Refill (Slim)(Pick-up)',
        type: 'Pick-up',
        url:
            'https://firebasestorage.googleapis.com/v0/b/aquapro-b890e.appspot.com/o/flat.png?alt=media&token=5be47884-2fbf-49b0-9e81-21910fb03b6f'));
    products.add(Product(
        name: 'Refill (Round)(Delivery)',
        type: 'Delivery',
        url:
            'https://firebasestorage.googleapis.com/v0/b/aquapro-b890e.appspot.com/o/round.png?alt=media&token=1cf52ada-6380-4511-b112-c02927ec1d0c'));
    products.add(Product(
        name: 'Refill (Slim)(Delivery)',
        type: 'Delivery',
        url:
            'https://firebasestorage.googleapis.com/v0/b/aquapro-b890e.appspot.com/o/flat.png?alt=media&token=5be47884-2fbf-49b0-9e81-21910fb03b6f'));
    products.add(Product(
        name: 'Refill 15-10 Liter(Delivery)',
        type: 'Delivery',
        url:
            'https://firebasestorage.googleapis.com/v0/b/aquapro-b890e.appspot.com/o/small.png?alt=media&token=d21b8e32-eee0-4c47-9bbf-26139a2e7dfc'));
    products.add(Product(
        name: 'Refill 8-5 Liters(Delivery)',
        type: 'Delivery',
        url:
            'https://firebasestorage.googleapis.com/v0/b/aquapro-b890e.appspot.com/o/small.png?alt=media&token=d21b8e32-eee0-4c47-9bbf-26139a2e7dfc'));
    products.add(Product(
        name: 'Refill 15-10 Liter(Pick-up)',
        type: 'Pick-up',
        url:
            'https://firebasestorage.googleapis.com/v0/b/aquapro-b890e.appspot.com/o/small.png?alt=media&token=d21b8e32-eee0-4c47-9bbf-26139a2e7dfc'));
    products.add(Product(
        name: 'Refill 8-5 Liters(Pick-up)',
        type: 'Pick-up',
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
      Reference firebaseStorageRef =
          FirebaseStorage.instance.ref().child('Stores_images/$fileName');
      UploadTask uploadTask = firebaseStorageRef.putFile(_image!);
      TaskSnapshot taskSnapshot = await uploadTask;
      String imageUrl = await taskSnapshot.ref.getDownloadURL();

      print("Done: $imageUrl");
      final userId = FirebaseAuth.instance.currentUser!.uid;
      GeoPoint coordinates = GeoPoint(latitude, longitude);

      DocumentReference storeRef =
          FirebaseFirestore.instance.collection('Store').doc(userId);

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
        await productsRef.doc(product.name).set(
            {
              'name': product.name,
              'price': product.price,
              'type': product.type,
              'url': product.url,
            },
            SetOptions(
                merge: true)); // Use merge option to update without overwriting
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
      body: Container(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
        ),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xff81e6eb), Color(0xffffffff)]),
        ),
        child: ListView(
          children: <Widget>[
            SizedBox(
              height: 15,
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _image==null? FloatingActionButton.extended(
                        onPressed: getImage,
                        label: const Text('Pick Image'),
                        tooltip: 'Pick Image',
                        icon: Icon(Icons.add_a_photo),
                      
              ): Center(
                child: Material(
                  elevation: 4,
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black, width: 1.5),
                        borderRadius: BorderRadiusDirectional.circular(20)),
                    child: ClipRRect(
                       borderRadius: BorderRadiusDirectional.circular(20),
                      child: Image.file(
                        _image!,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
                      
                      FloatingActionButton.extended(
                        onPressed: () => uploadImageToFirebase(context),
                        label: const Text('Upload Image'),
                        tooltip: 'Upload Image',
                        icon: Icon(Icons.upload_file),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Container(
                    height: 60,
                    child: TextField(
                      decoration: InputDecoration(
                        labelText: 'Store Operating Hours',
                        hintText: '(hh:mm AM - hh:mm PM)',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        time = value;
                      },
                    ),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Container(
                    height: 60,
                    child: TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Store Location Coordinates',
                        hintText: '(latitude, longitude)',
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
                  ),
                  SizedBox(height: 10),
                ],
              ),
            ),
            for (var product in products) ...[
              Column(
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    padding: EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: ListTile(
                      // title: Center(child: Text(product.name)),
                      subtitle: Row(
                        children: [
                          Container(
                            child: Image.network(
                              '${product.url}',
                              height: MediaQuery.of(context).size.height / 8,
                              width: MediaQuery.of(context).size.width - 400,
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Container(
                            // color: Colors.red,
                            width: MediaQuery.of(context).size.width - 200,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product.name,
                                  style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  'Type: ${product.type}',
                                  // style: TextStyle(fontWeight: FontWeight.bold, color: Color.fromARGB(255, 120, 120, 120)),
                                ),
                                SizedBox(
                                  height: 12,
                                ),
                                Container(
                                  height: 50,
                                  child: TextField(
                                    decoration: InputDecoration(
                                      labelText: 'Price',
                                      border: OutlineInputBorder(),
                                    ),
                                    onChanged: (value) {
                                      product.price =
                                          double.tryParse(value) ?? 0.0;
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //         onPressed: getImage,
      //         tooltip: 'Pick Image',
      //         child: Icon(Icons.add_a_photo),
      //       ),
    );
  }
}

class Product {
  final String name;
  double price;
  final String type; // New field for product type
  final String url; // New field for product URL

  Product(
      {required this.name,
      this.price = 0.0,
      required this.type,
      required this.url});
}
