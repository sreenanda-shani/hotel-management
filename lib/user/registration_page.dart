import 'package:flutter/material.dart';
import 'package:project1/user/home_page.dart';
import 'package:project1/user/login_page.dart';
import 'package:project1/user/services/user_auth_service.dart';

class UserRegistrationPage extends StatefulWidget {
  const UserRegistrationPage({super.key});

  @override
  State<UserRegistrationPage> createState() => _UserRegistrationPageState();
}

class _UserRegistrationPageState extends State<UserRegistrationPage> {
  TextEditingController fullNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController aadharController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  bool loading = false;
  bool _isPasswordVisible = false;
  String? selectedGender = 'Male'; // Default gender is Male

  // Registration handler function to process form data
  Future<void> registerHandler() async {
    setState(() {
      loading = true;
    });

    String fullName = fullNameController.text;
    String email = emailController.text;
    String password = passwordController.text;
    String aadhar = aadharController.text;
    String phone = phoneController.text;
    String address = addressController.text;
    String gender = selectedGender!; // Get the selected gender value

    // Basic validation
    if (fullName.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        aadhar.isEmpty ||
        phone.isEmpty ||
        address.isEmpty ||
        gender.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all the fields')),
      );
      setState(() {
        loading = false;
      });
      return;
    }

    // Call the register function (assuming UserAuthService is defined elsewhere)
    await UserAuthService().userRegister(
      email: emailController.text,
      fullName: fullNameController.text,
      password: passwordController.text,
      aadhar: aadharController.text,
      phone: phoneController.text,
      address: addressController.text,
      gender: gender, // Pass the selected gender here
      context: context,
    );

    setState(() {
      loading = false;
    });

    // Navigate to a success page (replace with your own)
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return UserLoginPage(); // Go back to the Login Page after registration
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("User Registration"),
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

                    // Full Name Text Field
                    _buildTextField('Full Name', fullNameController),

                    const SizedBox(height: 16),

                    // Email Text Field
                    _buildTextField('Email', emailController),

                    const SizedBox(height: 16),

                    // Password Text Field
                    _buildPasswordTextField(),

                    const SizedBox(height: 16),

                    // Aadhar Number Text Field
                    _buildTextField('Aadhar Number', aadharController),

                    const SizedBox(height: 16),

                    // Phone Number Text Field
                    _buildTextField('Phone Number', phoneController),

                    const SizedBox(height: 16),

                    // Address Text Field
                    _buildTextField('Address', addressController),

                    const SizedBox(height: 16),

                    // Gender Selection
                    _buildGenderSelection(),

                    const SizedBox(height: 24),

                    // Register Button
                    loading
                        ? const CircularProgressIndicator()
                        : ElevatedButton(
                            onPressed: registerHandler,
                            child: const Text('Register'),
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

  // Helper function to build text fields
  Widget _buildTextField(String label, TextEditingController controller) {
    return SizedBox(
      width: 300,
      child: TextField(
        controller: controller,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
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
    );
  }

  // Helper function to build password text field
  Widget _buildPasswordTextField() {
    return SizedBox(
      width: 300,
      child: TextField(
        controller: passwordController,
        obscureText: !_isPasswordVisible,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: 'Password',
          labelStyle: const TextStyle(color: Colors.white),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
          ),
          filled: true,
          fillColor: Colors.black.withOpacity(0.3),
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
            borderSide: const BorderSide(color: Colors.green, width: 2.0),
            borderRadius: BorderRadius.circular(50),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.white),
            borderRadius: BorderRadius.circular(50),
          ),
        ),
      ),
    );
  }

  // Helper function to build gender selection dropdown
  Widget _buildGenderSelection() {
    return SizedBox(
      width: 300,
      child: DropdownButtonFormField<String>(
        value: selectedGender,
        onChanged: (String? newValue) {
          setState(() {
            selectedGender = newValue!;
          });
        },
        decoration: InputDecoration(
          labelText: 'Gender',
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
        dropdownColor: Colors.black, // Dropdown background color
        items: ['Male', 'Female', 'Other']
            .map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(
              value,
              style: const TextStyle(color: Colors.white), // Dropdown text color
            ),
          );
        }).toList(),
      ),
    );
  }
}
