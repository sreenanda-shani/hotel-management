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
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade50, Colors.blueAccent.shade100],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ListView(
                  children: [
                    _buildFeatureCard(
                      title: "Room Type",
                      child: DropdownButton<String>(
                        value: selectedRoomType,
                        isExpanded: true,
                        hint: const Text("Select room type"),
                        items: roomTypes.map((type) {
                          return DropdownMenuItem<String>(
                            value: type,
                            child: Text(type),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedRoomType = value;
                          });
                        },
                      ),
                    ),
                    _buildFeatureCard(
                      title: "Max People",
                      child: DropdownButton<int>(
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
                    ),
                    _buildFeatureCard(
                      title: "WiFi Available",
                      child: DropdownButton<int>(
                        value: selectedWiFi,
                        isExpanded: true,
                        hint: const Text("Select WiFi availability"),
                        items: const [
                          DropdownMenuItem<int>(
                            value: 1,
                            child: Text("Yes"),
                          ),
                          DropdownMenuItem<int>(
                            value: 0,
                            child: Text("No"),
                          ),
                        ],
                        onChanged: (value) {
                          setState(() {
                            selectedWiFi = value;
                          });
                        },
                      ),
                    ),
                    _buildFeatureCard(
                      title: "Refrigerator Available",
                      child: DropdownButton<int>(
                        value: selectedRefrigerator,
                        isExpanded: true,
                        hint: const Text("Select refrigerator availability"),
                        items: const [
                          DropdownMenuItem<int>(
                            value: 1,
                            child: Text("Yes"),
                          ),
                          DropdownMenuItem<int>(
                            value: 0,
                            child: Text("No"),
                          ),
                        ],
                        onChanged: (value) {
                          setState(() {
                            selectedRefrigerator = value;
                          });
                        },
                      ),
                    ),
                    _buildFeatureCard(
                      title: "Discount",
                      child: DropdownButton<int>(
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
                    ),
                    _buildFeatureCard(
                      title: "AC Available",
                      child: DropdownButton<int>(
                        value: selectedAC,
                        isExpanded: true,
                        hint: const Text("Select AC availability"),
                        items: const [
                          DropdownMenuItem<int>(
                            value: 1,
                            child: Text("Yes"),
                          ),
                          DropdownMenuItem<int>(
                            value: 0,
                            child: Text("No"),
                          ),
                        ],
                        onChanged: (value) {
                          setState(() {
                            selectedAC = value;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (selectedMaxPeople != null &&
                        selectedWiFi != null &&
                        selectedRefrigerator != null &&
                        selectedDiscount != null &&
                        selectedAC != null &&
                        selectedRoomType != null) {
                      final roomFeatures = {
                        "roomType": selectedRoomType,
                        "maxPeople": selectedMaxPeople,
                        "wifi": selectedWiFi,
                        "refrigerator": selectedRefrigerator,
                        "discount": selectedDiscount,
                        "ac": selectedAC,
                      };
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
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 12,
                    ),
                  ),
                  child: const Text(
                    "Save",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureCard({required String title, required Widget child}) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            child,
          ],
        ),
      ),
    );
  }
}
