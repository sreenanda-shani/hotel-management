import 'package:flutter/material.dart';
import 'package:project1/user/home_page.dart';
import 'package:project1/user/registration%20screen.dart'; // Import the RegistrationPage

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController fullNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool _isPasswordVisible = false;

  // Login handler function to process form data
  void loginHandler() {
    String fullName = fullNameController.text;
    String password = passwordController.text;

    // Basic validation
    if (fullName.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill in all the fields')),
      );
      return;
    }

    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return HomePage();
    }));

    // Print or process the data here (e.g., send it to a backend or store it locally)
    print("Full Name: $fullName");
    print("Password: $password");

    // You can add your login logic here, like verifying credentials via an API.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
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
                        'asset/download.png',
                        width: 120,
                        height: 120,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(height: 24),

                    // Full Name Text Field (Oval-like shape)
SizedBox(
  width: 300, // Adjust the width as needed
  child: TextField(
    controller: fullNameController,
    style: TextStyle(color: Colors.white),
    decoration: InputDecoration(
      labelText: 'Full Name',
      labelStyle: TextStyle(color: Colors.white),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(50), // Oval shape
      ),
      filled: true, // To fill the background with color
      fillColor: Colors.black.withOpacity(0.3), // Semi-transparent background
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.green, width: 2.0),
        borderRadius: BorderRadius.circular(50), // Oval shape
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.white),
        borderRadius: BorderRadius.circular(50), // Oval shape
      ),
    ),
  ),
),
SizedBox(height: 16),

// Password Text Field (Oval-like shape)
SizedBox(
  width: 300, // Adjust the width as needed
  child: TextField(
    controller: passwordController,
    obscureText: !_isPasswordVisible,
    style: TextStyle(color: Colors.white),
    decoration: InputDecoration(
      labelText: 'Password',
      labelStyle: TextStyle(color: Colors.white),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(50), // Oval shape
      ),
      filled: true, // To fill the background with color
      fillColor: Colors.black.withOpacity(0.3), // Semi-transparent background
      suffixIcon: IconButton(
        icon: Icon(
          _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
          color: Colors.white,
        ),
        onPressed: () {
          setState(() {
            _isPasswordVisible = !_isPasswordVisible;
          });
        },
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.green, width: 2.0),
        borderRadius: BorderRadius.circular(50), // Oval shape
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.white),
        borderRadius: BorderRadius.circular(50), // Oval shape
      ),
    ),
  ),
),

                    SizedBox(height: 24),

                    // Sign In Button
                    ElevatedButton(
                      onPressed: loginHandler,
                      child: Text('Sign In'),
                    ),
                    SizedBox(height: 12),

                    // Register now text
                    GestureDetector(
                      onTap: () {
                        // Navigate to the Registration Screen
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const RegistrationScreen(),
                          ),
                        );
                      },
                      child: Text(
                        "Don't you have an account? Register now",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
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
