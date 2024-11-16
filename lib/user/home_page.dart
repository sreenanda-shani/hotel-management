import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Define service titles outside of the builder
    double screenWidth = MediaQuery.of(context).size.width;
    double FontSize = screenWidth * 0.02;
    List<String> serviceTitles = [
      'Tour and Excursions',
      'Free Wireless Internet Access',
      'Restaurant Service',
      'Laundry Service'
    ];

    return Scaffold(
      appBar: AppBar(
        // Burger menu (leading) stays on the left
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {
            Scaffold.of(context).openDrawer(); // Open the left drawer
          },
        ),
        
        // Center content (image) in the title
        title: Padding(
          padding: EdgeInsets.only(right: 55.0), // Adjust the left padding to make room for the burger menu
          child: Center(
            child: ClipOval(
              child: Image.asset(
                'asset/download.png', // Replace with your logo path
                height: 40.0, // Height of the circle
                width: 40.0,  // Ensure width is equal to height for a perfect circle
                fit: BoxFit.cover,  // This ensures the image scales and fits inside the circle
              ),
            ),
          ),
        ),

        elevation: 4,
      ),
      drawer: _buildLeftDrawer(context),
      body: Column(
        children: [
          // Existing Image at the top
          Image.asset(
            'asset/1731664618375_1731664606081_1731664598342_Leonardo_Kino_XL_resorts_imges_for_background_0.jpg',
            width: double.maxFinite,
            fit: BoxFit.fitWidth,
            height: 300,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Services', // Heading Text
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blue, // You can customize the color
              ),
            ),
          ),
          // Four boxes using Card and ListTile
          Expanded(
            child: GridView.count(
              crossAxisCount: 4, // Creates a 4x1 grid of cards
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              padding: EdgeInsets.all(10),
              children: List.generate(serviceTitles.length, (index) {
                return Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: InkWell(
                    onTap: () {
                      // Action when the user taps on the grid item
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('${serviceTitles[index]} tapped')),
                      );
                    },
                    child: Center(
                      child: ListTile(
                        title: Text(
                          serviceTitles[index], // Displaying service titles
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: FontSize, // Increased the font size
                            fontWeight: FontWeight.w600, // Semi-bold font weight
                            color: Colors.deepPurple, // Changed color to deep purple
                            fontStyle: FontStyle.italic, // Applying italic font style
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  // Left Drawer
  Widget _buildLeftDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          // User Account section
          UserAccountsDrawerHeader(
            accountName: Text("User Name"),
            accountEmail: Text("user@example.com"),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.person, size: 50),
            ),
          ),
          // Menu items
          ListTile(
            title: Text('Home'),
            onTap: () {
              Navigator.pop(context); // Close the drawer
              // You can navigate to the Home page here
            },
          ),
          ListTile(
            title: Text('Profile'),
            onTap: () {
              Navigator.pop(context); // Close the drawer
              // Navigate to Profile page here
            },
          ),
          ListTile(
            title: Text('Settings'),
            onTap: () {
              Navigator.pop(context); // Close the drawer
              // Navigate to Settings page here
            },
          ),
          ListTile(
            title: Text('Notifications'),
            onTap: () {
              Navigator.pop(context); // Close the drawer
              // Add actions here
            },
          ),
          ListTile(
            title: Text('Help'),
            onTap: () {
              Navigator.pop(context); // Close the drawer
              // Add actions here
            },
          ),
          ListTile(
            title: Text('Logout'),
            onTap: () {
              Navigator.pop(context); // Close the drawer
              // Add logout logic here
            },
          ),
        ],
      ),
    );
  }
}
