import 'package:flutter/material.dart';
import 'consultation_screen.dart'; // Importez la page de consultation avec Juridisme
import 'chat_screen.dart'; // Importez la page de chat avec Jurysis AI
import 'settings_screen.dart'; // Importez la page des paramètres (Settings)
import 'chat_juridisme_screen.dart'; // Importez la page de chat avec Jurysis AI

class ChooseOptionScreen extends StatefulWidget {
  const ChooseOptionScreen({Key? key}) : super(key: key);

  @override
  _ChooseOptionScreenState createState() => _ChooseOptionScreenState();
}

class _ChooseOptionScreenState extends State<ChooseOptionScreen> {
  int _selectedIndex = 0; // Indice sélectionné pour la navigation
  bool isConsultationLocked = true; // La consultation payante est verrouillée par défaut
  final TextEditingController _keyController = TextEditingController();
  final List<String> validKeys = ["111", "222", "333"]; // Liste des clés valides

  // Fonction pour afficher la boîte de dialogue de saisie de clé
  void _showKeyDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Enter Access Key"),
          content: TextField(
            controller: _keyController,
            decoration: const InputDecoration(hintText: "Enter the key here"),
            keyboardType: TextInputType.number,
          ),
          actions: [
            TextButton(
              onPressed: () {
                String enteredKey = _keyController.text.trim();
                if (validKeys.contains(enteredKey)) {
                  setState(() {
                    isConsultationLocked = false; // Déverrouille l'accès après la saisie correcte de la clé
                  });
                  Navigator.pop(context); // Ferme la boîte de dialogue

                  // Redirection vers Chat Juridisme après déverrouillage
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ChatJuridismeScreen(),
                    ),
                  );
                } else {
                  // Afficher une erreur si la clé est incorrecte
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Incorrect key!')),
                  );
                }
              },
              child: const Text('Unlock'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Ferme la boîte de dialogue sans faire de changement
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  // Liste des écrans pour chaque onglet
  late List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    // Initialise les écrans après que le widget ait été construit
    _screens = [
      // Écran principal
      Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Choose your Consultation Option',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20), // Augmenter l'espacement ici
              const Text(
                'Get free AI-based advice or book a paid consultation with a legal expert.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),

              // Bouton Consultation avec Jurysis AI
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade300,
                      blurRadius: 6,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ChatScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 18.0),
                    backgroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Start chat with Jurysis AI',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.blue,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 25), // Espacement entre les boutons

              // Bouton Consultation Juridisme (Payé)
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade300,
                      blurRadius: 6,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: isConsultationLocked
                      ? () {
                    // Lorsque la consultation est verrouillée, afficher la boîte de dialogue pour saisir la clé
                    _showKeyDialog();
                  }
                      : () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ConsultationScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 18.0),
                    backgroundColor: Colors.blue.withBlue(233),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (isConsultationLocked)
                        const Icon(Icons.lock, color: Colors.white), // Icône de verrouillage
                      const SizedBox(width: 10),
                      const Text(
                        'Consult with a legal expert (Paid)',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      // Consultation Screen (Already navigated)
      const ChatScreen(),
      // Settings Screen (for settings, replaced ProfileScreen)
      const SettingsScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Arrière-plan blanc

      appBar: AppBar(
        title: const Text(
          'Jurysis AI',
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
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu), // Icône des trois tirés pour les paramètres
            label: 'Settings', // Remplacer "Profile" par "Settings"
          ),
        ],
      ),
    );
  }

  // Fonction de gestion du changement d'écran
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
