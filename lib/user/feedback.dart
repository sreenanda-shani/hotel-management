import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FeedbackPage extends StatelessWidget {
  const FeedbackPage({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController feedbackController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Feedback"),
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
                  await FirebaseFirestore.instance.collection('feedbacks').add({
                    'userId': FirebaseAuth.instance.currentUser?.uid,
                    'feedback': feedback,
                    'timestamp': FieldValue.serverTimestamp(),
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Feedback submitted successfully!")),
                  );
                  Navigator.pop(context);  // Go back to HomePage
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

class UserDrawerHeader extends StatelessWidget {
  const UserDrawerHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance
          .collection('user')
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }

        if (snapshot.hasError) {
          return const Text('Error fetching user data');
        }

        if (!snapshot.hasData || snapshot.data == null) {
          return const Text('User not found');
        }

        final userData = snapshot.data!.data() as Map<String, dynamic>;

        final name = userData['name'] ?? 'User Name';
        final email = userData['email'] ?? 'No email';
        final profilePictureUrl = userData['profilePicture'];

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
              email,
              style: const TextStyle(color: Colors.white70, fontSize: 14),
            ),
          ],
        );
      },
    );
  }
}
