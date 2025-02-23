import 'package:flutter/material.dart';
import 'package:project1/loginpage/login_page.dart';
import 'package:file_picker/file_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/foundation.dart';

class UserRegistrationPage extends StatefulWidget {
  const UserRegistrationPage({super.key});

  @override
  State<UserRegistrationPage> createState() => _UserRegistrationPageState();
}

class _UserRegistrationPageState extends State<UserRegistrationPage> {
  TextEditingController fullNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController idProofNumberController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  bool loading = false;
  bool _isPasswordVisible = false;
  String? selectedGender = 'Male'; // Default gender is Male
  String? selectedIdProofType = 'Aadhar'; // Default ID proof type
  File? selectedImage; // Variable to hold the selected image file

  @override
  void initState() {
    super.initState();
    checkPermissions();
  }

  Future<void> checkPermissions() async {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }
    status = await Permission.camera.status;
    if (!status.isGranted) {
      await Permission.camera.request();
    }
  }

  Future<void> _pickImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'png', 'heic'],
    );

    if (result != null) {
      setState(() {
        selectedImage = File(result.files.single.path!);
        print('Selected image: ${selectedImage!.path}');
      });
    } else {
      print('No image selected.');
    }
  }

  void _removeImage() {
    setState(() {
      selectedImage = null;
    });
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

                    // ID Proof Type Dropdown
                    _buildIdProofTypeSelection(),

                    const SizedBox(height: 16),

                    // ID Proof Number Text Field
                    _buildTextField('ID Proof Number', idProofNumberController),

                    const SizedBox(height: 16),

                    // Phone Number Text Field
                    _buildTextField('Phone Number', phoneController),

                    const SizedBox(height: 16),

                    // Address Text Field
                    _buildTextField('Address', addressController),

                    const SizedBox(height: 16),

                    // Gender Selection
                    _buildGenderSelection(),

                    const SizedBox(height: 16),

                    // Image Upload Button
                    _buildImageUploadButton(),

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

  // Helper function to build ID proof type selection dropdown
  Widget _buildIdProofTypeSelection() {
    return SizedBox(
      width: 300,
      child: DropdownButtonFormField<String>(
        value: selectedIdProofType,
        onChanged: (String? newValue) {
          setState(() {
            selectedIdProofType = newValue!;
            print('Selected ID Proof Type: $selectedIdProofType');
          });
        },
        decoration: InputDecoration(
          labelText: 'ID Proof Type',
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
        items: ['Aadhar', 'Passport', 'Licence']
            .map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(
              value,
              style:
                  const TextStyle(color: Colors.white), // Dropdown text color
            ),
          );
        }).toList(),
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
            print('Selected Gender: $selectedGender');
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
              style:
                  const TextStyle(color: Colors.white), // Dropdown text color
            ),
          );
        }).toList(),
      ),
    );
  }

  // Helper function to build image upload button
  Widget _buildImageUploadButton() {
    return SizedBox(
      width: 300,
      child: Column(
        children: [
          ElevatedButton(
            onPressed: _pickImage,
            child: Text(selectedImage == null
                ? 'Upload ID Proof Image'
                : 'Change Image'),
          ),
          if (selectedImage != null)
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Stack(
                children: [
                  Image.file(
                    selectedImage!,
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                  Positioned(
                    right: 0,
                    top: 0,
                    child: IconButton(
                      icon: Icon(Icons.close, color: Colors.red),
                      onPressed: _removeImage,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Future<Map<String, dynamic>?> _uploadToCloudinary(File imageFile) async {
    try {
      const cloudName = 'dsjp0qqgo';
      const uploadPreset = 'credentials';
      const apiKey = '666732294294543';
      const apiSecret = 'RHEoFrFCQw48apLQaSIV1vcAfcU';

      final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
      final folder = 'User';
      final signature = sha1
          .convert(utf8.encode(
              'folder=$folder&timestamp=$timestamp&upload_preset=$uploadPreset$apiSecret'))
          .toString();

      final uri =
          Uri.parse('https://api.cloudinary.com/v1_1/$cloudName/image/upload');
      final request = http.MultipartRequest('POST', uri);

      request.fields['upload_preset'] = uploadPreset;
      request.fields['api_key'] = apiKey;
      request.fields['timestamp'] = timestamp;
      request.fields['signature'] = signature;
      request.fields['folder'] = folder;

      request.files
          .add(await http.MultipartFile.fromPath('file', imageFile.path));

      final response = await request.send();
      final responseData = await response.stream.toBytes();
      final jsonResponse = json.decode(String.fromCharCodes(responseData));

      if (response.statusCode == 200) {
        print("Upload successful: $jsonResponse");
        return jsonResponse;
      } else {
        print("Error uploading image: ${response.statusCode}");
        print("Response Data: ${String.fromCharCodes(responseData)}");
        return null;
      }
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }

  Future<void> registerHandler() async {
    setState(() {
      loading = true;
      print('Registration started...');
    });

    String fullName = fullNameController.text;
    String email = emailController.text;
    String password = passwordController.text;
    String idProofNumber = idProofNumberController.text;
    String phone = phoneController.text;
    String address = addressController.text;
    String gender = selectedGender!; // Get the selected gender value
    String idProofType = selectedIdProofType!; // Get the selected ID proof type

    // Basic validation
    if (fullName.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        idProofNumber.isEmpty ||
        phone.isEmpty ||
        address.isEmpty ||
        gender.isEmpty ||
        idProofType.isEmpty ||
        selectedImage == null) {
      // Ensure image is selected
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please fill in all the fields and upload an image')),
      );
      setState(() {
        loading = false;
        print('Validation failed: Missing fields or image.');
      });
      return;
    }

    String imageUrl = '';
    if (selectedImage != null) {
      print('Uploading image: ${selectedImage!.path}');
      final uploadResponse = await _uploadToCloudinary(selectedImage!);
      if (uploadResponse != null) {
        imageUrl = uploadResponse['secure_url'];
        print("Image uploaded: $imageUrl");
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Image upload failed')),
        );
        setState(() {
          loading = false;
          print('Image upload failed.');
        });
        return;
      }
    }

    try {
      // Store user data in Firestore
      await FirebaseFirestore.instance.collection('user').add({
        'fullName': fullName,
        'email': email,
        'password':
            password, // Consider using a more secure method for storing passwords
        'idProofNumber': idProofNumber,
        'phone': phone,
        'address': address,
        'gender': gender,
        'idProofType': idProofType,
        'imageUrl': imageUrl,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registration Successful!')),
      );

      print('Registration successful!');
      // Navigate to Login Page after successful registration
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return const UserLoginPage();
      }));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Registration failed: $e')),
      );
      print('Registration failed: $e');
    } finally {
      setState(() {
        loading = false;
      });
    }
  }
}