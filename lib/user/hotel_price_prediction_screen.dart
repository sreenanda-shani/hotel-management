
import 'package:flutter/material.dart';
import 'package:project1/user/ai_user_screen.dart';
import 'package:webview_flutter/webview_flutter.dart';

class AiChatScreen extends StatefulWidget {
  const AiChatScreen({super.key});

  @override
  State<AiChatScreen> createState() => _AiChatScreenState();
}

class _AiChatScreenState extends State<AiChatScreen> {

   late final WebViewController _controller;


   @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Optional: Update a progress bar or loader if required.
          },
          onPageStarted: (String url) {
            print('Page started loading: $url');
          },
          onPageFinished: (String url) {
            print('Page finished loading: $url');
          },
          onWebResourceError: (WebResourceError error) {
            print('Error loading resource: ${error.description}');
          },
        ),
      )
      ..loadHtmlString('''
          <!DOCTYPE html>
          <html lang="en">
          <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Chatbot</title>
            <style>
              body {
                margin: 0;
                padding: 0;
                display: flex;
                justify-content: center;
                align-items: center;
                height: 100vh;
                background-color: #f0f0f0;
              }
              iframe {
                width: 100%;
                max-width: 400px;
                height: 90vh;
                border: none;
                box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
                border-radius: 10px;
              }
            </style>
          </head>
          <body>
            <iframe
              src="https://www.chatbase.co/chatbot-iframe/mmesoypWXYoGkMComMcBa"
              allow="camera; microphone; autoplay; encrypted-media"
            ></iframe>
          </body>
          </html>
      ''');
  }

  @override
  Widget build(BuildContext context) {




    return Scaffold(
      appBar: AppBar(
        title: const Text('AI'),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          ElevatedButton(onPressed: () {

            Navigator.push(context, MaterialPageRoute(builder: (context) => const PredictionScreen(),));


            
          }, child: const Text('Explore with ai'))

        ],
      ),
    );
  }
}
