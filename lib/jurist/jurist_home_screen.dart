import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:table_calendar/table_calendar.dart'; // Importation de TableCalendar
import 'ChatScreenJurist.dart'; // Importez l'écran de chat où le juriste peut discuter avec l'utilisateur
import 'package:signin_firebase/settings_screen.dart'; // Importez la page des paramètres (Settings)

class JuristHomeScreen extends StatefulWidget {
  final String juristId;

  const JuristHomeScreen({Key? key, required this.juristId}) : super(key: key);

  @override
  _JuristHomeScreenState createState() => _JuristHomeScreenState();
}

class _JuristHomeScreenState extends State<JuristHomeScreen> {
  int _selectedIndex = 0; // Indice sélectionné pour la navigation

  // Liste des écrans pour chaque onglet
  late List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    // Initialise les écrans après que le widget ait été construit
    _screens = [
      // Liste des conversations avec juriste
      _buildChatListScreen(),
      // Paramètres du juriste
      const SettingsScreen(),
    ];
  }

  // Fonction pour afficher la liste des conversations
  Widget _buildChatListScreen() {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Chats", // Titre de l'AppBar
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black, // Texte noir pour contraster avec le fond blanc
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0, // Enlever l'ombre de l'AppBar
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today, color: Colors.lightBlueAccent), // Icône du calendrier
            onPressed: () {
              _showCalendarDialog(context);
            },
          ),
        ],
      ),
      backgroundColor: Colors.white, // Arrière-plan blanc pour tout l'écran
      body: Column(
        children: [
          // Réduction de l'espace entre l'AppBar et la ligne
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16), // Réduit l'espace vertical
            decoration: BoxDecoration(
              color: Colors.white, // Fond blanc pour l'en-tête
              border: Border(bottom: BorderSide(color: Colors.lightBlueAccent, width: 3)), // Bordure orange en bas
            ),
          ),
          const SizedBox(height: 20),
          // Liste des conversations statiques
          Expanded(
            child: ListView.builder(
              itemCount: 5, // Exemple statique de 5 conversations
              itemBuilder: (context, index) {
                final userId = 'user$index'; // ID fictif de l'utilisateur
                final conversationId = 'conv$index'; // ID fictif de la conversation

                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: const BorderSide(color: Colors.white, width: 2), // Bordure orange autour de chaque carte
                  ),
                  elevation: 5,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white, // Fond blanc pour la carte
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16),
                      title: Text(
                        'Conversation with user: $userId',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: const Text('Status: active'), // Exemple de statut
                      trailing: PopupMenuButton<String>(
                        onSelected: (value) {
                          if (value == 'block') {
                            _blockUser(context, conversationId);
                          } else if (value == 'delete') {
                            _deleteConversation(context, conversationId);
                          }
                        },
                        itemBuilder: (context) => const [
                          PopupMenuItem(value: 'block', child: Text('Block')),
                          PopupMenuItem(value: 'delete', child: Text('Delete')),
                        ],
                        icon: const Icon(Icons.more_vert, color: Colors.lightBlueAccent), // Trois points en orange
                      ),
                      onTap: () {
                        // Naviguer vers l'écran de discussion avec l'utilisateur
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatScreenJurist(
                              conversationId: conversationId,
                              juristId: widget.juristId, // Passer l'ID du juriste ici
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Logique pour bloquer un utilisateur
  Future<void> _blockUser(BuildContext context, String conversationId) async {
    try {
      // Mettre à jour le statut de la conversation pour la bloquer
      await FirebaseFirestore.instance.collection('conversations').doc(conversationId).update({
        'status': 'blocked', // Mettre à jour le statut de la conversation
      });
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('User blocked')));
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $error')));
    }
  }

  // Logique pour supprimer une conversation
  Future<void> _deleteConversation(BuildContext context, String conversationId) async {
    try {
      // Supprimer la conversation de Firestore
      await FirebaseFirestore.instance.collection('conversations').doc(conversationId).delete();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Conversation deleted')));
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $error')));
    }
  }

  // Afficher un dialogue de calendrier
  void _showCalendarDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select a Date'),
          content: TableCalendar(
            focusedDay: DateTime.now(),
            firstDay: DateTime.utc(2010, 10, 16),
            lastDay: DateTime.utc(2030, 3, 14),
            onDaySelected: (selectedDay, focusedDay) {
              Navigator.of(context).pop(); // Fermer le dialogue lorsque l'utilisateur sélectionne une date
              // Vous pouvez ajouter une logique pour gérer la date sélectionnée
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Fermer le dialogue sans action
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  // Gérer la sélection d'un élément dans le BottomNavigationBar
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Jurist Dashboard",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: _screens[_selectedIndex], // Afficher l'écran sélectionné
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.lightBlueAccent,
        unselectedItemColor: Colors.black,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Chats',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
