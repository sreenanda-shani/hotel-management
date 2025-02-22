import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudinary/cloudinary.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class AddRoomScreen extends StatefulWidget {
  @override
  _AddRoomScreenState createState() => _AddRoomScreenState();
}

class _AddRoomScreenState extends State<AddRoomScreen> {
  final _roomNumberController = TextEditingController();
  final _rentController = TextEditingController();
  final _totalRentController =
      TextEditingController(); // New controller for Total Rent
  final _maxPeopleController = TextEditingController();

  String _selectedRoomType = 'Standard Room';
  String _acType = 'AC';
  String _bedType = 'Single';
  bool _wifiAvailable = false;
  bool _balconyAvailable = false;
  bool _isAvailable = true;
  File? _selectedImage;
  bool _isLoading = false;
  final _hotelId =
      FirebaseAuth.instance.currentUser?.uid; // Replace with actual hotel ID

  final _roomTypes = [
    'Double Room',
    'Twin Room',
    'Single Room',
    'Triple Room',
    'Family Room',
    'Suite',
    'Standard Room',
    'Superior Room',
    'Quadruple Room',
    'Deluxe Room',
    'Vacation Home',
    'Apartment',
    'King Room',
    'Guest Room',
    'Studio',
    'House',
    'Queen Room',
    'Premium Room'
  ];
  final _acTypes = ['AC', 'Non-AC'];
  final _bedTypes = ['Single', 'Double', 'Queen', 'King'];

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

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

  Future<void> _updateRoomDetails() async {
    if (_roomNumberController.text.isEmpty ||
        _rentController.text.isEmpty ||
        _totalRentController.text.isEmpty ||
        _maxPeopleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all required fields')),
      );
      return;
    }

    try {
      setState(() {
        _isLoading = true;
      });

      // Parse the room number as an integer
      final roomNumber = int.tryParse(_roomNumberController.text) ?? 0;

      // Check if a room with the same room number already exists for this hotel
      final querySnapshot = await FirebaseFirestore.instance
          .collection('rooms')
          .where('hotelId', isEqualTo: _hotelId)
          .where('roomNumber', isEqualTo: roomNumber)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Room number already exists for this hotel')),
        );
        return;
      }

      // Upload image to Cloudinary if selected
      String? imageUrl;
      if (_selectedImage != null) {
        imageUrl = await _uploadImageToCloudinary(_selectedImage!);
      }

      // Parse the rent and total rent values
      final double rentValue = double.tryParse(_rentController.text) ?? 0.0;
      final double totalRentValue =
          double.tryParse(_totalRentController.text) ?? 0.0;

      // Add room details to Firestore including totalRent field
      await FirebaseFirestore.instance.collection('rooms').add({
        'hotelId': _hotelId,
        'roomNumber': roomNumber,
        'rent': rentValue,
        'totalRent': totalRentValue, // New field for Total Rent
        'maxPeople': int.tryParse(_maxPeopleController.text) ?? 1,
        'acType': _acType,
        'bedType': _bedType,
        'wifiAvailable': _wifiAvailable,
        'balconyAvailable': _balconyAvailable,
        'imageUrl': imageUrl, // Save the image URL
        'isAvailable': _isAvailable,
        'roomType': _selectedRoomType,
      });

      // Clear all fields after successful save
      _roomNumberController.clear();
      _rentController.clear();
      _totalRentController.clear();
      _maxPeopleController.clear();
      setState(() {
        _selectedRoomType = 'Standard Room';
        _acType = 'AC';
        _bedType = 'Single';
        _wifiAvailable = false;
        _balconyAvailable = false;
        _isAvailable = true;
        _selectedImage = null;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Room details added successfully!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error adding room details')),
        );
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Room Details'),
        backgroundColor: Colors.teal,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTextField(_roomNumberController, 'Room Number',
                      TextInputType.number),
                  _buildTextField(
                      _rentController, 'Rent', TextInputType.number),
                  // New Total Rent Field below Rent
                  _buildTextField(
                      _totalRentController, 'Total Rent', TextInputType.number),
                  _buildTextField(
                      _maxPeopleController, 'Max People', TextInputType.number),
                  const SizedBox(height: 16.0),
                  _buildDropdown('Room Type', _roomTypes, _selectedRoomType,
                      (value) {
                    setState(() {
                      _selectedRoomType = value!;
                    });
                  }),
                  _buildDropdown('AC Type', _acTypes, _acType, (value) {
                    setState(() {
                      _acType = value!;
                    });
                  }),
                  _buildDropdown('Bed Type', _bedTypes, _bedType, (value) {
                    setState(() {
                      _bedType = value!;
                    });
                  }),
                  _buildSwitch('WiFi Available', _wifiAvailable, (value) {
                    setState(() {
                      _wifiAvailable = value;
                    });
                  }),
                  _buildSwitch('Balcony Available', _balconyAvailable, (value) {
                    setState(() {
                      _balconyAvailable = value;
                    });
                  }),
                  _buildSwitch('Available', _isAvailable, (value) {
                    setState(() {
                      _isAvailable = value;
                    });
                  }),
                  const SizedBox(height: 16.0),
                  _buildImagePicker(),
                  const SizedBox(height: 16.0),
                  _buildAddRoomButton(),
                ],
              ),
            ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String labelText,
      TextInputType inputType) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: labelText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          filled: true,
          fillColor: Colors.grey[100],
        ),
        keyboardType: inputType,
      ),
    );
  }

  Widget _buildDropdown(String label, List<String> items, String currentValue,
      Function(String?) onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<String>(
        value: currentValue,
        items: items.map((type) {
          return DropdownMenuItem(
            value: type,
            child: Text(type),
          );
        }).toList(),
        onChanged: onChanged,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          filled: true,
          fillColor: Colors.grey[100],
        ),
      ),
    );
  }

  Widget _buildSwitch(
      String title, bool currentValue, Function(bool) onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: SwitchListTile(
        title: Text(title),
        value: currentValue,
        onChanged: onChanged,
        activeColor: Colors.teal,
      ),
    );
  }

  Widget _buildImagePicker() {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: ElevatedButton.icon(
        onPressed: _pickImage,
        icon: const Icon(Icons.photo_library),
        label: const Text('Pick Image'),
        style: ElevatedButton.styleFrom(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          backgroundColor: Colors.teal,
        ),
      ),
    );
  }

  Widget _buildAddRoomButton() {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: ElevatedButton(
        onPressed: _updateRoomDetails,
        child: const Text(
          'Add Room',
          style: TextStyle(color: Colors.white),
        ),
        style: ElevatedButton.styleFrom(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
          padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 16),
          backgroundColor: Colors.teal,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _roomNumberController.dispose();
    _rentController.dispose();
    _totalRentController.dispose();
    _maxPeopleController.dispose();
    super.dispose();
  }
}