import 'package:flutter/material.dart';

class ChatJuridismeScreen extends StatefulWidget {
  const ChatJuridismeScreen({Key? key}) : super(key: key);

  @override
  _ChatJuridismeScreenState createState() => _ChatJuridismeScreenState();
}

class _ChatJuridismeScreenState extends State<ChatJuridismeScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<Map<String, String>> _messages = [];
  final String _accessKey = 'mysecretkey'; // Clé d'accès pour la page payante
  bool _isAccessGranted = false; // Variable pour vérifier l'accès
  bool _showAccessError = false; // Affiche un message d'erreur si la clé est incorrecte

  void _sendMessage() {
    String userMessage = _messageController.text.trim();

    if (userMessage.isNotEmpty) {
      setState(() {
        _messages.add({'sender': 'user', 'message': userMessage});
        String response = _getJuridismeResponse(userMessage);
        _messages.add({'sender': 'juridisme', 'message': response});
      });

      _messageController.clear();
    }
  }

  String _getJuridismeResponse(String userMessage) {
    userMessage = userMessage.toLowerCase();

    // Exemple de réponse spécifique pour Juridisme payant
    if (userMessage.contains('bonjour')) {
      return 'Bonjour, vous êtes en contact avec notre service juridique payant. Comment puis-je vous aider?';
    } else if (userMessage.contains('avocat')) {
      return 'Pour une consultation juridique payante, contactez notre équipe. Nous vous guiderons vers un avocat compétent.';
    } else if (userMessage.contains('merci')) {
      return 'Merci pour votre message. N\'hésitez pas à nous recontacter pour toute question juridique.';
    } else {
      return 'Je suis à votre disposition pour toute demande juridique. Comment puis-je vous aider?';
    }
  }

  void _requestAccess() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Enter Access Key'),
        content: TextField(
          obscureText: true,
          decoration: const InputDecoration(hintText: 'Enter your key'),
          onChanged: (value) {
            setState(() {
              _showAccessError = false; // Réinitialiser l'erreur à chaque modification
            });
          },
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('OK'),
            onPressed: () {
              if (_messageController.text.trim() == _accessKey) {
                setState(() {
                  _isAccessGranted = true;
                });
                Navigator.of(context).pop();
              } else {
                setState(() {
                  _showAccessError = true; // Afficher l'erreur
                });
              }
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    if (!_isAccessGranted) {
      _requestAccess(); // Demander la clé d'accès
      return Scaffold(
        appBar: AppBar(
          title: const Text('Chat with Juridisme (Paid)'),
          backgroundColor: Colors.blue,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Please enter the access key to continue'),
              if (_showAccessError)
                const Text(
                  'Incorrect key! Please try again.',
                  style: TextStyle(color: Colors.red),
                ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat with Juridisme (Paid)'),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                final isUserMessage = message['sender'] == 'user';

                return Align(
                  alignment: isUserMessage ? Alignment.centerRight : Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: isUserMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
                      children: [
                        if (!isUserMessage)
                          const CircleAvatar(
                            backgroundColor: Colors.white,
                            child: Icon(Icons.person, color: Colors.blue),
                          ),
                        const SizedBox(width: 8.0),
                        Flexible(
                          child: Container(
                            decoration: BoxDecoration(
                              color: isUserMessage
                                  ? Colors.blue.shade300
                                  : Colors.grey.shade800,
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                            child: Text(
                              message['message']!,
                              style: const TextStyle(color: Colors.white, fontSize: 16.0),
                            ),
                          ),
                        ),
                      ],
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
                      hintText: 'Type your message...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
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
    );
  }
}
