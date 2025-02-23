import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class StaffFeedbackPage extends StatefulWidget {
  const StaffFeedbackPage({super.key});

  @override
  _StaffFeedbackPageState createState() => _StaffFeedbackPageState();
}

class _StaffFeedbackPageState extends State<StaffFeedbackPage> {
  final TextEditingController feedbackController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Staff Feedback"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Please share your feedback:",
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: feedbackController,
              maxLines: 5,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Enter your feedback here...",
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                String feedback = feedbackController.text.trim();
                if (feedback.isNotEmpty) {
                  await FirebaseFirestore.instance.collection('stafffeedback').add({
                    'staffId': FirebaseAuth.instance.currentUser?.uid,
                    'feedback': feedback,
                    'timestamp': FieldValue.serverTimestamp(),
                  });

                  feedbackController.clear(); // Clear the input field after submission

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Feedback submitted successfully!")),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Please enter some feedback")),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text("Submit Feedback"),
            ),
          ],
        ),
      ),
    );
  }
}
