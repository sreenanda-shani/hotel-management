import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ViewRoomPage extends StatefulWidget {
  const ViewRoomPage({super.key});

  @override
  _ViewRoomPageState createState() => _ViewRoomPageState();
}

class _ViewRoomPageState extends State<ViewRoomPage> {

  Future<void> _removeRoom(String roomId) async {
    try {
      await FirebaseFirestore.instance.collection('rooms').doc(roomId).delete();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Room removed successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error removing room')),
      );
    }
  }

  void _navigateToUpdatePage(Map<String, dynamic> roomData) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UpdateRoomPage(roomData: roomData),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("View Room Details"),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black), // Change back arrow to black
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('rooms')
            .where('hotelId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Error fetching room details'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No rooms found'));
          }

          var roomsData = snapshot.data!.docs.map((doc) {
            return {
              ...doc.data() as Map<String, dynamic>,
              'id': doc.id,  // Add the document ID
            };
          }).toList();

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  for (var room in roomsData)
                    Card(
                      elevation: 10,
                      shadowColor: Colors.black.withOpacity(0.1),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      color: Colors.transparent, // Set the background to transparent
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Image display
                            room['imageUrl'] != null
                                ? Image.network(room['imageUrl'], width: double.infinity, height: 200, fit: BoxFit.cover)
                                : Container(
                                    width: double.infinity,
                                    height: 200,
                                    color: Colors.grey.shade300,
                                    child: const Icon(Icons.image, color: Colors.white),
                                  ),

                            const SizedBox(height: 8),

                            Text(
                              "Room Number: ${room['roomNumber']}",
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.black, // Set text color to black
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "Rent: \$${room['rent']}",
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                                color: Colors.black, // Set text color to black
                              ),
                            ),
                            Text(
                              "Max People: ${room['maxPeople']}",
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                                color: Colors.black, // Set text color to black
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "AC Type: ${room['acType']}",
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                                color: Colors.black, // Set text color to black
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "Bed Type: ${room['bedType']}",
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                                color: Colors.black, // Set text color to black
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "Wi-Fi Available: ${room['wifiAvailable'] ? 'Yes' : 'No'}",
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                                color: Colors.black, // Set text color to black
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "Balcony Available: ${room['balconyAvailable'] ? 'Yes' : 'No'}",
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                                color: Colors.black, // Set text color to black
                              ),
                            ),
                            const SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ElevatedButton.icon(
                                  onPressed: () => _navigateToUpdatePage(room),
                                  icon: const Icon(Icons.edit, color: Colors.black), // Change icon color to black
                                  label: const Text("Update", style: TextStyle(color: Colors.black)), // Change text color to black
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white, // Set button color to white
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                                  ),
                                ),
                                ElevatedButton.icon(
                                  onPressed: () => _removeRoom(room['id']),
                                  icon: const Icon(Icons.delete, color: Colors.black), // Change icon color to black
                                  label: const Text("Remove", style: TextStyle(color: Colors.black)), // Change text color to black
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white, // Set button color to white
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class UpdateRoomPage extends StatefulWidget {
  final Map<String, dynamic> roomData;

  const UpdateRoomPage({super.key, required this.roomData});

  @override
  _UpdateRoomPageState createState() => _UpdateRoomPageState();
}

class _UpdateRoomPageState extends State<UpdateRoomPage> {
  late TextEditingController _roomNumberController;
  late TextEditingController _rentController;
  late TextEditingController _maxPeopleController;

  String _acType = 'AC';
  String _bedType = 'Double Bed';
  bool _wifiAvailable = true;
  bool _balconyAvailable = false;
  bool _isAvailable = true; // Added availability toggle

  @override
  void initState() {
    super.initState();
    _roomNumberController = TextEditingController(text: widget.roomData['roomNumber'].toString());
    _rentController = TextEditingController(text: widget.roomData['rent'].toString());
    _maxPeopleController = TextEditingController(text: widget.roomData['maxPeople'].toString()); // Correct controller for maxPeople
    _acType = widget.roomData['acType'];
    _bedType = widget.roomData['bedType'];
    _wifiAvailable = widget.roomData['wifiAvailable'];
    _balconyAvailable = widget.roomData['balconyAvailable'];
    _isAvailable = widget.roomData['isAvailable']; // Initialize availability from Firestore
  }

  Future<void> _updateRoomDetails() async {
    try {
      await FirebaseFirestore.instance.collection('rooms').doc(widget.roomData['id']).update({
        'roomNumber': int.tryParse(_roomNumberController.text) ?? 0,
        'rent': double.tryParse(_rentController.text) ?? 0.0,
        'maxPeople' :  int.tryParse(_maxPeopleController.text) ?? 0,
        'acType': _acType,
        'bedType': _bedType,
        'wifiAvailable': _wifiAvailable,
        'balconyAvailable': _balconyAvailable,
        'isAvailable': _isAvailable, // Store availability status
      });

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Room details updated successfully!')));
      Navigator.pop(context); // Go back to the previous screen
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Error updating room details')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Update Room Details"),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black), // Change back arrow to black
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Room Number Field
              Card(
                elevation: 5,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                color: Colors.transparent, // Set to transparent
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      const Icon(Icons.room, color: Colors.teal),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          controller: _roomNumberController,
                          decoration: const InputDecoration(labelText: 'Room Number'),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Rent Field
              Card(
                elevation: 5,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                color: Colors.transparent, // Set to transparent
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      const Icon(Icons.money, color: Colors.teal),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          controller: _rentController,
                          decoration: const InputDecoration(labelText: 'Rent'),
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Max People Field
              Card(
                elevation: 5,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                color: Colors.transparent, // Set to transparent
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      const Icon(Icons.people, color: Colors.teal),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          controller: _maxPeopleController,  // Correct controller
                          decoration: const InputDecoration(labelText: 'Max People'),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // AC Type Field
              Card(
                elevation: 5,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                color: Colors.transparent, // Set to transparent
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      const Icon(Icons.ac_unit, color: Colors.teal),
                      const SizedBox(width: 10),
                      Expanded(
                        child: DropdownButton<String>(
                          value: _acType,
                          items: ['AC', 'Non-AC']
                              .map((ac) => DropdownMenuItem(
                                    value: ac,
                                    child: Text(ac),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              _acType = value!;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Bed Type Field
              Card(
                elevation: 5,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                color: Colors.transparent, // Set to transparent
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      const Icon(Icons.bed, color: Colors.teal),
                      const SizedBox(width: 10),
                      Expanded(
                        child: DropdownButton<String>(
                          value: _bedType,
                          items: ['Single Bed', 'Double Bed']
                              .map((bed) => DropdownMenuItem(
                                    value: bed,
                                    child: Text(bed),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              _bedType = value!;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Wi-Fi Switch
              Card(
                elevation: 5,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                color: Colors.transparent, // Set to transparent
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      const Icon(Icons.wifi, color: Colors.teal),
                      const SizedBox(width: 10),
                      Expanded(
                        child: SwitchListTile(
                          title: const Text('Wi-Fi Available'),
                          value: _wifiAvailable,
                          onChanged: (value) {
                            setState(() {
                              _wifiAvailable = value;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Balcony Switch
              Card(
                elevation: 5,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                color: Colors.transparent, // Set to transparent
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      const Icon(Icons.balcony, color: Colors.teal),
                      const SizedBox(width: 10),
                      Expanded(
                        child: SwitchListTile(
                          title: const Text('Balcony Available'),
                          value: _balconyAvailable,
                          onChanged: (value) {
                            setState(() {
                              _balconyAvailable = value;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // Update Room Button
              ElevatedButton(
                onPressed: _updateRoomDetails,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,  // Set background to white
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                ),
                child: const Text('Update Room Details'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
