import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class RoomServicesPage extends StatefulWidget {
  final String staffHotelId;

  RoomServicesPage({required this.staffHotelId});

  @override
  _RoomServicesPageState createState() => _RoomServicesPageState();
}

class _RoomServicesPageState extends State<RoomServicesPage> {
  final CollectionReference roomServiceCollection =
      FirebaseFirestore.instance.collection('roomService');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Room Service Requests', style: TextStyle(fontSize: 20)),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: roomServiceCollection
            .where('hotelId', isEqualTo: widget.staffHotelId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text('No Room Service Requests',
                  style: TextStyle(fontSize: 18, color: Colors.grey)),
            );
          }

          final roomServices = snapshot.data!.docs;

          return ListView.builder(
            itemCount: roomServices.length,
            itemBuilder: (context, index) {
              final service = roomServices[index];
              final String docId = service.id;
              final String roomNo = service['roomNo'].toString();
              final String message = service['message'] ?? 'No details provided';

              return Dismissible(
                key: Key(docId),
                direction: DismissDirection.endToStart,
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: EdgeInsets.only(right: 20),
                  color: Colors.red,
                  child: Icon(Icons.delete, color: Colors.white),
                ),
                onDismissed: (direction) {
                  roomServiceCollection.doc(docId).delete();
                },
                child: Card(
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    contentPadding: EdgeInsets.all(16),
                    leading: Icon(Icons.room_service, color: Colors.blueAccent, size: 30),
                    title: Text(
                      "Room no. $roomNo has booked a room service",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Padding(
                      padding: EdgeInsets.only(top: 5),
                      child: Text(
                        message,
                        style: TextStyle(fontSize: 14, color: Colors.black87),
                      ),
                    ),
                    trailing: ElevatedButton(
                      onPressed: () {
                        roomServiceCollection.doc(docId).delete();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text("Mark as Done"),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
