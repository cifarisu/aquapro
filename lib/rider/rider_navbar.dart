import "package:aquapro/customer/cus_orders.dart";
import "package:aquapro/customer/cus_profile.dart";
import "package:aquapro/pages/home.dart";
import "package:aquapro/rider/rider_home.dart";
import "package:aquapro/rider/rider_profile.dart";
import "package:aquapro/rider/deliveries.dart";
import "package:flutter/material.dart";

class RiderNavbar extends StatefulWidget {
  const RiderNavbar({super.key});

  @override
  State<RiderNavbar> createState() => _RiderNavbarState();
}

class _RiderNavbarState extends State<RiderNavbar> {

  int _selectedIndex = 0;

  late List<Widget> pages;
  late Widget currentPage;
  late RiderHome homepage;
  late Deliveries deliveries;
  late RiderProfile riderprofile;
  
  @override
  void initState() {
    homepage=RiderHome();
    deliveries=Deliveries();
    riderprofile=RiderProfile();
     pages = [homepage, deliveries,  riderprofile];
    super.initState();
  }

   void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        iconSize: 45,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_shipping_rounded),
            label: 'Deliveries',
            
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_rounded),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Color(0xff0eb4f3),
        onTap: _onItemTapped,
       
        
      ),
       
    );
  }
}