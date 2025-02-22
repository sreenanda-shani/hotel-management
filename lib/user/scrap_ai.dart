import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class HotelScraperPage extends StatefulWidget {
  @override
  _HotelScraperPageState createState() => _HotelScraperPageState();
}

class _HotelScraperPageState extends State<HotelScraperPage> {
  final TextEditingController cityController = TextEditingController();
  final TextEditingController priceLimitController = TextEditingController();
  List<dynamic> hotels = [];
  bool isLoading = false;

  Future<void> fetchHotels() async {
    final String city = cityController.text;
    final String priceLimit = priceLimitController.text;

    if (city.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please enter a city name")),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final Uri url = Uri.parse(
          'https://a464-2409-4073-4e34-5df6-9573-50fa-3a05-d0f4.ngrok-free.app?city=$city&price_limit=$priceLimit');

      final response = await http.get(url);

      if (response.statusCode == 200) {
        setState(() {
          hotels = json.decode(response.body);
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to fetch hotels")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Hotel Scraper"),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: cityController,
              decoration: InputDecoration(
                labelText: "Enter city name",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: priceLimitController,
              decoration: InputDecoration(
                labelText: "Enter price limit (optional)",
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: fetchHotels,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                padding: EdgeInsets.symmetric(vertical: 12.0),
                textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              child: isLoading
                  ? CircularProgressIndicator(color: Colors.white)
                  : Text("Fetch Hotels", style: TextStyle(color: Colors.white)),
            ),
            SizedBox(height: 20),
            Expanded(
              child: hotels.isEmpty
                  ? Center(child: Text("No hotels found"))
                  : ListView.builder(
                      itemCount: hotels.length,
                      itemBuilder: (context, index) {
                        final hotel = hotels[index];
                        return Card(
                          margin: EdgeInsets.symmetric(vertical: 8.0),
                          child: ListTile(
                            title: Text(hotel['name'] ?? "Unknown Hotel"),
                            subtitle: Text("Price: ${hotel['price']}"),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
