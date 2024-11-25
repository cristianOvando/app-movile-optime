import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ChatbotPage(),
    );
  }
}

class ChatbotPage extends StatefulWidget {
  const ChatbotPage({super.key});

  @override
  _ChatbotPageState createState() => _ChatbotPageState();
}

class _ChatbotPageState extends State<ChatbotPage> {
  final String apiKey = '';
  final String apiUrl =
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash-latest:generateContent?key=AIzaSyDjnR4t4xfwYQ44yuE7MNcsOqBlEV289Nc';
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _messages = [];
  final List<Map<String, String>> _history = []; // Contexto de la conversación

  Future<void> sendMessage(String message) async {
    try {
      setState(() {
        _messages.add({"sender": "user", "message": message});
        _history.add({"sender": "user", "message": message});
      });

      final apiResponse = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          "contents": [
            {
              "parts": [
                {"text": message}
              ]
            }
          ]
        }),
      );

      if (apiResponse.statusCode == 200) {
        final data = json.decode(apiResponse.body);
        final botMessage = data["candidates"]?[0]["content"]?["parts"]?[0]
                ["text"] ??
            'No hubo respuesta';

        setState(() {
          _messages.add({"sender": "bot", "message": botMessage});
          _history.add({"sender": "bot", "message": botMessage});
        });
      } else {
        setState(() {
          _messages.add({
            "sender": "bot",
            "message": "Error: ${apiResponse.statusCode} - ${apiResponse.body}"
          });
        });
      }

      _controller.clear();
    } catch (e) {
      setState(() {
        _messages.add({
          "sender": "bot",
          "message": "Error: No hay conexión a Internet."
        });
      });
    }
  }

  void _clearChat() {
    setState(() {
      _messages.clear();
      _history.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chatbot'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            color: Colors.black54, // Icono en un color discreto
            onPressed: _clearChat,
          ),
        ],
        backgroundColor: Colors.white.withOpacity(0.9), // Fondo transparente
        elevation: 0, // Sin sombra
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(10.0),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                final isUserMessage = message['sender'] == 'user';
                return Align(
                  alignment: isUserMessage
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 5.0),
                    padding: const EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                      color: isUserMessage
                          ? Colors.blueAccent
                          : Colors.grey[300],
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: Text(
                      message['message']!,
                      style: TextStyle(
                        color: isUserMessage ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: 'Escribe un mensaje...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8.0),
                IconButton(
                  icon: const Icon(Icons.send),
                  color: Colors.blueAccent,
                  onPressed: () {
                    if (_controller.text.isNotEmpty) {
                      sendMessage(_controller.text);
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
