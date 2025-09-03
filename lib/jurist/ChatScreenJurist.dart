import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatScreenJurist extends StatefulWidget {
  final String conversationId;
  final String juristId; // Ajout de l'ID du juriste pour identifier dynamiquement l'expéditeur

  const ChatScreenJurist({Key? key, required this.conversationId, required this.juristId}) : super(key: key);

  @override
  _ChatScreenJuristState createState() => _ChatScreenJuristState();
}

class _ChatScreenJuristState extends State<ChatScreenJurist> {
  final TextEditingController _messageController = TextEditingController();
  bool isLoading = false;

  Future<void> _sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      setState(() => isLoading = true);
      try {
        // Ajouter un message à la conversation dans Firestore
        await FirebaseFirestore.instance.collection('conversations').doc(widget.conversationId).collection('messages').add({
          'senderId': widget.juristId, // Utiliser l'ID du juriste comme expéditeur
          'message': _messageController.text.trim(),
          'timestamp': FieldValue.serverTimestamp(),
        });

        // Effacer le champ de texte après l'envoi du message
        _messageController.clear();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
      } finally {
        setState(() => isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chat with User"),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('conversations')
                  .doc(widget.conversationId)
                  .collection('messages')
                  .orderBy('timestamp', descending: true)  // Trier les messages par date
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No messages yet.'));
                }

                final messages = snapshot.data!.docs;

                return ListView.builder(
                  reverse: true,  // Afficher les messages les plus récents en bas
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    final messageText = message['message'];
                    final senderId = message['senderId'];

                    return ListTile(
                      title: Align(
                        alignment: senderId == widget.juristId ? Alignment.centerRight : Alignment.centerLeft,
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                          decoration: BoxDecoration(
                            color: senderId == widget.juristId ? Colors.blue : Colors.grey[300],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            messageText,
                            style: TextStyle(
                              color: senderId == widget.juristId ? Colors.white : Colors.black,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
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
                    decoration: const InputDecoration(
                      hintText: 'Type a message...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                isLoading
                    ? const CircularProgressIndicator()
                    : IconButton(
                  icon: const Icon(Icons.send),
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
