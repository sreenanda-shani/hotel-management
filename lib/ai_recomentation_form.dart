import 'package:flutter/material.dart';
import 'package:project1/api/ai_api.dart';

class PredictionScreen extends StatefulWidget {
  @override
  _PredictionScreenState createState() => _PredictionScreenState();
}

class _PredictionScreenState extends State<PredictionScreen> {
  // Controllers and initial values
  final TextEditingController onsiterateController = TextEditingController();
  final TextEditingController discountController = TextEditingController();
  final TextEditingController maxoccupancyController = TextEditingController();
  int airConditioning = 0;
  int tv = 0;
  int refrigerator = 0;
  int wifi = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hotel Prediction'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Input fields for numerical data
            _buildInputField(onsiterateController, 'Onsiterate'),
            _buildInputField(discountController, 'Discount'),
            _buildInputField(maxoccupancyController, 'Max Occupancy'),

            // Dropdowns for boolean values
            _buildDropdown('Air Conditioning', (value) {
              setState(() {
                airConditioning = value!;
              });
            }, airConditioning),
            _buildDropdown('TV', (value) {
              setState(() {
                tv = value!;
              });
            }, tv),
            _buildDropdown('Refrigerator', (value) {
              setState(() {
                refrigerator = value!;
              });
            }, refrigerator),
            _buildDropdown('Wi-Fi [free]', (value) {
              setState(() {
                wifi = value!;
              });
            }, wifi),

            // Submit Button
            ElevatedButton(
              onPressed: () {
                // Get input values
                final onsiterate = int.tryParse(onsiterateController.text) ?? 0;
                final discount = int.tryParse(discountController.text) ?? 0;
                final maxoccupancy = int.tryParse(maxoccupancyController.text) ?? 0;

                // Call the prediction API
                makePredictionRequest(
                  onsiterate: onsiterate,
                  discount: discount,
                  maxoccupancy: maxoccupancy,
                  airConditioning: airConditioning,
                  tv: tv,
                  refrigerator: refrigerator,
                  wifi: wifi,
                );
              },
              child: Text('Get Prediction'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal, // Set button color
                padding: EdgeInsets.symmetric(vertical: 16.0),
                textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to build input fields
  Widget _buildInputField(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
          filled: true,
          fillColor: Colors.grey[200],
        ),
      ),
    );
  }

  // Helper method to build dropdowns for boolean values
  Widget _buildDropdown(String label, ValueChanged<int?> onChanged, int value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<int>(
        value: value,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
          filled: true,
          fillColor: Colors.grey[200],
        ),
        items: [
          DropdownMenuItem(
            value: 0,
            child: Text('False'),
          ),
          DropdownMenuItem(
            value: 1,
            child: Text('True'),
          ),
        ],
        onChanged: onChanged,
      ),
    );
  }
}