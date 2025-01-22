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
        final role = await firestoreDatabse
            .collection('role_tb')
            .where('uid', isEqualTo: userCredential.user?.uid)
            .get();

        final roledata = role.docs.first.data();
        print(roledata);

        switch (roledata['role']) {
          case 'Users':
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const HomePage(),
                ));
            break;
          case 'Hotel':
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const HotelHome(),
                ));
            break;
         case 'Admin':
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AdminHomePage(),
                ));
            break;
           case 'Staff':
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const StaffHomeScreen(),
                ));
            break;
        }

        // Optionally, navigate to another screen after successful login
        // Navigator.pushReplacementNamed(context, '/home');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Login failed')),
      );
    }
  }
}