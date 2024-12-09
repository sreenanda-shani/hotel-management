import 'package:flutter/material.dart';

class AnalyticsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Analytics')),
      body: Center(
        child: Text(
          'Analytics Page',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
