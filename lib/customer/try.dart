import 'dart:io';
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
            return letsgo();
          }
          return CircularProgressIndicator();
        },
      ),
    );
  }
}

class letsgo extends StatefulWidget {
  @override
  _letsgoState createState() => _letsgoState();
}

class _letsgoState extends State<letsgo> {
  File? _image;
  final picker = ImagePicker();
  String? _imageUrl;
  String? _name;
  String? _address;
  String? _contact;
  String? _time;

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
    String fileName = _image!.path.split('/').last; // get the filename from path
    Reference firebaseStorageRef =
        FirebaseStorage.instance.ref().child('Stores_images/$fileName'); // upload to 'Stores_images' folder
    UploadTask uploadTask = firebaseStorageRef.putFile(_image!);
    TaskSnapshot taskSnapshot = await uploadTask;
    taskSnapshot.ref.getDownloadURL().then(
      (value) {
        print("Done: $value");
        final userId = FirebaseAuth.instance.currentUser!.uid;
        FirebaseFirestore.instance.collection('Store').doc(userId).update({
          'url': value, // storing url in Firestore
        });
      },
    );
  }

  Future fetchDetailsFromFirebase() async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final docSnapshot = await FirebaseFirestore.instance.collection('Store').doc(userId).get();
    
    final name = docSnapshot.get('name');
    final address = docSnapshot.get('address');
    final contact = docSnapshot.get('contact');
    final time = docSnapshot.get('time');
    final imageUrl = docSnapshot.get('url');
    
    setState(() {
      _name = name;
      _address = address;
      _contact = contact;
      _time = time;
      _imageUrl = imageUrl;
    });
  }

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text('Firebase Storage Demo'),
    ),
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          _imageUrl == null
              ? Text('No image fetched.')
              : Image.network(_imageUrl!),
          SizedBox(height: 20),
          Text('Name: ${_name ?? 'No name fetched.'}'),
          Text('Address: ${_address ?? 'No address fetched.'}'),
          Text('Contact: ${_contact ?? 'No contact fetched.'}'),
          Text('Time: ${_time ?? 'No time fetched.'}'),
        ],
      ),
    ),
    floatingActionButton: Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        FloatingActionButton(
          onPressed: getImage,
          tooltip: 'Pick Image',
          child: Icon(Icons.add_a_photo),
        ),
        SizedBox(
          height: 10,
        ),
        FloatingActionButton(
          onPressed: () => uploadImageToFirebase(context),
          tooltip: 'Upload Image',
          child: Icon(Icons.upload_file),
        ),
        SizedBox(
          height: 10,
        ),
        FloatingActionButton(
          onPressed: fetchDetailsFromFirebase,
          tooltip: 'Fetch Details',
          child: Icon(Icons.download),
        ),
      ],
    ),
  );
}

}