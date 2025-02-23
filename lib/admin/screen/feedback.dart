import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AdminFeedback extends StatefulWidget {
  const AdminFeedback({super.key});

  @override
  _AdminFeedbackState createState() => _AdminFeedbackState();
}

class _AdminFeedbackState extends State<AdminFeedback> {
  final List<Map<String, dynamic>> _feedbacks = []; // Local list to store feedbacks
  bool _isLoading = true; // Add a loading state to track data fetching

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
            .collection('users') // The collection where user info is stored
            .doc(feedbackData['userId']) // Get user by the userId stored in feedback
            .get();

        // Get the user's name (if available)
        String userName = userDoc.exists ? userDoc['name'] ?? 'Unknown User' : 'Unknown User';

        // Add feedback along with the user name and timestamp
        _feedbacks.add({
          'userName': userName,
          'feedback': feedbackData['feedback'], // Feedback text
          'timestamp': feedbackData['timestamp'], // Timestamp of feedback
        });
      }

      // Update the UI with the fetched feedbacks
      setState(() {
        _isLoading = false; // Set loading to false once data is fetched
      });
    } catch (e) {
      print('Error fetching feedbacks: $e');
      setState(() {
        _isLoading = false; // Stop loading even if there is an error
      });
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
      appBar: AppBar(
        title: const Text(
          'User feedbacks',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.teal,
        elevation: 4,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _isLoading // Check the loading state
            ? const Center(child: CircularProgressIndicator()) // Show loading spinner if data is being fetched
            : _feedbacks.isEmpty
                ? const Center(child: Text('No feedbacks available.'))
                : ListView.builder(
                    itemCount: _feedbacks.length,
                    itemBuilder: (context, index) {
                      final feedback = _feedbacks[index];
                      final userName = feedback['userName'];
                      final feedbackMessage = feedback['feedback'];
                      final timestamp = feedback['timestamp'];

                      // Convert Firestore Timestamp to DateTime
                      String formattedTime = timestamp != null
                          ? (timestamp as Timestamp).toDate().toLocal().toString() // Format timestamp to local time
                          : 'Unknown time';

                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        child: ListTile(
                          title: Text(userName), // Displaying the user's name
                          subtitle: Text(feedbackMessage), // Displaying the feedback message
                          trailing: Text(
                            formattedTime, // Displaying formatted timestamp
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
