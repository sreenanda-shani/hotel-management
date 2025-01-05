import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Fetchfeedbacks extends StatefulWidget {
  const Fetchfeedbacks({super.key});

  @override
  State<Fetchfeedbacks> createState() => _FetchfeedbacksState();
}

class _FetchfeedbacksState extends State<Fetchfeedbacks> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hotel Feedbacks'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('hotelfeedbacks') // Firestore collection name
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final feedbacks = snapshot.data!.docs;
          List<Widget> feedbackWidgets = [];

          for (var feedback in feedbacks) {
            try {
              // Using null-aware operators to handle potential null values
              final ac = feedback['ac'] is bool ? feedback['ac'] : false;
              final acRating = feedback['acRating'] ?? 'Not Available';
              final feedbackText = feedback['feedback'] ?? 'No feedback provided';
              final hotelId = feedback['hotelId'] ?? 'Unknown';
              final hotelName = feedback['hotelName'] ?? 'Unknown Hotel';
              final hotelRating = feedback['hotelRating'] ?? 'Not Rated';
              final refrigerator = feedback['refrigerator'] is bool ? feedback['refrigerator'] : false;
              final refrigeratorRating = feedback['refrigeratorRating'] ?? 'Not Rated';
              final roomRating = feedback['roomRating'] ?? 'Not Rated';
              final timestamp = feedback['timestamp'];
              final tv = feedback['tv'] is bool ? feedback['tv'] : false;
              final tvRating = feedback['tvRating'] ?? 'Not Rated';
              final userId = feedback['userId'] ?? 'Unknown';

              // Format timestamp, check if it's null first
              String formattedTime = timestamp != null
                  ? DateFormat('yyyy-MM-dd HH:mm').format((timestamp as Timestamp).toDate())
                  : 'Unknown time';

              // Add feedback widget to the list
              feedbackWidgets.add(
                Card(
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    leading: const Icon(
                      Icons.feedback,
                      color: Colors.blue,
                      size: 40,
                    ),
                    title: Text(
                      hotelName, // Hotel name is guaranteed to be non-null
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Hotel Rating: $hotelRating'),
                        Text('Room Rating: $roomRating'),
                        Text('AC Rating: $acRating'),
                        Text('Refrigerator Rating: $refrigeratorRating'),
                        Text('TV Rating: $tvRating'),
                        const SizedBox(height: 8),
                        Text('Feedback: $feedbackText'),
                        const SizedBox(height: 8),
                        Text('Feedback Date: $formattedTime'),
                      ],
                    ),
                  ),
                ),
              );
            } catch (e) {
              print("Error processing feedback: $e");
            }
          }

          if (feedbackWidgets.isEmpty) {
            return const Center(child: Text('No feedbacks available.'));
          }

          return ListView(
            children: feedbackWidgets,
          );
        },
      ),
    );
  }
}
