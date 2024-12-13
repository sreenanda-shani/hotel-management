import 'package:flutter/material.dart';

class MyBookingsPage extends StatelessWidget {
  const MyBookingsPage({super.key, required Map hotel});

  @override
  Widget build(BuildContext context) {
    // Updated booking data with 'description', 'amenities' and 'image' fields
    final List<Map<String, dynamic>> userBookingList = [
      {
        'hotelName': 'Oceanview Resort',
        'address': '123 Beach Road, Seaside City',
        'location': 'Seaside City',
        'checkInDate': '2024-11-15',
        'checkOutDate': '2024-11-18',
        'price': '\$450',
        'amenities': ['Free WiFi', 'Swimming Pool', 'Gym', 'Spa'],
        'description': 'A luxury resort by the ocean with stunning views and premium facilities.',
        'image': 'assets/asset/image1.jpeg',
      },
      {
        'hotelName': 'Mountain Retreat',
        'address': '456 Mountain Lane, Highview Town',
        'location': 'Highview Town',
        'checkInDate': '2024-10-10',
        'checkOutDate': '2024-10-12',
        'price': '\$350',
        'amenities': ['Free WiFi', 'Hiking Trails', 'Restaurant'],
        'description': 'A peaceful retreat in the mountains, perfect for hiking and relaxation.',
        'image': 'assets/asset/image2.jpg',
      },
      {
        'hotelName': 'City Center Hotel',
        'address': '789 Central Ave, Downtown',
        'location': 'Downtown City',
        'checkInDate': '2024-09-05',
        'checkOutDate': '2024-09-07',
        'price': '\$320',
        'amenities': ['Free WiFi', 'Restaurant', 'Bar'],
        'description': 'A modern hotel in the heart of the city, ideal for business and leisure.',
        'image': 'assets/asset/image3.jpg',
      },
      {
        'hotelName': 'Lakeside Resort',
        'address': '112 Lakeshore Dr, Lakeview',
        'location': 'Lakeview Town',
        'checkInDate': '2024-08-20',
        'checkOutDate': '2024-08-22',
        'price': '\$400',
        'amenities': ['Fishing', 'Boat Rentals', 'Free WiFi'],
        'description': 'A charming lakeside resort with outdoor activities and scenic views.',
        'image': 'assets/images/hotel_image.jpg',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Bookings'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: userBookingList.length,
          itemBuilder: (context, index) {
            final booking = userBookingList[index];
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 12.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Single Hotel Image
                  Center(
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                      ),
                      child: Image.asset(
                        booking['image'],
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
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Hotel Name
                        Text(
                          booking['hotelName'],
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                        const SizedBox(height: 8),
                        // Hotel Address
                        Row(
                          children: [
                            const Icon(Icons.home, size: 16, color: Colors.grey),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                booking['address'],
                                style: const TextStyle(fontSize: 14),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        // Location
                        Row(
                          children: [
                            const Icon(Icons.location_on,
                                size: 16, color: Colors.grey),
                            const SizedBox(width: 8),
                            Text(
                              'Location: ${booking['location']}',
                              style: const TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        // Price
                        Row(
                          children: [
                            const Icon(Icons.attach_money,
                                size: 16, color: Colors.grey),
                            const SizedBox(width: 8),
                            Text(
                              'Price: ${booking['price']}',
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
                        const SizedBox(height: 4),
                        Text(
                          booking['amenities'].join(', '),
                          style: const TextStyle(fontSize: 14),
                        ),
                        const SizedBox(height: 16),
                        // View in Detail Button
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => HotelDetailPage(booking: booking),
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

class HotelDetailPage extends StatelessWidget {
  final Map<String, dynamic> booking;

  const HotelDetailPage({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(booking['hotelName']),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hotel Name
            Text(
              booking['hotelName'],
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 16),
            // Hotel Image
            Center(
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                child: Image.asset(
                  booking['image'],
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
            ),
            const SizedBox(height: 16),
            // Hotel Description
            const Text(
              'Description:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              booking['description'],
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 16),
            // Hotel Address
            Row(
              children: [
                const Icon(Icons.home, size: 16, color: Colors.grey),
                const SizedBox(width: 8),
                Text(booking['address'], style: const TextStyle(fontSize: 14)),
              ],
            ),
            const SizedBox(height: 8),
            // Location
            Row(
              children: [
                const Icon(Icons.location_on, size: 16, color: Colors.grey),
                const SizedBox(width: 8),
                Text('Location: ${booking['location']}',
                    style: const TextStyle(fontSize: 14)),
              ],
            ),
            const SizedBox(height: 8),
            // Check-in and Check-out Dates
            const Text(
              'Check-in and Check-out Dates:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                const SizedBox(width: 8),
                Text(
                  'Check-in: ${booking['checkInDate']}  |  Check-out: ${booking['checkOutDate']}',
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Price
            Row(
              children: [
                const Icon(Icons.attach_money, size: 16, color: Colors.grey),
                const SizedBox(width: 8),
                Text('Price: ${booking['price']}',
                    style: const TextStyle(fontSize: 14)),
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
              booking['amenities'].join(', '),
              style: const TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}