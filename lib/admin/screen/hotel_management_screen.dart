import 'package:flutter/material.dart';

class HotelManagementScreen extends StatelessWidget {
  const HotelManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Hotel Management')),
      body: const Center(
        child: Text(
          'Hotel Management Page',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
