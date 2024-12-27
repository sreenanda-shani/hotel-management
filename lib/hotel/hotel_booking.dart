import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BookingHistoryPage extends StatelessWidget {
  const BookingHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Booking History",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueGrey.shade900,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('asset/img4.webp'), // Replace with your image path
            fit: BoxFit.cover,
          ),
        ),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('booking')
              .where('hotelId', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(
                child: Text(
                  "No bookings found.",
                  style: TextStyle(fontSize: 18, color: Colors.black),
                ),
              );
            }

            final bookings = snapshot.data!.docs;

            return ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              itemCount: bookings.length,
              itemBuilder: (context, index) {
                final booking = bookings[index].data() as Map<String, dynamic>;
                return BookingCard(booking: booking);
              },
            );
          },
        ),
      ),
    );
  }
}

class BookingCard extends StatelessWidget {
  final Map<String, dynamic> booking;

  const BookingCard({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    final hotelId = booking["hotelId"] ?? "";

    if (hotelId.isEmpty) {
      debugPrint("Missing 'hotelId' field in booking: $booking");
      return _buildErrorCard("Unknown Hotel", "Hotel details are missing.");
    }

    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance.collection('hotels').doc(hotelId).get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || !snapshot.data!.exists) {
          debugPrint("Hotel document not found for hotelId: $hotelId");
          return _buildErrorCard(
            "Unknown Hotel (ID: $hotelId)",
            "Hotel details not found.",
          );
        }

        final hotelData = snapshot.data!.data() as Map<String, dynamic>;
        final hotelName = hotelData["hotelName"] ?? "Unnamed Hotel";

        return ClipRRect(
          borderRadius: BorderRadius.circular(30), // Side oval shape for more curvature
          child: Card(
            elevation: 8, // Slightly increased elevation for depth
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            shadowColor: Colors.black.withOpacity(0.3),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              tileColor: Colors.white.withOpacity(0.85), // Slight transparency for softness
              title: Text(
                hotelName,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black, // Black text for better visibility
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 5),
                  Text(
                    "Booking Date: ${formatDate(booking["bookingDate"])}",
                    style: const TextStyle(fontSize: 14, color: Colors.black),
                  ),
                  Text(
                    "Check-In: ${booking["checkIn"] ?? "N/A"} | Check-Out: ${booking["checkOut"] ?? "N/A"}",
                    style: const TextStyle(fontSize: 14, color: Colors.black),
                  ),
                  Text(
                    "Guests: ${booking["guests"] ?? 0} | Room: ${booking["roomNumber"] ?? "N/A"}",
                    style: const TextStyle(fontSize: 14, color: Colors.black),
                  ),
                  Text(
                    "Rent: \$${booking["rent"] ?? 0}",
                    style: const TextStyle(fontSize: 14, color: Colors.black),
                  ),
                ],
              ),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Booking: $hotelName'),
                    backgroundColor: Colors.blueGrey,
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildErrorCard(String title, String subtitle) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(30), // Side oval shape
      child: Card(
        elevation: 4,
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        shadowColor: Colors.black.withOpacity(0.2),
        child: ListTile(
          contentPadding: const EdgeInsets.all(16),
          tileColor: const Color.fromARGB(255, 205, 197, 198),
          title: Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
          ),
          subtitle: Text(
            subtitle,
            style: const TextStyle(fontSize: 14, color: Colors.black),
          ),
        ),
      ),
    );
  }

  String formatDate(Timestamp? timestamp) {
    if (timestamp == null) return "Unknown Date";
    final date = timestamp.toDate();
    return "${date.day}/${date.month}/${date.year} at ${date.hour}:${date.minute}";
  }
}
