import 'package:flutter/material.dart';

class FavouritesPage extends StatelessWidget {
  // Sample data for favorite items with enhanced details
  final List<Map<String, dynamic>> favourites = [
    {
      "name": "Hotel Sunshine",
      "type": "Hotel",
      "description": "A cozy hotel located in the heart of the city.",
      "location": "Downtown",
      "amenities": ["Free WiFi", "Parking", "Breakfast"],
      "image": "assets/images/hotel_sunshine.jpg",
    },
    {
      "name": "Mountain Resort",
      "type": "Resort",
      "description": "A serene mountain resort with breathtaking views.",
      "location": "Highlands",
      "amenities": ["Hiking Trails", "Swimming Pool", "Gym"],
      "image": "assets/images/mountain_resort.jpg",
    },
    {
      "name": "Ocean View",
      "type": "Hotel",
      "description": "Experience luxury with stunning ocean views.",
      "location": "Seaside",
      "amenities": ["Beach Access", "Spa", "Free WiFi"],
      "image": "assets/images/ocean_view.jpg",
    },
    {
      "name": "City Inn",
      "type": "Inn",
      "description": "A budget-friendly inn with modern amenities.",
      "location": "City Center",
      "amenities": ["Free WiFi", "Restaurant", "Bar"],
      "image": "assets/images/city_inn.jpg",
    },
  ];

  FavouritesPage({super.key});

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
        child: ListView.builder(
          itemCount: favourites.length,
          itemBuilder: (context, index) {
            final favourite = favourites[index];
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
                    child: Image.asset(
                      favourite['image'] ?? 'assets/images/placeholder.jpg',
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
                          favourite['name'],
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Type: ${favourite['type']}",
                          style: const TextStyle(fontSize: 14, color: Colors.grey),
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
                        // Amenities
                        const Text(
                          'Amenities:',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          favourite['amenities'].join(', '),
                          style: const TextStyle(fontSize: 14),
                        ),
                        const SizedBox(height: 16),
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
        title: Text(favourite['name']),
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
              favourite['name'],
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
              child: Image.asset(
                favourite['image'] ?? 'assets/images/placeholder.jpg',
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
              favourite['description'],
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
            // Amenities
            const Text(
              'Amenities:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              favourite['amenities'].join(', '),
              style: const TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}