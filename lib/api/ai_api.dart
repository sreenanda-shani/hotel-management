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
  const String apiUrl = 'https://a464-2409-4073-4e34-5df6-9573-50fa-3a05-d0f4.ngrok-free.app/predict'; // Replace with your Flask API URL

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
    print("rESPONSE STAUS CODE");
    // Handle the response
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
       print("rESPONSE STAUS CODE ${response.statusCode}");
      print('Predictions: ${data['predictions']}');
      return data['predictions'].first;
    } else {
      print('Failed to get predictions. Status Code: ${response.statusCode}');
      print('Error: ${response.body}');
      print("rESPONSE STAUS CODE");
      throw Exception(response.body);
    }
  } catch (e) {

    rethrow;
  }
}
