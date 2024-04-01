import "package:aquapro/widget/widget_support.dart";
import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";

class cusToPay extends StatefulWidget {
  const cusToPay({super.key});

  @override
  State<cusToPay> createState() => _cusToPayState();
}

class _cusToPayState extends State<cusToPay> {
  int total = 1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xff81e6eb), Color(0xffffffff)]),
        ),
        child: 
        
        Container(

                      padding: EdgeInsets.only(left: 5, right: 5, top: 30,),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            
                            SizedBox(width: 14.0,),
                            Container(
                              padding: EdgeInsets.all(5),
                               decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Color.fromARGB(0, 0, 0, 0),
                                  border: Border.all(
                                    width: 3,
                                    color: Color(0xff0EB4F3),
                                  )),
                              child: ClipRRect(
                                child: Image.asset(
                                "images/flat.png",
                                height: 120, 
                                width: 120, 
                                fit: BoxFit.cover,),
                              ),
                            ),
                            SizedBox(width: 20.0,),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(height: 8.0,),
                              Container(
                                width: MediaQuery.of(context).size.width/1.6,
                                child: Text("Joylan Water Refilling Station",
                                style: TextStyle(fontFamily: "Times New Roman", fontSize: 15, fontWeight: FontWeight.w600))
                              ),
                              SizedBox(height: 5.0,),
                              Container(
                                width: MediaQuery.of(context).size.width/1.6,
                                child: Text("New Slim Container w/ water" + "     x" + total.toString(),
                                style: TextStyle(fontFamily: "Times New Roman", fontSize: 13, fontWeight: FontWeight.w800))
                              ),
                              SizedBox(height: 3.0,),
                              Container(
                                width: MediaQuery.of(context).size.width/1.6,
                                child: Text("Php " + "230.00" + "     |     " + "Deliver",
                                style: TextStyle(fontFamily: "Callibri", fontSize: 14, fontWeight: FontWeight.w400))
                              ),
                             SizedBox(height: 10.0,),
                              Row(
                                children: [
                                  GestureDetector(
                                    onTap: () => showDialog<String>(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                actionsPadding: EdgeInsets.only(bottom: 10),
                contentPadding: EdgeInsets.only(top: 30),
                backgroundColor: Colors.white,
                content: SingleChildScrollView(
                  child: ListBody(
                    children: <Widget>[
                      Container(
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Are you sure you want to',
                              style: TextStyle(fontSize: 17),
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              " Cancel",
                              style: TextStyle(
                                  fontSize: 17, color: Color(0xffff3131)),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                      Text(
                        'your order?',
                        style: TextStyle(fontSize: 17),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 2,
                        color: Color(0xffbfbdbc),
                      )
                    ],
                  ),
                ),
                actions: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, 'Continue'),
                        child: Text(
                          'Continue',
                          style: TextStyle(
                            color: Color(0xff0eb4f3),
                            fontSize: 20,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, 'Cancel'),
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 20,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
                                    child: Container(
                                      width: 100,
                                      padding: EdgeInsets.only(left: 5, right: 5),
                                     decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30),
                                      color: Color.fromARGB(0, 0, 0, 0),
                                        border: Border.all(
                                          width: 2,
                                          color: Color(0xffff3131),
                                        )),
                                      child:  Center(
                                      child: Text(
                                        "CANCEL",
                                        style: TextStyle(
                                          fontFamily: 'Callibri',
                                          fontSize: 13,
                                          color: Color(0xffff3131)
                                        ),
                                      ),
                                    ),
                                    ),
                                  ),
                                  SizedBox(width: 210.0,),
                                ],
                              )
                             
                              
                            ],)
                          ],
                        ),
                    ),

      ),
    );
  }
}