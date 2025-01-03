import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudinary/cloudinary.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:project1/hotel/hotel_login.dart';

class HotelRegistrationPage extends StatefulWidget {
  const HotelRegistrationPage({super.key});

  @override
  State<HotelRegistrationPage> createState() => _HotelRegistrationPageState();
}

class _HotelRegistrationPageState extends State<HotelRegistrationPage> {
  final _formKey = GlobalKey<FormState>();

  // Form field values
  String hotelName = '';
  String location = ''; // Location will be automatically fetched
  String contactEmail = '';
  String contactNumber = ''; // Added for full address
  // Added for pin code
  String password = ''; // Added for password
  String confirmPassword = ''; // Added for confirm password
  int numberOfRooms = 1;

  String? latitude;
  String? longitude;

  // Facilities selection
  bool hasSwimmingPool = false;
  bool hasParking = false;
  bool hasRestaurant = false;
  bool hasBarFacility = false;
  bool hasDJNight = false;
  bool hasLaundryCleaning = false;
  bool hasWifi = false;
  bool hasGym = false;
  bool hasDoctorOnCall = false;
  String acSelection = 'AC'; // Default AC

  bool isLoading = false;

  // Firebase Firestore instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Image fields
  String? imageUrl;
  String ? documnetUrl;
  File? _image; // Holds the selected image file
  File ? document;

  final cloudinary = Cloudinary.signedConfig(
    apiKey: '666732294294543',
    apiSecret: 'RHEoFrFCQw48apLQaSIV1vcAfcU',
    cloudName: 'dsjp0qqgo',
  );

  // Method to request location permission and get the current location
  Future<void> _getCurrentLocation() async {
    // Request permission for location
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
      // Handle permission denied case
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Location permission denied")));
      return;
    }

    // Get current position
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    setState(() {
      latitude = position.latitude.toString();
      longitude = position.longitude.toString();
      location = "Lat: ${position.latitude}, Long: ${position.longitude}"; // Set location as a string
    });

