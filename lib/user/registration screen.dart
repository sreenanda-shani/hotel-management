import 'package:flutter/material.dart';

class Registration extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final List<String> locations = ['Nearby', 'Bangalore', 'Chennai', 'Delhi'];
  final List<String> premiumHotels = ['₹999 + taxes', '₹1199 + taxes', '₹1499 + taxes'];

  Registration({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            if (_scaffoldKey.currentState != null) {
              _scaffoldKey.currentState!.openDrawer();
            }
          },
        ),
        title: Center(
          child: ClipOval(
            child: Image.asset(
              'asset/download.png', // Ensure the file exists
              height: 40.0,
              width: 40.0,
              fit: BoxFit.cover,
            ),
          ),
        ),
        elevation: 4,
      ),
      drawer: _buildLeftDrawer(context),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            // Background Image
            Positioned.fill(
              child: Image.asset(
                'asset/img4.webp', // Replace with your background image path
                fit: BoxFit.cover,
              ),
            ),
            // Foreground Content
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Search Bar
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "Search for city, location or hotel",
                        hintStyle: const TextStyle(color: Colors.black54),
                        prefixIcon: const Icon(Icons.search, color: Colors.black),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        filled: true,
                        fillColor: Colors.grey[200]!.withOpacity(0.6),
                      ),
                    ),
                  ),
                  // Horizontal Scrollable Buttons for Locations
                  SizedBox(
                    height: 80,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: locations.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            // Navigate to a new page for the selected location
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LocationPage(locationName: locations[index]),
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Column(
                              children: [
                                CircleAvatar(
                                  radius: 25,
                                  backgroundColor: Colors.white,
                                  child: Text(
                                    locations[index][0], // First letter of location
                                    style: const TextStyle(color: Colors.white, fontSize: 20),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  locations[index],
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  // Premium Hotels Section
                  const Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Text(
                      "Premium Hotels",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxHeight: 400),
                    child: GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: premiumHotels.length,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 3 / 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            // Navigate to a new page for the selected price
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PricePage(priceDetails: premiumHotels[index]),
                              ),
                            );
                          },
                          child: Card(
                            elevation: 4,
                            color: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  const Icon(
                                    Icons.hotel,
                                    color: Colors.white,
                                    size: 30,
                                  ),
                                  const Text(
                                    "Starting from",
                                    style: TextStyle(color: Colors.white, fontSize: 14),
                                  ),
                                  Text(
                                    premiumHotels[index],
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      foregroundColor: Colors.black,
                                    ),
                                    onPressed: () {
                                      // Navigate to the price page
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => PricePage(priceDetails: premiumHotels[index]),
                                        ),
                                      );
                                    },
                                    child: const Text("Explore"),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: Colors.black),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book, color: Colors.black),
            label: 'Bookings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search, color: Colors.black),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.room_service, color: Colors.black),
            label: 'Services',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.share, color: Colors.black),
            label: 'Refer & Earn',
          ),
        ],
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black54,
      ),
    );
  }

  Widget _buildLeftDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const UserAccountsDrawerHeader(
            accountName: Text("User Name"),
            accountEmail: Text("user@example.com"),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.yellow,
              child: Icon(Icons.person, size: 50),
            ),
          ),
          ListTile(
            title: const Text('Home'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('Profile'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('Settings'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('Logout'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}

class LocationPage extends StatelessWidget {
  final String locationName;

  const LocationPage({super.key, required this.locationName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(locationName),
      ),
      body: Center(
        child: Text(
          'Welcome to $locationName!',
          style: const TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}

class PricePage extends StatelessWidget {
  final String priceDetails;

  const PricePage({super.key, required this.priceDetails});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Hotel Details"),
      ),
      body: Center(
        child: Text(
          'Hotels at $priceDetails',
          style: const TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
