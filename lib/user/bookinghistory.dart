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

        // Fetch hotel data for the booking using hotelId
        var hotelSnapshot = await _hotelCollection.doc(bookingData['hotelId']).get();
        if (hotelSnapshot.exists) {
          var hotelData = hotelSnapshot.data() as Map<String, dynamic>;
          bookingData['hotelName'] = hotelData['hotelName']; // Hotel Name
          bookingData['hotelEmail'] = hotelData['contactEmail']; // Hotel Email
          bookingData['hotelMobile'] = hotelData['contactNumber']; // Hotel Mobile
          bookingData['hotelImage'] = hotelData['imageUrl']; // Hotel Image
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
    // Extract details from the booking
    var hotelName = booking['hotelName'] ?? 'Hotel Name';
    var hotelEmail = booking['hotelEmail'] ?? 'Not Available';
    var hotelMobile = booking['hotelMobile'] ?? 'Not Available';
    var roomNumber = booking['roomNumber'] ?? 'Not Available';
    var rent = booking['rent'] ?? 'Not Available';
    var guests = booking['guests'] ?? 'Not Available';
    var hotelImage = booking['hotelImage'] ?? '';

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display hotel image
            if (hotelImage.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  hotelImage,
                  height: 150,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            const SizedBox(height: 10),

            // Display hotel name
            Text(
              hotelName,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),

            // Display room details
            Text(
              'Room: $roomNumber',
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 4),

            // Display rent
            Text(
              'Total Rent: \$${rent.toString()}',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 4),

            // Display guests
            Text(
              'Guests: $guests',
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 8),

            // Display hotel contact details
            Text(
              'Hotel Email: $hotelEmail',
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 4),
            Text(
              'Hotel Mobile: $hotelMobile',
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 12),

            ElevatedButton(
              onPressed: () {
                // Navigate to detailed page or take action
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BookingDetailsPage(
                      bookingId: booking['bookingId'],
                    ),
                  ),
                );
              },
              child: const Text("View Details"),
            ),
          ],
        ),
      ),
    );
  }
}

class BookingDetailsPage extends StatelessWidget {
  final String bookingId;

  const BookingDetailsPage({super.key, required this.bookingId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: const Text("Booking Details"),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('booking')
            .doc(bookingId)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text('Booking not found.'));
          }

          var bookingData = snapshot.data!.data() as Map<String, dynamic>;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Name: ${bookingData['name']}',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text('Email: ${bookingData['email']}'),
                Text('Room: ${bookingData['roomNumber']}'),
                Text('Guests: ${bookingData['guests']}'),
                Text('Total Rent: \$${bookingData['rent']}'),
                Text('Check-In: ${_formatDate(bookingData['checkIn'])}'),
                Text('Check-Out: ${_formatDate(bookingData['checkOut'])}'),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Back'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  String _formatDate(dynamic date) {
    if (date == null) return "Unknown date";
    if (date is Timestamp) {
      var convertedDate = date.toDate();
      return "${convertedDate.day}/${convertedDate.month}/${convertedDate.year} ${convertedDate.hour}:${convertedDate.minute}";
    }
    return "Invalid date format";
  }
}