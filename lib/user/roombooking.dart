import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';  // For date formatting
import 'package:project1/hotel/hotelpayment.dart';

class RoomBookingPage extends StatefulWidget {
  final String hotelId;
  final int roomNumber;
  final double rent;

  const RoomBookingPage({
    super.key,
    required this.hotelId,
    required this.roomNumber,
    required this.rent,
  });

  @override
  _RoomBookingPageState createState() => _RoomBookingPageState();
}

class _RoomBookingPageState extends State<RoomBookingPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _guestsController = TextEditingController();
  final TextEditingController _checkInController = TextEditingController();
  final TextEditingController _checkOutController = TextEditingController();

  final _formKey = GlobalKey<FormState>();  // Global key to manage the form state

  // Function to save booking details to Firestore
  Future<void> _saveBooking() async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        // Parse the check-in and check-out dates as DateTime objects
        DateTime checkInDate = DateFormat('yyyy-MM-dd').parse(_checkInController.text.trim());
        DateTime checkOutDate = DateFormat('yyyy-MM-dd').parse(_checkOutController.text.trim());

        final bookingData = {
          'hotelId': widget.hotelId,
          'roomNumber': widget.roomNumber,
          'rent': widget.rent,
          'name': _nameController.text.trim(),
          'mobile': _mobileController.text.trim(),
          'email': _emailController.text.trim(),
          'guests': int.parse(_guestsController.text.trim()),
          'checkIn': Timestamp.fromDate(checkInDate),  // Store as Firestore Timestamp
          'checkOut': Timestamp.fromDate(checkOutDate),  // Store as Firestore Timestamp
          'bookingDate': Timestamp.now(),  // Optional: Add timestamp for booking date
        };

        // Save the booking data to Firestore
        await FirebaseFirestore.instance.collection('booking').add(bookingData);

        // Show confirmation message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Booking confirmed for room ${widget.roomNumber}!')),
        );

        // Navigate to payment page
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PaymentPage()), // Navigate to the payment page
        );
      } catch (e) {
        // Handle any errors here
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error booking the room: $e')),
        );
      }
    }
  }

  // Date picker for selecting the check-in date
  Future<void> _selectDate(BuildContext context, TextEditingController controller) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      controller.text = DateFormat('yyyy-MM-dd').format(pickedDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: const Text("Room Booking"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,  // Use the form key for validation
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Room Number: ${widget.roomNumber}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Text('Rent: \$${widget.rent}', style: const TextStyle(fontSize: 18)),
              const SizedBox(height: 16),

              // Booking form with box design
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Full Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _mobileController,
                decoration: const InputDecoration(labelText: 'Mobile Number'),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your mobile number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email Address'),
                validator: (value) {
                  if (value == null || value.isEmpty || !RegExp(r"^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+$").hasMatch(value)) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _guestsController,
                decoration: const InputDecoration(labelText: 'Number of Guests'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the number of guests';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _checkInController,
                decoration: const InputDecoration(labelText: 'Check-in Date'),
                readOnly: true,
                onTap: () => _selectDate(context, _checkInController),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a check-in date';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _checkOutController,
                decoration: const InputDecoration(labelText: 'Check-out Date'),
                readOnly: true,
                onTap: () => _selectDate(context, _checkOutController),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a check-out date';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              ElevatedButton(
                onPressed: _saveBooking, // Save booking when button is pressed
                child: const Text("Confirm Booking"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
