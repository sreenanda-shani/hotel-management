import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class RoomBookingPage extends StatefulWidget {
  final String hotelId;
  final int roomNumber;
  final double rent;
  final String roomId;

  const RoomBookingPage({
    super.key,
    required this.hotelId,
    required this.roomNumber,
    required this.rent,
    required this.roomId,
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

  final _formKey = GlobalKey<FormState>();
  late Razorpay _razorpay;

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();

    // Set up Razorpay event listeners
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
  }

  @override
  void dispose() {
    _razorpay.clear(); // Clean up Razorpay resources
    super.dispose();
  }

  // Function to handle successful payment
  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    try {
      DateTime checkInDate =
          DateFormat('yyyy-MM-dd').parse(_checkInController.text.trim());
      DateTime checkOutDate =
          DateFormat('yyyy-MM-dd').parse(_checkOutController.text.trim());

      // Calculate the total rent based on the number of days between check-in and check-out
      int daysStay = checkOutDate.difference(checkInDate).inDays;
      double totalRent = daysStay * widget.rent;

      final bookingData = {
        'hotelId': widget.hotelId,
        'roomNumber': widget.roomNumber,
        'roomid': widget.roomId,
        'rent': widget.rent,
        'totalRent': totalRent, // Add total rent field
        'name': _nameController.text.trim(),
        'mobile': _mobileController.text.trim(),
        'email': _emailController.text.trim(),
        'guests': int.parse(_guestsController.text.trim()),
        'checkIn': Timestamp.fromDate(checkInDate),
        'checkOut': Timestamp.fromDate(checkOutDate),
        'bookingDate': Timestamp.now(),
        'paymentId': response.paymentId,
      };

      // Save the booking to Firestore
      await FirebaseFirestore.instance.collection('booking').add(bookingData);

      // Update the room availability to false
      await FirebaseFirestore.instance
          .collection('rooms')
          .doc(widget.roomId)
          .update({
        'isAvailable': false, // Set room availability to false
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Booking confirmed for room ${widget.roomNumber}!')),
      );

      Navigator.pop(context); // Navigate back after successful booking
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving booking: $e')),
      );
    }
  }

  // Function to handle payment errors
  void _handlePaymentError(PaymentFailureResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Payment failed: ${response.message}')),
    );
  }

  // Function to initiate Razorpay payment
  void _startPayment() {
    if (_formKey.currentState?.validate() ?? false) {
      var options = {
        'key': 'rzp_test_QLvdqmBfoYL2Eu', // Replace with your Razorpay key
        'amount': (widget.rent * 100).toInt(), // Amount in paise
        'name': 'Room Booking',
        'description': 'Payment for room ${widget.roomNumber}',
        'prefill': {
          'contact': _mobileController.text.trim(),
          'email': _emailController.text.trim(),
        },
      };

      try {
        _razorpay.open(options);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error starting payment: $e')),
        );
      }
    }
  }

  // Date picker for selecting dates
  Future<void> _selectDate(
      BuildContext context, TextEditingController controller) async {
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
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade300,
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Room Number: ${widget.roomNumber}',
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    Text('Rent: \$${widget.rent}',
                        style: const TextStyle(fontSize: 18)),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Booking form fields
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                    labelText: 'Full Name', border: OutlineInputBorder()),
                validator: (value) => value == null || value.isEmpty
                    ? 'Please enter your name'
                    : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _mobileController,
                decoration: const InputDecoration(
                    labelText: 'Mobile Number', border: OutlineInputBorder()),
                keyboardType: TextInputType.phone,
                validator: (value) => value == null || value.isEmpty
                    ? 'Please enter your mobile number'
                    : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                    labelText: 'Email Address', border: OutlineInputBorder()),
                validator: (value) => value == null ||
                        value.isEmpty ||
                        !RegExp(r"^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+$")
                            .hasMatch(value)
                    ? 'Please enter a valid email'
                    : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _guestsController,
                decoration: const InputDecoration(
                    labelText: 'Number of Guests',
                    border: OutlineInputBorder()),
                keyboardType: TextInputType.number,
                validator: (value) => value == null || value.isEmpty
                    ? 'Please enter the number of guests'
                    : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _checkInController,
                decoration: const InputDecoration(
                    labelText: 'Check-in Date', border: OutlineInputBorder()),
                readOnly: true,
                onTap: () => _selectDate(context, _checkInController),
                validator: (value) => value == null || value.isEmpty
                    ? 'Please select a check-in date'
                    : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _checkOutController,
                decoration: const InputDecoration(
                    labelText: 'Check-out Date', border: OutlineInputBorder()),
                readOnly: true,
                onTap: () => _selectDate(context, _checkOutController),
                validator: (value) => value == null || value.isEmpty
                    ? 'Please select a check-out date'
                    : null,
              ),
              const SizedBox(height: 24),

              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: _startPayment,
                  child: const Text("Proceed to Payment",
                      style: TextStyle(fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}