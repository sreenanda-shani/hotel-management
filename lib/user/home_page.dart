import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:project1/user/favuorite.dart';
import 'package:project1/user/hotel_details.dart';
import 'package:project1/user/notification.dart';
import 'package:project1/user/orders.dart';
import 'package:project1/user/profile.dart';
import 'package:project1/user/feedback.dart';
import 'package:project1/user/login_page.dart';
import 'package:project1/user/user_hotelhomepage.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(120),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.transparent,
          ),
          child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            flexibleSpace: Center(
              child: Container(
                padding: const EdgeInsets.all(5),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                child: const CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white,
                  backgroundImage: AssetImage("asset/download.png"),
                ),
              ),
            ),
          ),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blueAccent,
              ),
              child: UserDrawerHeader(), // Make sure this widget is defined somewhere in your project
            ),
            _buildDrawerItem(Icons.person, "Profile", () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfilePage()),
              );
            }),
            _buildDrawerItem(Icons.search, "Search Hotel", () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HotelDetailsPage()), // Fixed typo
              );
            }),
            _buildDrawerItem(Icons.history, "Booking History", () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const MyBookingsPage(
                    hotel: {
                      'hotelName': 'Oceanview Resort',
                      'address': '123 Beach Road, Seaside City',
                      'location': 'Seaside City',
                      'checkInDate': '2024-11-15',
                      'checkOutDate': '2024-11-18',
                      'price': '\$450',
                      'amenities': const ['Free WiFi', 'Swimming Pool', 'Gym', 'Spa'],
                      'description': 'A luxury resort by the ocean with stunning views and premium facilities.',
                      'image': 'assets/asset/image1.jpeg',
                    },
                  ),
                ),
              );
            }),
            _buildDrawerItem(Icons.favorite, "Favourites", () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) =>  FavouritesPage()),
              );
            }),
            _buildDrawerItem(Icons.notifications, "Notifications", () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NotificationPage()),
              );
            }),
            _buildDrawerItem(Icons.feedback, "Feedback", () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const FeedbackPage()),
              );
            }),
            _buildDrawerItem(Icons.login, "Logout", () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return const UserLoginPage();
              }));
            }),
          ],
        ),
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.lightBlue.shade50, Colors.blueAccent.shade100],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  Stack(
                    children: [
                      Container(
                        height: 300,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          image: const DecorationImage(
                            image: AssetImage("asset/image1.jpeg"),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Container(
                        height: 300,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          gradient: const LinearGradient(
                            colors: [Colors.black54, Colors.transparent],
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                          ),
                        ),
                      ),
                      const Positioned(
                        bottom: 20,
                        left: 20,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "ENJOY A LUXURY EXPERIENCE",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              "Luxury Hotel & Best Resort",
                              style: TextStyle(color: Colors.white, fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Center(
                    child: Text(
                      "Top Hotels",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Fetching and displaying approved hotels
                  StreamBuilder<QuerySnapshot>( 
                    stream: FirebaseFirestore.instance
                        .collection('hotels')
                        .where('isApproved', isEqualTo: true)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return const Center(child: Text('No approved hotels available.'));
                      }

                      final hotels = snapshot.data!.docs;
                      return Column(
                        children: hotels.map((doc) {
                          final hotelData = doc.data() as Map<String, dynamic>;
                          final hotelName = hotelData['hotelName'] ?? 'No name';
                          final description = hotelData['facilities'] ?? 'No description';
                          final imageUrl = hotelData['imageUrl'] ?? '';
                          final rating = '5 Stars'; // Add logic for actual rating if needed
                      

                          return GestureDetector(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(builder:  (context) => UserHotelDetailsScreen(hotelData: hotelData),));
                            },
                            child: _buildHotelCard(
                              hotelName,
                              rating,
                              description,
                              imageUrl,
                            ),
                          );
                        }).toList(),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: onTap,
    );
  }

  Widget _buildHotelCard(String hotelName, String hotelRating, String description, String hotelImage) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.blueAccent.withOpacity(0.5),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
            child: hotelImage.isNotEmpty
                ? Image.network(
                    hotelImage,
                    height: 150,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  )
                : const Icon(Icons.image_not_supported, size: 150), // Placeholder icon for invalid URLs
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  hotelName,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  hotelRating,
                  style: const TextStyle(color: Colors.orange, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: TextStyle(color: Colors.grey[700]),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    "Book Now",
                    style: TextStyle(color: Colors.blueAccent),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
