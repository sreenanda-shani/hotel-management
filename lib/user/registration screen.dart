import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController adharController = TextEditingController();

  String? gender; // Variable to store selected gender
  bool _isPasswordVisible = false;

  @override
  void dispose() {
    // Dispose controllers to prevent memory leaks
    fullNameController.dispose();
    addressController.dispose();
    passwordController.dispose();
    phoneNumberController.dispose();
    emailController.dispose();
    adharController.dispose();
    super.dispose();
  }

  void registrationHandler() {
    String fullName = fullNameController.text.trim();
    String address = addressController.text.trim();
    String password = passwordController.text;
    String phoneNumber = phoneNumberController.text.trim();
    String email = emailController.text.trim();
    String adhar = adharController.text.trim();

    if (fullName.isEmpty ||
        address.isEmpty ||
        password.isEmpty ||
        phoneNumber.isEmpty ||
        email.isEmpty ||
        adhar.isEmpty ||
        gender == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill in all the fields')),
      );
      return;
    }

    if (!RegExp(r"^[a-zA-Z0-9]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a valid email address')),
      );
      return;
    }

    if (phoneNumber.length != 10 || !RegExp(r'^[0-9]+$').hasMatch(phoneNumber)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a valid phone number (10 digits)')),
      );
      return;
    }

    if (adhar.length != 12 || !RegExp(r'^[0-9]+$').hasMatch(adhar)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a valid Aadhar number (12 digits)')),
      );
      return;
    }

    print("Full Name: $fullName");
    print("Address: $address");
    print("Password: $password");
    print("Phone Number: $phoneNumber");
    print("Email: $email");
    print("Aadhar: $adhar");
    print("Gender: $gender");

    // Add further registration logic here
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Registration"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Image.asset(
              'asset/download.png', // Ensure this path matches your asset configuration
              width: 100,
              height: 200,
              fit: BoxFit.contain,
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

            // Address
            TextField(
              controller: addressController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'Address',
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
            SizedBox(height: 16),

            // Phone Number
            TextField(
              controller: phoneNumberController,
              keyboardType: TextInputType.phone,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: InputDecoration(
                labelText: 'Phone Number',
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.green, width: 2.0),
                ),
              ),
            ),
            SizedBox(height: 16),

            // Email
            TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.green, width: 2.0),
                ),
              ),
            ),
            SizedBox(height: 16),

            // Aadhar Number
            TextField(
              controller: adharController,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: InputDecoration(
                labelText: 'Aadhar Number',
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.green, width: 2.0),
                ),
              ),
            ),
            SizedBox(height: 16),

            // Gender Selection
            DropdownButtonFormField<String>(
              value: gender,
              onChanged: (String? newValue) {
                setState(() {
                  gender = newValue;
                });
              },
              decoration: InputDecoration(
                labelText: 'Gender',
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.green, width: 2.0),
                ),
              ),
              items: ['Male', 'Female', 'Other']
                  .map((genderOption) => DropdownMenuItem<String>(
                        value: genderOption,
                        child: Text(genderOption),
                      ))
                  .toList(),
            ),
            SizedBox(height: 20),

            // Sign Up Button
            Center(
              child: ElevatedButton(
                onPressed: registrationHandler,
                child: Text('Sign Up'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
