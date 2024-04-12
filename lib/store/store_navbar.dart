import "package:aquapro/customer/cus_orders.dart";
import "package:aquapro/customer/cus_profile.dart";
import "package:aquapro/pages/home.dart";
import "package:aquapro/rider/rider_home.dart";
import "package:aquapro/rider/rider_profile.dart";
import "package:aquapro/rider/rider_deliveries.dart";
import "package:aquapro/store/store_home.dart";
import "package:aquapro/store/store_profile.dart";
import "package:aquapro/store/store_track_orders.dart";
import "package:flutter/material.dart";

class StoreNavbar extends StatefulWidget {
  const StoreNavbar({super.key});

  @override
  State<StoreNavbar> createState() => _StoreNavbarState();
}

class _StoreNavbarState extends State<StoreNavbar> {
  int _selectedIndex = 0;

  late List<Widget> pages;
  late Widget currentPage;
  late StoreHome homepage;
  late TrackOrders trackorders;
  late StoreProfile storeprofile;

  @override
  void initState() {
    homepage = StoreHome();
    trackorders = TrackOrders();
    storeprofile = StoreProfile();
    pages = [homepage, trackorders, storeprofile];
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
            label: 'Track Orders',
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
