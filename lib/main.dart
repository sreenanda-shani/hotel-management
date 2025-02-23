
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';

import 'package:project1/firebase_options.dart';
import 'package:project1/loginpage/login_page.dart';



const apiKey = 'AIzaSyBBuFxwyOb2LIbbl50qc1LXFZQBLO2Wd48';

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

