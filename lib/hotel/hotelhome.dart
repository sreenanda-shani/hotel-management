import 'package:flutter/material.dart';
import 'package:project1/hotel/hotel_booking.dart';
import 'package:project1/hotel/hotel_rooms.dart';
import 'package:project1/hotel/hotel_view.dart';
import 'package:project1/hotel/hotelcontact.dart';
import 'package:project1/hotel/hotelmanage.dart';


class HotelHome extends StatefulWidget {
  const HotelHome({super.key});

  @override
  State<HotelHome> createState() => _HotelHomeState();
}

class _HotelHomeState extends State<HotelHome> {
  String welcomeMessage = "Welcome to Our Hotel!";

  // Edit Welcome Message method
  void editWelcomeMessage() {
    TextEditingController controller = TextEditingController(text: welcomeMessage);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Edit Welcome Message", style: TextStyle(fontWeight: FontWeight.bold)),
          content: TextField(
            controller: controller,
            maxLines: 2,
            decoration: const InputDecoration(
              hintText: "Enter a welcome message",
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  welcomeMessage = controller.text;
                });
                Navigator.of(context).pop();
              },
              child: const Text("Save", style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancel", style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Hotel Management"),
        backgroundColor: Colors.teal,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            // Welcome Message Section
            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              color: Colors.teal[50],
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Welcome Message:",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            welcomeMessage,
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: editWelcomeMessage,
                          color: Colors.teal,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),

            // Buttons Section for Navigation
            Column(
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const HotelContactPage()),
                    );
                  },
                  icon: const Icon(Icons.contact_phone),
                  label: const Text("Contact Details"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    minimumSize: const Size(double.infinity, 60),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    textStyle: const TextStyle(fontSize: 18),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const HotelBookingsPage()),
                    );
                  },
                  icon: const Icon(Icons.book),
                  label: const Text("View Bookings"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    minimumSize: const Size(double.infinity, 60),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    textStyle: const TextStyle(fontSize: 18),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ManageHotelDetailsPage()),
                    );
                  },
                  icon: const Icon(Icons.manage_accounts),
                  label: const Text("Manage Hotel Details"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    minimumSize: const Size(double.infinity, 60),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    textStyle: const TextStyle(fontSize: 18),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ManageRoomDetailsPage()),
                    );
                  },
                  icon: const Icon(Icons.room_service),
                  label: const Text("Manage Rooms"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    minimumSize: const Size(double.infinity, 60),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    textStyle: const TextStyle(fontSize: 18),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: () {
                    // Pass roomData to UpdateRoomPage when navigating
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ViewRoomPage(
                          roomData: {
                            'id': 'dummyId', // Example room ID
                            'roomNumber': 101,
                            'rent': 100.0,
                            'acType': 'AC',
                            'bedType': 'Double Bed',
                            'wifiAvailable': true,
                            'balconyAvailable': false,
                          },
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.room),
                  label: const Text("View Rooms"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    minimumSize: const Size(double.infinity, 60),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    textStyle: const TextStyle(fontSize: 18),
                  ),
                ),
              ],
            ),
          ],
        ),
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
  String _acType = 'AC';
  String _bedType = 'Double Bed';
  bool _wifiAvailable = true;
  bool _balconyAvailable = false;

  @override
  void initState() {
    super.initState();
    _roomNumberController = TextEditingController(text: widget.roomData['roomNumber'].toString());
    _rentController = TextEditingController(text: widget.roomData['rent'].toString());
    _acType = widget.roomData['acType'];
    _bedType = widget.roomData['bedType'];
    _wifiAvailable = widget.roomData['wifiAvailable'];
    _balconyAvailable = widget.roomData['balconyAvailable'];
  }

  Future<void> _updateRoomDetails() async {
    try {
      // This should update the room in Firestore or your database
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
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Card(
                elevation: 8,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                color: Colors.teal.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        controller: _roomNumberController,
                        decoration: const InputDecoration(labelText: 'Room Number'),
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: _rentController,
                        decoration: const InputDecoration(labelText: 'Rent'),
                        keyboardType: TextInputType.numberWithOptions(decimal: true),
                      ),
                      const SizedBox(height: 10),
                      DropdownButton<String>(
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
                      const SizedBox(height: 10),
                      DropdownButton<String>(
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
                      const SizedBox(height: 10),
                      SwitchListTile(
                        title: const Text('Wi-Fi Available'),
                        value: _wifiAvailable,
                        onChanged: (value) {
                          setState(() {
                            _wifiAvailable = value;
                          });
                        },
                      ),
                      SwitchListTile(
                        title: const Text('Balcony Available'),
                        value: _balconyAvailable,
                        onChanged: (value) {
                          setState(() {
                            _balconyAvailable = value;
                          });
                        },
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _updateRoomDetails,
                        child: const Text("Save Changes", style: TextStyle(color: Colors.white)),
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
