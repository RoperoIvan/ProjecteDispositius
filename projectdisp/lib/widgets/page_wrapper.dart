import 'package:flutter/material.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:projectdisp/custom_colors.dart';
import '../screens/homescreen.dart';
import '../screens/search_page.dart';
import '../screens/profilescreen.dart';

class PageWrapper extends StatefulWidget {
  @override
  _PageWrapperState createState() => _PageWrapperState();
}

class _PageWrapperState extends State<PageWrapper> {
  int selectedPage = 0;
  final _pageOptions = [
    HomeScreen(),
    SearchScreen(),
    ProfileScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pageOptions[selectedPage],
      bottomNavigationBar: ConvexAppBar(
        items:[
      TabItem(icon: Icons.home, title: 'Home'),
      TabItem(icon: Icons.search, title: 'Search'),
      TabItem(icon: Icons.people, title: 'Profile'),
      ],
      backgroundColor: customViolet,
      activeColor: Colors.amber,
      //cornerRadius: 10,
      top:-20,
      //height: 50,
      curveSize: 90,
      onTap: (index) {
        setState(() {
          selectedPage = index;
          });
        },
      ),
    );
  }
}