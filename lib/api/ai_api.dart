import 'dart:convert';
import 'package:http/http.dart' as http;

Future<void> makePredictionRequest({
  required int onsiterate,
  required int discount,
  required int maxoccupancy,
  required int airConditioning,
  required int tv,
  required int refrigerator,
  required int wifi,
}) async {
  const String apiUrl = 'https://4da4-2409-4073-10f-23c9-9bfd-990e-3630-ce6a.ngrok-free.app/predict'; // Replace with your Flask API URL

  // Input data
  Map<String, dynamic> inputData = {
    "onsiterate": onsiterate,
    "discount": discount,
    "maxoccupancy": maxoccupancy,
    "Air conditioning:": airConditioning,
    "TV:": tv,
    "Refrigerator:": refrigerator,
    "Wi-Fi [free]:": wifi,
  };

  try {
    // Create the POST request
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(inputData), // Convert the input data to JSON format
    );

    // Handle the response
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print('Predictions: ${data['predictions']}');
    } else {
      print('Failed to get predictions. Status Code: ${response.statusCode}');
      print('Error: ${response.body}');
    }
  } catch (e) {
    print('An error occurred: $e');
  }
}
