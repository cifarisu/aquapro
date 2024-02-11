import 'package:aquapro/pages/signup.dart';
import 'package:aquapro/widget/widget_support.dart';
import 'package:flutter/material.dart';

class LogIn extends StatefulWidget {
  const LogIn({super.key});

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(child: Stack(children: [
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height/2.5,
          decoration: BoxDecoration(gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFFff5c30), Color(0xFFe74b1a)
              ]),),
        ),
        Container(
          margin: EdgeInsets.only(top: MediaQuery.of(context).size.height/3),
          height: MediaQuery.of(context).size.height/2,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.only(topLeft: Radius.circular(40),topRight: Radius.circular(40),),),
          child: Text(""),
        ),
        Container(
          margin: EdgeInsets.only(top:55, left: 20, right: 20),
          child: SingleChildScrollView(
            child: Column(children: [
              Center(child: Image.asset("images/logo.png", width: MediaQuery.of(context).size.width/2,fit: BoxFit.cover,)),
              SizedBox(height: 50.0,),
              Material(
                elevation: 5.0,
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height/2,
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                  child: SingleChildScrollView(
                    child: Column(children: [
                      SizedBox(height: 30,),
                      Text("Login", style: AppWidget.boldTextFieldStyle(),
                      ),
                      SizedBox(
                        height:30,
                      ),
                      TextField(
                        decoration: InputDecoration(hintText: 'Email', hintStyle: AppWidget.boldTextFieldStyle(), prefixIcon: Icon(Icons.email_outlined)),
                      ),
                      SizedBox(
                        height:30,
                      ),
                      TextField(
                        obscureText: true,
                        decoration: InputDecoration(hintText: 'Password', hintStyle: AppWidget.boldTextFieldStyle(), prefixIcon: Icon(Icons.password_outlined)),
                      ),
                      SizedBox(height: 20,),
                      Container(
                        alignment: Alignment.topRight,
                        child: Text("Forgot Password?", style: AppWidget.boldTextFieldStyle(),),),
                      SizedBox(height: 20,),
                      Material(
                        elevation: 5,
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          width: 200,
                          decoration: BoxDecoration(color: Color(0Xffff5722), borderRadius: BorderRadius.circular(20)),
                          child: Center(child: Text("LOG IN", style: TextStyle(color: Colors.white, fontSize: 18.0, fontFamily: 'Poppins', fontWeight: FontWeight.bold))),
                        ),
                      ),
                      SizedBox(height: 50,),
                      GestureDetector(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context)=> SignUp()));
                          },
                          child: Text("Don't have an account? Sign Up", style: TextStyle(fontSize: 15))),
                    ]),
                  ),
                ),
              )
            ],),
          ),
        )
      ],),),
    );
  }
}
