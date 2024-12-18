

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:project1/firebase_options.dart';
import 'package:project1/hotel/hotel_login.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
);
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: HotelLoginPage()
  ));
}

