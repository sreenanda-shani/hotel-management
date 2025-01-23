import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HotelFeedback extends StatefulWidget {
  final String hotelId; // Assuming you have a way to pass the hotel ID
  final String hotelName; // Assuming the hotel name is passed

  const HotelFeedback({
    super.key,
    required this.hotelId,
    required this.hotelName,
  });

  @override
  _HotelFeedbackState createState() => _HotelFeedbackState();
}

class _HotelFeedbackState extends State<HotelFeedback> {
  final TextEditingController feedbackController = TextEditingController();
  String hotelRating = "Excellent";
  String roomRating = "Excellent";
  bool refrigerator = false;
  bool tv = false;
  bool ac = false;
  String refrigeratorRating = "Excellent";
  String tvRating = "Excellent";
  String acRating = "Excellent";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Hotel Feedback", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            // Hotel Name displayed (default value)
            Text(
              "Hotel: ${widget.hotelName}",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.teal),
            ),
            const SizedBox(height: 20),

            // Hotel Rating (Excellent, Good, Average, etc.)
            const Text(
              "Rate the Hotel:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            _buildRatingSelector(
              value: hotelRating,
              onChanged: (value) {
                setState(() {
                  hotelRating = value!;
                });
              },
            ),
            const SizedBox(height: 20),

            // Room Rating (Excellent, Good, Average, etc.)
            const Text(
              "Rate the Room:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            _buildRatingSelector(
              value: roomRating,
              onChanged: (value) {
                setState(() {
                  roomRating = value!;
                });
              },
            ),
            const SizedBox(height: 20),

            // Feedback text input
            TextField(
              controller: feedbackController,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: "Enter your feedback here...",
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: const EdgeInsets.all(16),
                prefixIcon: Icon(Icons.feedback, color: Colors.teal),
              ),
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),

            // Amenities checkboxes and corresponding radio buttons
            const Text(
              "Select amenities available in the room:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            // Checkboxes for amenities
            _buildAmenityCheckbox("Refrigerator", refrigerator, (value) {
              setState(() {
                refrigerator = value!;
              });
            }),
            _buildAmenityCheckbox("TV", tv, (value) {
              setState(() {
                tv = value!;
              });
            }),
            _buildAmenityCheckbox("AC", ac, (value) {
              setState(() {
                ac = value!;
              });
            }),

            const SizedBox(height: 20),

            // Display ratings for selected amenities
            if (refrigerator) _buildAmenityRatingSelector("Refrigerator", refrigeratorRating, (value) {
              setState(() {
                refrigeratorRating = value!;
              });
            }),
            if (tv) _buildAmenityRatingSelector("TV", tvRating, (value) {
              setState(() {
                tvRating = value!;
              });
            }),
            if (ac) _buildAmenityRatingSelector("AC", acRating, (value) {
              setState(() {
                acRating = value!;
              });
            }),

            const SizedBox(height: 30),

            // Submit button aligned to the right
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    String feedback = feedbackController.text.trim();
                    if (feedback.isNotEmpty) {
                      try {
                        await FirebaseFirestore.instance.collection('hotelfeedbacks').add({
                          'userId': FirebaseAuth.instance.currentUser?.uid,
                          'hotelId': widget.hotelId,
                          'hotelName': widget.hotelName,
                          'hotelRating': hotelRating,
                          'roomRating': roomRating,
                          'feedback': feedback,
                          'refrigerator': refrigerator,
                          'refrigeratorRating': refrigeratorRating,
                          'tv': tv,
                          'tvRating': tvRating,
                          'ac': ac,
                          'acRating': acRating,
                          'timestamp': FieldValue.serverTimestamp(),
                        });

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Feedback submitted successfully!")),
                        );
                        Navigator.pop(context);  // Go back to the previous page (BookingHistoryPage)
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Failed to submit feedback. Please try again.")),
                        );
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Please fill in all the fields")),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text(
                    "Submit Feedback",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Cancel button to go back
            Center(
              child: TextButton(
                onPressed: () {
                  Navigator.pop(context);  // Go back to the previous page
                },
                child: const Text(
                  "Cancel",
                  style: TextStyle(color: Colors.deepPurpleAccent, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Method to build the rating selector
  Widget _buildRatingSelector({required String value, required ValueChanged<String?> onChanged}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _buildRatingOption("Excellent", value, onChanged),
            _buildRatingOption("Good", value, onChanged),
            _buildRatingOption("Average", value, onChanged),
          ],
        ),
        const SizedBox(height: 10),  // Space between rows
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _buildRatingOption("Below Average", value, onChanged),
            _buildRatingOption("Bad", value, onChanged),
          ],
        ),
      ],
    );
  }

  // Method to build individual rating option
  Widget _buildRatingOption(String label, String value, ValueChanged<String?> onChanged) {
    return Row(
      children: [
        Radio<String>(
          value: label,
          groupValue: value,
          onChanged: onChanged,
        ),
        Text(label),
      ],
    );
  }

  // Method to build the amenity checkbox
  Widget _buildAmenityCheckbox(String amenity, bool isSelected, ValueChanged<bool?> onChanged) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Checkbox(
          value: isSelected,
          onChanged: onChanged,
        ),
        Text(amenity),
      ],
    );
  }

  // Method to build the amenity rating selector (Excellent, Good, etc.)
  Widget _buildAmenityRatingSelector(String amenity, String rating, ValueChanged<String?> onChanged) {
    return Column(
      children: [
        const SizedBox(height: 10),
        Text(
          "Rate the $amenity:",
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _buildRatingOption("Excellent", rating, onChanged),
            _buildRatingOption("Good", rating, onChanged),
            _buildRatingOption("Average", rating, onChanged),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _buildRatingOption("Below Average", rating, onChanged),
            _buildRatingOption("Bad", rating, onChanged),
          ],
        ),
      ],
    );
  }
}
