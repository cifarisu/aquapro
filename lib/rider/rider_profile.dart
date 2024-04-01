import "package:aquapro/widget/widget_support.dart";
import "package:flutter/material.dart";

class RiderProfile extends StatefulWidget {
  const RiderProfile({super.key});

  @override
  State<RiderProfile> createState() => _RiderProfileState();
}

class _RiderProfileState extends State<RiderProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(left: 35, right: 35),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xff81e6eb), Color(0xffffffff)]),
        ),  
        child: 
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
          
          Container(
            height: 60,
            padding: EdgeInsets.only(bottom: 0),
            alignment: Alignment.bottomCenter,
            
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              
              children: [
              Text(
                      "Profile",
                      style:TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                    ),
              Container(
               
                child: Text("Edit", style:TextStyle(fontSize: 18, decoration: TextDecoration.underline, decorationColor: Color(0xff0eb4f3) ,fontFamily: 'Times New Roman', 
                color: Color(0xff0eb4f3), fontWeight: FontWeight.w600),
                ))
            ],),

          ),
          Row(
            children: [
              Stack(children:[Container(child: Image.asset('images/profile.png', height: 140,)),
              Positioned(
                bottom: -3, 
                right: -2,
                child: Icon(Icons.photo_camera, size: 40, color: Color(0xff0eb4f3),))] ),
              Container(
                padding: EdgeInsets.only(left: 30),
                
                // alignment: Alignment.center,
                width: 280,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Joylan Water Refilling Station', style:TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Color(0xff0eb4f3)),),
                    Text('Followers 46', textAlign: TextAlign.left, style: TextStyle(fontFamily: 'Times New Roman', 
                    fontSize: 15, fontWeight: FontWeight.w500),)
                  ],
                ))
            ],
          ),
          Container(child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
            Text('Name:', style: TextStyle(color: Color(0xff545454), fontFamily: 'Times New Roman',
            fontSize: 20, ),),
            Text("Adrian Jones Abache", style: TextStyle( fontFamily: 'Times New Roman',
            fontSize: 20, fontWeight: FontWeight.w600))
          ],),),
           Container(
            
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
            Text('Address:', style: TextStyle(color: Color(0xff545454), fontFamily: 'Times New Roman',
            fontSize: 20, ),),
            Container(
              alignment: Alignment.centerRight,
              
              width: 300,
              child: Text("Barangay 2 Em’s Barrio South, Legazpi City, Albay", style: TextStyle( fontFamily: 'Times New Roman',
              fontSize: 17.5, fontWeight: FontWeight.w600), textAlign: TextAlign.right,),
            )
          ],),),
           Container(child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
            Text('Email:', style: TextStyle(color: Color(0xff545454), fontFamily: 'Times New Roman',
            fontSize: 20, ),),
            Container(
              
              width: 320,
              child: Text("ajtheinventor23@gmail.com", style: TextStyle( fontFamily: 'Times New Roman',
              fontSize: 17.5, fontWeight: FontWeight.w600), textAlign: TextAlign.right),
            )
          ],),),
           Container(child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
            Text('Phone:', style: TextStyle(color: Color(0xff545454), fontFamily: 'Times New Roman',
            fontSize: 20, ),),
            Text("09954464587", style: TextStyle( fontFamily: 'Times New Roman',
            fontSize: 17.5, fontWeight: FontWeight.w600))
          ],
          ),
          ),
          Row(children: [
            Icon(Icons.settings, size: 50, color: Color(0xff0eb4f3),), 
            SizedBox(width: 12,),
            Text('Settings', style: TextStyle(fontSize: 22.5),)
          ],),
          Row(children: [
            Icon(Icons.info, size: 50, color: Color(0xff0eb4f3),), 
            SizedBox(width: 12,),
            Text('About Us', style: TextStyle(fontSize: 22.5),)
          ],),
          SizedBox(height: 50,)
        ],)
        
      ),
    );
  }
}