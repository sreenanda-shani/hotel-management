import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class PaymentPage extends StatefulWidget {
  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  late Razorpay _razorpay;

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();

    // Event listeners for Razorpay events
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();  // Important to release Razorpay resources
  }

  // Function to initiate payment process
  void _openCheckout(double amount, [Function(String paymentId)? onSuccess]) async {
    var options = {
      'key': 'rzp_test_QLvdqmBfoYL2Eu', // Replace with your Razorpay key
      'amount': (amount * 100).toInt(), // Convert amount to paise
      'name': 'Machinery Booking',
      'description': 'Payment for machinery rental',
      'prefill': {
        'contact': '1234567890', // Add user phone number here if available
        'email': 'user@example.com', // Add user email here if available
      },
    };

    try {
      _razorpay.open(options);

      // Call the onSuccess callback if provided
      if (onSuccess != null) {
        _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, (response) {
          onSuccess(response.paymentId);  // Return the paymentId
        });
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  // Handle successful payment
  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    print('Payment Success: ${response.paymentId}');
    // Call your function to process the order, e.g., _processOrder(paymentId: response.paymentId)
  }

  // Handle failed payment
  void _handlePaymentError(PaymentFailureResponse response) {
    print('Payment Failed: ${response.code} - ${response.message}');
    // Check if it's a payment cancellation
    if (response.code == 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Payment was cancelled by the user')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Payment failed: ${response.message}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: const Text("Payment Page"),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Example usage: Open checkout with amount 100.0
            _openCheckout(100.0, (paymentId) {
              print("Payment ID: $paymentId");
            });
          },
          child: const Text("Pay Now"),
        ),
      ),
    );
  }
}
