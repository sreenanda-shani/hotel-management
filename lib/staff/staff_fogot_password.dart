import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StaffForgotPasswordPage extends StatefulWidget {
  const StaffForgotPasswordPage({super.key});

  @override
  State<StaffForgotPasswordPage> createState() => _StaffForgotPasswordPageState();
}

class _StaffForgotPasswordPageState extends State<StaffForgotPasswordPage> {
  final TextEditingController emailController = TextEditingController();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> sendPasswordResetEmail() async {
    final String email = emailController.text.trim();

    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Please enter your email address.'),
        backgroundColor: Colors.red,
      ));
      return;
    }

    try {
      // Check if the staff exists in the Firestore
      final staffQuery = await firestore
          .collection('staff') // Replace with the correct collection name for staff
          .where('email', isEqualTo: email)
          .get();

      if (staffQuery.docs.isNotEmpty) {
        // Staff exists; send a password reset email
        await _firebaseAuth.sendPasswordResetEmail(email: email);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Reset link sent. Check your email to reset your password.'),
            backgroundColor: Colors.green,
          ));
          Navigator.of(context).pop();
        }
      } else {
        // Staff does not exist
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Staff not found. Please try again.'),
          backgroundColor: Colors.red,
        ));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('An error occurred: $e'),
        backgroundColor: Colors.red,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Staff Forgot Password"),
      ),
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              'asset/img4.webp', // Replace with your image path
              fit: BoxFit.cover,
            ),
          ),
          // Foreground Content
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Circular Logo
                    ClipOval(
                      child: Image.asset(
                        'asset/download.png', // Replace with your logo path
                        width: 120,
                        height: 120,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Email Text Field
                    SizedBox(
                      width: 300,
                      child: TextField(
                        controller: emailController,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: 'Email',
                          labelStyle: const TextStyle(color: Colors.white),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                          filled: true,
                          fillColor: Colors.black.withOpacity(0.3),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.green, width: 2.0),
                            borderRadius: BorderRadius.circular(50),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Forgot Password Button
                    ElevatedButton(
                      onPressed: sendPasswordResetEmail,
                      child: const Text('Forgot Password'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
