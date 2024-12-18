import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project1/hotel/hotel_registration.dart';
import 'package:project1/hotel/hotelhome.dart';

class HotelLoginPage extends StatefulWidget {
  const HotelLoginPage({super.key});

  @override
  _HotelLoginPageState createState() => _HotelLoginPageState();
}

class _HotelLoginPageState extends State<HotelLoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool _isLoading = false;
  String _errorMessage = "";

  Future<void> _login() async {
    setState(() {
      _isLoading = true;
      _errorMessage = "";
    });

    try {
      String email = _emailController.text;
      if (email.isEmpty || !RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$").hasMatch(email)) {
        setState(() {
          _errorMessage = "Please enter a valid email address.";
          _isLoading = false;
        });
        return;
      }

      // Firebase Auth login
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      User? user = userCredential.user;
      if (user != null) {
        var userEmail = user.email;

        // Query the hotels collection in Firestore to find the hotel account
        var userDoc = await FirebaseFirestore.instance
            .collection('hotels') // Ensure you're using the correct collection name
            .where('contactEmail', isEqualTo: userEmail) // Assuming 'email' is the field name
            .limit(1)
            .get();

        print(userDoc.docs.length);

        if (userDoc.docs.isNotEmpty) {
          // No need to check for admin approval anymore
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HotelHome()), // Navigate to the hotel home page
          );
        } else {
          setState(() {
            _errorMessage = "No hotel account found for this email.";
          });
        }
      }
    } catch (e) {
      setState(() {
        if (e is FirebaseAuthException) {
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

  InputDecoration _buildInputDecoration(String labelText) {
    return InputDecoration(
      labelText: labelText,
      labelStyle: const TextStyle(color: Colors.teal),
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: const BorderSide(color: Colors.teal),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("asset/img.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Login Form
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Card(
                  elevation: 10,
                  color: Colors.white.withOpacity(0.8), // Adjust the transparency here
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        // Hotel Logo
                        const CircleAvatar(
                          radius: 50,
                          backgroundImage: AssetImage("asset/download.png"),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          "Welcome to Hotel Booking",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.teal,
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Email Field
                        TextFormField(
                          controller: _emailController,
                          decoration: _buildInputDecoration("Email"),
                        ),
                        const SizedBox(height: 16),
                        // Password Field
                        TextFormField(
                          controller: _passwordController,
                          obscureText: true,
                          decoration: _buildInputDecoration("Password"),
                        ),
                        const SizedBox(height: 24),
                        if (_isLoading)
                          const CircularProgressIndicator()
                        else
                          ElevatedButton(
                            onPressed: _login,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.teal,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                            ),
                            child: const Text(
                              'Login',
                              style: TextStyle(fontSize: 16, color: Colors.white),
                            ),
                          ),
                        const SizedBox(height: 16),
                        if (_errorMessage.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 16.0),
                            child: Text(
                              _errorMessage,
                              style: const TextStyle(color: Colors.red),
                            ),
                          ),
                        const SizedBox(height: 24),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const HotelRegistrationPage()),
                            );
                          },
                          child: const Text(
                            "Don't have an account? Sign Up",
                            style: TextStyle(
                              color: Colors.teal,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
