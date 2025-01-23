import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project1/user/user_hotelhomepage.dart';
 // Import UserHotelDetailsScreen

class HotelDetailsPage extends StatefulWidget {
  const HotelDetailsPage({super.key});

  @override
  _HotelDetailsPageState createState() => _HotelDetailsPageState();
}

class _HotelDetailsPageState extends State<HotelDetailsPage> {
  final TextEditingController _searchController = TextEditingController();
  late FirebaseFirestore _firestore;
  late CollectionReference _hotelCollection;
  List<Map<String, dynamic>> _hotels = [];
  List<Map<String, dynamic>> _filteredHotels = [];

  @override
  void initState() {
    super.initState();
    _firestore = FirebaseFirestore.instance;
    _hotelCollection = _firestore.collection('hotels');
    _fetchHotels();
  }

  // Fetch hotel data from Firestore
  Future<void> _fetchHotels() async {
    try {
      QuerySnapshot snapshot = await _hotelCollection.get();
      List<Map<String, dynamic>> hotels = snapshot.docs.map((doc) {
        var data = doc.data() as Map<String, dynamic>;
        data['hotelId'] = doc.id; // Add the document ID (hotelId) to the hotel data
        return data;
      }).toList();

      setState(() {
        _hotels = hotels; // Set fetched hotels data
        _filteredHotels = hotels; // Initially, all hotels are shown
      });
    } catch (e) {
      print('Error fetching hotel data: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to load hotel data')),
      );
    }
  }

  // Filter hotels based on search query
  void _filterHotels(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredHotels = _hotels; // If search is empty, show all hotels
      } else {
        _filteredHotels = _hotels.where((hotel) {
          // Check if hotel name matches search query (case-insensitive)
          return hotel['hotelName']
              .toLowerCase()
              .contains(query.toLowerCase());
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: const Text(
          "Search Hotel Page",
          style: TextStyle(fontSize: 20),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search Hotel Here',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    _filterHotels(_searchController.text); // Trigger search
                  },
                ),
              ),
              onChanged: (query) {
                _filterHotels(query); // Update filtered hotels on text change
              },
            ),
            const SizedBox(height: 20),
            // Displaying hotel cards
            Expanded(
              child: _filteredHotels.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      itemCount: _filteredHotels.length,
                      itemBuilder: (context, index) {
                        var hotel = _filteredHotels[index];
                        return _buildHotelCard(
                          hotel['hotelName'],
                          hotel['facilities'],
                          hotel['location'],
                          hotel['imageUrl'], // Use imageUrl from Firebase
                          hotel // Pass the entire hotel data
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  // Hotel card widget
  Widget _buildHotelCard(
    String hotelName,
    String facilities,
    String location,
    String hotelImage,
    Map<String, dynamic> hotel,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.blueAccent.withOpacity(0.5),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
            child: Image.network(
              hotelImage,
              height: 150,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  hotelName,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  facilities,
                  style: const TextStyle(color: Colors.orange, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  'Location: $location',
                  style: TextStyle(color: Colors.grey[700]),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () {
                    // Pass the hotel document ID to UserHotelDetailsScreen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UserHotelDetailsScreen(
                          hotelDocumentId: hotel['hotelId'], // Pass hotelDocumentId
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    "Book Now",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}