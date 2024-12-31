

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:project1/admin/screen/_screen.dart';
import 'package:project1/admin/screen/admin_home_page.dart';
import 'package:project1/choose_screen.dart';
import 'package:project1/firebase_options.dart';
import 'package:project1/hotel/hotel_rooms.dart';
import 'package:project1/user/home_page.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
);
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: ChooseScreen()
  ));
  debugPrint("hai");
}

