
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:project1/choose_screen.dart';
import 'package:project1/firebase_options.dart';
import 'package:project1/hotel/add_staff.dart';
import 'package:project1/hotel/fetchfeedbacks.dart';
import 'package:project1/hotel/hotelhome.dart';
import 'package:project1/hotel/staff_noti.dart';
import 'package:project1/hotel/view_staff.dart';
import 'package:project1/loginpage/login_page.dart';
import 'package:project1/staff/staff_home.dart';
import 'package:project1/staff/staff_login.dart';
import 'package:project1/staff/staff_profile.dart';
import 'package:project1/user/new_ai_screen.dart';


const apiKey = 'AIzaSyCD8u6ra1ix2Ttbjsfb6GyCFGYxxWGG48g';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
);

  Gemini.init(apiKey: apiKey);
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: UserLoginPage()
  ));
  debugPrint("hai");
}

