import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudinary/cloudinary.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ManageRoomDetailsPage extends StatefulWidget {
  const ManageRoomDetailsPage({super.key});

  @override
  _ManageRoomDetailsPageState createState() => _ManageRoomDetailsPageState();
}

class _ManageRoomDetailsPageState extends State<ManageRoomDetailsPage> {
  final TextEditingController _roomNumberController = TextEditingController();
  final TextEditingController _rentController = TextEditingController();
  final TextEditingController _maxPeopleController = TextEditingController(); // New controller for max people

  String _acType = 'AC';
  String _bedType = 'Single';
  bool _wifiAvailable = false;
  bool _balconyAvailable = false;
  bool _isAvailable = true; // Added to store room availability status

  bool _isLoading = true;
  String _hotelId = '';
  File? _selectedImage; // Variable to store the selected image

  final cloudinary = Cloudinary.signedConfig(
    apiKey: '666732294294543',
    apiSecret: 'RHEoFrFCQw48apLQaSIV1vcAfcU',
    cloudName: 'dsjp0qqgo',
  );

  // Function to upload image to Cloudinary
  Future<String?> _uploadImageToCloudinary(File imageFile) async {
    try {
      final result = await cloudinary.upload(
        file: imageFile.path,
        folder: 'hotels',
        resourceType: CloudinaryResourceType.image,
      );
      return result.secureUrl;
    } catch (e) {
      print("Error uploading image: $e");
      return null;
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchRoomDetails();
  }

  // Function to fetch room details
  Future<void> _fetchRoomDetails() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        _hotelId = user.uid;
        DocumentSnapshot docSnapshot = await FirebaseFirestore.instance
            .collection('rooms')
            .doc(_hotelId)
            .get();

        if (docSnapshot.exists) {
          var data = docSnapshot.data() as Map<String, dynamic>;

          if (mounted) {
            setState(() {
              _roomNumberController.text = data['roomNumber'].toString() ?? '';
              _rentController.text = data['rent'].toString() ?? '';
              _maxPeopleController.text = data['maxPeople'].toString() ?? ''; // Load max people field
              _acType = data['acType'] ?? 'AC';
              _bedType = data['bedType'] ?? 'Single';
              _wifiAvailable = data['wifiAvailable'] ?? false;
              _balconyAvailable = data['balconyAvailable'] ?? false;
              _isAvailable = data['isAvailable'] ?? true;
              _isLoading = false;
            });
          }
        } else {
          if (mounted) {
            setState(() {
              _isLoading = false;
            });
          }
        }
      } else {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // Function to update room details
  Future<void> _updateRoomDetails() async {
    try {
      await FirebaseFirestore.instance.collection('rooms').add({
        'hotelId': _hotelId,
        'roomNumber': int.tryParse(_roomNumberController.text) ?? 0,
        'rent': double.tryParse(_rentController.text) ?? 0.0,
        'maxPeople': int.tryParse(_maxPeopleController.text) ?? 1, // Save max people field
        'acType': _acType,
        'bedType': _bedType,
        'wifiAvailable': _wifiAvailable,
        'balconyAvailable': _balconyAvailable,
        'isAvailable': _isAvailable,
      });

      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Room details updated successfully!')));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Error updating room details')));
      }
    }
  }

  // Function to pick an image
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  // Function to add room details
  Future<void> _addRoomDetails({
    required int roomNumber,
    required double rent,
    required String acType,
    required String bedType,
    required bool wifiAvailable,
    required bool balconyAvailable,
    required bool isAvailable,
    required int maxPeople, // Add max people parameter
  }) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        String hotelId = user.uid;

        String? imageUrl;
        if (_selectedImage != null) {
          imageUrl = await _uploadImageToCloudinary(_selectedImage!);
        }

        await FirebaseFirestore.instance.collection('rooms').add({
          'hotelId': hotelId,
          'roomNumber': roomNumber,
          'rent': rent,
          'maxPeople': maxPeople, // Save max people field
          'acType': acType,
          'bedType': bedType,
          'wifiAvailable': wifiAvailable,
          'balconyAvailable': balconyAvailable,
          'imageUrl': imageUrl,
          'isAvailable': isAvailable,
        });

        if (mounted) {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text('Room added successfully!')));
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text('User is not logged in')));
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Error adding room details')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Manage Room Details"),
          backgroundColor: Colors.teal,
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: Colors.teal.shade50,
      appBar: AppBar(
        title: const Text("Manage Room Details"),
        backgroundColor: Colors.teal,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _updateRoomDetails,
        backgroundColor: Colors.teal,
        child: const Icon(Icons.save),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Room Number
            _buildCard(child: _buildTextField("Room Number", _roomNumberController)),

            // Rent
            _buildCard(child: _buildTextField("Rent", _rentController)),

            // Max People
            _buildCard(child: _buildTextField("Max People", _maxPeopleController)), // New field for max people

            // AC Type
            _buildCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("AC Type", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  _buildRadioTile('AC'),
                  _buildRadioTile('Non-AC'),
                ],
              ),
            ),

            // Bed Type
            _buildCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Bed Type", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  _buildRadioTile('Single Bed'),
                  _buildRadioTile('Double Bed'),
                ],
              ),
            ),

            // Wi-Fi Availability
            _buildCard(
              child: Row(
                children: [
                  const Text("Wi-Fi Available", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  _buildCustomCheckbox(
                    value: _wifiAvailable,
                    onChanged: (value) {
                      setState(() {
                        _wifiAvailable = value!;
                      });
                    },
                  ),
                ],
              ),
            ),

            // Balcony Availability
            _buildCard(
              child: Row(
                children: [
                  const Text("Balcony Available", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  _buildCustomCheckbox(
                    value: _balconyAvailable,
                    onChanged: (value) {
                      setState(() {
                        _balconyAvailable = value!;
                      });
                    },
                  ),
                ],
              ),
            ),

            // Room Availability
            _buildCard(
              child: Row(
                children: [
                  const Text("Room Available", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  _buildCustomCheckbox(
                    value: _isAvailable,
                    onChanged: (value) {
                      setState(() {
                        _isAvailable = value!;
                      });
                    },
                  ),
                ],
              ),
            ),

            // Image Picker
            _buildCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Room Image", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  GestureDetector(
                    onTap: _pickImage,
                    child: Container(
                      width: double.infinity,
                      height: 200,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: _selectedImage == null
                          ? const Icon(Icons.add_a_photo, size: 40, color: Colors.teal)
                          : Image.file(_selectedImage!, fit: BoxFit.cover),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard({required Widget child}) {
    return Card(
      elevation: 10,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 12),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: child,
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      keyboardType: label == "Rent" || label == "Max People"
          ? TextInputType.numberWithOptions(decimal: true)
          : TextInputType.number,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      ),
    );
  }

  Widget _buildRadioTile(String value) {
    return ListTile(
      title: Text(value),
      leading: Radio<String>(
        value: value,
        groupValue: value == 'AC' || value == 'Non-AC' ? _acType : _bedType,
        onChanged: (newValue) {
          setState(() {
            if (value == 'AC' || value == 'Non-AC') {
              _acType = newValue!;
            } else {
              _bedType = newValue!;
            }
          });
        },
      ),
    );
  }

  Widget _buildCustomCheckbox({required bool value, required ValueChanged<bool?> onChanged}) {
    return Checkbox(
      value: value,
      onChanged: onChanged,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      activeColor: Colors.teal,
    );
  }
}
