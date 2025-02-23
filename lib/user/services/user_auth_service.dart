import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project1/user/navigation.dart';

class UserAuthService {
  final firebaseAuth = FirebaseAuth.instance;
  final fireStoreDatabase = FirebaseFirestore.instance;

  // Register function
  Future<void> userRegister({
    required String email,
    required String fullName,
    required String password,
    required String aadhar,
    required String phone,
    required String address,
    required String gender, // Added gender field
    required BuildContext context,
  }) async {
    try {
      final user = await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      print(user.user?.uid);

      // Save user data to Firestore
      await fireStoreDatabase.collection('user').doc(user.user?.uid).set({
        'name': fullName,
        'email': email,
        // Storing password in Firestore is not recommended for security reasons.
        'aadhar': aadhar,
        'phone': phone,
        'address': address,
        'gender': gender, // Store gender
      });

      // Add the role information to the 'role_tb' collection
    await fireStoreDatabase.collection('role_tb').add({
      'uid': user.user?.uid,
      'role': 'Users',
    });

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Registration Successful')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Registration failed')));
    }
  }

  // Login function
  Future<void> userLogin({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      final user = await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      Navigator.push(
  context,
  MaterialPageRoute(builder: (context) {
    return const BottomNavBarScreen();
  }),
);


      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Login Successful')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Login failed')));
    }
  }
}
