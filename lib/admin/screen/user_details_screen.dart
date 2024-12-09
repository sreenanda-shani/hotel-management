import 'package:flutter/material.dart';

class UserDetailsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('User Details')),
      body: Center(
        child: Text(
          'User Details Page',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
