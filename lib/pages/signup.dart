// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:aquapro/rider/rider_storeselection.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:aquapro/pages/login.dart';
import 'package:aquapro/store/store_manual_registration.dart';
import 'package:aquapro/widget/widget_support.dart';
import 'package:flutter/widgets.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  String email = "", password = "", name = "";
  String? selectedType;
  List<String> userTypes = ['Customer', 'Store', 'Rider'];

  TextEditingController namecontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();
  TextEditingController mailcontroller = TextEditingController();
  TextEditingController contactController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  final _formkey = GlobalKey<FormState>();

  registration() async {
    if (_formkey.currentState!.validate()) {
      setState(() {
        email = mailcontroller.text;
        name = namecontroller.text;
        password = passwordcontroller.text;
      });

      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);

        // After successful registration, update the user profile with the name
        await FirebaseAuth.instance.currentUser!.updateDisplayName(name);

        // Then, you can store the user's name and ID in your Firestore database
        // Use the selectedType as the collection name
        await FirebaseFirestore.instance
            .collection(selectedType!)
            .doc(userCredential.user!.uid)
            .set({
          'name': name,
          'id': userCredential.user!.uid,
          'email': email,
          'contact': contactController.text,
          'address': addressController.text,
        });

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.redAccent,
          content:
              Text("Registered Successfully", style: TextStyle(fontSize: 20)),
        ));

        // Check if selectedType is "Store"
        if (selectedType == "Store") {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => StoreReg()));
        } else if (selectedType == "Rider") {
          // Check if selectedType is "Rider"
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      RiderSelection())); // Navigate to RiderSelection
        } else {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => LogIn()));
        }
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.orangeAccent,
            content:
                Text("Password is too weak", style: TextStyle(fontSize: 18)),
          ));
        } else if (e.code == 'email-already-in-use') {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.orangeAccent,
            content:
                Text("Account already exists", style: TextStyle(fontSize: 18)),
          ));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
          expandedHeight: MediaQuery.of(context).size.height/3,
          flexibleSpace: FlexibleSpaceBar(
            background: Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color.fromARGB(255, 2, 206, 247),
                      Color.fromARGB(255, 255, 255, 255)
                    ],
                  ),
                ),
              height: MediaQuery.of(context).size.height,
              child: Image.asset(
                        "images/logo.png",
                        width: MediaQuery.of(context).size.width / 1.9,
                      ),
            ),
          ),
          pinned: false,
        ),
        SliverToBoxAdapter(
          child:  Container(
          padding: EdgeInsets.only(top: 3),
          decoration: BoxDecoration(
             borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                    ),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.2),
        spreadRadius: 1,
        blurRadius: 5,
        offset: Offset(0, 2), // changes position of shadow
      ),
    ],
  ),
          child: ClipRRect(
            
             borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height-85,
              decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                    ),
                  ),
              padding: EdgeInsets.only(left: 20, right: 20),
              child:   Form(
                                    key: _formkey,
                                    child: Column(
                                      children: [
                                        const SizedBox(
                                          height: 30,
                                        ),
                                        Text(
                                          "Sign Up",
                                          style: AppWidget.boldTextFieldStyle(),
                                        ),
                                        const SizedBox(
                                          height: 30,
                                        ),
                                        TextFormField(
                                          controller: namecontroller,
                                          validator: (value) {
                                            if (value == null || value.isEmpty) {
                                              return 'Please Enter Name';
                                            }
                                            return null;
                                          },
                                          decoration: InputDecoration(
                                              hintText: 'Name',
                                              hintStyle: AppWidget.boldTextFieldStyle(),
                                              prefixIcon:
                                                  const Icon(Icons.person_outlined)),
                                        ),
                                        const SizedBox(
                                          height: 30,
                                        ),
                                        TextFormField(
                                          controller: mailcontroller,
                                          validator: (value) {
                                            if (value == null || value.isEmpty) {
                                              return 'Please Enter E-Email';
                                            }
                                            return null;
                                          },
                                          decoration: InputDecoration(
                                              hintText: 'Email',
                                              hintStyle: AppWidget.boldTextFieldStyle(),
                                              prefixIcon:
                                                  const Icon(Icons.email_outlined)),
                                        ),
                                        const SizedBox(
                                          height: 30,
                                        ),
                                        TextFormField(
                                          controller: passwordcontroller,
                                          validator: (value) {
                                            if (value == null || value.isEmpty) {
                                              return 'Please enter password';
                                            }
                                            return null;
                                          },
                                          obscureText: true,
                                          decoration: InputDecoration(
                                            hintText: 'Password',
                                            hintStyle: AppWidget.boldTextFieldStyle(),
                                            prefixIcon: Icon(Icons.lock_outline),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 30,
                                        ),
                                        DropdownButtonFormField(
                                          value: selectedType,
                                          items: userTypes.map((String value) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: Text(value),
                                            );
                                          }).toList(),
                                          onChanged: (String? newValue) {
                                            setState(() {
                                              selectedType = newValue;
                                            });
                                          },
                                          validator: (value) {
                                            if (value == null || value.isEmpty) {
                                              return 'Please choose user type';
                                            }
                                            return null;
                                          },
                                          decoration: InputDecoration(
                                            hintText: 'Type',
                                            hintStyle: AppWidget.boldTextFieldStyle(),
                                            prefixIcon:
                                                const Icon(Icons.person_outline),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 30,
                                        ),
                                        TextFormField(
                                          controller: contactController,
                                          validator: (value) {
                                            if (value == null || value.isEmpty) {
                                              return 'Please enter contact number';
                                            }
                                            return null;
                                          },
                                          decoration: InputDecoration(
                                            hintText: 'Contact',
                                            hintStyle: AppWidget.boldTextFieldStyle(),
                                            prefixIcon: Icon(Icons.phone),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 30,
                                        ),
                                        TextFormField(
                                          controller: addressController,
                                          validator: (value) {
                                            if (value == null || value.isEmpty) {
                                              return 'Please enter address';
                                            }
                                            return null;
                                          },
                                          decoration: InputDecoration(
                                            hintText: 'Address',
                                            hintStyle: AppWidget.boldTextFieldStyle(),
                                            prefixIcon: Icon(Icons.location_on),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        GestureDetector(
                                          onTap: () async {
                                            if (_formkey.currentState!.validate()) {
                                              setState(() {
                                                email = mailcontroller.text;
                                                name = namecontroller.text;
                                                password = passwordcontroller.text;
                                                contactController.text =
                                                    contactController.text;
                                                addressController.text =
                                                    addressController.text;
                                              });
                                              registration();
                                            }
                                          },
                                          child: Material(
                                            elevation: 5,
                                            borderRadius: BorderRadius.circular(20),
                                            child: Container(
                                              padding: const EdgeInsets.symmetric(
                                                  vertical: 8),
                                              width: 200,
                                              decoration: BoxDecoration(
                                                  color: const Color.fromARGB(
                                                      255, 33, 214, 250),
                                                  borderRadius:
                                                      BorderRadius.circular(20)),
                                              child: const Center(
                                                  child: Text("SIGN UP",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 18.0,
                                                          fontFamily: 'Poppins',
                                                          fontWeight:
                                                              FontWeight.bold))),
                                            ),
                                          ),
                                        ),
                                         const SizedBox(
                                          height: 20,
                                        ),
                                      ],
                                    ),
                                  ),
              
            ),
          ),
        )
           
       )
        ],
        
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        
        child: Center(
          child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const LogIn()));
                              },
                              child: const Text("Already have an account? Log In",
                                  style: TextStyle(fontSize: 15))),
        )
      ),
    );
  }
}
