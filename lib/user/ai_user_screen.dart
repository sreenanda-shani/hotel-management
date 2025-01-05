import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project1/api/ai_api.dart';
import 'package:project1/user/user_hotelhomepage.dart';
import 'package:url_launcher/url_launcher.dart';

class PredictionScreen extends StatefulWidget {
  const PredictionScreen({super.key});

  @override
  _PredictionScreenState createState() => _PredictionScreenState();
}

class _PredictionScreenState extends State<PredictionScreen> {
  // Controllers and initial values
  final TextEditingController onsiterateController = TextEditingController();
  final TextEditingController discountController = TextEditingController();
  final TextEditingController maxoccupancyController = TextEditingController();
  int airConditioning = 0;
  int tv = 0;
  int refrigerator = 0;
  int wifi = 0;

  String? predict;
  bool isLoading = false;
  var rooms;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hotel Prediction'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Input fields for numerical data
            _buildInputField(onsiterateController, 'Onsiterate'),
            _buildInputField(discountController, 'Discount'),
            _buildInputField(maxoccupancyController, 'Max Occupancy'),

            // Dropdowns for boolean values
            _buildDropdown('Air Conditioning', (value) {
              setState(() {
                airConditioning = value!;
              });
            }, airConditioning),
            _buildDropdown('TV', (value) {
              setState(() {
                tv = value!;
              });
            }, tv),
            _buildDropdown('Refrigerator', (value) {
              setState(() {
                refrigerator = value!;
              });
            }, refrigerator),
            _buildDropdown('Wi-Fi [free]', (value) {
              setState(() {
                wifi = value!;
              });
            }, wifi),

            // Submit Button
            ElevatedButton(
              onPressed: () async {
                try {
                  setState(() {
                    isLoading = true;
                  });

                  // Get input values
                  final onsiterate = int.tryParse(onsiterateController.text) ?? 0;
                  final discount = int.tryParse(discountController.text) ?? 0;
                  final maxoccupancy = int.tryParse(maxoccupancyController.text) ?? 0;

                  // Call the prediction API
                  predict = await makePredictionRequest(
                    onsiterate: onsiterate,
                    discount: discount,
                    maxoccupancy: maxoccupancy,
                    airConditioning: airConditioning,
                    tv: tv,
                    refrigerator: refrigerator,
                    wifi: wifi,
                  );

                  print("Prediction: $predict");

                  // Fetch data from Firebase based on prediction
                  final rooms = await fetchRoomsData(predict!);

                  setState(() {
                    isLoading = false;
                  });

                  // Navigate to RoomDetailsPage
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RoomListPage(roomData: rooms,prediction:predict),
                    ),
                  );
                } catch (e) {
                  print("Error: $e");
                  setState(() {
                    isLoading = false;
                  });
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              child: isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text(
                      'Get Prediction',
                      style: TextStyle(color: Colors.white),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to build input fields
  Widget _buildInputField(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          filled: true,
          fillColor: Colors.grey[200],
        ),
      ),
    );
  }

  // Helper method to build dropdowns for boolean values
  Widget _buildDropdown(String label, ValueChanged<int?> onChanged, int value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<int>(
        value: value,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          filled: true,
          fillColor: Colors.grey[200],
        ),
        items: const [
          DropdownMenuItem(
            value: 0,
            child: Text('False'),
          ),
          DropdownMenuItem(
            value: 1,
            child: Text('True'),
          ),
        ],
        onChanged: onChanged,
      ),
    );
  }

  // Helper method to fetch rooms data
  Future<List<Map<String, dynamic>>> fetchRoomsData(String roomType) async {
    final roomSnapshot = await FirebaseFirestore.instance
        .collection('rooms')
        .where('roomType', isEqualTo: roomType).where('rent' , isLessThanOrEqualTo:double.parse(onsiterateController.text))
        .get();

    final List<Map<String, dynamic>> fetchedRooms = [];

    for (var room in roomSnapshot.docs) {
      final hotelId = room['hotelId'];

      // Fetch hotel details
      final hotelSnapshot = await FirebaseFirestore.instance
          .collection('hotels')
          .doc(hotelId)
          .get();

      if (hotelSnapshot.exists) {
        fetchedRooms.add({
          ...room.data(),
          'hotelDetails': hotelSnapshot.data(),
        });
      }
    }

    return fetchedRooms;
  }
}







class RoomListPage extends StatelessWidget {
  final List<Map<String, dynamic>> roomData;
  final dynamic prediction;

  const RoomListPage({super.key, required this.roomData,required this.prediction});

  // Helper function to launch Google Maps with latitude and longitude
  void _launchMaps(double latitude, double longitude) async {
    final Uri googleMapsUrl = Uri.parse('https://www.google.com/maps?q=$latitude,$longitude');
    if (await canLaunchUrl(googleMapsUrl)) {
      await launchUrl(googleMapsUrl, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $googleMapsUrl';
    }
  }

  @override
  Widget build(BuildContext context) {
    print(roomData);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Room List'),
        backgroundColor: Colors.teal,
        
      ),
      body: roomData.isEmpty
          ?  Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('The Ai recommented room type  : ${prediction.toString()}'),
                  Text(
                    'No rooms found in your budget or type',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: roomData.length,
              itemBuilder: (context, index) {
                final room = roomData[index];
                final hotelDetails = room['hotelDetails'];

                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.hotel, color: Colors.teal, size: 24),
                            const SizedBox(width: 8),
                            Text(
                              'Room Type: ${room['roomType']}',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Rent: ₹${room['rent']}',
                          style: TextStyle(fontSize: 16, color: Colors.grey[800]),
                        ),
                        Text(
                          'Max People: ${room['maxPeople']}',
                          style: TextStyle(fontSize: 16, color: Colors.grey[800]),
                        ),
                        const SizedBox(height: 8),
                        if (hotelDetails != null) ...[
                          Row(
                            children: [
                              const Icon(Icons.apartment, color: Colors.teal, size: 20),
                              const SizedBox(width: 8),
                              Text(
                                'Hotel Name: ${hotelDetails['hotelName']}',
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              const Icon(Icons.location_on, color: Colors.teal, size: 20),
                              const SizedBox(width: 8),
                              Text(
                                'Location: ${hotelDetails['location']}',
                                style: const TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                          
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: () {
                                    print(hotelDetails);
                                     Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => UserHotelDetailsScreen(
                                      hotelDocumentId: roomData[index]['hotelId'],
                                    ),
                                  ),
                                );
                                  },
                                  icon: const Icon(Icons.book, color: Colors.white),
                                  label: const Text('Book now',style: TextStyle(color: Colors.white),),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.teal,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                  ),
                                ),
                              ),

                              SizedBox(width: 10,),
                                Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () => _launchMaps(
                                double.parse(hotelDetails['lat']),
                                double.parse(hotelDetails['log']),
                              ),
                              icon: const Icon(Icons.directions, color: Colors.white),
                              label: const Text('Route',style: TextStyle(color: Colors.white),),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.teal,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                              ),
                            ),
                          ),
                       
                            ],
                          ),
                        
                       
                       
                       
                        ],
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
