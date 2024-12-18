import 'package:flutter/material.dart';
import 'package:project1/admin/screen/feedback.dart';
import 'package:project1/admin/screen/notification.dart';
import 'package:project1/admin/usersearchpage.dart';

import 'analytics_screen.dart';
import 'hotel_management_screen.dart';



class AdminHomePage extends StatelessWidget {
  const AdminHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Admin Home',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: AdminHomeScreen(),
    );
  }
}

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({super.key});

  @override
  _AdminHomeScreenState createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  int _selectedIndex = 0;

  // List of pages for each navigation item
  final List<Widget> _pages = [
    const UserSearchPage(),
    AnalyticsScreen(),
    HotelManagementScreen(),
    NotificationScreen(),
   const AdminFeedback(),
  ];

  // This function is triggered when a navigation item is tapped
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Home'),
        centerTitle: true,
      ),
      // Body changes based on the selected index
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'User Details',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics),
            label: 'Analytics',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.hotel),
            label: 'Hotel Management',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notification',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.feedback),
            label: 'Feedback',
          ),
         
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped, // Update index when tapped
      ),
    );
  }
}
