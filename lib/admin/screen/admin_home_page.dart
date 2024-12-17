import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project1/admin/screen/_screen.dart';
import 'package:project1/admin/screen/admin_hotel_management.dart';
import 'package:project1/choose_screen.dart';

class AdminHomePage extends StatelessWidget {
  const AdminHomePage({Key? key}) : super(key: key);

  // Function to handle logout
  void _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => ChooseScreen()),
    );
  }

  // Reusable button widget with gradient effect
  Widget _buildMenuButton(String title, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Colors.teal, Colors.greenAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.4),
              spreadRadius: 1,
              blurRadius: 6,
              offset: const Offset(2, 4),
            ),
          ],
        ),
        child: ListTile(
          leading: Icon(icon, color: Colors.white, size: 30),
          title: Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Gradient AppBar
      appBar: AppBar(
        title: const Text('Admin Dashboard',style: TextStyle(color: Colors.white),),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.teal, Colors.greenAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout,color: Colors.red,),
            onPressed: () => _logout(context),
          ),
        ],
      ),
      // Background with gradient
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.tealAccent],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              _buildMenuButton(
                'Hotel Management',
                Icons.business,
                () {
                  // Navigate to Hotel Management Screen

                  Navigator.push(context, MaterialPageRoute(builder: (context) => AdminHotelManagementScreen(),));
                },
              ),
              _buildMenuButton(
                'User View',
                Icons.people,
                () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => AdminUserScreen(),));
                },
              ),
              _buildMenuButton(
                'Complaint Management',
                Icons.report_problem,
                () {
                  // Navigate to Complaint Management Screen
                },
              ),
              _buildMenuButton(
                'Chat',
                Icons.chat,
                () {
                  // Navigate to Chat Screen
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
