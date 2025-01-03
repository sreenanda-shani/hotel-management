

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:project1/choose_screen.dart';
import 'package:project1/firebase_options.dart';



const apiKey = 'AIzaSyCSE3RrVEOEc-PigYbrT5MBZHA-wsf4ZxM';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
);

  Gemini.init(apiKey: apiKey);
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: ChooseScreen()
  ));
  debugPrint("hai");
}

