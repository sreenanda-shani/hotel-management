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
  final TextEditingController _maxPeopleController = TextEditingController();

  String _acType = 'AC';
  String _bedType = 'Single Bed';
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

  // List of bed types
  final List<String> _bedTypes = ['Single Bed', 'Double Bed', 'Suite', 'Standard', 'King', 'Queen'];

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
              _bedType = data['bedType'] ?? 'Single Bed';
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
      // Upload image to Cloudinary if selected
      String? imageUrl;
      if (_selectedImage != null) {
        imageUrl = await _uploadImageToCloudinary(_selectedImage!);
      }

      // Update the room details in Firestore
      await FirebaseFirestore.instance.collection('rooms').add({
        'hotelId': _hotelId,
        'roomNumber': int.tryParse(_roomNumberController.text) ?? 0,
        'rent': double.tryParse(_rentController.text) ?? 0.0,
        'maxPeople': int.tryParse(_maxPeopleController.text) ?? 1,
        'acType': _acType,
        'bedType': _bedType,
        'wifiAvailable': _wifiAvailable,
        'balconyAvailable': _balconyAvailable,
        'imageUrl': imageUrl, // Save the image URL
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
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.transparent,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
      keyboardType: TextInputType.number,
    );
  }

  Widget _buildRadioTile(String value, String groupValue, Function(String?) onChanged) {
    return Row(
      children: [
        Radio<String>(
          value: value,
          groupValue: groupValue,
          onChanged: onChanged,
        ),
        Text(value),
      ],
    );
  }

  Widget _buildCustomCheckbox({required bool value, required void Function(bool?) onChanged}) {
    return Checkbox(
      value: value,
      onChanged: onChanged,
      checkColor: Colors.white,
      activeColor: Colors.transparent,
    );
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
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        title: const Text(
          "Manage Room Details",
          style: TextStyle(color: Colors.black),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _updateRoomDetails,
        backgroundColor: Colors.teal,
        child: const Icon(Icons.save),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'asset/img4.webp',
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              color: Colors.transparent,
              child: ListView(
                children: [
                  _buildCard(child: _buildTextField("Room Number", _roomNumberController)),
                  _buildCard(child: _buildTextField("Rent", _rentController)),
                  _buildCard(child: _buildTextField("Max People", _maxPeopleController)),
                  _buildCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("AC Type", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        _buildRadioTile('AC', _acType, (newValue) {
                          setState(() {
                            _acType = newValue!;
                          });
                        }),
                        _buildRadioTile('Non-AC', _acType, (newValue) {
                          setState(() {
                            _acType = newValue!;
                          });
                        }),
                      ],
                    ),
                  ),
                  _buildCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Bed Type", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        ..._bedTypes.map((bedType) => _buildRadioTile(bedType, _bedType, (newValue) {
                              setState(() {
                                _bedType = newValue!;
                              });
                            })),
                      ],
                    ),
                  ),
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
          ),
        ],
      ),
    );
  }
}
