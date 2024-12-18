// late Razorpay _razorpay;


//  @override
//   void initState() {
//     super.initState();
//     _razorpay = Razorpay();
//     // _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
//     _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);

//   }


// void _openCheckout(double amount, [Function(String paymentId)? onSuccess]) async {
//   var options = {
//     'key': 'rzp_test_QLvdqmBfoYL2Eu', // Replace with your Razorpay key
//     'amount': (amount * 100).toInt(), // Convert amount to paise
//     'name': 'Machinery Booking',
//     'description': 'Payment for machinery rental',
//     'prefill': {
//       'contact': '1234567890', // Add user phone number here if available
//       'email': 'user@example.com', // Add user email here if available
//     },
//   };

//   try {
//     _razorpay.open(options);

//       _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, (response) {


//         if(onSuccess == null){
//           _handlePaymentSuccess(response);
//         }else{
//           onSuccess(response.paymentId);
//         }
//       });



//   } catch (e) {
//     print('Error: $e');
//   }
// }








//   // Handle successful payment
//   void _handlePaymentSuccess(PaymentSuccessResponse response) {
//     print('Payment Success: ${response.paymentId}');
//     _processOrder(paymentId:response.paymentId!);
//   }

//   // Handle failed payment
//   void _handlePaymentError(PaymentFailureResponse response) {
//     print('Payment Failed: ${response.code} - ${response.message}');
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text('Payment failed: ${response.message}')),
//     );
//   }

//   // Handle payment cancellation
//   void _handlePaymentCancel(dynamic response) {
//     print('Payment Cancelled: ${response.paymentId}');
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text('Payment cancelled')),
//     );
//   }