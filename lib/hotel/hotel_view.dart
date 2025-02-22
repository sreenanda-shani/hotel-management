import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ViewRoomPage extends StatefulWidget {
  const ViewRoomPage({super.key});

  @override
  _ViewRoomPageState createState() => _ViewRoomPageState();
}

class _ViewRoomPageState extends State<ViewRoomPage> {
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
        title: const Text("View Rooms"),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme:
            const IconThemeData(color: Colors.black), // Back arrow in black
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
              'id': doc.id, // Add the document ID
            };
          }).toList();

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Number of columns
                crossAxisSpacing: 10, // Space between columns
                mainAxisSpacing: 10, // Space between rows
                childAspectRatio: 1.5, // Adjusted for taller cards
              ),
              itemCount: roomsData.length,
              itemBuilder: (context, index) {
                final room = roomsData[index];
                final isAvailable = room['isAvailable'] as bool;

                return GestureDetector(
                  onTap: () {
                    _navigateToDetailsPage(room);
                  },
                  child: Card(
                    color: isAvailable
                        ? Colors.teal
                        : Colors.redAccent, // Background color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 5,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.hotel,
                            size: 40,
                            color: Colors.white, // Icon color
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "Room ${room['roomNumber']}",
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white, // Text color
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

void _navigateToDetailsPage(Map<String, dynamic> room) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RoomDetailsPage(room: room),
      ),
    );
  }
}

class RoomDetailsPage extends StatefulWidget {
  final Map<String, dynamic> room;

  const RoomDetailsPage({super.key, required this.room});

  @override
  State<RoomDetailsPage> createState() => _RoomDetailsPageState();
}

class _RoomDetailsPageState extends State<RoomDetailsPage> {
  Future<void> _removeRoom(String roomId) async {
    try {
      await FirebaseFirestore.instance.collection('rooms').doc(roomId).delete();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Room removed successfully!')),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error removing room')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Safe retrieval of room values
    final roomNumber = widget.room['roomNumber'] ?? 'N/A';
    final rent = widget.room['rent'] ?? 0;
    final totalRent = widget.room['totalRent'] ?? 0; // new field for total rent
    final maxPeople = widget.room['maxPeople'] ?? 0;
    final acType = widget.room['acType'] ?? 'N/A';
    final bedType = widget.room['bedType'] ?? 'N/A';
    final wifiAvailable = widget.room['wifiAvailable'] ?? false;
    final balconyAvailable = widget.room['balconyAvailable'] ?? false;
    final isAvailable = widget.room['isAvailable'] ?? false;
    final imageUrl = widget.room['imageUrl'] ?? '';

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Room Details",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (imageUrl != null && imageUrl.toString().isNotEmpty)
                Image.network(
                  imageUrl,
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height / 3,
                  fit: BoxFit.cover,
                ),
              const SizedBox(height: 30),
              Row(
                children: [
                  const Icon(Icons.meeting_room, size: 30, color: Colors.teal),
                  const SizedBox(width: 10),
                  Text(
                    "Room Number: $roomNumber",
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const Divider(height: 30, thickness: 1),
              _buildRoomDetail(Icons.attach_money, "Rent", "\$$rent"),
              _buildRoomDetail(Icons.money, "Total Rent",
                  "\$$totalRent"), // added total rent
              _buildRoomDetail(Icons.group, "Max People", "$maxPeople"),
              _buildRoomDetail(Icons.ac_unit, "AC Type", acType),
              _buildRoomDetail(Icons.bed, "Bed Type", bedType),
              _buildRoomDetail(Icons.wifi, "Wi-Fi",
                  wifiAvailable ? 'Available' : 'Not Available'),
              _buildRoomDetail(Icons.balcony, "Balcony",
                  balconyAvailable ? 'Available' : 'Not Available'),
              _buildRoomDetail(Icons.check_circle, "Availability",
                  isAvailable ? 'Available' : 'Not Available'),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(

builder: (context) =>
                                  UpdateRoomPage(roomData: widget.room)),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 12),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        backgroundColor: Colors.blue,
                      ),
                      icon: const Icon(Icons.edit, color: Colors.white),
                      label: const Text(
                        "Update",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        _removeRoom(widget.room['id'] ?? '');
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 12),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        backgroundColor: Colors.red,
                      ),
                      icon: const Icon(Icons.delete, color: Colors.white),
                      label: const Text(
                        "Delete",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // Go back
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 12),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    backgroundColor: Colors.teal,
                  ),
                  child: const Text(
                    "Back",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method to create a detailed row with icon, title, and value
  Widget _buildRoomDetail(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, size: 24, color: Colors.teal),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              "$title: $value",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  void _updateRoom(BuildContext context) {
    // Navigate to update room screen or trigger update logic
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          content: Text("Update room functionality not implemented yet")),
    );
  }

