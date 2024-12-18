import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:project1/admin/screen/admin_hotel_details_screen.dart';

class AdminHotelManagementScreen extends StatefulWidget {
  const AdminHotelManagementScreen({Key? key}) : super(key: key);

  @override
  _AdminHotelManagementScreenState createState() =>
      _AdminHotelManagementScreenState();
}

class _AdminHotelManagementScreenState
    extends State<AdminHotelManagementScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  // Function to approve a hotel
  void _approveHotel(String hotelId) async {
    await FirebaseFirestore.instance
        .collection('hotels')
        .doc(hotelId)
        .update({'isApproved': true});
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Hotel approved successfully!')),
    );
    setState(() {});
  }

  // Function to reject a hotel
  void _rejectHotel(String hotelId) async {
    await FirebaseFirestore.instance
        .collection('hotels')
        .doc(hotelId)
        .delete();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Hotel rejected and removed!')),
    );
    setState(() {});
  }

  // Function to display hotel details
  void _showHotelDetails(BuildContext context, Map<String, dynamic> hotelData) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(hotelData['hotelName']),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.network(hotelData['imageUrl']),
                const SizedBox(height: 10),
                Text('Location: ${hotelData['location']}'),
                Text('Contact Email: ${hotelData['contactEmail']}'),
                Text('Contact Number: ${hotelData['contactNumber']}'),
                Text('Number of Rooms: ${hotelData['numberOfRooms']}'),
                Text('Facilities: ${hotelData['facilities'].join(", ")}'),
                Text('Latitude: ${hotelData['lat']}'),
                Text('Longitude: ${hotelData['log']}'),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }


Widget _buildHotelCard(Map<String, dynamic> hotelData, String hotelId) {
  return GestureDetector(
    onTap: () {
      Navigator.push(context, MaterialPageRoute(builder: (context) => HotelDetailsScreen(hotelData: hotelData,),));
    },
    child: Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // First Row: Image and Hotel Details
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Profile Image
                CircleAvatar(
                  backgroundImage: hotelData['imageUrl'] != null
                      ? NetworkImage(hotelData['imageUrl'])
                      : null,
                  backgroundColor: Colors.grey[200],
                  radius: 35,
                  child: hotelData['imageUrl'] == null
                      ? const Icon(Icons.hotel, size: 30, color: Colors.teal)
                      : null,
                ),
                const SizedBox(width: 16),
                // Hotel Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        hotelData['hotelName'],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Contact: ${hotelData['contactNumber']}',
                        style: const TextStyle(fontSize: 14, color: Colors.black54),
                      ),
                      Text(
                        'Email: ${hotelData['contactEmail']}',
                        style: const TextStyle(fontSize: 14, color: Colors.black54),
                      ),
                    ],
                  ),
                ),
              ],
            ),
             // Document Link Section
                  if (hotelData['document'] != null) ...[
                    const Divider(),
                    
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: () {
                        showDocumentImage(context, hotelData['document']);
                      },
                      child: const Text(
                        'View Document',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
            const SizedBox(height: 12),
            // Buttons Section: Full-Width Buttons
            Row(
              children: [
                if(!hotelData['isApproved'])
                Expanded(
                  
                  child: ElevatedButton.icon(
                    onPressed: () => _approveHotel(hotelId),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    icon: const Icon(Icons.check, color: Colors.white),
                    label: const Text(
                      'Approve',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
                          const SizedBox(width: 8),
    
                  Expanded(
              
              child: OutlinedButton.icon(
                onPressed: () => _rejectHotel(hotelId),
                style: OutlinedButton.styleFrom(
                  
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                icon: const Icon(Icons.close, color: Colors.red),
                label: const Text(
                  'Reject',
                  style: TextStyle(fontSize: 16, color: Colors.red),
                ),
              ),
            ),
          
              ],
            ),
          
          ],
        ),
      ),
    ),
  );
}





  Widget _buildHotelList(bool isApproved) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('hotels')
          .where('isApproved', isEqualTo: isApproved)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No hotels found.'));
        }

        final hotels = snapshot.data!.docs;

        return ListView.builder(
          itemCount: hotels.length,
          itemBuilder: (context, index) {
            final hotelData = hotels[index].data() as Map<String, dynamic>;
            final hotelId = hotels[index].id;

            return _buildHotelCard(hotelData, hotelId);
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hotel Management'),
        backgroundColor: Colors.teal,
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          tabs: const [
            Tab(icon: Icon(Icons.pending_actions,color: Colors.white,), text: 'Pending'),
            Tab(icon: Icon(Icons.check_circle,color: Colors.white,) ,text: 'Accepted'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildHotelList(false), // Pending
          _buildHotelList(true),  // Accepted
        ],
      ),
    );
  }
}
 // Show Document Image in a Popup
  void showDocumentImage(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 8),
              const Text(
                'Document Image',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal,
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 250,
                width: double.infinity,
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  'Close',
                  style: TextStyle(color: Colors.teal),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

