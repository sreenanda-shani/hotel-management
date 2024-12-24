import 'package:flutter/material.dart';
import 'package:project1/user/ai_user_screen.dart';

class AiChatScreen extends StatelessWidget {
  const AiChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          ElevatedButton(onPressed: () {

            Navigator.push(context, MaterialPageRoute(builder: (context) => RoomFeaturesScreen(),));


            
          }, child: Text('price'))

        ],
      ),
    );
  }
}