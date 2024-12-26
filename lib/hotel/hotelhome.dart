import 'package:flutter/material.dart';
import 'package:project1/hotel/hotel_booking.dart';
import 'package:project1/hotel/hotel_rooms.dart';
import 'package:project1/hotel/hotel_view.dart';
import 'package:project1/hotel/hotelcontact.dart';
import 'package:project1/hotel/hotelmanage.dart';

class HotelHome extends StatefulWidget {
  const HotelHome({super.key});

  @override
  State<HotelHome> createState() => _HotelHomeState();
}

class _HotelHomeState extends State<HotelHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Hotel Management",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.black.withOpacity(0.7),
        elevation: 0,
      ),
      body: Container(
        // Background image
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('asset/img7.jpg'), // Replace with your image path
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
            child: Container(
              // Group container for navigation buttons
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.85), // Slight transparency
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "Welcome to Hotel Management",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildNavigationButton(
                      context,
                      icon: Icons.contact_phone,
                      label: "Contact Details",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const HotelContactPage()),
                        );
                      },
                    ),
                    const SizedBox(height: 15),
                    _buildNavigationButton(
                      context,
                      icon: Icons.book,
                      label: "View Bookings",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const BookingHistoryPage()),
                        );
                      },
                    ),
                    const SizedBox(height: 15),
                    _buildNavigationButton(
                      context,
                      icon: Icons.manage_accounts,
                      label: "Manage Hotel Details",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const ManageHotelDetailsPage()),
                        );
                      },
                    ),
                    const SizedBox(height: 15),
                    _buildNavigationButton(
                      context,
                      icon: Icons.room_service,
                      label: "Manage Rooms",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const ManageRoomDetailsPage()),
                        );
                      },
                    ),
                    const SizedBox(height: 15),
                    _buildNavigationButton(
                      context,
                      icon: Icons.room,
                      label: "View Rooms",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ViewRoomPage(
                              roomData: {
                                'id': 'dummyId',
                                'roomNumber': 101,
                                'rent': 100.0,
                                'acType': 'AC',
                                'bedType': 'Double Bed',
                                'wifiAvailable': true,
                                'balconyAvailable': false,
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Button Builder
  Widget _buildNavigationButton(BuildContext context, {required IconData icon, required String label, required VoidCallback onTap}) {
    return ElevatedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 28),
      label: Text(label, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        minimumSize: const Size(double.infinity, 60),
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        shadowColor: Colors.black.withOpacity(0.2),
      ),
    );
  }
}
