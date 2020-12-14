import 'package:flutter/material.dart';
import '../sign_in_flow/auth_state_switch.dart';
import '../screens/homescreen.dart';
import '../screens/search_page.dart';
import '../screens/profilescreen.dart';


class PageWrapper extends StatefulWidget {
  @override
  _PageWrapperState createState() => _PageWrapperState();
}

class _PageWrapperState extends State<PageWrapper> {
  int selectedPage = 2;
  final _pageOptions = [
    HomeScreen(),
    SearchScreen(),
    AuthStateSwitch(app:ProfileScreen()),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pageOptions[selectedPage],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          )
        ],
        currentIndex: selectedPage,
        selectedItemColor: Colors.amber[800],
        onTap: (index) {
          setState(() {
            selectedPage = index;
          });
        },
      ),
    );
  }
}
