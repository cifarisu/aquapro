// ignore_for_file: non_constant_identifier_names, prefer_const_constructors

import 'package:flutter/material.dart';

class AppWidget{
  static TextStyle boldTextFieldStyle(){
    return const TextStyle(color: Colors.black, fontSize: 20.0, fontWeight: FontWeight.bold, fontFamily: 'Poppins');

  }

  static TextStyle HeadlineTextFeildStyle(){
    return TextStyle(
                color: Colors.black, 
                fontSize: 24.0, 
                fontWeight: FontWeight.bold, 
                fontFamily: 'Poppins');
  }

  static TextStyle LightTextFeildStyle(){
    return TextStyle(
                color: Colors.black38, 
                fontSize: 15.0, 
                fontWeight: FontWeight.w500, 
                fontFamily: 'Poppins');
  }

  static TextStyle semiBoldTextFeildStyle(){
    return TextStyle(
                color: Colors.black, 
                fontSize: 18.0, 
                fontWeight: FontWeight.w500, 
                fontFamily: 'Poppins');
  }

  static TextStyle BlueTextFeildStyle(){
    return TextStyle(
                color: Color(0xff0EB4F3), 
                fontSize: 15.0, 
                fontWeight: FontWeight.w500, 
                fontFamily: 'Poppins');
  }

  static TextStyle BlackTextFeildStyle(){
    return TextStyle(
                color: Colors.black, 
                fontSize: 16.0, 
                fontWeight: FontWeight.w500, 
                fontFamily: 'Poppins');
}

static TextStyle SmallTextFeildStyle(){
    return TextStyle(
                color: Colors.black, 
                fontSize: 13.0, 
                fontWeight: FontWeight.w400, 
                fontFamily: 'Poppins');
}

}