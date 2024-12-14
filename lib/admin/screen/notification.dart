import 'package:flutter/material.dart';

class AdminNotification extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Reports')),
      body: Center(
        child: Text(
          'Reports Page',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
