import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserAuthService {
  final firebaseAuth = FirebaseAuth.instance;

  final fireStoreDatabase =FirebaseFirestore.instance;



 Future<void> userRegister(
  {
  required String email ,required String fullName, required String password,required BuildContext context}) async {
  try {
       final user = await firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
       print(user.user?.uid);

        await fireStoreDatabase.collection('user').doc(user.user?.uid).set(
          {
             'name':fullName,
             'email':email,
             'password':password
          }
          );

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Registration Successfull')));
    
  } catch(e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Registration failed')));
    
  }
 }
}