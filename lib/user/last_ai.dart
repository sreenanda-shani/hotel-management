import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:developer';

const apiKey = 'AIzaSyCD8u6ra1ix2Ttbjsfb6GyCFGYxxWGG48g';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Gemini.init(apiKey: apiKey);

  runApp(const MaterialApp(
    home: AiChatPage(),
    debugShowCheckedModeBanner: false,
  ));
}



class AiChatPage extends StatefulWidget {
  const AiChatPage({super.key});

  @override
  AiChatPageState createState() => AiChatPageState();
}

class AiChatPageState extends State<AiChatPage> {
  final TextEditingController _controller = TextEditingController();
  final String _chatStorageKey = 'ai_chat_history';
  final List<String> _userInputHistory = [];
  late SharedPreferences _prefs;
  List<Map<String, String>> _chatHistory = [];
  List<Map<String, dynamic>>? usersPosts;
  Map<String, dynamic>? _currentUserDetails;
  int? userAge;
  String? 
      instruction;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initializeStorage();
  }

  Future<void> _initializeStorage() async {
    _prefs = await SharedPreferences.getInstance();
    _loadChatHistory();
  }

  Future<void> _loadChatHistory() async {
    try {
      final String? chatHistoryJson = _prefs.getString(_chatStorageKey);
      if (chatHistoryJson != null) {
        final List<dynamic> decodedList = json.decode(chatHistoryJson);
        if (mounted) {
          setState(() {
            _chatHistory = decodedList
                .map((item) => Map<String, String>.from(item))
                .toList();
          });
        }
      }
    } catch (e) {
      log('Error loading chat history: $e');
    }
  }

  Future<void> _saveChatHistory() async {
    try {
      final String chatHistoryJson = json.encode(_chatHistory);
      await _prefs.setString(_chatStorageKey, chatHistoryJson);
    } catch (e) {
      log('Error saving chat history: $e');
    }
  }

  void _addMessageToHistory(Map<String, String> message) {
    if (message['role'] != 'error') {
      if (mounted) {
        setState(() {
          _chatHistory.add(message);
        });
      }
      _saveChatHistory();
    } else {
      if (mounted) {
        setState(() {
          _chatHistory.add(message);
        });
        Future.delayed(const Duration(seconds: 5), () {
          if (mounted) {
            setState(() {
              _chatHistory.removeWhere((msg) =>
                  msg['role'] == 'error' &&
                  msg['message'] == message['message']);
            });
          }
        });
      }
    }
  }

  void _systemPromptMaker() {
    if (mounted) {
      setState(() {
        instruction = '''
      instruction = [ { "system_instruction": "You are Explore AI, an intelligent assistant for the Explore Together application. Your primary role is to assist users who interact with this app. The application's main goal is to connect solo travelers with groups. In the user_details, where i provide the details of current chating user. So mention the username in greeting responses, only on important. In there i also provide the user previous inputs also , so consider that if usefull. Provide simple and clear responses to 'user_input'. Now i am explaining the app usage in detail. In this app in the Home Page user Can see the Posts of All users (current user can also uplaod post based on their interest), when in the post there if the current user is arracted then the user can chat with that user. in that case of post there many user will chat with that post uploaded user. at that time in the app there is option of creating chat group and disscuss about there plan. And make trip. Also in this App that provide many trip packages. user can also considerr that in their trip. In my App  then main Feature is the user can follow another user and make their budddy. In the 'all_users_post' i will provide the all posts uploaded by the user, where have triplocation, planToVisitPlacesInTrip, and post uplaoded user Details (username and location).if th user ask about any user that in the all_users_post, give the details with one or 2 posts details of that user. if the user ask about the trip location, 'anything like i want to got to trip' in the time you must ask interest and suguust tge loaction from the post triplocation and planToVisitPlacesInTrip . In there i provide the tripCompleted , that is the posted user complete that trip or not. if completed, then not consider that in the finding place to user. beacuse that is alrready completed.","navigation_in_app": {"Find Travel Buddies" : "Search for your desired location in the Home section > Browse potential matches and start chatting and Create Group", "Edit Profile" : "Go to your profile > Tap Edit Profile or navigate to Settings > Account Management > Edit Profile" , "Go to your profile > Navigate to Settings > Account Management > Change Password"}]''';
      });
    }
  }

 

  Future<void> clearChatHistory() async {
    try {
      await _prefs.remove(_chatStorageKey);
      if (mounted) {
        setState(() {
          _chatHistory = [];
        });
      }
    } catch (e) {
      log('Error clearing chat history: $e');
    }
  }

  Future<void> _showClearChatDialog() async {


    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text(
            'Clear Chat History',
            style: TextStyle(color: Colors.black),
          ),
          content: Text(
            'Are you sure you want to clear all chat history? This action cannot be undone.',
            style: TextStyle(color: Colors.black),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.black),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text(
                'Clear',
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () {
                clearChatHistory();
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Chat history cleared'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  
  void _sendMessage(String userMessage) async {
    if (userMessage.trim().isEmpty) return;

    _userInputHistory.add(userMessage);
    if (_userInputHistory.length > 5) {
      _userInputHistory.removeAt(0);
    }

    _addMessageToHistory({'role': 'user', 'message': userMessage});

    if (mounted) {
      setState(() {
        _isLoading = true;
      });
    }

    _systemPromptMaker();

    String modifiedUserInput =
        '''$instruction,  "user_input": "$userMessage"''';

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
      final response = await gemini.chat(conversation);
      if (mounted) {
        setState(() {
          _addMessageToHistory({
            'role': 'model',
            'message': response?.output ?? 'No response received',
          });
        });
      }
    } catch (e) {
      log('Error in chat: $e');
      if (mounted) {
        setState(() {
          _addMessageToHistory({
            'role': 'error',
            'message':
                'Response not loading. Please try again or check your internet connection.',
          });
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Widget _buildMessageBubble(String message, String role,
      {bool isLoading = false}) {

    bool isUser = role == 'user';
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
        padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 18.0),
        decoration: BoxDecoration(
          color: isUser ? Colors.blue : Colors.blueGrey,
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
        child: isLoading
            ? const CircularProgressIndicator()
            : Text(
                message,
                style: TextStyle(
                  fontSize: 16.0,
                  color: isUser ? Colors.white : Colors.white,
                  fontWeight: FontWeight.w400,
                  height: 1.4,
                ),
              ),
      ),
    );
  }

  Widget _buildChatList() {
    return ListView.builder(
      itemCount: _chatHistory.length + (_isLoading ? 1 : 0),
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      itemBuilder: (context, index) {
        if (index == _chatHistory.length && _isLoading) {
          return _buildMessageBubble('', 'model', isLoading: true);
        }
        final message = _chatHistory[index];
        return _buildMessageBubble(message['message']!, message['role']!);
      },
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Padding(
          padding: EdgeInsets.only(left: 0.0),
          child: Row(
            children: [
              CircleAvatar(
                backgroundImage:
                    AssetImage('assets/system/iconImage/aiIcon.png'),
                backgroundColor: Colors.blue,
                radius: 16,
              ),
              SizedBox(width: 10),
              Text(
                'Explore Ai',
                style: TextStyle(fontSize: 18, color: Colors.black),
              ),
            ],
          ),
        ),
        actions: [
          if (_chatHistory.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: _showClearChatDialog,
              tooltip: 'Clear chat history',
            ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: _chatHistory.isEmpty
                  ? Center(
                      child: Text(
                        'Start a conversation with Explore Ai',
                        style:
                            TextStyle(fontSize: 16, color: Colors.black),
                      ),
                    )
                  : _buildChatList(),
            ),
            const Divider(height: 1),
            Container(
              color:Colors.blue,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: TextField(
                          controller: _controller,
                          decoration: InputDecoration(
                            hintText: 'Type a message...',
                            hintStyle: TextStyle(
                                color:Colors.black,
                                fontSize: 16),
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 16, horizontal: 16),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide.none,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          minLines: 1,
                          maxLines: 5,
                          onSubmitted: (_) {
                            final message = _controller.text;
                            _controller.clear();
                            _sendMessage(message);
                          },
                          style: TextStyle(color: Colors.black),
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
            ),
          ],
        ),
      ),
    );
  }
}