import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:project1/hotel/user_details.dart';

class HotelBooking extends StatefulWidget {
  const HotelBooking({super.key});

  @override
  _HotelBookingState createState() => _HotelBookingState();
}

class _HotelBookingState extends State<HotelBooking> {
  DateTime? _fromDate;
  DateTime? _toDate;

  Future<void> _selectDate(BuildContext context, bool isFromDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
    );

    if (picked != null) {
      setState(() {
        if (isFromDate) {
          _fromDate = picked;
        } else {
          _toDate = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(120.0),
        child: AppBar(
          title: const Text(
            "Booking History",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          backgroundColor: Colors.blueGrey.shade900,
          elevation: 0,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.calendar_today, color: Colors.white),
                    onPressed: () => _selectDate(context, true),
                  ),
                  const Text(
                    "From:",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  if (_fromDate != null)
                    Text(
                      DateFormat('dd/MM/yyyy').format(_fromDate!),
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  const SizedBox(width: 10),
                  IconButton(
                    icon: const Icon(Icons.calendar_today, color: Colors.white),
                    onPressed: () => _selectDate(context, false),
                  ),
                  const Text(
                    "To:",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  if (_toDate != null)
                    Text(
                      DateFormat('dd/MM/yyyy').format(_toDate!),
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('asset/img4.webp'),
            fit: BoxFit.cover,
          ),
        ),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('booking')
              .where('hotelId', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(
                child: Text(
                  "No bookings found.",
                  style: TextStyle(fontSize: 18, color: Colors.black),
                ),
              );
            }

            final bookings = snapshot.data!.docs;
            List<Map<String, dynamic>> filteredBookings = [];

            for (var bookingDoc in bookings) {
              final booking = bookingDoc.data() as Map<String, dynamic>;

              DateTime checkOutDate = (booking["checkOut"] as Timestamp).toDate();

              // Filter bookings based on the selected date range
              if (_fromDate != null && _toDate != null) {
                if (checkOutDate.isAfter(_fromDate!.subtract(const Duration(days: 1))) &&
                    checkOutDate.isBefore(_toDate!.add(const Duration(days: 1)))) {
                  filteredBookings.add(booking);
                }
              } else {
                // If no date range is selected, show all bookings
                filteredBookings.add(booking);
              }
            }

            return ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              itemCount: filteredBookings.length,
              itemBuilder: (context, index) {
                final booking = filteredBookings[index];
                return BookingCard(booking: booking);
              },
            );
          },
        ),
      ),
    );
  }
}

class BookingCard extends StatelessWidget {
  final Map<String, dynamic> booking;

  const BookingCard({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    final hotelId = booking["hotelId"] ?? "";

    if (hotelId.isEmpty) {
      debugPrint("Missing 'hotelId' field in booking: $booking");
      return _buildErrorCard("Unknown Hotel", "Hotel details are missing.");
    }

    final bookingName = booking["name"] ?? "No Name Provided";

    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: Card(
        elevation: 8,
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        shadowColor: Colors.black.withOpacity(0.3),
        child: ListTile(
          contentPadding: const EdgeInsets.all(16),
          tileColor: Colors.white.withOpacity(0.85),
          title: Text(
            bookingName,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 5),
              Text(
                "Booking Date: ${formatDate(booking["bookingDate"])}",
                style: const TextStyle(fontSize: 14, color: Colors.black),
              ),
              Text(
                "Check-In: ${formatDate(booking["checkIn"]) ?? "N/A"}",
                style: const TextStyle(fontSize: 14, color: Colors.black),
              ),
              Text(
                "Check-Out: ${formatDate(booking["checkOut"]) ?? "N/A"}",
                style: const TextStyle(fontSize: 14, color: Colors.black),
              ),
              Text(
                "Guests: ${booking["guests"] ?? 0} | Room: ${booking["roomNumber"] ?? "N/A"}",
                style: const TextStyle(fontSize: 14, color: Colors.black),
              ),
              Text(
                "Rent: \$${booking["rent"] ?? 0}",
                style: const TextStyle(fontSize: 14, color: Colors.black),
              ),
            ],
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => UserDetails(userName: booking["name"])),
            );
          },
        ),
      ),
    );
  }

  Widget _buildErrorCard(String title, String subtitle) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: Card(
        elevation: 4,
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        shadowColor: Colors.black.withOpacity(0.2),
        child: ListTile(
          contentPadding: const EdgeInsets.all(16),
          tileColor: const Color.fromARGB(255, 205, 197, 198),
          title: Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
          ),
          subtitle: Text(
            subtitle,
            style: const TextStyle(fontSize: 14, color: Colors.black),
          ),
        ),
      ),
    );
  }

  String formatDate(Timestamp? timestamp) {
    if (timestamp == null) return "Unknown Date";
    final date = timestamp.toDate();
    return "${date.day}/${date.month}/${date.year}";
  }
}
