import 'package:flutter/material.dart';

class HotelContactPage extends StatelessWidget {
  const HotelContactPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Contact Details"),
        backgroundColor: Colors.teal,
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Phone: +123 456 7890\nEmail: info@ourhotel.com",
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}

