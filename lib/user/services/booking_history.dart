import 'package:flutter/material.dart';

class BookingHistoryPage extends StatelessWidget {
  // Sample data for bookings
  final List<Map<String, String>> bookings = [
    {"hotel": "Hotel Sunshine", "date": "2024-12-01", "status": "Completed"},
    {"hotel": "Mountain Resort", "date": "2024-11-20", "status": "Completed"},
    {"hotel": "Ocean View", "date": "2024-10-15", "status": "Cancelled"},
    {"hotel": "City Inn", "date": "2024-09-05", "status": "Completed"},
  ];

  BookingHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Booking History"),
        backgroundColor: Colors.teal, // Set the background color of the AppBar to teal
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: bookings.length,
          itemBuilder: (context, index) {
            return BookingCard(booking: bookings[index]);
          },
        ),
      ),
    );
  }
}

class BookingCard extends StatelessWidget {
  final Map<String, String> booking;

  const BookingCard({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    // Determine status color
    Color statusColor = booking["status"] == "Completed" ? Colors.green : Colors.red;

    return Card(
      elevation: 8, // Higher elevation for a more prominent card
      margin: const EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20), // More rounded corners for elegance
      ),
      shadowColor: Colors.black26,
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        title: Text(
          booking["hotel"]!,
          style: const TextStyle(
            fontSize: 20, 
            fontWeight: FontWeight.bold, 
            color: Colors.teal
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Date: ${booking["date"]!}",
              style: TextStyle(
                fontSize: 14, 
                color: Colors.grey[600],
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                Icon(
                  booking["status"] == "Completed" ? Icons.check_circle : Icons.cancel,
                  color: statusColor,
                ),
                const SizedBox(width: 6),
                Text(
                  "Status: ${booking["status"]!}",
                  style: TextStyle(
                    fontSize: 14, 
                    fontWeight: FontWeight.bold,
                    color: statusColor,
                  ),
                ),
              ],
            ),
          ],
        ),
        onTap: () {
          // Add your desired action on tap
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Booking: ${booking["hotel"]!}')),
          );
        },
      ),
    );
  }
}
