import 'dart:convert';

Future<void> makePredictionRequest({
  required int onsiterate,
  required int discount,
  required int maxoccupancy,
  required int airConditioning,
  required int tv,
  required int refrigerator,
  required int wifi,
}) async {
  const String apiUrl = 'http://127.0.0.1:5000/predict'; // Replace with your Flask API URL

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
