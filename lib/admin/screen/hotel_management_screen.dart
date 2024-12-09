import 'package:flutter/material.dart';

class HotelManagementScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Hotel Management')),
      body: Center(
        child: Text(
          'Hotel Management Page',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
