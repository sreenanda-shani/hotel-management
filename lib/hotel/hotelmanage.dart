import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    home: ManageHotelDetailsPage(),
  ));
}

class ManageHotelDetailsPage extends StatefulWidget {
  const ManageHotelDetailsPage({super.key});

  @override
  _ManageHotelDetailsPageState createState() => _ManageHotelDetailsPageState();
}

class _ManageHotelDetailsPageState extends State<ManageHotelDetailsPage> {
  final TextEditingController _hotelNameController = TextEditingController();
  final TextEditingController _contactEmailController = TextEditingController();
  final TextEditingController _contactNumberController = TextEditingController();
  final TextEditingController _facilitiesController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _latController = TextEditingController();
  final TextEditingController _logController = TextEditingController();
  final TextEditingController _numberOfRoomsController = TextEditingController();
  bool _isApproved = false;

  List<Map<String, String>> _nearbyAttractions = [];
  final TextEditingController _attractionNameController = TextEditingController();
  final TextEditingController _attractionDistanceController = TextEditingController();
  final TextEditingController _attractionFeaturesController = TextEditingController();

  bool _isLoading = true;
  String _hotelId = ''; // Store the hotel ID of the logged-in user

  @override
  void initState() {
    super.initState();
    _fetchHotelDetails();
  }

  Future<void> _fetchHotelDetails() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        _hotelId = user.uid;
        DocumentSnapshot docSnapshot = await FirebaseFirestore.instance
            .collection('hotels')
            .doc(_hotelId)
            .get();

        if (docSnapshot.exists) {
          var data = docSnapshot.data() as Map<String, dynamic>;
          setState(() {
            _hotelNameController.text = data['hotelName'] ?? '';
            _contactEmailController.text = data['contactEmail'] ?? '';
            _contactNumberController.text = data['contactNumber'] ?? '';
            _facilitiesController.text = data['facilities'] ?? '';
            _imageUrlController.text = data['imageUrl'] ?? '';
            _locationController.text = data['location'] ?? '';
            _latController.text = data['lat'] ?? '';
            _logController.text = data['log'] ?? '';
            _numberOfRoomsController.text = data['numberOfRooms'].toString();
            _nearbyAttractions = List<Map<String, String>>.from(data['nearbyAttractions'] ?? []);
            _isApproved = data['isApproved'] ?? false;
            _isLoading = false;
          });
        } else {
          setState(() {
            _isLoading = false;
          });
        }
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _updateHotelDetails() async {
    if (!_validateEmail(_contactEmailController.text)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid email address')),
      );
      return;
    }

    if (!_validatePhoneNumber(_contactNumberController.text)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid phone number')),
      );
      return;
    }

    try {
      await FirebaseFirestore.instance
          .collection('hotels')
          .doc(_hotelId)
          .update({
        'hotelName': _hotelNameController.text,
        'contactEmail': _contactEmailController.text,
        'contactNumber': _contactNumberController.text,
        'facilities': _facilitiesController.text,
        'imageUrl': _imageUrlController.text,
        'location': _locationController.text,
        'lat': _latController.text,
        'log': _logController.text,
        'numberOfRooms': int.tryParse(_numberOfRoomsController.text) ?? 0,
        'nearbyAttractions': _nearbyAttractions,
        'isApproved': _isApproved,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Hotel details updated successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error updating hotel details')),
      );
    }
  }

  bool _validateEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  bool _validatePhoneNumber(String phoneNumber) {
    final phoneRegex = RegExp(r'^\+?[0-9]{10,}$');
    return phoneRegex.hasMatch(phoneNumber);
  }

  void _addAttraction() {
    setState(() {
      _nearbyAttractions.add({
        'name': _attractionNameController.text,
        'distance': _attractionDistanceController.text,
        'features': _attractionFeaturesController.text,
      });
      _attractionNameController.clear();
      _attractionDistanceController.clear();
      _attractionFeaturesController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Manage Hotel Details"),
          backgroundColor: Colors.teal,
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Manage Hotel Details",
          style: TextStyle(
            color: Colors.black, // Change the text color to black
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.white, // Set the AppBar background color to white
        elevation: 0, // Remove the shadow
        actions: [
          IconButton(
            icon: const Icon(Icons.save, color: Colors.black), // Change the icon color to black
            onPressed: _updateHotelDetails,
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('asset/img4.webp'), // Add your background image path here
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.8), // Semi-transparent background color for the form container
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  _buildTextField("Hotel Name", _hotelNameController),
                  _buildTextField("Contact Email", _contactEmailController),
                  _buildTextField("Contact Number", _contactNumberController),
                  _buildTextField("Facilities", _facilitiesController),
                  _buildTextField("Image URL", _imageUrlController),
                  _buildTextField("Location", _locationController),
                  _buildTextField("Latitude", _latController),
                  _buildTextField("Longitude", _logController),
                  _buildTextField("Number of Rooms", _numberOfRoomsController),
                  const SizedBox(height: 16),
                  const Text("Nearby Attractions",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  _buildTextField("Attraction Name", _attractionNameController),
                  _buildTextField("Distance", _attractionDistanceController),
                  _buildTextField("Features", _attractionFeaturesController),
                  ElevatedButton(
                      onPressed: _addAttraction,
                      child: const Text("Add Attraction")),
                  Column(
                    children: _nearbyAttractions
                        .map((attraction) => ListTile(
                              title: Text(attraction['name']!),
                              subtitle: Text(
                                  "${attraction['distance']} km - ${attraction['features']}"),
                            ))
                        .toList(),
                  ),
                  Row(
                    children: [
                      const Text(
                        "Is Approved",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                      Checkbox(
                        value: _isApproved,
                        onChanged: (value) {
                          setState(() {
                            _isApproved = value!;
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.black), // Changed label color to black
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.teal),
          ),
          filled: true,
          fillColor: Colors.transparent, // Transparent background
          focusColor: Colors.teal, // Focus color for better visibility
          hoverColor: Colors.teal, // Hover color (optional)
        ),
      ),
    );
  }
}