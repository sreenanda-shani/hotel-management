import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:project1/user/bookinghistory.dart';
import 'package:project1/user/favuorite.dart';
import 'package:project1/user/feedback.dart';
import 'package:project1/user/hotel_details.dart';
import 'package:project1/user/notification.dart';
import 'package:project1/user/profile.dart';
import 'package:project1/user/user_hotelhomepage.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    // Get the current user info
    User? currentUser = FirebaseAuth.instance.currentUser;

    // Define a default image
    String defaultImage = "assets/default_profile_image.png"; // Corrected path to assets

    // Fetch the user's name, email, and profile image URL (if available)
    String userName = currentUser?.displayName ?? 'Guest User';
    String userEmail = currentUser?.email ?? 'guest@example.com';
    String userImageUrl = currentUser?.photoURL ?? defaultImage; // Use default image if null

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(120),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30), // Rounded edges for the AppBar
            color: Colors.transparent,
          ),
          child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            flexibleSpace: Padding(
              padding: const EdgeInsets.only(left: 50, right: 16),
              child: Center(
                child: TextField(
                  onChanged: (query) {
                    setState(() {
                      searchQuery = query;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Search Hotels...',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                    prefixIcon: Icon(Icons.search, color: Colors.blueAccent),
                    contentPadding: EdgeInsets.symmetric(vertical: 12), // Adjust padding
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      drawer: Transform.translate(
        offset: Offset(0, 50), // This shifts the drawer down by 50 pixels
        child: Drawer(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.lightBlue.shade50, Colors.blueAccent.shade100],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                DrawerHeader(
                  decoration: BoxDecoration(
                    color: Colors.blueAccent.shade700, // Gradient color for the drawer header
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 5),
                      Text(
                        userEmail,
                        style: const TextStyle(color: Colors.white, fontSize: 18),
                      ),
                      const SizedBox(height: 10),
                      CircleAvatar(
                        radius: 30,
                        backgroundImage: NetworkImage(userImageUrl),
                      ),
                    ],
                  ),
                ),
                _buildDrawerItem(Icons.person, "Profile", () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ProfilePage()),
                  );
                }),
                _buildDrawerItem(Icons.search, "Search Hotel", () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HotelDetailsPage()),
                  );
                }),
                _buildDrawerItem(Icons.history, "Booking History", () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => BookingHistoryPage()),
                  );
                }),
                _buildDrawerItem(Icons.favorite, "Favourites", () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => FavouritesPage()),
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
                    MaterialPageRoute(builder: (context) => FeedbackPage()),
                  );
                }),
                _buildDrawerItem(Icons.login, "Logout", () {
                  FirebaseAuth.instance.signOut();
                  Navigator.pop(context);
                }),
              ],
            ),
          ),
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
                      final filteredHotels = hotels.where((doc) {
                        final hotelData = doc.data() as Map<String, dynamic>;
                        final hotelName = hotelData['hotelName'] ?? '';
                        return hotelName.toLowerCase().contains(searchQuery.toLowerCase());
                      }).toList();

                      return Column(
                        children: filteredHotels.map((doc) {
                          final hotelData = doc.data() as Map<String, dynamic>;
                          final hotelName = hotelData['hotelName'] ?? 'No name';
                          final description = hotelData['facilities'] ?? 'No description';
                          final imageUrl = hotelData['imageUrl'] ?? '';
                          final rating = hotelData['rating'] ?? '5 Stars';
                          final hotelId = doc.id;

                          return _buildHotelCard(
                            hotelName,
                            rating,
                            description,
                            imageUrl,
                            hotelData,
                            hotelId,
                            context,
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
      leading: Icon(icon, color: Colors.blueAccent),
      title: Text(
        title,
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      onTap: onTap,
    );
  }

  Widget _buildHotelCard(
    String hotelName,
    String hotelRating,
    String description,
    String hotelImage,
    Map<String, dynamic> hotelData,
    String hotelId,
    BuildContext context,
  ) {
    User? currentUser = FirebaseAuth.instance.currentUser;

    return StatefulBuilder(
      builder: (context, setState) {
        Future<bool> isFavorite() async {
          final userDoc = await FirebaseFirestore.instance
              .collection('user')
              .doc(currentUser?.uid)
              .get();
          final favorites = userDoc.data()?['favourites'] as List<dynamic>? ?? [];
          return favorites.contains(hotelId);
        }

        Future<void> toggleFavorite() async {
          final userDocRef = FirebaseFirestore.instance
              .collection('user')
              .doc(currentUser?.uid);

          final userDoc = await userDocRef.get();
          final favorites = userDoc.data()?['favourites'] as List<dynamic>? ?? [];

          if (favorites.contains(hotelId)) {
            await userDocRef.update({
              'favourites': FieldValue.arrayRemove([hotelId]),
            });
          } else {
            await userDocRef.update({
              'favourites': FieldValue.arrayUnion([hotelId]),
            });
          }
          setState(() {});
        }

        return FutureBuilder<bool>(
          future: isFavorite(),
          builder: (context, snapshot) {
            final isFavorite = snapshot.data ?? false;

            return Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
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
                        : const Icon(Icons.image_not_supported, size: 150),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              hotelName,
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            IconButton(
                              icon: Icon(
                                isFavorite ? Icons.favorite : Icons.favorite_border,
                                color: isFavorite ? Colors.red : Colors.grey,
                              ),
                              onPressed: () => toggleFavorite(),
                            ),
                          ],
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
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => UserHotelDetailsScreen(
                                  hotelDocumentId: hotelId,
                                ),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueAccent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            "Book Now",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
