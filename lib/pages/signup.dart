// ignore_for_file: unnecessary_null_comparison, unused_local_variable, prefer_const_constructors

import 'package:aquapro/pages/home.dart';
import 'package:aquapro/pages/login.dart';
import 'package:aquapro/widget/widget_support.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';



class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {

  String email="", password="", name="", type="df";


  TextEditingController namecontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();
  TextEditingController mailcontroller = TextEditingController();
  TextEditingController typecontroller = TextEditingController();

  final _formkey=GlobalKey<FormState>();

registration() async {
  if (password != null) {
    try {
    UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);

    ScaffoldMessenger.of(context).showSnackBar((SnackBar(
        backgroundColor: Colors.redAccent,
        content: Text(
          "Registered Successfully", 
          style: TextStyle(fontSize: 20)
        ),
      )),
    );
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> const Home()));
  } on FirebaseException catch (e) {
    if (e.code == 'weak-password') {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.orangeAccent,
          content: Text("Password is too weak", style: TextStyle(fontSize: 18)),
        ),
      );
    } else if (e.code == 'email-already-in-use') {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.orangeAccent,
          content: Text("Account already exists", style: TextStyle(fontSize: 18)),
        ),
      );
    }
  }
  }
}





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(child: Stack(children: [
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height/2.5,
          decoration: const BoxDecoration(gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color.fromARGB(255, 2, 206, 247), Color.fromARGB(255, 255, 255, 255)
              ]),),
        ),
        Container(
          margin: EdgeInsets.only(top: MediaQuery.of(context).size.height/3),
          height: MediaQuery.of(context).size.height/2,
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(color: Colors.white,borderRadius: BorderRadius.only(topLeft: Radius.circular(40),topRight: Radius.circular(40),),),
          child: const Text(""),
        ),
        Container(
          margin: const EdgeInsets.only(top:55, left: 20, right: 20),
          child: SingleChildScrollView(
            child: Column(children: [
              Center(child: Image.asset("images/logo.png", width: MediaQuery.of(context).size.width/2,fit: BoxFit.cover,)),
              const SizedBox(height: 50.0,),
              Material(
                elevation: 5.0,
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height/2,
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                  child: SingleChildScrollView(
                    child: Form(
                      key: _formkey,
                      child: Column(children: [
                        const SizedBox(height: 30,),
                        Text("Sign Up", style: AppWidget.boldTextFieldStyle(),
                        ),
                        const SizedBox(
                          height:30,
                        ),
                        TextFormField(
                          controller: namecontroller,
                          validator: (value){
                            if(value==null || value.isEmpty){
                              return 'Please Enter Name';
                            }
                            return null;
                          },
                          decoration: InputDecoration(hintText: 'Name', hintStyle: AppWidget.boldTextFieldStyle(), prefixIcon: const Icon(Icons.person_outlined)),
                        ),
                        const SizedBox(
                          height:30,
                        ),
                        TextFormField(
                           controller: mailcontroller,
                          validator: (value){
                            if(value==null || value.isEmpty){
                              return 'Please Enter E-Email';
                            }
                            return null;
                          },
                          decoration: InputDecoration(hintText: 'Email', hintStyle: AppWidget.boldTextFieldStyle(), prefixIcon: const Icon(Icons.email_outlined)),
                        ),
                        const SizedBox(
                          height:30,
                        ),
                        TextFormField(
                           controller: typecontroller,
                          validator: (value){
                            if(value==null || value.isEmpty){
                              return 'Please choose user type';
                            }
                            return null;
                          },
                          decoration: InputDecoration(hintText: 'Type', hintStyle: AppWidget.boldTextFieldStyle(), prefixIcon: const Icon(Icons.email_outlined)),
                        ),
                        const SizedBox(
                          height:30,
                        ),
                        TextFormField(
                           controller: passwordcontroller,
                            validator: (value){
                            if(value==null || value.isEmpty){
                              return 'Please Enter password';
                            }
                            return null;
                          },
                          obscureText: true,
                          decoration: InputDecoration(hintText: 'Password', hintStyle: AppWidget.boldTextFieldStyle(), prefixIcon: const Icon(Icons.password_outlined)),
                        ),
                        const SizedBox(height: 20,),
                        GestureDetector(
                          onTap: () async {
                            if(_formkey.currentState!.validate()){
                              setState(() {
                                email=mailcontroller.text;
                                type=typecontroller.text;
                                name=namecontroller.text;
                                password=passwordcontroller.text;

                              });
                            }
                            registration();
                          },
                          child: Material(
                            elevation: 5,
                            borderRadius: BorderRadius.circular(20),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              width: 200,
                              decoration: BoxDecoration(color: const Color.fromARGB(255, 33, 214, 250), borderRadius: BorderRadius.circular(20)),
                              child: const Center(child: Text("SIGN UP", style: TextStyle(color: Colors.white, fontSize: 18.0, fontFamily: 'Poppins', fontWeight: FontWeight.bold))),
                            ),
                          ),
                        ),
                        
                      ]),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 50,),
              GestureDetector(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> const LogIn()));
                },
              child: const Text("Already have an account? Log In", style: TextStyle(fontSize: 15))),
            ],),
          ),
        )
      ],),),
    );
  }
}
