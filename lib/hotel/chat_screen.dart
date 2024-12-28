import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  final String senderId; // Accept senderId as a parameter

  const ChatScreen({super.key, required this.senderId}); // Pass senderId during instantiation

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  TextEditingController _messageController = TextEditingController();
  String? _currentUserId;

  @override
  void initState() {
    super.initState();
    _getCurrentUserId();
  }

  // Fetch current user ID
  Future<void> _getCurrentUserId() async {
    User? user = _auth.currentUser;
    setState(() {
      _currentUserId = user?.uid;
    });
  }

  // Send message to Firestore
  Future<void> _sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      await _firestore.collection('chats').add({
        'message': _messageController.text,
        'senderId': _currentUserId, // Use the current user as sender
        'receiverId': widget.senderId, // The other user is the receiver
        'timestamp': FieldValue.serverTimestamp(),
      });
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chat"),
        backgroundColor: Colors.teal,
        elevation: 0.0,
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Display chat messages
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection('chats')
                  .where('receiverId', isEqualTo: _currentUserId) // Filter by receiverId (current user)
                  .where('senderId', isEqualTo: widget.senderId) // Filter by senderId (passed as argument)
                  .orderBy('timestamp') // Order messages by timestamp
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                var messages = snapshot.data!.docs;
                List<Widget> messageWidgets = [];
                for (var message in messages) {
                  var messageText = message['message'];
                  var messageSender = message['senderId'];
                  var timestamp = (message['timestamp'] as Timestamp).toDate();

                  // Determine alignment based on senderId
                  Alignment messageAlignment = (messageSender == _currentUserId)
                      ? Alignment.centerRight // Sent message
                      : Alignment.centerLeft; // Received message

                  messageWidgets.add(
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5.0),
                      child: Align(
                        alignment: messageAlignment,
                        child: Material(
                          color: messageSender == _currentUserId
                              ? Colors.teal.shade100 // Color for sent messages (right side)
                              : Colors.grey.shade300, // Color for received messages (left side)
                          borderRadius: BorderRadius.circular(20),
                          elevation: 1.0,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 10),
                            child: Column(
                              crossAxisAlignment: messageSender == _currentUserId
                                  ? CrossAxisAlignment.end
                                  : CrossAxisAlignment.start,
                              children: [
                                // Sender's name and message
                                Text(
                                  messageSender ?? 'Unknown Sender',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  messageText,
                                  style: const TextStyle(color: Colors.black87),
                                ),
                                // Timestamp display
                                Padding(
                                  padding: const EdgeInsets.only(top: 5),
                                  child: Text(
                                    "${timestamp.hour}:${timestamp.minute < 10 ? '0' : ''}${timestamp.minute}",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }

                return ListView(
                  reverse: true, // Scroll to the bottom
                  padding: const EdgeInsets.all(8.0),
                  children: messageWidgets,
                );
              },
            ),
          ),
          // Text input and send button
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.attach_file, color: Colors.grey),
                  onPressed: () {
                    // Add file attachment functionality
                  },
                ),
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      hintStyle: TextStyle(color: Colors.grey.shade500),
                      filled: true,
                      fillColor: Colors.grey.shade200,
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 16),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    maxLines: null, // Allow multiple lines
                    keyboardType: TextInputType.multiline,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.teal),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
