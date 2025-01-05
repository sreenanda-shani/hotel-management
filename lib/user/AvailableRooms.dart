import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:project1/user/roombooking.dart'; // Import RoomBookingPage

class AvailableRoomsPage extends StatelessWidget {
  final String hotelId;

  const AvailableRoomsPage({super.key, required this.hotelId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal, // Teal AppBar
        title: const Text("Available Rooms"),
        elevation: 4,
      ),
      body: FutureBuilder<List<Room>>(
        future: _fetchAvailableRooms(hotelId), // Fetch rooms using hotelId
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No rooms available"));
          } else {
            List<Room> rooms = snapshot.data!;
            return SingleChildScrollView( // Wrap the ListView in SingleChildScrollView
              child: Column(
                children: rooms.map((room) {
                  return RoomTile(room: room, hotelId: hotelId); // Pass hotelId to RoomTile
                }).toList(),
              ),
            );
          }
        },
      ),
    );
  }

  Future<List<Room>> _fetchAvailableRooms(String hotelId) async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('rooms') // Assuming you have a 'rooms' collection
          .where('hotelId', isEqualTo: hotelId) // Filter by hotelId
          .where('isAvailable', isEqualTo: true) // Filter by availability
          .get();

      List<Room> rooms = snapshot.docs.map((doc) {
        var data = doc.data() as Map<String, dynamic>;
        return Room(
          roomId: doc.id,
          roomNumber: data['roomNumber'],
          acType: data['acType'],
          balconyAvailable: data['balconyAvailable'],
          bedType: data['bedType'],
          rent: data['rent'],
          isAvailable: data['isAvailable'],
          wifiAvailable: data['wifiAvailable'],
        );
      }).toList();

      return rooms;
    } catch (e) {
      print('Error fetching available rooms: $e');
      return [];
    }
  }
}

class Room {
  final int roomNumber;
  final String acType;
  final bool balconyAvailable;
  final String bedType;
  final double rent;
  final bool isAvailable;
  final bool wifiAvailable;
  final String roomId;

  Room({
    required this.roomId,
    required this.roomNumber,
    required this.acType,
    required this.balconyAvailable,
    required this.bedType,
    required this.rent,
    required this.isAvailable,
    required this.wifiAvailable,
  });
}

class RoomTile extends StatefulWidget {
  final Room room;
  final String hotelId; // To pass hotelId for booking

  const RoomTile({super.key, required this.room, required this.hotelId});

  @override
  _RoomTileState createState() => _RoomTileState();
}

class _RoomTileState extends State<RoomTile> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: Colors.white, // Soft teal background for the room tile
      child: ExpansionTile(
        title: Text(
          'Room ${widget.room.roomNumber}',
          style: const TextStyle(
            color: Colors.teal, // Title color in teal
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          widget.room.isAvailable ? 'Available' : 'Not Available',
          style: TextStyle(
            color: widget.room.isAvailable ? Colors.green : Colors.red,
          ),
        ),
        trailing: Icon(
          _isExpanded ? Icons.expand_less : Icons.expand_more,
          color: Colors.teal,
        ),
        onExpansionChanged: (bool expanding) {
          setState(() {
            _isExpanded = expanding;
          });
        },
        children: [
          ListTile(
            title: const Text('Room Details'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('AC Type: ${widget.room.acType}'),
                Text('Balcony Available: ${widget.room.balconyAvailable ? 'Yes' : 'No'}'),
                Text('Bed Type: ${widget.room.bedType}'),
                Text('Rent: \$${widget.room.rent.toString()}'),
                Text('Wi-Fi Available: ${widget.room.wifiAvailable ? 'Yes' : 'No'}'),
              ],
            ),
          ),
          // Book Now button with teal accent
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal, // Button color teal
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                // Navigate to RoomBookingPage with room details and hotelId
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RoomBookingPage(
                      hotelId: widget.hotelId,
                      roomNumber: widget.room.roomNumber,
                      rent: widget.room.rent,
                      roomId:widget.room.roomId
                    ),
                  ),
                );
              },
              child: const Text(
                "Book Now",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
