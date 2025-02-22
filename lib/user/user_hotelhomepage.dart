import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project1/user/AvailableRooms.dart'; // Import AvailableRoomsPage

class UserHotelDetailsScreen extends StatelessWidget {
  final String hotelDocumentId; // Accept hotel document ID

  const UserHotelDetailsScreen({super.key, required this.hotelDocumentId});

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

          // Get the facilities list (if it's a String, split it into a List)
          List<String> facilitiesList;
          if (hotelData['facilities'] is String) {
            // Split the comma-separated string into a List
            facilitiesList = hotelData['facilities'].split(',');
          } else if (hotelData['facilities'] is List) {
            // If it's already a List, use it as is
            facilitiesList = List<String>.from(hotelData['facilities']);
          } else {
            // If it's neither, fallback to an empty list
            facilitiesList = [];
          }

          List<dynamic> nearbyAttractions = hotelData['nearbyAttractions'] ?? [];

          return Scaffold(
            appBar: AppBar(
              title: Text(
                hotelData['hotelName'],
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              backgroundColor: Colors.teal,
              centerTitle: true,
              elevation: 6,
            ),
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Hotel Image with a gradient overlay for a modern look
                  Container(
                    width: double.infinity,
                    height: 250,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(16),
                        bottomRight: Radius.circular(16),
                      ),
                      image: DecorationImage(
                        image: NetworkImage(hotelData['imageUrl'] ?? ''),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.black.withOpacity(0.5), Colors.transparent],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Hotel Details Section with Card-like Layouts
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
                            color: Colors.teal,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Divider(),

                        // Contact Information in Card-like Containers
                        _buildDetailCard(
                          icon: Icons.phone,
                          title: 'Contact Number',
                          value: hotelData['contactNumber'] ?? 'N/A',
                        ),
                        _buildDetailCard(
                          icon: Icons.email,
                          title: 'Email',
                          value: hotelData['contactEmail'] ?? 'N/A',
                        ),
                        _buildDetailCard(
                          icon: Icons.location_on,
                          title: 'Location',
                          value: hotelData['location'] ?? 'N/A',
                        ),
                        _buildDetailCard(
                          icon: Icons.hotel,
                          title: 'Number of Rooms',
                          value: hotelData['numberOfRooms']?.toString() ?? 'N/A',
                        ),
                        const Divider(),

                        // Facilities Section in Two-in-One-Row Format
                        const SizedBox(height: 8),
                        const Text(
                          'Facilities',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.teal,
                          ),
                        ),
                        const SizedBox(height: 8),

                        // Container with white background for facilities
                        Container(
                          padding: const EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            color: Colors.white, // Changed background color to white
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 6,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: GridView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2, // Two items per row
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                            ),
                            itemCount: facilitiesList.length,
                            itemBuilder: (context, index) {
                              // Each facility is displayed in the grid
                              return Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.teal.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  facilitiesList[index] ?? 'N/A',
                                  style: const TextStyle(fontSize: 16),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 8),

                        // Nearby Attractions Section
                        const Text(
                          'Nearby Attractions',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.teal),
                        ),
                        const SizedBox(height: 8),
                        nearbyAttractions.isEmpty
                            ? const Text("No nearby attractions available.")
                            : ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: nearbyAttractions.length,
                                itemBuilder: (context, index) {
                                  var attraction = nearbyAttractions[index] as Map<String, dynamic>;
                                  return Card(
                                    margin: const EdgeInsets.symmetric(vertical: 8),
                                    elevation: 4,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: ListTile(
                                      leading: const Icon(Icons.place, color: Colors.teal),
                                      title: Text(attraction['name'] ?? 'N/A'),
                                      subtitle: Text(
                                          "${attraction['distance']} km - ${attraction['features']}"),
                                    ),
                                  );
                                },
                              ),
                        const SizedBox(height: 16),


                        // Book Now Button with Elevated Style
                        Center(
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width,
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
                                backgroundColor: Colors.teal,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 16, horizontal: 32),
                              ),
                              child: const Text(
                                "Book Now",
                                style: TextStyle(color: Colors.white, fontSize: 18),
                              ),
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

  // Build Individual Detail Card for displaying each detail in a card
  Widget _buildDetailCard({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: Colors.teal, size: 28),
            const SizedBox(width: 16),
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
      ),
    );
  }
}