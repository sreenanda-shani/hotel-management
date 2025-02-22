import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class AiRecomentationScreen extends StatefulWidget {
  

  const AiRecomentationScreen({Key? key,}) : super(key: key);

  @override
  State<AiRecomentationScreen> createState() => _AiRecomentationScreenState();
}

class _AiRecomentationScreenState extends State<AiRecomentationScreen> {



 Map<String, dynamic>  ? response;

  bool isLoading = false;
  String? errorMessage;

  // Fetch and format data from Firebase
  Future<Map<String, dynamic>> fetchAndFormatData() async {
    final bookingSnapshot = await FirebaseFirestore.instance
        .collection('booking')
        .where('hotelId', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
        .get();
    final bookingData = bookingSnapshot.docs.map((doc) {
      return {
        "guests": doc["guests"],
        "rent": doc["rent"],
      };
    }).toList();

    final feedbackSnapshot = await FirebaseFirestore.instance
        .collection('hotelfeedbacks')
        .where('hotelId', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
        .get();
    final feedbackData = feedbackSnapshot.docs.map((doc) {
      return {
        "feedback": doc["feedback"],
        "ac": doc["ac"],
        "refrigerator": doc["refrigerator"],
        "roomRating": doc["roomRating"],
        "cleanliness": doc["acRating"],
        "hotelRating": doc["hotelRating"],
      };
    }).toList();

    return {
      "bookingData": bookingData,
      "feedbackData": feedbackData,
    };
  }

  // Post data to API and handle response
  Future<Map<String, dynamic>> postToApi(Map<String, dynamic> formattedData) async {
    final apiUrl = "https://a464-2409-4073-4e34-5df6-9573-50fa-3a05-d0f4.ngrok-free.app/get_improvement_suggestions";

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(formattedData),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception("Failed to post data: ${response.reasonPhrase}");
      }
    } catch (e) {
      throw Exception("Error posting data: $e");
    }
  }

  // Process data and handle API response
  void processAndDisplayData(BuildContext context) async {
    setState(() {
      isLoading = true; // Show loading indicator
      errorMessage = null; // Clear any previous error messages
    });

    try {
      final formattedData = await fetchAndFormatData();
      
     if(formattedData['bookingData'].isNotEmpty && formattedData['feedbackData'].isNotEmpty){
      
      final apiResponse = await postToApi(formattedData);

     
     response = apiResponse;
     }else{

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('No booking')));
     }
    } catch (e) {
      setState(() {
        errorMessage = e.toString(); // Set the error message
      });
    } finally {
      setState(() {
        isLoading = false; // Hide loading indicator
      });
    }
  }

 @override
Widget build(BuildContext context) {
  var improvementSuggestions = response != null 
      ? response!["general_improvement"] as List<dynamic>? 
      : null;

  return Scaffold(
    appBar: AppBar(
      title: const Text("API Response"),
      backgroundColor: Colors.blueAccent,
    ),
    body: isLoading 
      ? Center(child: CircularProgressIndicator())
      : improvementSuggestions != null && improvementSuggestions.isNotEmpty 
        ? Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView.builder(
              itemCount: improvementSuggestions.length,
              itemBuilder: (context, index) {
                final suggestion = improvementSuggestions[index];

                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    leading: const Icon(
                      Icons.lightbulb,
                      color: Colors.blueAccent,
                      size: 30,
                    ),
                    title: Text(
                      suggestion,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                );
              },
            ),
          )
        : Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(child: Text('No improvement suggestions available')),
          ),
  );
}
}