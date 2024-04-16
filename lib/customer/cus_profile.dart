import 'package:aquapro/customer/cus_navbar.dart';
import 'package:aquapro/pages/login.dart';
import 'package:aquapro/widget/widget_support.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class cusProfile extends StatefulWidget {
  const cusProfile({Key? key}) : super(key: key);

  @override
  State<cusProfile> createState() => _cusProfileState();
}

class _cusProfileState extends State<cusProfile> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  late TextEditingController _nameController;
  late TextEditingController _addressController;
  late TextEditingController _contactController;

  String _name = '';
  String _email = '';
  String _address = '';
  String _contact = '';

  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _contactController.dispose();
    super.dispose();
  }

  Future<void> _fetchUserData() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc =
          await _firestore.collection('Customer').doc(user.uid).get();
      setState(() {
        _name = userDoc.get('name') ?? '';
        _email = user.email ?? '';
        _address = userDoc.get('address') ?? '';
        _contact = userDoc.get('contact') ?? '';
        _nameController = TextEditingController(text: _name);
        _addressController = TextEditingController(text: _address);
        _contactController = TextEditingController(text: _contact);
      });
    }
  }

  Future<void> _updateUserData() async {
    User? user = _auth.currentUser;
    if (user != null) {
      await _firestore.collection('Customer').doc(user.uid).update({
        'name': _nameController.text,
        'address': _addressController.text,
        'contact': _contactController.text,
      });
      setState(() {
        _name = _nameController.text;
        _address = _addressController.text;
        _contact = _contactController.text;
        _isEditing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile', style: AppWidget.boldTextFieldStyle(),),
        leading: GestureDetector(
          onTap: () {
           Navigator.push(
                  context, MaterialPageRoute(builder: (context) => CusNavbar()));
          },
          child: Icon(
            Icons.arrow_back_ios_new_outlined,
            color: Colors.black,
          ),),
        actions: _isEditing
            ? [
                IconButton(
                  onPressed: () async {
                    await _updateUserData();
                  },
                  icon: Icon(Icons.save),
                ),
              ]
            : [],
      ),
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
        child: ListView(
          // mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              height: 60,
              padding: EdgeInsets.only(bottom: 0),
              alignment: Alignment.bottomCenter,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _isEditing = !_isEditing;
                      });
                    },
                    child: Text(
                      "Edit",
                      style: TextStyle(
                          fontSize: 18,
                          decoration: TextDecoration.underline,
                          decorationColor: Color(0xff0eb4f3),
                          fontFamily: 'Times New Roman',
                          color: Color(0xff0eb4f3),
                          fontWeight: FontWeight.w600),
                          textAlign: TextAlign.right,
                    ),
                  )
                ],
              ),
            ),
            Stack(
              children: [
                Container(
                  alignment: Alignment.center,
                  child: Image.asset(
                    'images/profile.png',
                    height: 200,
                  ),
                ),
                // Positioned(
                //   bottom: -10,
                //   right: 5,
                //   child: Icon(Icons.photo_camera,
                //       size: 50, color: Color(0xff0eb4f3)),
                // ),
                
              ],
            ),
            SizedBox(height: 30,),
            Container(
              alignment: Alignment.topLeft,
              child: Text("Following 0", textAlign: TextAlign.left, style: TextStyle(fontFamily: 'Times New Roman',
              fontSize: 15, fontWeight: FontWeight.w500),),
            ),
            SizedBox(height: 20,),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Name:',
                    style: TextStyle(
                      color: Color(0xff545454),
                      fontFamily: 'Times New Roman',
                      fontSize: 20,
                    ),
                  ),
                  _isEditing
                      ? Expanded(
                          child: TextField(
                            controller: _nameController,
                            decoration: InputDecoration(
                              hintText: 'Enter your name',
                            ),
                          ),
                        )
                      : Text(
                          _name,
                          style: TextStyle(
                            fontFamily: 'Times New Roman',
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ],
              ),
            ),
            SizedBox(height: 20,),
            Container(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Address:',
                    style: TextStyle(
                      color: Color(0xff545454),
                      fontFamily: 'Times New Roman',
                      fontSize: 20,
                    ),
                  ),
                  _isEditing
                      ? Expanded(
                          child: TextField(
                            controller: _addressController,
                            decoration: InputDecoration(
                              hintText: 'Enter your address',
                            ),
                          ),
                        )
                      : Expanded(
                          child: Text(
                            _address,
                            style: TextStyle(
                              fontFamily: 'Times New Roman',
                              fontSize: 17.5,
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.right,
                          ),
                        ),
                ],
              ),
            ),
            SizedBox(height: 20,),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Email:',
                    style: TextStyle(
                      color: Color(0xff545454),
                      fontFamily: 'Times New Roman',
                      fontSize: 20,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      _email,
                      style: TextStyle(
                        fontFamily: 'Times New Roman',
                        fontSize: 17.5,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20,),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Phone:',
                    style: TextStyle(
                      color: Color(0xff545454),
                      fontFamily: 'Times New Roman',
                      fontSize: 20,
                    ),
                  ),
                  _isEditing
                      ? Expanded(
                          child: TextField(
                            controller: _contactController,
                            decoration: InputDecoration(
                              hintText: 'Enter your contact number',
                            ),
                          ),
                        )
                      : Text(
                          _contact,
                          style: TextStyle(
                            fontFamily: 'Times New Roman',
                            fontSize: 17.5,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ],
              ),
            ),
            SizedBox(height: 30,),
            Row(children: [
              Icon(Icons.settings, size: 45, color: Color(0xff0eb4f3)),
              SizedBox(width: 12),
              Text('Settings', style: TextStyle(fontSize: 22.5)),
            ]),
            SizedBox(height: 20,),
            GestureDetector(
              onTap:() async{
                await FirebaseAuth.instance.signOut();
                Navigator.push(context, MaterialPageRoute(builder: (context)=> const LogIn()));            
              },
              child: Row(children: [
                Icon(Icons.logout_outlined, size: 45, color: Color(0xff0eb4f3)),
                SizedBox(width: 12),
                Text('Logout', style: TextStyle(fontSize: 22.5)),
              ]),
            ),
           
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: cusProfile(),
  ));
}
