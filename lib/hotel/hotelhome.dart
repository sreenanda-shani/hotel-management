import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project1/choose_screen.dart';
import 'package:project1/hotel/chat_screen.dart';
import 'package:project1/hotel/hotel_profile.dart';
import 'package:project1/hotel/hotel_view.dart';
import 'package:project1/hotel/hotelmanage.dart';
import 'package:project1/user/bookinghistory.dart';
import 'package:project1/user/roombooking.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class HotelApp extends StatelessWidget {
  const HotelApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hotel App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const HotelHome(),
    );
  }
}

class HotelHome extends StatefulWidget {
  const HotelHome({Key? key}) : super(key: key);

  @override
  _HotelHomeState createState() => _HotelHomeState();
}

class _HotelHomeState extends State<HotelHome> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final PageController _pageController = PageController();
  int _selectedIndex = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onTap(int index) {
    _pageController.jumpToPage(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HotelProfile()),
              );
            },
          ),
        ],
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipOval(
              child: Image.asset(
                'asset/download.png',
                height: 40,
                width: 40,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 8),
            const Text(
              'Hotel App',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
      drawer: Drawer(
        child: Column(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.black,
              ),
              child: Row(
                children: [
                  ClipOval(
                    child: Image.asset(
                      'asset/download.png',
                      height: 60,
                      width: 60,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Text(
                    'Hotel Name',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.account_circle, color: Colors.black),
              title: const Text('Profile'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HotelProfile()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.hotel, color: Colors.black),
              title: const Text('View Rooms'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ViewRoomPage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.exit_to_app, color: Colors.black),
              title: const Text('Logout'),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => ChooseScreen()),
                );
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildCard(
                  context,
                  icon: Icons.book_online,
                  title: 'View Bookings',
                  subtitle: 'Check reservations',
                  route: const BookingHistoryPage(),
                ),
                _buildCard(
                  context,
                  icon: Icons.room_preferences,
                  title: 'View Rooms',
                  subtitle: '',
                  route: const ViewRoomPage(),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'Notifications',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('hotelnotifications')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final notifications = snapshot.data!.docs;
                  List<Widget> notificationWidgets = [];
                  for (var notification in notifications) {
                    final message = notification['message'];
                    final timestamp = notification['timestamp'];
                    String formattedTime = timestamp != null
                        ? DateFormat('yyyy-MM-dd HH:mm')
                            .format(timestamp.toDate())
                        : 'Unknown time';

                    notificationWidgets.add(
                      Card(
                        elevation: 4,
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          leading: const Icon(
                              Icons.notifications,
                              size: 30,
                              color: Colors.blueAccent),
                          title: Text(message,
                              style: const TextStyle(fontSize: 16)),
                          subtitle: Text(
                            formattedTime,
                            style: const TextStyle(
                                fontSize: 12, color: Colors.grey),
                          ),
                        ),
                      ),
                    );
                  }
                  return ListView(
                    children: notificationWidgets,
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.room_preferences),
            label: 'Manage rooms',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blueAccent,
        onTap: _onTap,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ChatList()),
          );
        },
        backgroundColor: Colors.blueAccent,
        child: const Icon(Icons.chat),
      ),
     
    );
  }

  Widget _buildCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Widget route,
  }) {
    return Container(
      height: 180,
      width: 200,
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: ListTile(
          leading: Icon(icon, size: 40, color: Colors.blueAccent),
          title: Text(
            title,
            style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent),
          ),
          subtitle: Text(
            subtitle,
            style: const TextStyle(fontSize: 12),
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => route),
            );
          },
        ),
      ),
    );
  }
}



class ChatList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat List'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('chats').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final chatDocs = snapshot.data!.docs;
          final Set<String> displayedUsers = {}; // To track unique users
          List<Widget> chatWidgets = [];

          for (var chat in chatDocs) {
            if (chat['receiverId'] == currentUserId) {
              final senderId = chat['senderId'];

              if (!displayedUsers.contains(senderId)) {
                displayedUsers.add(senderId);

                chatWidgets.add(
                  FutureBuilder<DocumentSnapshot>(
                    future: FirebaseFirestore.instance
                        .collection('user')
                        .doc(senderId)
                        .get(),
                    builder: (context, userSnapshot) {
                      if (!userSnapshot.hasData) {
                        return const ListTile(
                          title: Text('Loading...'),
                        );
                      }

                      final userName = userSnapshot.data!['name'];

                      return ListTile(
                        leading: const Icon(Icons.person, color: Colors.blue),
                        title: Text(userName),
                        subtitle: Text(chat['message'] ?? ''),
                        onTap: () {
                          // Navigate to ChatScreen and pass the senderId
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChatScreen(
                                senderId: senderId,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                );
              }
            }
          }

          if (chatWidgets.isEmpty) {
            return const Center(
              child: Text('No chats available'),
            );
          }

          return ListView(
            children: chatWidgets,
          );
        },
      ),
    );
  }
}
