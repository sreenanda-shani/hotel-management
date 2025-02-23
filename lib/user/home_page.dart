import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:project1/loginpage/login_page.dart';
import 'package:project1/user/ai_user_screen.dart';
import 'package:project1/user/bookinghistory.dart';
import 'package:project1/user/favuorite.dart';
import 'package:project1/user/feedback.dart';
import 'package:project1/user/hotel_details.dart';
import 'package:project1/user/hotel_price_prediction_screen.dart';
import 'package:project1/user/last_ai.dart';
import 'package:project1/user/notification.dart';
import 'package:project1/user/profile.dart';
import 'package:project1/user/user_chat_screen.dart';
import 'package:project1/user/user_hotelhomepage.dart';
import 'package:url_launcher/url_launcher.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String searchQuery = '';
  String sortBy = 'location';

  @override
  Widget build(BuildContext context) {
    User? currentUser = FirebaseAuth.instance.currentUser;

    String defaultImage = "assets/default_profile_image.png";
    String userName = currentUser?.displayName ?? '';
    String userEmail = currentUser?.email ?? 'guest@example.com';
    String userImageUrl = currentUser?.photoURL ?? defaultImage;

    return Scaffold(
      floatingActionButton: SpeedDial(
        icon: Icons.message,
        activeIcon: Icons.close,
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        buttonSize: const Size(56.0, 56.0),
        childrenButtonSize: const Size(56.0, 56.0),
        children: [
          SpeedDialChild(
            child: const Icon(Icons.chat),
            label: 'AiChatScreen',
            backgroundColor: Colors.blue,
            onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const PredictionScreen(),));

            },
          ),
          SpeedDialChild(
            child: const Icon(Icons.chat_bubble),
            label: 'AiChatPage',
            backgroundColor: Colors.green,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AiChatPage(),
                ),
              );
            },
          ),
        ],
      ),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 0, 123, 123),
        elevation: 4,
        toolbarHeight: 70, // Reduced height
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipOval(
            child:Image.asset('asset/download.png', height: 40,
            width: 40,
          fit: BoxFit.cover,),
            ),
             // App logo
            const SizedBox(width: 8),
            const Text(
              'Aventra Luxe Connect',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18,color: Colors.white),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_3_rounded, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfilePage()),
              );
            },
          ),
        ],
      ),
      drawer: Transform.translate(
        offset: const Offset(0, 50),
        child: Drawer(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.deepPurple.shade50, const Color.fromARGB(124, 63, 209, 194)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                DrawerHeader(
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(159, 92, 205, 193),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 5),
                      CircleAvatar(
                        radius: 30,
                        backgroundImage: NetworkImage(userImageUrl),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        userName,
                        style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        userEmail,
                        style: const TextStyle(color: Colors.white, fontSize: 14),
                      ),
                    ],
                  ),
                ),
                _buildDrawerItem(Icons.person, "Profile", () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfilePage()));
                }),
                
                _buildDrawerItem(Icons.history, "Booking History", () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const BookingHistoryPage()));
                }),
                _buildDrawerItem(Icons.favorite, "Favourites", () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const FavouritesPage()));
                }),
                _buildDrawerItem(Icons.notifications, "Notifications", () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const NotificationPage()));
                }),
                _buildDrawerItem(Icons.feedback, "Feedback", () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const FeedbackPage()));
                }),
                _buildDrawerItem(Icons.login, "Logout", () async {
                  await FirebaseAuth.instance.signOut();
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const UserLoginPage()));
                }),
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: TextField(
                  onChanged: (query) {
                    setState(() {
                      searchQuery = query;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Search hotels...',
                    hintStyle: TextStyle(color: Colors.grey[600]),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                    prefixIcon: const Icon(Icons.search, color: Colors.grey),
                    contentPadding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                ),
              ),
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
                  var hotels = snapshot.data!.docs;
                  hotels = hotels.where((doc) {
                    final hotelData = doc.data() as Map<String, dynamic>;
                    final location = hotelData['location'] ?? '';
                    return location.toLowerCase().contains(searchQuery.toLowerCase());
                  }).toList();
                  return Column(
                    children: hotels.map((doc) {
                      final hotelData = doc.data() as Map<String, dynamic>;
                      final hotelName = hotelData['hotelName'] ?? 'No name';
                      final description = hotelData['facilities'] ?? 'No description';
                      final imageUrl = hotelData['imageUrl'] ?? '';
                      final rating = hotelData['rating'] ?? '';
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
    );
  }



  Widget _buildDrawerItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.blueAccent),
      title: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black), // Set color to black
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
              .collection('users')
              .doc(currentUser?.uid)
              .get();
          final favorites = userDoc.data()?['favourites'] as List<dynamic>? ?? [];
          return favorites.contains(hotelId);
        }

        Future<void> toggleFavorite() async {
          final userDocRef = FirebaseFirestore.instance
              .collection('users')
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
                color: Colors.white, // The background color of the container
                boxShadow: [
                  BoxShadow(
                    color: const Color.fromARGB(255, 234, 235, 236).withOpacity(0.5),
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
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
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
                        if (hotelRating.isNotEmpty)
                          Text(
                            hotelRating,
                            style: const TextStyle(color: Colors.orange, fontWeight: FontWeight.bold),
                          ),
                        const SizedBox(height: 8),
                        Text(
                          description,
                          style: const TextStyle(color: Colors.black),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
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
                                backgroundColor: Colors.black, // Set button color to black
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: const Text(
                                "Book Now",
                                style: TextStyle(color: Colors.white), // Text color is white
                              ),
                            ),
                            SizedBox(width: 5,),
                            ElevatedButton(
                              onPressed: () {
                                print(hotelData);
                                // Define the latitude and longitude
    String destinationLat = hotelData['lat']; // Replace with your destination latitude
    String destinationLng = hotelData['log']; // Replace with your destination longitude

    // Build the Google Maps URL
    String googleMapsUrl =
        "https://www.google.com/maps/dir/?api=1&destination=$destinationLat,$destinationLng&travelmode=driving";

    // Launch Google Maps
    _launchURL(googleMapsUrl);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black, // Set button color to black
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: const Text(
                                "Route",
                                style: TextStyle(color: Colors.white), // Text color is white
                              ),
                            ),
                            const Spacer(),
                            TextButton.icon(
                              icon: const Icon(Icons.message, color: Colors.black), // Icon color black
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => UserChatScreen(hotelId: hotelId),
                                  ),
                                );
                              },
                              label: const Text('Chat', style: TextStyle(color: Colors.black)), // Text color black
                            ),
                          ],
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


  // Define the _launchURL function
void _launchURL(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}
}