void _deleteRoom(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Confirm Delete"),
          content: const Text("Are you sure you want to delete this room?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                // Add logic to delete the room
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Room deleted successfully")),
                );
              },
              child: const Text("Delete", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
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
  late TextEditingController
      _totalRentController; // new controller for totalRent
  late TextEditingController _maxPeopleController;

  String _acType = 'AC';
  String _bedType = 'Double Bed';
  bool _wifiAvailable = true;
  bool _balconyAvailable = false;
  bool _isAvailable = true; // Added availability toggle

  @override
  void initState() {
    super.initState();
    _roomNumberController =
        TextEditingController(text: widget.roomData['roomNumber'].toString());
    _rentController =
        TextEditingController(text: widget.roomData['rent'].toString());
    _totalRentController = TextEditingController(
      text:
          (widget.roomData['totalRent'] ?? widget.roomData['rent']).toString(),
    );
    _maxPeopleController =
        TextEditingController(text: widget.roomData['maxPeople'].toString());
    _acType = widget.roomData['acType'];
    _bedType = widget.roomData['bedType'];
    _wifiAvailable = widget.roomData['wifiAvailable'];
    _balconyAvailable = widget.roomData['balconyAvailable'];
    _isAvailable = widget.roomData['isAvailable'];
  }

  Future<void> _updateRoomDetails() async {
    try {
      await FirebaseFirestore.instance
          .collection('rooms')
          .doc(widget.roomData['id'])
          .update({
        'roomNumber': int.tryParse(_roomNumberController.text) ?? 0,
        'rent': double.tryParse(_rentController.text) ?? 0.0,
        'totalRent': double.tryParse(_totalRentController.text) ??
            0.0, // update totalRent
        'maxPeople': int.tryParse(_maxPeopleController.text) ?? 0,
        'acType': _acType,
        'bedType': _bedType,
        'wifiAvailable': _wifiAvailable,
        'balconyAvailable': _balconyAvailable,
        'isAvailable': _isAvailable, // Store availability status
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Room details updated successfully!')),
      );
      Navigator.pop(context); // Go back to the previous screen
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error updating room details')),
      );
    }
  }

@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Update Room Details"),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(
            color: Colors.black), // Change back arrow to black
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
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
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
                          decoration:
                              const InputDecoration(labelText: 'Room Number'),
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
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
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
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Total Rent Field
              Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                color: Colors.transparent, // Set to transparent
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      const Icon(Icons.money, color: Colors.teal),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          controller: _totalRentController,
                          decoration:
                              const InputDecoration(labelText: 'Total Rent'),
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true),
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
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                color: Colors.transparent, // Set to transparent
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      const Icon(Icons.people, color: Colors.teal),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          controller:
                              _maxPeopleController, // Correct controller
                          decoration:
                              const InputDecoration(labelText: 'Max People'),
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
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
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
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
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
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
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
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
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
                  backgroundColor: Colors.white, // Set background to white
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
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