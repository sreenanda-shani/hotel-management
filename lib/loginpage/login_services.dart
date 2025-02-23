import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project1/admin/screen/admin_home_page.dart';
import 'package:project1/hotel/hotelhome.dart';
import 'package:project1/staff/staff_home.dart';
import 'package:project1/user/home_page.dart';

class LoginServiceFire {
  final firebaseAuth = FirebaseAuth.instance;
  final firestoreDatabse = FirebaseFirestore.instance;

  Future<void> LoginService({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      // Sign in with email and password
      final userCredential = await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Login Successful')),
        );

        final roleSnapshot = await firestoreDatabse
            .collection('role_tb')
            .where('uid', isEqualTo: userCredential.user?.uid)
            .get();

        if (roleSnapshot.docs.isEmpty) {
          throw Exception("User role not found.");
        }

        final roledata = roleSnapshot.docs.first.data();

        if (roledata['role'] == 'Hotel') {
          // Fetch hotel data to check approval status
          final hotelSnapshot = await firestoreDatabse
              .collection('hotels')
              .doc(userCredential.user!.uid)
              .get();

          if (!hotelSnapshot.exists || hotelSnapshot.data()?['isApproved'] != true) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Hotel not approved. Please wait for admin approval.')),
            );
            await firebaseAuth.signOut();
            return;
          }
        }

        // Navigate based on role
        switch (roledata['role']) {
          case 'Users':
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomePage()),
            );
            break;
          case 'Hotel':
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HotelHome()),
            );
            break;
          case 'Admin':
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const AdminHomePage()),
            );
            break;
          case 'Staff':
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const StaffHomeScreen()),
            );
            break;
          default:
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Unknown role. Contact support.')),
            );
            await firebaseAuth.signOut();
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login failed: ${e.toString()}')),
      );
    }
  }
}
