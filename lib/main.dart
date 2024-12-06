import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:project1/admin/admin_login.dart';
import 'package:project1/firebase_options.dart';
import 'package:project1/user/forgot_password_page.dart';
import 'package:project1/user/home_page.dart';
import 'package:project1/user/login_page.dart';
import 'package:project1/user/registration%20screen.dart';
import 'package:project1/user/registration_page.dart';

Future<void> main() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
);
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: UserRegistrationPage(),
  ));
}

