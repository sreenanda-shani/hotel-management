import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FavouritesPage extends StatefulWidget {
  const FavouritesPage({super.key});

  @override
  _FavouritesPageState createState() => _FavouritesPageState();
}

class _FavouritesPageState extends State<FavouritesPage> {
  // List to hold favourite hotel data fetched from Firestore
  List<Map<String, dynamic>> favourites = [];

  @override
  void initState() {
    super.initState();
    _fetchFavouriteHotels();
  }

  Future<void> _fetchFavouriteHotels() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      try {
        // Fetch user document
        final userDoc = await FirebaseFirestore.instance
            .collection('user')
            .doc(currentUser.uid)
            .get();

        // Get the list of favorite hotel document IDs
        final favorites = userDoc.data()?['favourites'] as List<dynamic>? ?? [];

        // Fetch hotel data for each favourite hotel document ID
        List<Map<String, dynamic>> hotelList = [];
        for (var hotelId in favorites) {
          final hotelDoc = await FirebaseFirestore.instance
              .collection('hotels')
              .doc(hotelId)
              .get();

          if (hotelDoc.exists) {
            hotelList.add({
              'hotelId': hotelDoc.id,
              'hotelName': hotelDoc['hotelName'],
              'location': hotelDoc['location'],
              'imageUrl': hotelDoc['imageUrl'],
              'facilities': hotelDoc['facilities'],
            });
          }
        }

        setState(() {
          favourites = hotelList;
        });
      } catch (e) {
        // Handle errors (optional)
        print('Error fetching favourite hotels: $e');
      }
    }
  }

  Future<void> _removeFavorite(String hotelId) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      try {
        final userDoc = FirebaseFirestore.instance.collection('user').doc(currentUser.uid);

        // Remove the hotel ID from the user's favourites field
        await userDoc.update({
          'favourites': FieldValue.arrayRemove([hotelId]),
        });

        // Update local state after removing the favorite
        setState(() {
          favourites.removeWhere((hotel) => hotel['hotelId'] == hotelId);
        });
      } catch (e) {
        // Handle errors during the removal process
        print('Error removing favorite: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Favourites"),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: favourites.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: favourites.length,
                itemBuilder: (context, index) {
                  final favourite = favourites[index];
                  final hotelId = favourite['hotelId'];

                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 12.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Display Image
                        ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                          ),
                          child: Image.network(
                            favourite['imageUrl'] ?? 'assets/images/placeholder.jpg',
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: 200,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(
                                Icons.broken_image,
                                size: 100,
                                color: Colors.grey,
                              );
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Name and Type
                              Text(
                                favourite['hotelName'] ?? 'Unknown Hotel',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue,
                                ),
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                "Type: Hotel", // You can modify this to be dynamic if needed
                                style: TextStyle(fontSize: 14, color: Colors.grey),
                              ),
                              const SizedBox(height: 8),
                              // Location
                              Row(
                                children: [
                                  const Icon(Icons.location_on, size: 16, color: Colors.grey),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Location: ${favourite['location']}',
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              // Facilities (amenities)
                              const Text(
                                'Facilities:',
                                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                favourite['facilities'] ?? 'No facilities listed',
                                style: const TextStyle(fontSize: 14),
                              ),
                              const SizedBox(height: 16),
                              // Heart Icon Button to Remove from Favourites
                              Align(
                                alignment: Alignment.centerRight,
                                child: IconButton(
                                  icon: const Icon(
                                    Icons.favorite,
                                    color: Colors.red,
                                  ),
                                  onPressed: () {
                                    _removeFavorite(hotelId);
                                  },
                                ),
                              ),
                              // View Details Button
                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => FavouriteDetailPage(favourite: favourite),
                                      ),
                                    );
                                  },
                                  child: const Text(
                                    'View in Detail',
                                    style: TextStyle(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
      ),
    );
  }
}

class FavouriteDetailPage extends StatelessWidget {
  final Map<String, dynamic> favourite;

  const FavouriteDetailPage({super.key, required this.favourite});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(favourite['hotelName'] ?? 'Hotel Details'),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Name
            Text(
              favourite['hotelName'] ?? 'Unknown Hotel',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 16),
            // Image
            ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              child: Image.network(
                favourite['imageUrl'] ?? 'assets/images/placeholder.jpg',
                fit: BoxFit.cover,
                width: double.infinity,
                height: 250,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(
                    Icons.broken_image,
                    size: 100,
                    color: Colors.grey,
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            // Description
            const Text(
              'Description:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              favourite['description'] ?? 'No description available.',
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 16),
            // Location
            Row(
              children: [
                const Icon(Icons.location_on, size: 16, color: Colors.grey),
                const SizedBox(width: 8),
                Text(
                  'Location: ${favourite['location']}',
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Facilities
            const Text(
              'Facilities:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              favourite['facilities'] ?? 'No facilities listed',
              style: const TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
