import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserAuthService {
  final firebaseAuth = FirebaseAuth.instance;



 void userRegister(
  {
  required String email , required String password,required BuildContext context}){
  try {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Registration Succesful")));
    
  } catch(e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Registration failed')));
    
  }
 }
}