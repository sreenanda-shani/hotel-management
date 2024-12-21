import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BookingHistoryPage extends StatefulWidget {
  const BookingHistoryPage({super.key});

  @override
  _BookingHistoryPageState createState() => _BookingHistoryPageState();
}

class _BookingHistoryPageState extends State<BookingHistoryPage> {
  late FirebaseFirestore _firestore;
  late CollectionReference _bookingCollection;
  late CollectionReference _hotelCollection;
  List<Map<String, dynamic>> _userBookings = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _firestore = FirebaseFirestore.instance;
    _bookingCollection = _firestore.collection('booking');
    _hotelCollection = _firestore.collection('hotels');
    _fetchUserBookings();
  }

  // Fetch user booking data from Firestore
  Future<void> _fetchUserBookings() async {
    try {
      QuerySnapshot bookingSnapshot = await _bookingCollection.get();

      List<Map<String, dynamic>> bookings = [];
      for (var doc in bookingSnapshot.docs) {
        var bookingData = doc.data() as Map<String, dynamic>;
        bookingData['bookingId'] = doc.id; // Add booking ID

        // Debugging: Check types of checkIn and checkOut
        print('checkIn: ${bookingData['checkIn']}, Type: ${bookingData['checkIn'].runtimeType}');
        print('checkOut: ${bookingData['checkOut']}, Type: ${bookingData['checkOut'].runtimeType}');

        // Convert checkIn and checkOut to Timestamp if necessary
        if (bookingData['checkIn'] is! Timestamp && bookingData['checkIn'] != null) {
          bookingData['checkIn'] = Timestamp.fromDate(DateTime.parse(bookingData['checkIn']));
        }
        if (bookingData['checkOut'] is! Timestamp && bookingData['checkOut'] != null) {
          bookingData['checkOut'] = Timestamp.fromDate(DateTime.parse(bookingData['checkOut']));
        }

        // Fetch hotel data for the booking
        var hotelSnapshot = await _hotelCollection.doc(bookingData['hotelId']).get();
        if (hotelSnapshot.exists) {
          var hotelData = hotelSnapshot.data() as Map<String, dynamic>;
          bookingData['hotel'] = hotelData; // Attach hotel data
        }

        bookings.add(bookingData);
      }

      setState(() {
        _userBookings = bookings;
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching booking data: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to load booking data')),
      );
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: const Text("Booking History"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _userBookings.isEmpty
                ? const Center(child: Text("No bookings available"))
                : ListView.builder(
                    itemCount: _userBookings.length,
                    itemBuilder: (context, index) {
                      var booking = _userBookings[index];
                      return _buildBookingCard(booking);
                    },
                  ),
      ),
    );
  }

  // Build booking card to display booking details
  Widget _buildBookingCard(Map<String, dynamic> booking) {
    var hotel = booking['hotel'];
    if (hotel == null) {
      return const Text("Hotel details not available");
    }

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          // Display hotel image
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
            child: hotel['imageUrl'] != null
                ? Image.network(
                    hotel['imageUrl'],
                    height: 150,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  )
                : const Icon(Icons.image_not_supported, size: 150),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Display hotel name and booking details
                Text(
                  hotel['hotelName'] ?? 'Hotel Name',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  'Room: ${booking['roomNumber']} | Guests: ${booking['guests']}',
                  style: const TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 4),
                Text(
                  'Check-in: ${_formatDate(booking['checkIn'])} | Check-out: ${_formatDate(booking['checkOut'])}',
                  style: const TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 8),
                Text(
                  'Total Rent: \$${booking['rent']}',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () {
                    // Navigate to detailed page or take action
                  },
                  child: const Text("View Details"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper function to format timestamp to human-readable format
  String _formatDate(dynamic date) {
    try {
      if (date == null) return "Unknown date";
      if (date is Timestamp) {
        var convertedDate = date.toDate();
        return "${convertedDate.day}/${convertedDate.month}/${convertedDate.year} ${convertedDate.hour}:${convertedDate.minute}";
      }
      return "Invalid date format";
    } catch (e) {
      return "Invalid date"; // Fallback for unexpected errors
    }
  }
}
