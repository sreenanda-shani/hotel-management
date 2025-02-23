import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'dart:developer';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Gemini.init(apiKey: apiKey);

  runApp(const MaterialApp(
    home: AiChatPage(),
    debugShowCheckedModeBanner: false,
  ));
}

const apiKey = 'AIzaSyBBuFxwyOb2LIbbl50qc1LXFZQBLO2Wd48';

class AiChatPage extends StatefulWidget {
  const AiChatPage({super.key});

  @override
  AiChatPageState createState() => AiChatPageState();
}

class AiChatPageState extends State<AiChatPage> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _chatHistory = [];
  bool _isLoading = false;
  final String currentUserId = FirebaseAuth.instance.currentUser!.uid;
  List<Map<String, dynamic>>? hotels;
  final List<String> _userInputHistory = [];

  String? instruction;

  @override
  void initState() {
    super.initState();
    _fetchHotelData();
  }

  void _systemPromptMaker() {
    setState(() {
      instruction = '''
      instruction = [
      {
        "system_instruction": "Your name is Hotel Ai, Your main goal is to assist the user to find the hotel with their choice . in there the user ask about hotels. I below provide the all hotel details in the hotels. is mus t be replay for the user inputs. in there i also provide the user previous inputs also , so consider that if usefull. this is yourrr system propmt not metion on the response , only consider the user_input only .",
        "user_previous_inputs" : $_userInputHistory,
        "hotels" : $hotels
        ]
      }
      ]
      ''';
    });
    print(instruction);
  }

  Future<void> _fetchHotelData() async {
    try {
      setState(() {
        _isLoading = true;
      });
      final hotelSnapshot = await FirebaseFirestore.instance
          .collection('hotels')
          .where('isApproved', isEqualTo: true)
          .get();

      if (hotelSnapshot.docs.isEmpty) {
        print('No hotels found'); // Debug print
      }

      setState(() {
        hotels = hotelSnapshot.docs.map((doc) {
          print('Processing hotel: ${doc['hotelName']}'); // Debug print
          return {
            'hotelName': doc['hotelName'],
            'facilities': doc['facilities'],
            'location': doc['location'],
            'numberOfRooms': doc['numberOfRooms'],
          };
        }).toList();
        _isLoading = false;
      });

      _systemPromptMaker();
    } catch (e) {
      print('Error fetching hotels: $e'); // Debug print
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _sendMessage(String userMessage) async {
    if (userMessage.trim().isEmpty) return;

    _userInputHistory.add(userMessage);
    if (_userInputHistory.length > 5) {
      // Keep last 5 messages
      _userInputHistory.removeAt(0);
    }

    setState(() {
      _chatHistory.add({'role': 'user', 'message': userMessage});
      _isLoading = true;
    });

    _systemPromptMaker();

    String modifiedUserInput = '''
$instruction,
"user_input": "$userMessage"
''';

    try {
      final gemini = Gemini.instance;

      final conversation = [
        ..._chatHistory.map(
          (msg) => Content(
            parts: [Part.text(msg['message']!)],
            role: msg['role'],
          ),
        ),
        Content(
          parts: [Part.text(modifiedUserInput)],
          role: 'user',
        ),
      ];

      // Call the Gemini API
      final response = await gemini.chat(conversation);

      // Add the model's response to the chat history
      setState(() {
        _chatHistory.add({
          'role': 'model',
          'message': response?.output ?? 'No response received',
        });
      });
    } catch (e) {
      // Log error for debugging
      log('Error in chat: $e');

      setState(() {
        _chatHistory.add({
          'role': 'error',
          'message': 'An error occurred. Please try again.',
        });
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Widget _buildMessageBubble(String message, String role) {
    bool isUser = role == 'user';
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
        padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 18.0),
        decoration: BoxDecoration(
          color: isUser ? Colors.blue : Colors.grey.shade300,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(20.0),
            topRight: const Radius.circular(20.0),
            bottomLeft: isUser ? const Radius.circular(20.0) : Radius.zero,
            bottomRight: isUser ? Radius.zero : const Radius.circular(20.0),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              offset: const Offset(0, 2),
              blurRadius: 4.0,
            ),
          ],
        ),
        child: Text(
          message,
          style: TextStyle(
            fontSize: 16.0,
            color: isUser ? Colors.white : Colors.black87,
            fontWeight: FontWeight.w400,
            height: 1.4,
          ),
        ),
      ),
    );
  }

  Widget _buildChatList() {
    return ListView.builder(
      itemCount: _chatHistory.length,
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      itemBuilder: (context, index) {
        final message = _chatHistory[index];
        return _buildMessageBubble(message['message']!, message['role']!);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: _chatHistory.isEmpty
                  ? const Center(
                      child: Text(
                        'Start a conversation with Hotel Ai',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    )
                  : _buildChatList(),
            ),
            if (_isLoading)
              const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: CircularProgressIndicator()),
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: TextField(
                        controller: _controller,
                        decoration: InputDecoration(
                          hintText: 'Type your message...',
                          hintStyle: TextStyle(color: Colors.grey[600]),
                          filled: true,
                          fillColor: Colors.grey[200],
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 16, horizontal: 16),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide:
                                const BorderSide(color: Colors.blueAccent),
                          ),
                        ),
                        minLines: 1,
                        maxLines: 5,
                        onSubmitted: (_) {
                          final message = _controller.text;
                          _controller.clear();
                          _sendMessage(message);
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 4),
                    child: IconButton(
                      icon: const Icon(
                        Icons.send,
                        color: Colors.blueAccent,
                      ),
                      onPressed: () {
                        final message = _controller.text;
                        _controller.clear();
                        _sendMessage(message);
                      },
                      splashColor: Colors.blueAccent.withOpacity(0.3),
                      splashRadius: 25,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}