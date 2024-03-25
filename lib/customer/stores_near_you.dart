import 'package:aquapro/customer/cus_stores.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StoresNearYou extends StatefulWidget {
  const StoresNearYou({Key? key});

  @override
  State<StoresNearYou> createState() => _StoresNearYouState();
}

class _StoresNearYouState extends State<StoresNearYou> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        shadowColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0,
        titleSpacing: -3,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back_ios_new_outlined,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.transparent,
        title: Text(
          "Stores Near You",
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Container(
        padding: EdgeInsets.only(top: 120),
        alignment: Alignment.topLeft,
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xff81e6eb), Color(0xffffffff)]),
        ),
        child: Container(
          padding: EdgeInsets.only(top: 5, left: 40, right: 40),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: Colors.white,
          ),
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('Store').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }
              final List<DocumentSnapshot> stores = snapshot.data!.docs;
              return ListView.builder(
                itemCount: stores.length,
                itemBuilder: (context, index) {
                  final store = stores[index];
                  final name = store['name'];
                  final address = store['address'];
                  final contact = store['contact'];
                  final time = store['time'];
                  final imageUrl = store['url'];

                  return GestureDetector(
                    onTap: () async {
                      final productsSnapshot = await store.reference.collection('Products').get();
                      final List<DocumentSnapshot> products = productsSnapshot.docs;
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Stores(
                            name: name,
                            address: address,
                            contact: contact,
                            time: time,
                            imageUrl: imageUrl,
                            products: products,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      margin: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        border: Border.all(color: Color(0xff0EB4F3), width: 3),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Material(
                        elevation: 5.0,
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          constraints: BoxConstraints(minWidth: 330, maxWidth: 330),
                          padding: EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                alignment: Alignment.topCenter,
                                width: MediaQuery.of(context).size.height,
                                child: SizedBox(
                                  width: 330,
                                  height: 200,
                                  child: Image.network(
                                    imageUrl,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              SizedBox(height: 5.0),
                              Text(
                                name,
                                textAlign: TextAlign.center,
                                style: TextStyle(fontFamily: 'Times New Roman', fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 5.0),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(Icons.location_on, color: Color(0xff0EB4F3), size: 30),
                                  SizedBox(width: 8),
                                  Container(
                                    constraints: BoxConstraints(maxWidth: 240),
                                    child: Text(
                                      address,
                                      style: TextStyle(fontFamily: 'Callibri', fontSize: 13, fontWeight: FontWeight.w500),
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(height: 12.0),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(width: 2),
                                  Container(
                                    constraints: BoxConstraints(maxWidth: 25, minWidth: 25, minHeight: 25),
                                    decoration: BoxDecoration(color: Color(0xff0EB4F3), borderRadius: BorderRadius.circular(20)),
                                    child: Icon(Icons.phone, color: Colors.white, size: 20),
                                  ),
                                  SizedBox(width: 13),
                                  Container(
                                    constraints: BoxConstraints(maxWidth: 240),
                                    child: Text(
                                      contact,
                                      style: TextStyle(fontFamily: 'Callibri', fontSize: 13, fontWeight: FontWeight.w500),
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(height: 12.0),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    child: Icon(Icons.access_time, color: Color(0xff0EB4F3), size: 30),
                                  ),
                                  SizedBox(width: 10),
                                  Container(
                                    constraints: BoxConstraints(maxWidth: 230),
                                    child: Text(
                                      time,
                                      style: TextStyle(fontFamily: 'Callibri', fontSize: 13, fontWeight: FontWeight.w500),
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
