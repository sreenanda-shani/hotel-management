import 'package:flutter/material.dart';
import 'package:project1/admin/screen/admin_hotel_management.dart';
import 'package:project1/admin/screen/feedback.dart';
import 'package:project1/admin/screen/notification.dart';
import 'package:project1/admin/usersearchpage.dart';

import 'analytics_screen.dart';





class AdminUserScreen extends StatefulWidget {
  const AdminUserScreen({super.key});

  @override
  _AdminUserScreenState createState() => _AdminUserScreenState();
}

class _AdminUserScreenState extends State<AdminUserScreen> {
  int _selectedIndex = 0;

  // List of pages for each navigation item
  final List<Widget> _pages = [
    const AnalyticsScreen(),
    const UserSearchPage(),
    const AdminHotelManagementScreen(),
    const NotificationScreen(),
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
      floatingActionButton:  FloatingActionButton(
        onPressed: () {
          
        
      },),
      
      // Body changes based on the selected index
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics),
            label: 'Analytics',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'User Details',
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
