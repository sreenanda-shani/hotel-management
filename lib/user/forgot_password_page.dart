import 'package:flutter/material.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController otpController = TextEditingController();
  bool _otpSent = false; // To track whether OTP has been sent
  String _otp = ''; // To store the generated OTP for verification

  // Function to simulate sending OTP to the entered email
  void sendOtp() {
    String email = emailController.text;

    // Basic validation
    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your email')),
      );
      return;
    }

    // Simulate OTP generation (for this example, we'll use a hardcoded OTP)
    setState(() {
      _otp = '123456'; // Hardcoded OTP for simulation
      _otpSent = true; // OTP has been sent
    });

    // Show confirmation message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('OTP has been sent to your email')),
    );
  }

  // Function to handle OTP verification
  void verifyOtp() {
    String enteredOtp = otpController.text;

    if (enteredOtp.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter the OTP')),
      );
      return;
    }

    // Check if OTP matches
    if (enteredOtp == _otp) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('OTP verified! You can now reset your password')),
      );

      // Proceed to reset password (simulated here with a pop)
      Navigator.pop(context); // Navigate back to the login page or reset password page
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid OTP. Please try again')),
      );
    }
  }

  // Function to resend OTP
  void resendOtp() {
    setState(() {
      _otpSent = false;
    });
    sendOtp(); // Re-sending the OTP
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Forgot Password"),
      ),
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              'asset/img4.webp', // Replace with your image path
              fit: BoxFit.cover,
            ),
          ),
          // Foreground Content
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Circular Logo
                    ClipOval(
                      child: Image.asset(
                        'asset/download.png', // Replace with your logo path
                        width: 120,
                        height: 120,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Email Text Field
                    SizedBox(
                      width: 300,
                      child: TextField(
                        controller: emailController,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: 'Email',
                          labelStyle: const TextStyle(color: Colors.white),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                          filled: true,
                          fillColor: Colors.black.withOpacity(0.3),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.green, width: 2.0),
                            borderRadius: BorderRadius.circular(50),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Send OTP Button
                    !_otpSent
                        ? ElevatedButton(
                            onPressed: sendOtp,
                            child: const Text('Send OTP'),
                          )
                        : Container(),

                    // OTP Text Field
                    _otpSent
                        ? SizedBox(
                            width: 300,
                            child: TextField(
                              controller: otpController,
                              style: const TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                labelText: 'Enter OTP',
                                labelStyle: const TextStyle(color: Colors.white),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                filled: true,
                                fillColor: Colors.black.withOpacity(0.3),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(color: Colors.green, width: 2.0),
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(color: Colors.white),
                                  borderRadius: BorderRadius.circular(50),
                                ),
                              ),
                            ),
                          )
                        : Container(),

                    const SizedBox(height: 16),

                    // Verify OTP Button
                    _otpSent
                        ? ElevatedButton(
                            onPressed: verifyOtp,
                            child: const Text('Verify OTP'),
                          )
                        : Container(),

                    const SizedBox(height: 16),

                    // Resend OTP Option
                    _otpSent
                        ? GestureDetector(
                            onTap: resendOtp,
                            child: const Text(
                              "Didn't receive OTP? Resend",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )
                        : Container(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
