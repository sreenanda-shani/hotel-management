import 'dart:convert';
import 'package:http/http.dart' as http;

Future<String> makePredictionRequest({
  required int onsiterate,
  required int discount,
  required int maxoccupancy,
  required int airConditioning,
  required int tv,
  required int refrigerator,
  required int wifi,
}) async {
  const String apiUrl = 'https://c957-2409-4073-4d9b-66a8-1451-4921-dc07-942c.ngrok-free.app/predict'; // Replace with your Flask API URL

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
      return data['predictions'].first;
    } else {
      print('Failed to get predictions. Status Code: ${response.statusCode}');
      print('Error: ${response.body}');

      throw Exception(response.body);
    }
  } catch (e) {

    rethrow;
    print('An error occurred: $e');
  }
}