    // Reverse Geocoding to get location name (city, country)
    List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark place = placemarks[0];
    setState(() {
      location = "${place.subLocality}, ${place.locality}, ${place.country}"; // Update location with a human-readable name
    });
  }

  // Method to pick image
  Future<void> _pickImage({ bool isDocument  = false}) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery); // You can also use ImageSource.camera

    if (image != null) {
      setState(() {
        if(isDocument){
          document = File(image.path);

        }else{
          _image = File(image.path);
        }
      });
    }
  }

  // Method to upload image to Cloudinary
  Future<String?> _uploadImageToCloudinary(File imageFile) async {
    try {
      // Upload image to Cloudinary
      final result = await cloudinary.upload(
        file: imageFile.path,
        folder: 'hotels',
        resourceType: CloudinaryResourceType.image,
      );
      return result.secureUrl; // Return the image URL
    } catch (e) {
      print("Error uploading image: $e");
      return null;
    }
  }

  // Get selected facilities
  String _getSelectedFacilities() {
    List<String> facilities = [];
    if (hasSwimmingPool) facilities.add("Swimming Pool");
    if (hasParking) facilities.add("Parking");
    if (hasRestaurant) facilities.add("Restaurant");
    if (hasBarFacility) facilities.add("Bar Facility");
    if (hasDJNight) facilities.add("DJ Night");
    if (hasLaundryCleaning) facilities.add("Laundry and Cleaning");
    if (hasWifi) facilities.add("Wi-Fi");
    if (hasGym) facilities.add("Gym");
    if (hasDoctorOnCall) facilities.add("Doctor on Call");
    return facilities.isNotEmpty ? facilities.join(", ") : "None";
  }

  // Submit form
  void submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });

      _formKey.currentState!.save();

      // Validate password and confirm password match
      if (password != confirmPassword) {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Passwords do not match")),
        );
        return;
      }
      
      final user = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: contactEmail, password: password);
      // Upload image to Cloudinary if an image was picked
      if (_image != null && document != null) {
        imageUrl = await _uploadImageToCloudinary(_image!);
        documnetUrl = await  _uploadImageToCloudinary(document!);
      }

      // Creating a hotel registration model
      Map<String, dynamic> hotelData = {
        'hotelName': hotelName,
        'location': location,
        'contactEmail': contactEmail,
        'contactNumber': contactNumber,
        'lat': latitude,
        'log': longitude,
        'isApproved': false,
        'numberOfRooms': numberOfRooms,
        'facilities': _getSelectedFacilities(),
        'imageUrl': imageUrl, // Add image URL to the data
        'document': documnetUrl
      };

      try {
        await _firestore.collection('hotels').doc(user.user!.uid).set(hotelData);
        setState(() {
          isLoading = false;
        });

        Navigator.of(context).pop();

        // Display success dialog
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text("Registration Successful"),
              content: const Text("Hotel registration successful!"),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text("OK"),
                ),
              ],
            );
          },
        );
      } catch (e) {
        setState(() {
          isLoading = false;
        });
        // Error dialog
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text("Error"),
              content: const Text("Failed to register hotel. Please try again."),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text("OK"),
                ),
              ],
            );
          },
        );
      }
    }
  }

  // Input decoration
  InputDecoration _buildInputDecoration(String labelText) {
    return InputDecoration(
      labelText: labelText,
      labelStyle: const TextStyle(color: Colors.teal),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _getCurrentLocation(); // Get current location when the page is loaded
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Hotel Registration"),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Hotel Information",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    const Icon(Icons.location_pin, color: Colors.teal),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(location),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Hotel Name
                TextFormField(
                  decoration: _buildInputDecoration("Hotel Name"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter the hotel name";
                    }
                    return null;
                  },
                  onSaved: (value) {
                    hotelName = value!;
                  },
                ),
                const SizedBox(height: 16),
                // Contact Email
                TextFormField(
                  decoration: _buildInputDecoration("Contact Email"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter the contact email";
                    }
                    return null;
                  },
                  onSaved: (value) {
                    contactEmail = value!;
                  },
                ),
                const SizedBox(height: 16),
                // Contact Number
                TextFormField(
                  decoration: _buildInputDecoration("Contact Number"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter the contact number";
                    }
                    return null;
                  },
                  onSaved: (value) {
                    contactNumber = value!;
                  },
                ),
                const SizedBox(height: 16),
                // Number of Rooms
                TextFormField(
                  decoration: _buildInputDecoration("No. of Rooms"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter the number of rooms";
                    }
                    return null;
                  },
                  onSaved: (value) {
                    numberOfRooms = int.parse(value!);
                  },
                ),
                const SizedBox(height: 16),
                // Password
                TextFormField(
                  decoration: _buildInputDecoration("Password"),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter a password";
                    }
                    return null;
                  },
                  onSaved: (value) {
                    password = value!;
                  },
                ),
                const SizedBox(height: 16),
                // Confirm Password
                TextFormField(
                  decoration: _buildInputDecoration("Confirm Password"),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please confirm your password";
                    }
                    return null;
                  },
                  onSaved: (value) {
                    confirmPassword = value!;
                  },
                ),
                const SizedBox(height: 16),
                // Facilities Checkboxes
                const Text(
                  "Select Facilities",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                CheckboxListTile(
                  title: const Text("Swimming Pool"),
                  value: hasSwimmingPool,
                  onChanged: (bool? value) {
                    setState(() {
                      hasSwimmingPool = value!;
                    });
                  },
                ),
                CheckboxListTile(
                  title: const Text("Parking"),
                  value: hasParking,
                  onChanged: (bool? value) {
                    setState(() {
                      hasParking = value!;
                    });
                  },
                ),
                CheckboxListTile(
                  title: const Text("Restaurant"),
                  value: hasRestaurant,
                  onChanged: (bool? value) {
                    setState(() {
                      hasRestaurant = value!;
                    });
                  },
                ),
                CheckboxListTile(
                  title: const Text("Bar Facility"),
                  value: hasBarFacility,
                  onChanged: (bool? value) {
                    setState(() {
                      hasBarFacility = value!;
                    });
                  },
                ),
                CheckboxListTile(
                  title: const Text("DJ Night"),
                  value: hasDJNight,
                  onChanged: (bool? value) {
                    setState(() {
                      hasDJNight = value!;
                    });
                  },
                ),
                CheckboxListTile(
                  title: const Text("Laundry and Cleaning"),
                  value: hasLaundryCleaning,
                  onChanged: (bool? value) {
                    setState(() {
                      hasLaundryCleaning = value!;
                    });
                  },
                ),
                CheckboxListTile(
                  title: const Text("Wi-Fi"),
                  value: hasWifi,
                  onChanged: (bool? value) {
                    setState(() {
                      hasWifi = value!;
                    });
                  },
                ),
                CheckboxListTile(
                  title: const Text("Gym"),
                  value: hasGym,
                  onChanged: (bool? value) {
                    setState(() {
                      hasGym = value!;
                    });
                  },
                ),
                CheckboxListTile(
                  title: const Text("Doctor on Call"),
                  value: hasDoctorOnCall,
                  onChanged: (bool? value) {
                    setState(() {
                      hasDoctorOnCall = value!;
                    });
                  },
                ),
                const SizedBox(height: 16),

                const Text('logo'),
                // Hotel Image Picker
                GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    height: 200,
                    width: MediaQuery.of(context).size.width,
                    color: Colors.grey[200],
                    child: _image == null
                        ? const Icon(Icons.add_a_photo, size: 50)
                        : Image.file(_image!, fit: BoxFit.cover),
                  ),
                ),
                const SizedBox(height: 20),

                const Text('Document'),

                 GestureDetector(
                  onTap: (){
                    _pickImage(isDocument: true);
                  },
                  child: Container(
                    height: 200,
                    width: MediaQuery.of(context).size.width,
                    color: Colors.grey[200],
                    child: document == null
                        ? const Icon(Icons.add_a_photo, size: 50)
                        : Image.file(document!, fit: BoxFit.cover),
                  ),
                ),
                const SizedBox(height: 20),

                // Submit Button
                ElevatedButton(
                  onPressed: submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    fixedSize: Size(MediaQuery.of(context).size.width, 50)
                  ),
                  child: isLoading
                      ? const CircularProgressIndicator()
                      : const Text('Submit',style: TextStyle(color: Colors.white),),
                ),
                
                const SizedBox(height: 20),
                // Add "Already have an account?" section
                Align(
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Already have an account?"),
                      TextButton(
                        onPressed: () {
                          // Navigate to Hotel Login
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) =>  const HotelLoginPage()),
                          );
                        },
                        child: const Text("Login"),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
