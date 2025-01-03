import 'package:flutter/material.dart';
import 'package:project1/user/AvailableRooms.dart'; // Import the AvailableRoomsPage

class BookNowPage extends StatefulWidget {
  final Map<String, dynamic> hotelDetails;

  // Constructor to accept hotel details
  const BookNowPage({super.key, required this.hotelDetails});

  @override
  _BookNowPageState createState() => _BookNowPageState();
}

class _BookNowPageState extends State<BookNowPage> {
  @override
  Widget build(BuildContext context) {
    final hotelDetails = widget.hotelDetails;

    // Ensure no null values for essential hotel details
    final hotelName = hotelDetails['hotelName'] ?? 'Unknown Hotel';
    final hotelImageUrl = hotelDetails['imageUrl'] ?? 'https://via.placeholder.com/150';
    final hotelLocation = hotelDetails['location'] ?? 'No location specified';
    final hotelFacilities = hotelDetails['facilities'] ?? 'No facilities listed';
    
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: const Text("Book Hotel"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Displaying hotel image
            ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(15)),
              child: Image.network(
                hotelImageUrl,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 16),

            // Displaying hotel name
            Text(
              hotelName,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),

            // Displaying hotel location
            Text(
              'Location: $hotelLocation',
              style: TextStyle(color: Colors.grey[700]),
            ),
            const SizedBox(height: 8),

            // Displaying hotel facilities
            Text(
              'Facilities: $hotelFacilities',
              style: const TextStyle(
                color: Colors.orange,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            // Displaying a divider
            const Divider(
              color: Colors.grey,
              thickness: 1,
            ),
            const SizedBox(height: 16),

            // Button to navigate to Available Rooms page
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Navigate to AvailableRoomsPage
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AvailableRoomsPage(
                        hotelId: hotelDetails['hotelId'] ?? '', 
                        // Safe fallback for hotelId
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
                  "View Available Rooms",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
