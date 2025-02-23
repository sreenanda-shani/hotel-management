import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HotelChatScreen extends StatefulWidget {
  const HotelChatScreen({super.key});

  @override
  HotelChatScreenState createState() => HotelChatScreenState();
}

class HotelChatScreenState extends State<HotelChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  late String currentUserId;
  late CollectionReference messagesCollection;
  bool loading = false;
  String? receiverId;

  @override
  void initState() {
    super.initState();
    currentUserId = FirebaseAuth.instance.currentUser?.uid ?? '';
    messagesCollection = FirebaseFirestore.instance.collection('chats');
    getStaffData();
  }

  Future<void> getStaffData() async {
    try {
      setState(() {
        loading = true;
      });

      final documentSnapshot = await FirebaseFirestore.instance
          .collection("staff")
          .doc(currentUserId)
          .get();

      if (documentSnapshot.exists) {
        final data = documentSnapshot.data();
        receiverId = data?['hotelUid'];
      }
    } catch (e) {
      print("Error fetching staff data: $e");
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  Future<void> sendMessage() async {
    if (_messageController.text.isNotEmpty && receiverId != null) {
      await messagesCollection.add({
        'senderId': currentUserId,
        'receiverId': receiverId,
        'message': _messageController.text,
        'timestamp': FieldValue.serverTimestamp(),
      });
      _messageController.clear();
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  Widget buildMessageList() {
    if (receiverId == null) {
      return const Center(
        child: Text("No receiver assigned for this chat."),
      );
    }

    return StreamBuilder<QuerySnapshot>(
      stream: messagesCollection
          .where('senderId', whereIn: [currentUserId, receiverId])
          .where('receiverId', whereIn: [currentUserId, receiverId])
          .orderBy('timestamp', descending: false)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final messages = snapshot.data?.docs ?? [];
        return ListView.builder(
          controller: _scrollController,
          itemCount: messages.length,
          itemBuilder: (context, index) {
            final message = messages[index];
            final senderId = message['senderId'];
            final text = message['message'];
            final timestamp = message['timestamp']?.toDate() ?? DateTime.now();
            final isSentByCurrentUser = senderId == currentUserId;

            return Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
              child: Align(
                alignment: isSentByCurrentUser
                    ? Alignment.centerRight
                    : Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: isSentByCurrentUser
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 14.0),
                      decoration: BoxDecoration(
                        color: isSentByCurrentUser
                            ? Colors.green
                            : Colors.grey[300],
                        borderRadius: BorderRadius.only(
                          topLeft: const Radius.circular(16.0),
                          topRight: const Radius.circular(16.0),
                          bottomLeft: isSentByCurrentUser
                              ? const Radius.circular(16.0)
                              : Radius.zero,
                          bottomRight: isSentByCurrentUser
                              ? Radius.zero
                              : const Radius.circular(16.0),
                        ),
                      ),
                      child: Text(
                        text,
                        style: TextStyle(
                          color: isSentByCurrentUser
                              ? Colors.white
                              : Colors.black87,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      '${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}',
                      style: const TextStyle(fontSize: 10, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(child: buildMessageList()),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _messageController,
                          decoration: InputDecoration(
                            hintText: "Type a message...",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 16.0),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.send, color: Colors.green),
                        onPressed: sendMessage,
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}