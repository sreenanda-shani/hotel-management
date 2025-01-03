import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HotelProfile extends StatefulWidget {
  @override
  _HotelProfileState createState() => _HotelProfileState();
}

class _HotelProfileState extends State<HotelProfile> {
  // Function to fetch data from Firestore based on the current user ID
  Future<DocumentSnapshot> getHotelData() async {
    // Get the current user's UID from FirebaseAuth
    String uid = FirebaseAuth.instance.currentUser!.uid;

    return await FirebaseFirestore.instance
        .collection('hotels') // replace with your collection name
        .doc(uid) // use the current user's UID as the document ID
        .get();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hotel Profile'),
        backgroundColor: Colors.blueAccent,
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: getHotelData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(child: Text('Hotel not found.'));
          }

          var hotelData = snapshot.data!.data() as Map<String, dynamic>;

          // Extract hotel data
          String hotelName = hotelData['hotelName'] ?? 'N/A';
          String contactEmail = hotelData['contactEmail'] ?? 'N/A';
          String contactNumber = hotelData['contactNumber'] ?? 'N/A';
          String facilities = hotelData['facilities'] ?? 'N/A';
          String location = hotelData['location'] ?? 'N/A';
          int numberOfRooms = hotelData['numberOfRooms'] ?? 0;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Hotel Name Section
                  Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          Icon(Icons.hotel, size: 30, color: Colors.blueAccent),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              hotelName,
                              style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blueAccent),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 16),

                  // Contact Email Section
                  Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          Icon(Icons.email, size: 30, color: Colors.blueAccent),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'Contact Email: $contactEmail',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 16),

                  // Contact Number Section
                  Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          Icon(Icons.phone, size: 30, color: Colors.blueAccent),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'Contact Number: $contactNumber',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 16),

                  // Facilities Section
                  Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          Icon(Icons.security, size: 30, color: Colors.blueAccent),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'Facilities: $facilities',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 16),

                  // Location Section
                  Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          Icon(Icons.location_on, size: 30, color: Colors.blueAccent),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'Location: $location',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 16),

                  // Number of Rooms Section
                  Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          Icon(Icons.room_preferences, size: 30, color: Colors.blueAccent),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'Number of Rooms: $numberOfRooms',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
