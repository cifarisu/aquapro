// ignore_for_file: prefer_const_constructors, camel_case_types

import 'package:aquapro/pages/login.dart';
import 'package:aquapro/pages/signup.dart';
import 'package:flutter/material.dart';

class frontPage extends StatefulWidget {
  const frontPage({super.key});

  @override
  State<frontPage> createState() => _frontPageState();
}

class _frontPageState extends State<frontPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image:DecorationImage(
            image: AssetImage(
              "images/background.png"), 
              fit: BoxFit.cover
          )
        ),
        child: 
        Column(
          children: [
            SizedBox(height: 200,),
            Center(
              child: Image.asset(
                "images/logo.png", 
                width: MediaQuery.of(context).size.width/1.3,
                fit: BoxFit.cover,)
            ),
            SizedBox(height: 50,),
            GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=> const LogIn()));            
              },
              child: Material(
                elevation: 5,
                borderRadius: BorderRadius.circular(30),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  width: 300,
                  height: 80,
                  decoration: BoxDecoration(color:const Color.fromARGB(255, 33, 214, 250), borderRadius: BorderRadius.circular(30)),
                  child: const Center(child: Text("Login", style: TextStyle(color: Colors.white, fontSize: 30.0, fontFamily: 'Poppins', fontWeight: FontWeight.bold))),
                ),
              ),
            ),
            SizedBox(height: 20,),
            GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=> SignUp()));
              },
              child: Text(
                "Register", 
                style: TextStyle(
                  fontSize: 18, 
                  decoration: TextDecoration.underline,
                  fontWeight: FontWeight.w800,
                  fontFamily: "Times New Roman"
                  )
              )
            ),
          ],
        ),
        
      ),
    );
  }
}