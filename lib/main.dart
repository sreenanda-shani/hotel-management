import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:project1/admin/screen/_screen.dart';
import 'package:project1/admin/screen/admin_login.dart';
import 'package:project1/admin/screen/user_details_screen.dart';
import 'package:project1/firebase_options.dart';
import 'package:project1/user/forgot_password_page.dart';
import 'package:project1/user/home_page.dart';
import 'package:project1/user/hotel_details';
import 'package:project1/user/login_page.dart';
import 'package:project1/user/orders.dart';
import 'package:project1/user/profile.dart';
import 'package:project1/user/registration_page.dart';

Future<void> main() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
);
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: LoginPage()
  ));
}

