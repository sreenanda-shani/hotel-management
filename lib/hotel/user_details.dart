import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserDetails extends StatefulWidget {
  final String userName;

  const UserDetails({super.key, required this.userName});

  @override
  _UserDetailsState createState() => _UserDetailsState();
}

class _UserDetailsState extends State<UserDetails> {
  final TextEditingController _reportController = TextEditingController();
  String? userId;

  Future<Map<String, dynamic>?> fetchUserData() async {
    try {
      QuerySnapshot userQuery = await FirebaseFirestore.instance
          .collection('booking')
          .where('name', isEqualTo: widget.userName)
          .get();

      if (userQuery.docs.isNotEmpty) {
        final userData = userQuery.docs.first.data() as Map<String, dynamic>?;
        userId = userQuery.docs.first.id; // Get the document ID
        return userData;
      }
    } catch (e) {
      debugPrint('Error fetching user data: $e');
    }
    return null;
  }

  Future<void> submitReport() async {
    if (userId != null && _reportController.text.isNotEmpty) {
      try {
        await FirebaseFirestore.instance.collection('reports').add({
          'userId': userId,
          'report': _reportController.text,
          'timestamp': FieldValue.serverTimestamp(),
        });
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Report submitted successfully.')),
        );
        _reportController.clear();
      } catch (e) {
        debugPrint('Error submitting report: $e');
      }
    }
  }

  void showReportDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Report User'),
          content: TextField(
            controller: _reportController,
            decoration: const InputDecoration(
              labelText: 'Enter report details',
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: submitReport,
              child: const Text('Submit'),
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
        title: const Text('User Profile'),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        elevation: 5.0,
      ),
      body: FutureBuilder<Map<String, dynamic>?> (
        future: fetchUserData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error loading profile data'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('No user data found'));
          }

          final userDetails = snapshot.data!;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 70,
                  backgroundColor: Colors.white,
                  child: CircleAvatar(
                    radius: 65,
                    backgroundColor: Colors.blue.shade100,
                    child: const Icon(
                      Icons.account_circle,
                      size: 130,
                      color: Colors.grey,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  userDetails['name'] ?? 'N/A',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 30),
                ProfileDetailCard(icon: Icons.person, label: 'Name', value: userDetails['name'] ?? 'N/A'),
                ProfileDetailCard(icon: Icons.email, label: 'Email', value: userDetails['email'] ?? 'N/A'),
                ProfileDetailCard(icon: Icons.phone, label: 'Mobile', value: userDetails['mobile'] ?? 'N/A'),
                ProfileDetailCard(icon: Icons.payment, label: 'Payment ID', value: userDetails['paymentId'] ?? 'N/A'),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: showReportDialog,
                  child: const Text('Report User'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class ProfileDetailCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const ProfileDetailCard({super.key, required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      elevation: 5.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(color: Colors.blue.withOpacity(0.2), shape: BoxShape.circle),
          child: Icon(icon, size: 30, color: Colors.blueAccent),
        ),
        title: Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black87)),
        subtitle: Text(value, style: const TextStyle(fontSize: 14, color: Colors.black54)),
      ),
    );
  }
}