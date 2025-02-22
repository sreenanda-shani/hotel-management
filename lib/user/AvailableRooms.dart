import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:project1/user/roombooking.dart'; // Import RoomBookingPage

class AvailableRoomsPage extends StatelessWidget {
  final String hotelId;

  const AvailableRoomsPage({super.key, required this.hotelId});

  @override
  Widget build(BuildContext context) {
    print("AvailableRoomsPage initialized with hotelId: $hotelId"); // Debugging

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: const Text("Available Rooms"),
        elevation: 4,
      ),
      body: FutureBuilder<List<Room>>(
        future: _fetchAvailableRooms(hotelId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No rooms available"));
          } else {
            List<Room> rooms = snapshot.data!;
            return ListView.builder(
              itemCount: rooms.length,
              itemBuilder: (context, index) {
                return RoomTile(room: rooms[index], hotelId: hotelId);
              },
            );
          }
        },
      ),
    );
  }

  Future<List<Room>> _fetchAvailableRooms(String hotelId) async {
    try {
      print("Fetching rooms for hotelId: $hotelId"); // Debugging

      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('rooms')
          .where('hotelId', isEqualTo: hotelId) // Ensure hotelId exists in Firestore
          .where('isAvailable', isEqualTo: true) // Only fetch available rooms
          .get();

      print("Documents found: ${snapshot.docs.length}"); // Debugging

      if (snapshot.docs.isEmpty) {
        print("No rooms found for hotelId: $hotelId");
      }

      List<Room> rooms = snapshot.docs.map((doc) {
        var data = doc.data() as Map<String, dynamic>;
        print("Fetched Room Data: $data"); // Debugging

        return Room(
          roomId: doc.id,
          roomNumber: data['roomNumber'] ?? 0, // Default to 0 if missing
          acType: data['acType'] ?? 'Unknown',
          balconyAvailable: data['balconyAvailable'] ?? false,
          bedType: data['bedType'] ?? 'Unknown',
          rent: (data['rent'] as num?)?.toDouble() ?? 0.0, // Ensure double
          isAvailable: data['isAvailable'] ?? false,
          wifiAvailable: data['wifiAvailable'] ?? false,
          totalRent: (data['totalRent'] as num?)?.toDouble() ?? 0.0,
        );
      }).toList();

      return rooms;
    } catch (e) {
      print('Error fetching available rooms: $e');
      return [];
    }
  }
}

// Room Model Class
class Room {
  final int roomNumber;
  final String acType;
  final bool balconyAvailable;
  final String bedType;
  final double rent;
  final bool isAvailable;
  final bool wifiAvailable;
  final String roomId;
  final double totalRent;

  Room({
    required this.roomId,
    required this.roomNumber,
    required this.acType,
    required this.balconyAvailable,
    required this.bedType,
    required this.rent,
    required this.isAvailable,
    required this.wifiAvailable,
    required this.totalRent,
  });
}

// RoomTile Widget (List Item)
class RoomTile extends StatefulWidget {
  final Room room;
  final String hotelId;

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
      color: Colors.white,
      child: ExpansionTile(
        title: Text(
          'Room ${widget.room.roomNumber}',
          style: const TextStyle(
            color: Colors.teal,
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
                Text('Total Rent: \$${widget.room.totalRent.toString()}'),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RoomBookingPage(
                      hotelId: widget.hotelId,
                      roomNumber: widget.room.roomNumber,
                      rent: widget.room.rent,
                      roomId: widget.room.roomId,
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