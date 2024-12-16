import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool _isLoading = false;
  String _errorMessage = "";

  // Login function
  Future<void> _login() async {
    setState(() {
      _isLoading = true;
      _errorMessage = "";
    });

    try {
      // Validate Email Format
      String email = _emailController.text;
      if (email.isEmpty || !RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$").hasMatch(email)) {
        setState(() {
          _errorMessage = "Please enter a valid email address.";
          _isLoading = false;
        });
        return;
      }

      // Sign in with Firebase Authentication
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      print('lllll');

      // Fetch user information from Firestore collection 'hotel' and check if admin-approved
      User? user = userCredential.user;
      if (user != null) {
        var userEmail = user.email;
        var userDoc = await FirebaseFirestore.instance
            .collection('hotel')
            .where('email', isEqualTo: userEmail)
            .limit(1)
            .get();

        if (userDoc.docs.isNotEmpty) {
          // Check for admin approval in the 'hotel' collection
          var hotelData = userDoc.docs.first.data();
          bool isAdminApproved = hotelData['adminApproved'] ?? false;

          if (isAdminApproved) {
            // Navigate to the home screen or another page if approved
            Navigator.pushReplacementNamed(context, '/home');
          } else {
            // Show error if not admin approved
            setState(() {
              _errorMessage = "Your account is not admin-approved.";
            });
          }
        } else {
          setState(() {
            _errorMessage = "No user found in the hotel collection.";
          });
        }
      }
    } catch (e) {
      setState(() {
        if (e is FirebaseAuthException) {
          // Specific error handling for Firebase Authentication
          if (e.code == 'wrong-password') {
            _errorMessage = "The password is incorrect.";
          } else if (e.code == 'user-not-found') {
            _errorMessage = "No user found for that email.";
          } else if (e.code == 'invalid-email') {
            _errorMessage = "The email address is badly formatted.";
          } else {
            _errorMessage = "An error occurred: ${e.message}";
          }
        } else {
          _errorMessage = "An unexpected error occurred.";
        }
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Input decoration with same style as your previous code
  InputDecoration _buildInputDecoration(String labelText) {
    return InputDecoration(
      labelText: labelText,
      labelStyle: TextStyle(color: Colors.teal),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Email Field
            TextFormField(
              controller: _emailController,
              decoration: _buildInputDecoration("Email"),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please enter your email";
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            // Password Field
            TextFormField(
              controller: _passwordController,
              obscureText: true,
              decoration: _buildInputDecoration("Password"),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please enter your password";
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            if (_isLoading)
              const CircularProgressIndicator()
            else
              ElevatedButton(
                onPressed: _login,
                child: const Text('Login'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal, // Set button color to teal
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                ),
              ),
            const SizedBox(height: 16),
            // Error Message
            if (_errorMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Text(
                  _errorMessage,
                  style: TextStyle(color: Colors.red),
                ),
              ),
            const SizedBox(height: 24),
            // Create Account Text
            GestureDetector(
              onTap: () {
                Navigator.pushReplacementNamed(context, '/signup');
              },
              child: const Text(
                "Don't have an account? Sign Up",
                style: TextStyle(color: Colors.teal, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
