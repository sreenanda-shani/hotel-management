import 'package:flutter/material.dart';
import 'package:project1/user/favuorite.dart';
import 'package:project1/user/home_page.dart';
import 'package:project1/user/hotel_price_prediction_screen.dart';
import 'package:project1/user/notification.dart';
import 'package:project1/user/profile.dart';

class BottomNavBarScreen extends StatefulWidget {
  const BottomNavBarScreen({super.key});

  @override
  _BottomNavBarScreenState createState() => _BottomNavBarScreenState();
}

class _BottomNavBarScreenState extends State<BottomNavBarScreen> {
  // Initialize the selected index to 0, which corresponds to the Home screen
  int _selectedIndex = 0;

  // List of screens for each tab
  final List<Widget> _screens = [
    const HomePage(),
    const FavouritesPage(),
    const NotificationPage(),
  const ProfilePage(),
  ];

  // Function to handle bottom navigation item tap
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: WillPopScope(
        onWillPop: () async {
          // If we are not on the home page, navigate to the home page
          if (_selectedIndex != 0) {
            setState(() {
              _selectedIndex = 0; // Switch to HomePage
            });
            return Future.value(false); // Prevent default back navigation
          }
          return Future.value(true); // Allow back navigation if already on HomePage
        },
        child: _screens[_selectedIndex], // Display the selected screen
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.grey,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped, // Call the function when an item is tapped
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: "Favorites"),
          BottomNavigationBarItem(icon: Icon(Icons.notifications), label: "Notifications"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}
