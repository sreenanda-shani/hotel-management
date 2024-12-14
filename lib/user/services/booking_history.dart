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
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        title: Text(
          booking["hotel"]!,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          "Date: ${booking["date"]!}\nStatus: ${booking["status"]!}",
          style: const TextStyle(fontSize: 14, color: Colors.grey),
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