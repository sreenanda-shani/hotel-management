import 'package:flutter/material.dart';

class NotificationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Notifications')),
      body: Center(
        child: Text(
          'Notification Page',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
