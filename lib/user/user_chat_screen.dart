import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserChatScreen extends StatefulWidget {
  UserChatScreen({super.key, required this.hotelId});

  String hotelId;

  @override
  State<UserChatScreen> createState() => _UserChatScreenState();
}

class _UserChatScreenState extends State<UserChatScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  TextEditingController _messageController = TextEditingController();
  String? _currentUserId;

  @override
  void initState() {
    super.initState();
    _getCurrentUserId();
  }

  Future<void> _getCurrentUserId() async {
    User? user = _auth.currentUser;
    setState(() {
      _currentUserId = user?.uid;
    });
  }

  Future<void> _sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      await _firestore.collection('chats').add({
        'message': _messageController.text,
        'senderId': _currentUserId,
        'timestamp': FieldValue.serverTimestamp(),
        'receiverId': widget.hotelId, // The receiverId is the hotelId
      });
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chat with Hotel"),
        backgroundColor: Colors.teal,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Chat messages display area
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection('chats')
                  .where('receiverId', isEqualTo: widget.hotelId) // Filter by hotelId (receiver)
                  .orderBy('timestamp')
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

                  bool isSentByUser = messageSender == _currentUserId;

                  messageWidgets.add(
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Align(
                        alignment: isSentByUser
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 10),
                          decoration: BoxDecoration(
                            color: isSentByUser
                                ? Colors.teal.shade100
                                : Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            messageText,
                            style: TextStyle(
                              fontSize: 16,
                              color: isSentByUser ? Colors.black : Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }

                return ListView(
                  children: messageWidgets,
                );
              },
            ),
          ),

          // Text input and send button area
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                // Message input field
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      filled: true,
                      fillColor: Colors.grey.shade200,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 20),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                // Send button
                IconButton(
                  icon: const Icon(
                    Icons.send,
                    color: Colors.teal,
                    size: 28,
                  ),
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
