import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project1/user/AvailableRooms.dart'; // Import AvailableRoomsPage

class UserHotelDetailsScreen extends StatelessWidget {
  final String hotelDocumentId; // Accept hotel document ID

  const UserHotelDetailsScreen({Key? key, required this.hotelDocumentId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance
          .collection('hotels')
          .doc(hotelDocumentId) // Use hotelDocumentId here
          .get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData) {
          return const Center(child: Text('Hotel not found'));
        } else {
          var hotelData = snapshot.data!.data() as Map<String, dynamic>;
          final hotelId = snapshot.data!.id; // This is the document ID, which serves as hotelId

          return Scaffold(
            appBar: AppBar(
              title: Text(
                hotelData['hotelName'],
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              backgroundColor: Colors.blueAccent,
              centerTitle: true,
              elevation: 4,
            ),
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Hotel Image
                  Container(
                    width: double.infinity,
                    height: 250,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(16),
                        bottomRight: Radius.circular(16),
                      ),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          offset: Offset(0, 2),
                          blurRadius: 6.0,
                        ),
                      ],
                      image: DecorationImage(
                        image: NetworkImage(hotelData['imageUrl'] ?? ''),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Hotel Details Section
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Hotel Name
                        Text(
                          hotelData['hotelName'],
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueAccent,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Divider(),

                        // Contact Information
                        _buildDetailRow(
                          icon: Icons.phone,
                          title: 'Contact Number',
                          value: hotelData['contactNumber'] ?? 'N/A',
                        ),
                        _buildDetailRow(
                          icon: Icons.email,
                          title: 'Email',
                          value: hotelData['contactEmail'] ?? 'N/A',
                        ),
                        _buildDetailRow(
                          icon: Icons.location_on,
                          title: 'Location',
                          value: hotelData['location'] ?? 'N/A',
                        ),
                        _buildDetailRow(
                          icon: Icons.hotel,
                          title: 'Number of Rooms',
                          value: hotelData['numberOfRooms']?.toString() ?? 'N/A',
                        ),
                        const Divider(),

                        // Facilities Section
                        const SizedBox(height: 8),
                        const Text(
                          'Facilities',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueAccent,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          hotelData['facilities'] ?? 'N/A',
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 16),

                        // Book Now Button
                        Center(
                          child: ElevatedButton(
                            onPressed: () {
                              // Pass hotelId to AvailableRoomsPage
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AvailableRoomsPage(
                                    hotelId: hotelId, // Pass hotelId here
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
                              style: TextStyle(color: Colors.white, fontSize: 18),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }

  // Build Individual Detail Row
  Widget _buildDetailRow({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.blueAccent, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
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