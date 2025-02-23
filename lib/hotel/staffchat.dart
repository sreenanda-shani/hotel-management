import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class StaffChatPage extends StatefulWidget {
  StaffChatPage({super.key});

  @override
  State<StaffChatPage> createState() => _StaffChatPageState();
}

class _StaffChatPageState extends State<StaffChatPage> {
  String? contractorId;
  List<Map<String, dynamic>> staffList = [];

  @override
  void initState() {
    super.initState();
    _fetchContractorId();
  }

  Future<void> _fetchContractorId() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        contractorId = user.uid;
      });
      _fetchStaff(contractorId!);
    }
  }

  Future<void> _fetchStaff(String contractorId) async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('staff')
          .where('hotelUid', isEqualTo: contractorId)
          .get();

      setState(() {
        staffList = snapshot.docs.map((doc) {
          final data = doc.data();
          data['id'] = doc.id;
          return data;
        }).toList();
      });
    } catch (e) {
      print("Error fetching staff: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Staff List',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
        centerTitle: true,
      ),
      body: staffList.isEmpty
          ? const Center(
              child: Text(
                "No assigned staff.",
                style: TextStyle(fontSize: 18),
              ),
            )
          : ListView.builder(
              itemCount: staffList.length,
              itemBuilder: (context, index) {
                final staff = staffList[index];
                final staffName = staff['fullName'] ?? 'Unknown Staff';
                final staffId = staff['id'];

                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  elevation: 2.0,
                  child: ListTile(
                    leading: const Icon(Icons.person, color: Colors.green),
                    title: Text(
                      staffName,
                      style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
                    ),
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => StaffChatScreen(recipientId: staffId,),));
                    },
                  ),
                );
              },
            ),
    );
  }
}


class StaffChatScreen extends StatefulWidget {
  final String recipientId; // Recipient ID to identify the chat

  const StaffChatScreen({super.key, required this.recipientId});

  @override
  _StaffChatScreenState createState() => _StaffChatScreenState();
}

class _StaffChatScreenState extends State<StaffChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  late String currentUserId;
  late CollectionReference messagesCollection;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Get the current user's ID
    currentUserId = FirebaseAuth.instance.currentUser!.uid;
    // Reference to the 'chats' collection
    messagesCollection = FirebaseFirestore.instance.collection('chats');
  }

  // Send message to Firestore
  Future<void> _sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      await messagesCollection.add({
        'senderId': currentUserId,
        'receiverId': widget.recipientId,
        'message': _messageController.text,
        'timestamp': FieldValue.serverTimestamp(),
      });
      _messageController.clear();
      _scrollToBottom(); // Scroll to the latest message
    }
  }

  // Scroll to the latest message
  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.minScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  // Build the message list
  Widget _buildMessageList() {
    return StreamBuilder<QuerySnapshot>(
      stream: messagesCollection
          .where('senderId', whereIn: [
        currentUserId,
        widget.recipientId
      ]).where('receiverId',
              whereIn: [currentUserId, widget.recipientId]).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final messages = snapshot.data!.docs;

        return ListView.builder(
          controller: _scrollController,
          reverse: true, // Reverse for WhatsApp-style ordering
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
                      '${timestamp.hour}:${timestamp.minute.toString().padLeft(2, '0')}',
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
      appBar: AppBar(
        title: const Text("Chat"),
        backgroundColor: Colors.green,
      ),
      body: Column(
        children: [
          // Message List
          Expanded(child: _buildMessageList()),

          // Message Input Area
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
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
