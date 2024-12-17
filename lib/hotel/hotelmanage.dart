import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ManageHotelDetailsPage extends StatefulWidget {
  const ManageHotelDetailsPage({super.key});

  @override
  _ManageHotelDetailsPageState createState() => _ManageHotelDetailsPageState();
}

class _ManageHotelDetailsPageState extends State<ManageHotelDetailsPage> {
  // Controllers for each field
  TextEditingController _hotelNameController = TextEditingController();
  TextEditingController _contactEmailController = TextEditingController();
  TextEditingController _contactNumberController = TextEditingController();
  TextEditingController _facilitiesController = TextEditingController();
  TextEditingController _imageUrlController = TextEditingController();
  TextEditingController _locationController = TextEditingController();
  TextEditingController _latController = TextEditingController();
  TextEditingController _logController = TextEditingController();
  TextEditingController _numberOfRoomsController = TextEditingController();
  bool _isApproved = false;

  bool _isLoading = true;
  String _hotelId = ''; // Store the hotel ID of the logged-in user

  @override
  void initState() {
    super.initState();
    _fetchHotelDetails();
  }

  // Fetch Hotel Details from Firestore based on logged-in user
  Future<void> _fetchHotelDetails() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // Get hotel details using user ID as hotelId
        _hotelId = user.uid; // Using user ID to fetch the hotel details
        print("Fetching hotel details for hotel ID: $_hotelId");

        DocumentSnapshot docSnapshot = await FirebaseFirestore.instance
            .collection('hotels')
            .doc(_hotelId) // Using user ID to fetch the hotel details
            .get();

        if (docSnapshot.exists) {
          var data = docSnapshot.data() as Map<String, dynamic>;
          print("Document found, data: $data");  // Debugging the data

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
            _isApproved = data['isApproved'] ?? false;
            _isLoading = false;
          });
        } else {
          print("Document not found for hotel ID: $_hotelId");
          setState(() {
            _isLoading = false; // Ensure UI reflects the absence of document
          });
        }
      } else {
        print("User not logged in");
        setState(() {
          _isLoading = false; // If no user is logged in, stop loading
        });
      }
    } catch (e) {
      print("Error fetching hotel details: $e");
      setState(() {
        _isLoading = false; // If there's an error, set loading to false
      });
    }
  }

  // Update the hotel details in Firestore
  Future<void> _updateHotelDetails() async {
    try {
      await FirebaseFirestore.instance.collection('hotels').doc(_hotelId).update({
        'hotelName': _hotelNameController.text,
        'contactEmail': _contactEmailController.text,
        'contactNumber': _contactNumberController.text,
        'facilities': _facilitiesController.text,
        'imageUrl': _imageUrlController.text,
        'location': _locationController.text,
        'lat': _latController.text,
        'log': _logController.text,
        'numberOfRooms': int.tryParse(_numberOfRoomsController.text) ?? 0,
        'isApproved': _isApproved,
      });

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Hotel details updated successfully!')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error updating hotel details')));
      print("Error updating hotel details: $e");
    }
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
        title: const Text("Manage Hotel Details"),
        backgroundColor: Colors.teal,
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _updateHotelDetails,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
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
            Row(
              children: [
                const Text("Is Approved"),
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
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
      ),
    );
  }
}
