import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:project1/user/home_page.dart';
import 'package:project1/user/registration%20screen.dart';  // Import the RegistrationPage

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

    Navigator.push(context,MaterialPageRoute(builder: (context) {
      return HomePage();
    },));

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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Image
            Image.asset(
              'asset/download.png',
              width: 100,
              height: 200,
            ),
            SizedBox(height: 16),

            // Full Name
            TextField(
              controller: fullNameController,
              decoration: InputDecoration(
                labelText: 'Full Name',
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.green, width: 2.0),
                ),
              ),
            ),
            SizedBox(height: 16),

            // Password
            TextField(
              controller: passwordController,
              obscureText: !_isPasswordVisible,
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(
                    _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.green, width: 2.0),
                ),
              ),
            ),
            SizedBox(height: 20),

            // Space between the login button and the registration link
           
            Center(
              child: ElevatedButton(
                onPressed: loginHandler,
                child: Text('Sign In'),
              ),
            ),
            // Register now text
            Center(
              child: GestureDetector(
                onTap: () {
                  // Navigate to the Registration Screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const RegistrationScreen(),
                    ),
                  );
                },
                child: 
                Padding(
                  padding: const EdgeInsets.only(top: 12.0),
                  child: 
                  Text("Don't you have an account? Register now",
                  style: TextStyle(
                    color: const Color.fromARGB(255, 22, 150, 255),
                    fontWeight: FontWeight.bold,
                    //decoration: TextDecoration.underline,
                  ),)
                  
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
