import 'package:flutter/material.dart';

class HotelBookingsPage extends StatelessWidget {
  const HotelBookingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Bookings"),
        backgroundColor: Colors.teal,
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Bookings will be displayed here.",
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}