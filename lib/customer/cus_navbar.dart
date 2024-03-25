import "package:aquapro/customer/cus_home.dart";
import "package:aquapro/customer/cus_orders.dart";
import "package:aquapro/customer/cus_profile.dart";
import "package:flutter/material.dart";

class CusNavbar extends StatefulWidget {
  const CusNavbar({super.key});

  @override
  State<CusNavbar> createState() => _CusNavbarState();
}

class _CusNavbarState extends State<CusNavbar> {

  int _selectedIndex = 0;

  late List<Widget> pages;
  late Widget currentPage;
  late CusHome homepage;
  late cusOrders cusorders;
  late cusProfile cusprofile;
  
  @override
  void initState() {
    homepage=CusHome();
    cusorders=cusOrders();
    cusprofile=cusProfile();
     pages = [homepage, cusorders, cusprofile];
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
            icon: Icon(Icons.shopping_cart_rounded),
            label: 'Orders',
            
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