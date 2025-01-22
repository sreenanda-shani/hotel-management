import 'package:flutter/material.dart';
import 'package:project1/admin/screen/admin_login.dart';
import 'package:project1/hotel/hotel_registration.dart';
import 'package:project1/user/registration_page.dart';

class ChooseScreen extends StatelessWidget {
  const ChooseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image with Gradient Overlay
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('asset/choose.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withOpacity(0.6),
                    Colors.transparent,
                    Colors.black.withOpacity(0.6),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),
          // Content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Header Text
                const Text(
                  'Who Are You?',
                  style: TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 1.5,
                    shadows: [
                      Shadow(
                        color: Colors.black45,
                        blurRadius: 5,
                        offset: Offset(1, 1),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                // Role Cards
                RoleCard(
                  title: 'Hotel',
                  icon: Icons.hotel,
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const HotelRegistrationPage(),));
                  },
                ),
                const SizedBox(height: 20),
                RoleCard(
                  title: 'User',
                  icon: Icons.person,
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const UserRegistrationPage(),));
                  },
                ),
                const SizedBox(height: 20),
                // Staff Card
                ],
            ),
          ),
          // Admin Text with Icon at the bottom center
          Positioned(
            bottom: 20,
            left: MediaQuery.of(context).size.width * 0.5 - 50, // Adjusted position
            child: GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const AdminLoginPage(),));
              },
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(width: 25),
                  Icon(
                    Icons.admin_panel_settings,
                    color: Color.fromARGB(186, 167, 162, 162),
                    size: 13, // Smaller icon size
                  ),
                  SizedBox(width: 2),
                  Text(
                    'Admin',
                    style: TextStyle(
                      color: Color.fromARGB(165, 132, 132, 132),
                      fontSize: 10, // Much smaller text size
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class RoleCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const RoleCard({super.key, 
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        width: MediaQuery.of(context).size.width * 0.8,
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.85),
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundColor: Colors.grey.shade200,
              radius: 25,
              child: Icon(
                icon,
                color: Colors.black54,
                size: 30,
              ),
            ),
            const SizedBox(width: 20),
            Text(
              title,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
