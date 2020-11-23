import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'Appointment.dart';
import 'HomePage.dart';
import 'Profile.dart';
import 'Services.dart';

class LandingPage extends StatefulWidget {
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  int _currentTab = 0;
  List<Widget> _screens = [
    HomePage(),
    Services(),
    Appointment(),
    Profile(),
  ];
  void _onItemTapped(int selectedIndex) {
    setState(() {
      _currentTab = selectedIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: _screens[_currentTab],
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Color(0xffFF7d85),
          iconSize: 30,
          onTap: _onItemTapped,
          currentIndex: _currentTab,
          items: [
            BottomNavigationBarItem(
              icon: Icon(
                FontAwesomeIcons.home,
                size: 22,
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                FontAwesomeIcons.toolbox,
                size: 22,
              ),
              label: 'service',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                FontAwesomeIcons.calendarCheck,
                size: 22,
              ),
              label: 'Appointment',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                FontAwesomeIcons.userAlt,
                size: 22,
              ),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}