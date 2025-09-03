import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<Map<String, String>> _currentMessages = [];
  final List<Map<String, dynamic>> _chatHistory = [];
  int? _selectedChatIndex;
  bool _isSidebarVisible = true;

  // Fonction pour détecter les messages simples (greetings, merci, etc.)
  bool _isSimpleMessage(String message) {
    final simpleMessages = [
      'bonjour', 'merci', 'hello', 'good morning', 'salut', 'good evening'
    ];
    return simpleMessages.any((element) => message.toLowerCase().contains(element));
  }

  @override
  void initState() {
    super.initState();
    // Ajouter un message de bienvenue de Jurisys lorsque l'utilisateur entre dans le chat
    _currentMessages.add({
      'sender': 'jurisys',
      'message': 'Bienvenue dans Jurisys, comment puis-je vous aider aujourd\'hui ?',
    });
  }

  void _sendMessage() async {
    String userMessage = _messageController.text.trim();

    if (userMessage.isNotEmpty) {
      setState(() {
        _currentMessages.add({'sender': 'user', 'message': userMessage});
      });

      // Vérifier si c'est un message simple ou juridique
      if (_isSimpleMessage(userMessage)) {
        String simpleResponse = _getSimpleResponse(userMessage);
        setState(() {
          _currentMessages.add({'sender': 'jurisys', 'message': simpleResponse});
        });
      } else {
        // Envoyer la requête HTTP pour obtenir la réponse juridique
        String jurisysResponse = await _getJurisysResponse(userMessage);
        setState(() {
          _currentMessages.add({'sender': 'jurisys', 'message': jurisysResponse});
        });
      }

      _messageController.clear();
    }
  }

  // Réponse simple pour les messages courants
  String _getSimpleResponse(String userMessage) {
    final simpleResponses = {
      'bonjour': 'Bonjour, comment puis-je vous aider ?',
      'merci': 'De rien ! N\'hésitez pas à poser d\'autres questions.',
      'hello': 'Hello, how can I assist you today?',
      'good morning': 'Good morning! How can I help?',
      'salut': 'Salut, comment puis-je t\'aider ?',
      'good evening': 'Good evening! What can I do for you?'
    };

    return simpleResponses[userMessage.toLowerCase()] ?? 'Salut, comment puis-je vous aider ?';
  }

  Future<String> _getJurisysResponse(String userMessage) async {
    final url = Uri.parse('http://127.0.0.1:5000/get_answer'); // URL du backend Python
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'context': 'Le droit administratif régit les relations entre l\'administration publique et les citoyens...',
        'question': userMessage,
      }),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['answer'];
    } else {
      return 'Désolé, je n\'ai pas pu trouver une réponse.';
    }
  }

  void _startNewChat() {
    if (_currentMessages.isNotEmpty) {
      setState(() {
        _chatHistory.add({
          'title': 'Chat ${_chatHistory.length + 1}',
          'messages': List<Map<String, String>>.from(_currentMessages),
        });
        _currentMessages.clear();
        _selectedChatIndex = null;
      });
    }
  }

  void _loadChat(int index) {
    setState(() {
      _currentMessages.clear();
      _currentMessages.addAll(List<Map<String, String>>.from(_chatHistory[index]['messages']));
      _selectedChatIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
      ),
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context); // Retourner à la page précédente
            },
          ),
          backgroundColor: Colors.grey.shade900,
          actions: [
            IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                setState(() {
                  _isSidebarVisible = !_isSidebarVisible;
                });
              },
            ),
          ],
        ),
        body: Row(
          children: [
            if (_isSidebarVisible)
              Container(
                width: 250,
                color: Colors.grey.shade900,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton.icon(
                        onPressed: _startNewChat,
                        icon: const Icon(Icons.add),
                        label: const Text('Nouveau Chat'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                    const Divider(color: Colors.white),
                    Expanded(
                      child: ListView.builder(
                        itemCount: _chatHistory.length,
                        itemBuilder: (context, index) {
                          final chat = _chatHistory[index];
                          return ListTile(
                            title: Text(
                              chat['title'],
                              style: const TextStyle(color: Colors.white),
                            ),
                            selected: index == _selectedChatIndex,
                            selectedTileColor: Colors.blue.shade800,
                            onTap: () => _loadChat(index),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            Expanded(
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: _currentMessages.length,
                      itemBuilder: (context, index) {
                        final message = _currentMessages[index];
                        final isUserMessage = message['sender'] == 'user';

                        return Align(
                          alignment: isUserMessage ? Alignment.centerRight : Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: isUserMessage ? Colors.blue.shade700 : Colors.grey.shade800,
                                borderRadius: BorderRadius.only(
                                  topLeft: const Radius.circular(10),
                                  topRight: const Radius.circular(10),
                                  bottomLeft: isUserMessage ? const Radius.circular(10) : const Radius.circular(0),
                                  bottomRight: isUserMessage ? const Radius.circular(0) : const Radius.circular(10),
                                ),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                              child: Text(
                                message['message']!,
                                style: const TextStyle(color: Colors.white, fontSize: 16.0),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _messageController,
                            decoration: InputDecoration(
                              hintText: 'Envoyer un message...',
                              hintStyle: const TextStyle(color: Colors.white54),
                              filled: true,
                              fillColor: Colors.grey.shade900,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        const SizedBox(width: 8.0),
                        IconButton(
                          icon: const Icon(Icons.send),
                          color: Colors.blue,
                          onPressed: _sendMessage,
                        ),
                      ],
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
