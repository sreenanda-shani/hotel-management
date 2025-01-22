import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class StaffAuthService {
  final firebaseAuth = FirebaseAuth.instance;
  final fireStoreDatabase = FirebaseFirestore.instance;

  // Register function
  Future<void> staffRegister({
    required String email,
    required String fullName,
    required String password,
    required String staffID,
    required String phone,
    required String role, // Added role field
    required BuildContext context, required String staffId, required String address,
  }) async {
    try {
      final user = await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      print(user.user?.uid);

      // Save staff data to Firestore
      await fireStoreDatabase.collection('role_tb').add({
      'uid': user.user?.uid,
      'role': 'Staff',
    });
      await fireStoreDatabase.collection('staff').doc(user.user?.uid).set({
        'name': fullName,
        'email': email,
        'phone': phone,
        'role': role,
        'address':address 
        // Store role
      });
      // Add the role information to the 'role_tb' collection
    // await fireStoreDatabase.collection('role_tb').add({
    //   'uid': user.user?.uid,
    //   'role': 'Staff',
    // });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Staff Registration Successful')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Staff Registration failed: $e')),
      );
    }
  }

  // Login function
  Future<String?> staffLogin({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      final user = await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Login was successful
      return null; // Return null to indicate success
    } catch (e) {
      // Return the error message if login failed
      return 'Staff Login failed: ${e.toString()}';
    }
  }
}
