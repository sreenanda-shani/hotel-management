import 'package:firebase_auth/firebase_auth.dart';
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
  String? selectedGender = 'Male';
  String? selectedIdProofType = 'Aadhar';
  File? selectedImage;

  // Form key for validation
  final _formKey = GlobalKey<FormState>();

  // Validation regular expressions
  final RegExp emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );
  final RegExp phoneRegex = RegExp(r'^[0-9]{10}$');
  final RegExp aadharRegex = RegExp(r'^[0-9]{12}$');
  final RegExp passportRegex = RegExp(r'^[A-Z][0-9]{7}$');
  final RegExp licenseRegex = RegExp(
      r'^(([A-Z]{2}[0-9]{2})( )|([A-Z]{2}-[0-9]{2}))((19|20)[0-9][0-9])[0-9]{7}$');

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

  // Validate ID proof based on type
  String? validateIdProof(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter ID proof number';
    }

    switch (selectedIdProofType) {
      case 'Aadhar':
        if (!aadharRegex.hasMatch(value)) {
          return 'Please enter a valid 12-digit Aadhar number';
        }
        break;
      case 'Passport':
        if (!passportRegex.hasMatch(value)) {
          return 'Please enter a valid passport number (e.g., A1234567)';
        }
        break;
      case 'Licence':
        if (!licenseRegex.hasMatch(value)) {
          return 'Please enter a valid driving license number';
        }
        break;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("User Registration"),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'asset/img4.webp',
              fit: BoxFit.cover,
            ),
          ),
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ClipOval(
                        child: Image.asset(
                          'asset/download.png',
                          width: 120,
                          height: 120,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(height: 24),
                      _buildTextField('Full Name', fullNameController),
                      const SizedBox(height: 16),
                      _buildEmailField(),
                      const SizedBox(height: 16),
                      _buildPasswordTextField(),
                      const SizedBox(height: 16),
                      _buildIdProofTypeSelection(),
                      const SizedBox(height: 16),
                      _buildIdProofField(),
                      const SizedBox(height: 16),
                      _buildPhoneField(),
                      const SizedBox(height: 16),
                      _buildTextField('Address', addressController),
                      const SizedBox(height: 16),
                      _buildGenderSelection(),
                      const SizedBox(height: 16),
                      _buildImageUploadButton(),
                      const SizedBox(height: 24),
                      loading
                          ? const CircularProgressIndicator()
                          : ElevatedButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  registerHandler();
                                }
                              },
                              child: const Text('Register'),
                            ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return SizedBox(
      width: 300,
      child: TextFormField(
        controller: controller,
        style: const TextStyle(color: Colors.white),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter $label';
          }
          return null;
        },
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

  Widget _buildEmailField() {
    return SizedBox(
      width: 300,
      child: TextFormField(
        controller: emailController,
        style: const TextStyle(color: Colors.white),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter email';
          }
          if (!emailRegex.hasMatch(value)) {
            return 'Please enter a valid email address';
          }
          return null;
        },
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
    );
  }

  Widget _buildPasswordTextField() {
    return SizedBox(
      width: 300,
      child: TextFormField(
        controller: passwordController,
        obscureText: !_isPasswordVisible,
        style: const TextStyle(color: Colors.white),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter password';
          }
          if (value.length < 6) {
            return 'Password must be at least 6 characters';
          }
          return null;
        },
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

  Widget _buildPhoneField() {
    return SizedBox(
      width: 300,
      child: TextFormField(
        controller: phoneController,
        style: const TextStyle(color: Colors.white),
        keyboardType: TextInputType.phone,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter phone number';
          }
          if (!phoneRegex.hasMatch(value)) {
            return 'Please enter a valid 10-digit phone number';
          }
          return null;
        },
        decoration: InputDecoration(
          labelText: 'Phone Number',
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

  Widget _buildIdProofField() {
    return SizedBox(
      width: 300,
      child: TextFormField(
        controller: idProofNumberController,
        style: const TextStyle(color: Colors.white),
        validator: validateIdProof,
        decoration: InputDecoration(
          labelText: 'ID Proof Number',
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

  Widget _buildIdProofTypeSelection() {
    return SizedBox(
      width: 300,
      child: DropdownButtonFormField<String>(
        value: selectedIdProofType,
        onChanged: (String? newValue) {
          setState(() {
            selectedIdProofType = newValue!;
            // Clear the ID proof field when type changes
            idProofNumberController.clear();
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
        dropdownColor: Colors.black,
        items: ['Aadhar', 'Passport', 'Licence']
            .map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(
              value,
              style: const TextStyle(color: Colors.white),
            ),
          );
        }).toList(),
      ),
    );
  }

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
        dropdownColor: Colors.black,
        items: ['Male', 'Female', 'Other']
            .map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(
              value,
              style: const TextStyle(color: Colors.white),
            ),
          );
        }).toList(),
      ),
    );
  }

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
                      icon: const Icon(Icons.close, color: Colors.red),
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
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please upload an ID proof image')),
      );
      return;
    }

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
    String gender = selectedGender!;
    String idProofType = selectedIdProofType!;

    String imageUrl = '';
    if (selectedImage != null) {
      print('Uploading image: ${selectedImage!.path}');
      final uploadResponse = await _uploadToCloudinary(selectedImage!);
      if (uploadResponse != null) {
        imageUrl = uploadResponse['secure_url'];
        print("Image uploaded: $imageUrl");
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Image upload failed')),
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
      await FirebaseFirestore.instance.collection('users').add({
        'fullName': fullName,
        'email': email,
        'password': password,
        'idProofNumber': idProofNumber,
        'phone': phone,
        'address': address,
        'gender': gender,
        'idProofType': idProofType,
        'imageUrl': imageUrl,
        'createdAt': FieldValue.serverTimestamp(),
      });
       final user = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      print(user.user?.uid);

      // Save staff data to Firestore
      await FirebaseFirestore.instance.collection('role_tb').add({
      'uid': user.user?.uid,
      'role': 'Users',
    });


      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registration Successful!')),
      );

      print('Registration successful!');
      
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const UserLoginPage()),
      );
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