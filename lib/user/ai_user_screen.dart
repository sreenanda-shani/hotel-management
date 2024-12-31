import 'package:flutter/material.dart';

class RoomFeaturesScreen extends StatefulWidget {
  @override
  _RoomFeaturesScreenState createState() => _RoomFeaturesScreenState();
}

class _RoomFeaturesScreenState extends State<RoomFeaturesScreen> {
  // Variables to hold selected values
  int? selectedMaxPeople;
  int? selectedWiFi;
  int? selectedRefrigerator;
  int? selectedDiscount;
  int? selectedAC;
  String? selectedRoomType;

  final List<String> roomTypes = [
    'Double Room',
    'Twin Room',
    'Single Room',
    'Standard Double Room',
    'Triple Room',
    'Superior Double Room',
    'Family Room',
    'Junior Suite',
    'Standard Twin Room',
    'Double or Twin Room',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Room Features"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Max People:",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            DropdownButton<int>(
              value: selectedMaxPeople,
              isExpanded: true,
              hint: const Text("Select max people"),
              items: List.generate(10, (index) => index + 1).map((value) {
                return DropdownMenuItem<int>(
                  value: value,
                  child: Text(value.toString()),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedMaxPeople = value;
                });
              },
            ),
            const SizedBox(height: 16),
            const Text(
              "WiFi Available:",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            DropdownButton<bool>(
              value: selectedWiFi,
              isExpanded: true,
              hint: const Text("Select WiFi availability"),
              items: const [
                DropdownMenuItem<bool>(
                  value: true,
                  child: Text("Yes"),
                ),
                DropdownMenuItem<bool>(
                  value: false,
                  child: Text("No"),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  selectedWiFi = value;
                });
              },
            ),
            const SizedBox(height: 16),
            const Text(
              "Refrigerator Available:",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            DropdownButton<bool>(
              value: selectedRefrigerator,
              isExpanded: true,
              hint: const Text("Select refrigerator availability"),
              items: const [
                DropdownMenuItem<bool>(
                  value: true,
                  child: Text("Yes"),
                ),
                DropdownMenuItem<bool>(
                  value: false,
                  child: Text("No"),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  selectedRefrigerator = value;
                });
              },
            ),
            const SizedBox(height: 16),
            const Text(
              "Discount:",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            DropdownButton<int>(
              value: selectedDiscount,
              isExpanded: true,
              hint: const Text("Select discount (%)"),
              items: [0, 10, 20, 30, 40, 50].map((value) {
                return DropdownMenuItem<int>(
                  value: value,
                  child: Text("$value%"),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedDiscount = value;
                });
              },
            ),
            const SizedBox(height: 16),
            const Text(
              "AC Available:",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            DropdownButton<bool>(
              value: selectedAC,
              isExpanded: true,
              hint: const Text("Select AC availability"),
              items: const [
                DropdownMenuItem<bool>(
                  value: true,
                  child: Text("Yes"),
                ),
                DropdownMenuItem<bool>(
                  value: false,
                  child: Text("No"),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  selectedAC = value;
                });
              },
            ),
            const SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Save the selected options
                  if (selectedMaxPeople != null &&
                      selectedWiFi != null &&
                      selectedRefrigerator != null &&
                      selectedDiscount != null &&
                      selectedAC != null) {
                    // Logic to save data
                    final roomFeatures = {
                      "maxPeople": selectedMaxPeople,
                      "wifi": selectedWiFi,
                      "refrigerator": selectedRefrigerator,
                      "discount": selectedDiscount,
                      "ac": selectedAC,
                    };
                    // Handle save action (e.g., send to database)
                    print("Room Features Saved: $roomFeatures");
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Room features saved successfully!"),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Please fill all fields before saving."),
                      ),
                    );
                  }
                },
                child: const Text("Save"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
