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

  Future<List<DocumentSnapshot>> fetchAllStores() async {
    final querySnapshot = await FirebaseFirestore.instance.collection('Store').get();
    return querySnapshot.docs;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: fetchAllStores(),
      builder: (context, AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.error != null) {
          return Text('An error occurred!');
        } else {
          return Scaffold(
            appBar: AppBar(
              title: Text('Firebase Storage Demo'),
            ),
            body: ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final store = snapshot.data![index];
                final name = store.get('name');
                final address = store.get('address');
                final contact = store.get('contact');
                final time = store.get('time');
                final imageUrl = store.get('url');

                return ListTile(
                  leading: imageUrl == null ? null : Image.network(imageUrl),
                  title: Text('Name: $name'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Address: $address'),
                      Text('Contact: $contact'),
                      Text('Time: $time'),
                    ],
                  ),
                );
              },
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
              ],
            ),
          );
        }
      },
    );
  }
}
