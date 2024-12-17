

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:project1/admin/screen/_screen.dart';
import 'package:project1/choose_screen.dart';
import 'package:project1/firebase_options.dart';
import 'package:project1/hotel/hotel_login.dart';
import 'package:project1/hotel/hotel_registration.dart';
import 'package:project1/hotel/hotelhome.dart';
import 'package:project1/user/favuorite';
import 'package:project1/user/home_page.dart';
import 'package:project1/user/orders.dart';
import 'package:project1/user/registration_page.dart';

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

