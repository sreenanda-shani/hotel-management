import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class StaffFeedbackPage extends StatelessWidget {
  const StaffFeedbackPage({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController feedbackController = TextEditingController();

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
                  // Now saving feedback to the 'stafffeedback' collection
                  await FirebaseFirestore.instance.collection('stafffeedback').add({
                    'staffId': FirebaseAuth.instance.currentUser?.uid,
                    'feedback': feedback,
                    'timestamp': FieldValue.serverTimestamp(),
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Feedback submitted successfully!")),
                  );
                  Navigator.pop(context);  // Go back to the previous screen (Staff Home)
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

class StaffDrawerHeader extends StatelessWidget {
  const StaffDrawerHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance
          .collection('staff')  // Assuming collection is 'staff' instead of 'user'
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }

        if (snapshot.hasError) {
          return const Text('Error fetching staff data');
        }

        if (!snapshot.hasData || snapshot.data == null) {
          return const Text('Staff not found');
        }

        final staffData = snapshot.data!.data() as Map<String, dynamic>;

        final name = staffData['name'] ?? 'Staff Name';
        final role = staffData['role'] ?? 'No role assigned';
        final profilePictureUrl = staffData['profilePicture'];

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: Colors.white,
              backgroundImage: profilePictureUrl != null
                  ? NetworkImage(profilePictureUrl)
                  : const AssetImage('assets/asset/default_profile.jpg') as ImageProvider,
            ),
            const SizedBox(height: 10),
            Text(
              "Welcome $name",
              style: const TextStyle(color: Colors.white, fontSize: 18),
            ),
            Text(
              "Role: $role",
              style: const TextStyle(color: Colors.white70, fontSize: 14),
            ),
          ],
        );
      },
    );
  }
}
