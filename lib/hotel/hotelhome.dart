import 'package:flutter/material.dart';
import 'package:project1/hotel/hotel_booking.dart';
import 'package:project1/hotel/hotelcontact.dart';
import 'package:project1/hotel/hotelmanage.dart';



class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hotel Management',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: const HotelHome(),
    );
  }
}

class HotelHome extends StatefulWidget {
  const HotelHome({super.key});

  @override
  State<HotelHome> createState() => _HotelHomeState();
}

class _HotelHomeState extends State<HotelHome> {
  String welcomeMessage = "Welcome to Our Hotel!";

  // Edit Welcome Message method
  void editWelcomeMessage() {
    TextEditingController controller = TextEditingController(text: welcomeMessage);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Edit Welcome Message"),
          content: TextField(
            controller: controller,
            maxLines: 2,
            decoration: const InputDecoration(hintText: "Enter a welcome message"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  welcomeMessage = controller.text;
                });
                Navigator.of(context).pop();
              },
              child: const Text("Save"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancel"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Hotel Management"),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Message Section
            Card(
              color: Colors.teal[50],
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Welcome Message:",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            welcomeMessage,
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: editWelcomeMessage,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Buttons Section for Navigation
            Column(
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const HotelContactPage()),
                    );
                  },
                  icon: const Icon(Icons.contact_phone),
                  label: const Text("Contact Details"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    minimumSize: const Size(double.infinity, 50),
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const HotelBookingsPage()),
                    );
                  },
                  icon: const Icon(Icons.book),
                  label: const Text("View Bookings"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    minimumSize: const Size(double.infinity, 50),
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>  const ManageHotelDetailsPage()),
                    );
                  },
                  icon: const Icon(Icons.manage_accounts),
                  label: const Text("Manage Details"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    minimumSize: const Size(double.infinity, 50),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}


