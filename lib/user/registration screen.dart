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

  String? gender;
  bool _isPasswordVisible = false;

  @override
  void dispose() {
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
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: [
                // Logo - Circular Shape
                Center(
                  child: ClipOval(
                    child: Image.asset(
                      'asset/download.png', // Ensure this path matches your asset configuration
                      width: 100,
                      height: 100, // Adjust width and height for a circle
                      fit: BoxFit.cover, // Ensures the image covers the entire circle
                    ),
                  ),
                ),
                SizedBox(height: 16),

                // Full Name
                buildRoundedTextField(
                  controller: fullNameController,
                  label: 'Full Name',
                ),
                SizedBox(height: 16),

                // Address
                buildRoundedTextField(
                  controller: addressController,
                  label: 'Address',
                  maxLines: 3,
                ),
                SizedBox(height: 16),

                // Password
                buildRoundedTextField(
                  controller: passwordController,
                  label: 'Password',
                  obscureText: !_isPasswordVisible,
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
                ),
                SizedBox(height: 16),

                // Phone Number
                buildRoundedTextField(
                  controller: phoneNumberController,
                  label: 'Phone Number',
                  keyboardType: TextInputType.phone,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                ),
                SizedBox(height: 16),

                // Email
                buildRoundedTextField(
                  controller: emailController,
                  label: 'Email',
                  keyboardType: TextInputType.emailAddress,
                ),
                SizedBox(height: 16),

                // Aadhar Number
                buildRoundedTextField(
                  controller: adharController,
                  label: 'Aadhar Number',
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
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
                    labelStyle: TextStyle(color: Colors.white),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.green, width: 2.0),
                      borderRadius: BorderRadius.circular(30),
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
        ],
      ),
    );
  }

  Widget buildRoundedTextField({
    required TextEditingController controller,
    required String label,
    int maxLines = 1,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
    Widget? suffixIcon,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      obscureText: obscureText,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      style: TextStyle(color: Colors.white), // Change text color
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.white),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30), // Rounded corners
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.green, width: 2.0),
          borderRadius: BorderRadius.circular(30),
        ),
        filled: true,
        fillColor: Colors.black.withOpacity(0.6), // Semi-transparent background
        suffixIcon: suffixIcon,
      ),
    );
  }
}
