import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HotelContactPage extends StatelessWidget {
  const HotelContactPage({super.key});

  // Fetch hotel details for the current user
  Future<Map<String, dynamic>?> fetchHotelDetails() async {
    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        // User is not logged in
        return null;
      }

      // Fetch the user's associated hotel document (Assuming a user has a 'hotelId' field in their Firestore document)
      final userDoc = await FirebaseFirestore.instance
          .collection('hotels')
          .doc(user.uid)
          .get();

      if (userDoc.exists && userDoc.data() != null) {
        final hotelId = userDoc.data()!['hotelId']; // Assuming 'hotelId' is stored in the user's document

        if (hotelId != null) {
          // Fetch the corresponding hotel details from the 'hotels' collection
          final hotelDoc = await FirebaseFirestore.instance
              .collection('hotels')
              .doc(hotelId)
              .get();

          if (hotelDoc.exists) {
            return hotelDoc.data(); // Return hotel details
          }
        }
      }

      return null; // No associated hotel found
    } catch (e) {
      debugPrint('Error fetching hotel details: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Contact Details",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.black.withOpacity(0.7),
        elevation: 0,
      ),
      body: FutureBuilder<Map<String, dynamic>?>( // Fetch the hotel details
        future: fetchHotelDetails(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError || !snapshot.hasData || snapshot.data == null) {
            return const Center(
              child: Text(
                "Error fetching data or no data available",
                style: TextStyle(fontSize: 16, color: Colors.red),
              ),
            );
          }

          final hotelData = snapshot.data!;
          final contactEmail = hotelData['contactEmail'] ?? 'Not Available';
          final contactNumber = hotelData['contactNumber'] ?? 'Not Available';
          final location = hotelData['location'] ?? 'Not Available';

          return Container(
            // Background image
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('asset/img7.jpg'), // Replace with your image path
                fit: BoxFit.cover,
              ),
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  // Semi-transparent container
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.85),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Contact Us",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "Phone:",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      Text(
                        contactNumber,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black54,
                        ),
                      ),
                      const SizedBox(height: 15),
                      const Text(
                        "Email:",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      Text(
                        contactEmail,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black54,
                        ),
                      ),
                      const SizedBox(height: 15),
                      const Divider(color: Colors.black38),
                      const SizedBox(height: 15),
                      const Text(
                        "Address:",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      Text(
                        location,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
