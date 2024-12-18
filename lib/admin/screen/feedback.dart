import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AdminFeedback extends StatefulWidget {
  const AdminFeedback({super.key});

  @override
  _AdminFeedbackState createState() => _AdminFeedbackState();
}

class _AdminFeedbackState extends State<AdminFeedback> {
  final List<Map<String, dynamic>> _feedbacks = []; // Local list to store feedbacks

  // Fetch feedback data from Firestore
  void fetchFeedbacks() async {
    try {
      // Get all feedbacks ordered by timestamp
      QuerySnapshot feedbackSnapshot = await FirebaseFirestore.instance
          .collection('feedbacks') // The Firestore collection where feedbacks are stored
          .orderBy('timestamp', descending: true) // Order feedbacks by timestamp
          .get();

      // Loop through each feedback and fetch the user name using the userId (uid)
      for (var feedbackDoc in feedbackSnapshot.docs) {
        Map<String, dynamic> feedbackData = feedbackDoc.data() as Map<String, dynamic>;

        // Fetch user information using the uid from the feedback
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('user') // The collection where user info is stored
            .doc(feedbackData['userId']) // Get user by the userId stored in feedback
            .get();

        // Get the user's name
        String userName = userDoc['name'] ?? 'Unknown User';

        // Store feedback along with the user name
        _feedbacks.add({
          'userName': userName,
          'feedback': feedbackData['feedback'], // Feedback text
          'timestamp': feedbackData['timestamp'], // Timestamp of feedback
        });
      }

      // Update the UI with the fetched feedbacks
      setState(() {});
    } catch (e) {
      print('Error fetching feedbacks: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to fetch feedbacks')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    fetchFeedbacks(); // Fetch feedbacks when the screen is loaded
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('User Feedbacks')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _feedbacks.isEmpty
            ? const Center(child: Text('No feedbacks available.'))
            : ListView.builder(
                itemCount: _feedbacks.length,
                itemBuilder: (context, index) {
                  final feedback = _feedbacks[index];
                  final userName = feedback['userName'];
                  final feedbackMessage = feedback['feedback'];
                  final timestamp = feedback['timestamp'];

                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      title: Text(userName), // Displaying the user's name
                      subtitle: Text(feedbackMessage), // Displaying the feedback message
                      trailing: Text(
                        timestamp != null
                            ? (timestamp as Timestamp).toDate().toString() // Convert Timestamp to DateTime
                            : 'Unknown time',
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
