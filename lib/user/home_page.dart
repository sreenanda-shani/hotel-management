import 'package:flutter/material.dart';
import 'package:project1/user/login_page.dart';

class HomePage extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final List<String> locations = ['Nearby', 'Bangalore', 'Chennai', 'Delhi'];
  final List<String> premiumHotels = ['₹999 + taxes', '₹1199 + taxes', '₹1499 + taxes'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.menu),
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
      body: Stack(
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
                      hintStyle: TextStyle(color: Colors.black54),
                      prefixIcon: Icon(Icons.search, color: Colors.black),
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
                          // Handle tap event here
                         Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginPage(),),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Column(
                            children: [
                              CircleAvatar(
                                //backgroundColor: Colors.primaries[index % Colors.primaries.length],
                                radius: 25,
                               /*child: Text(
                                 // locations[index][0], // First letter of location
                                  style: TextStyle(color: Colors.white, fontSize: 20),
                                ),*/
                              ),
                              SizedBox(height: 4),
                              Text(
                                locations[index],
                                style: TextStyle(
                                  color: Colors.white, // Change to your preferred color
                                  fontSize: 16, // Optional: change font size
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
                Padding(
                  padding: const EdgeInsets.all(12.0),
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
                  constraints: BoxConstraints(maxHeight: 400),
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: premiumHotels.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 3 / 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    itemBuilder: (context, index) {
                      return Card(
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
                              Icon(
                                Icons.hotel,
                                color: Colors.white,
                                size: 30,
                              ),
                              Text(
                                "Starting from",
                                style: TextStyle(color: Colors.white, fontSize: 14),
                              ),
                              Text(
                                premiumHotels[index],
                                style: TextStyle(
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
                                  // Handle explore button click
                                },
                                child: Text("Explore"),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                // Best Offers Section
               /* Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    "Best Offers for You",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    /*child: Image.asset(
                      'asset/.jpg', // Ensure the file exists
                      width: double.infinity,
                      fit: BoxFit.cover,
                      height: 150,
                    ),*/
                  ),
                ),*/
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
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
          UserAccountsDrawerHeader(
            accountName: Text("User Name"),
            accountEmail: Text("user@example.com"),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.yellow,
              child: Icon(Icons.person, size: 50),
            ),
          ),
          ListTile(
            title: Text('Home'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text('Profile'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text('Settings'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text('Logout'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
