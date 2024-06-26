import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:aquapro/customer/cus_choose_loc.dart';
import 'package:aquapro/customer/cus_navbar.dart';
import 'package:aquapro/customer/try.dart';
import 'package:aquapro/pages/home.dart';
import 'package:aquapro/pages/signup.dart';
import 'package:aquapro/rider/rider_choose_loc.dart';
import 'package:aquapro/rider/rider_navbar.dart';
import 'package:aquapro/store/store_choose_loc.dart';
import 'package:aquapro/store/store_navbar.dart';
import 'package:aquapro/widget/widget_support.dart';

class LogIn extends StatefulWidget {
  const LogIn({Key? key}) : super(key: key);

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  bool _isTapped = false;
  bool _isLoading = false; // Added isLoading state
  String email = "", password = "";
  final _formkey = GlobalKey<FormState>();

  TextEditingController useremailcontroller = new TextEditingController();
  TextEditingController userpasswordcontroller = new TextEditingController();

  userLogin() async {
    setState(() {
      _isLoading = true; // Set isLoading to true when login process starts
    });

    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      String uid = userCredential.user!.uid;

      // Check each collection to see if the user's ID exists in it
      if (await FirebaseFirestore.instance
          .collection('Customer')
          .doc(uid)
          .get()
          .then((doc) => doc.exists)) {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => CusChooseLocation()));
      } else if (await FirebaseFirestore.instance
          .collection('Rider')
          .doc(uid)
          .get()
          .then((doc) => doc.exists)) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => RiderNavbar()));
      } else if (await FirebaseFirestore.instance
          .collection('Store')
          .doc(uid)
          .get()
          .then((doc) => doc.exists)) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => StoreNavbar()));
      } else {
        // Handle unexpected situation
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
          "No User Found for this Email",
          style: TextStyle(fontSize: 18.0, color: Colors.black),
        )));
      } else if (e.code == 'wrong-password') {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
          "Wrong password",
          style: TextStyle(fontSize: 18.0, color: Colors.black),
        )));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.redAccent,
            content: Text(
              "Wrong email or password",
              style: TextStyle(fontSize: 18.0, color: Colors.white),
            )));
      }
    } finally {
      setState(() {
        _isLoading =
            false; // Set isLoading to false after login process completes
      });
    }
  }

  void _handleTapDown(TapDownDetails details) {
    setState(() {
      _isTapped = true;
    });
  }

  void _handleTapUp(TapUpDetails details) {
    setState(() {
      _isTapped = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
        onWillPop: () async => false,
        child: Container(
          child: Stack(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 2.5,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color.fromARGB(255, 33, 214, 250),
                        Color.fromARGB(255, 184, 247, 251)
                      ]),
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height / 3),
                height: MediaQuery.of(context).size.height / 2,
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                ),
                child: const Text(""),
              ),
              Container(
                margin: const EdgeInsets.only(top: 55, left: 20, right: 20),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Center(
                          child: Image.asset(
                        "images/logo.png",
                        width: MediaQuery.of(context).size.width / 2,
                        fit: BoxFit.cover,
                      )),
                      const SizedBox(
                        height: 50.0,
                      ),
                      Material(
                        elevation: 5.0,
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          padding: const EdgeInsets.only(left: 20, right: 20),
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height / 2,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20)),
                          child: SingleChildScrollView(
                            child: Form(
                              key: _formkey,
                              child: Column(children: [
                                const SizedBox(
                                  height: 30,
                                ),
                                Text(
                                  "Login",
                                  style: AppWidget.boldTextFieldStyle(),
                                ),
                                const SizedBox(
                                  height: 30,
                                ),
                                TextFormField(
                                  controller: useremailcontroller,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please Enter Email';
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
                                  controller: userpasswordcontroller,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please Enter Password';
                                    }
                                    return null;
                                  },
                                  obscureText: true,
                                  decoration: InputDecoration(
                                      hintText: 'Password',
                                      hintStyle: AppWidget.boldTextFieldStyle(),
                                      prefixIcon:
                                          const Icon(Icons.password_outlined)),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Container(
                                  alignment: Alignment.topRight,
                                  child: Text(
                                    "Forgot Password?",
                                    style: AppWidget.boldTextFieldStyle(),
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    if (_formkey.currentState!.validate()) {
                                      setState(() {
                                        email = useremailcontroller.text;
                                        password = userpasswordcontroller.text;
                                      });
                                    }
                                    userLogin();
                                  },
                                  onTapDown: _handleTapDown,
                                  onTapUp: _handleTapUp,
                                  onTapCancel: () {
                                    setState(() {
                                      _isTapped = false;
                                    });
                                  },
                                  child: _isLoading
                                      ? CircularProgressIndicator() // Show CircularProgressIndicator when isLoading is true
                                      : Material(
                                          elevation: 5,
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 8),
                                            width: 200,
                                            decoration: BoxDecoration(
                                                color: _isTapped
                                                    ? Color.fromARGB(
                                                            255, 33, 214, 250)
                                                        .withOpacity(0.5)
                                                    : Color.fromARGB(
                                                        255, 33, 214, 250),
                                                borderRadius:
                                                    BorderRadius.circular(20)),
                                            child: const Center(
                                                child: Text("LOG IN",
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
                                  height: 50,
                                ),
                                GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const SignUp()));
                                    },
                                    child: const Text(
                                        "Don't have an account? Sign Up",
                                        style: TextStyle(fontSize: 15))),
                              ]),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
