import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'security_policy_screen.dart'; // Votre écran de politique de sécurité
import 'privacy_policy_screen.dart'; // Votre écran de politique de confidentialité
import 'about_us_screen.dart'; // Votre écran "À propos de nous"
import 'sign_in_screen.dart'; // Votre écran de connexion

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Arrière-plan blanc
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
        child: ListView(
          children: [
            // Modifier le mot de passe
            _buildListTile(
              context,
              Icons.lock_outline,
              'Change Password',
              onTap: () async {
                TextEditingController currentPasswordController = TextEditingController();
                TextEditingController newPasswordController = TextEditingController();
                TextEditingController confirmPasswordController = TextEditingController();

                bool isPasswordVisible = false;

                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text('Change Password'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Champ pour le mot de passe actuel
                          TextField(
                            controller: currentPasswordController,
                            obscureText: !isPasswordVisible,
                            decoration: InputDecoration(
                              labelText: 'Current Password',
                              suffixIcon: IconButton(
                                icon: Icon(isPasswordVisible ? Icons.visibility : Icons.visibility_off),
                                onPressed: () {
                                  // Toggle visibility
                                  isPasswordVisible = !isPasswordVisible;
                                  (context as Element).markNeedsBuild(); // Rebuild to reflect changes
                                },
                              ),
                            ),
                          ),
                          SizedBox(height: 8), // Réduire l'espacement entre les champs

                          // Champ pour le nouveau mot de passe
                          TextField(
                            controller: newPasswordController,
                            obscureText: !isPasswordVisible,
                            decoration: InputDecoration(
                              labelText: 'New Password',
                              suffixIcon: IconButton(
                                icon: Icon(isPasswordVisible ? Icons.visibility : Icons.visibility_off),
                                onPressed: () {
                                  // Toggle visibility
                                  isPasswordVisible = !isPasswordVisible;
                                  (context as Element).markNeedsBuild(); // Rebuild to reflect changes
                                },
                              ),
                            ),
                          ),
                          SizedBox(height: 8), // Réduire l'espacement entre les champs

                          // Champ pour confirmer le mot de passe
                          TextField(
                            controller: confirmPasswordController,
                            obscureText: !isPasswordVisible,
                            decoration: InputDecoration(
                              labelText: 'Confirm Password',
                              suffixIcon: IconButton(
                                icon: Icon(isPasswordVisible ? Icons.visibility : Icons.visibility_off),
                                onPressed: () {
                                  // Toggle visibility
                                  isPasswordVisible = !isPasswordVisible;
                                  (context as Element).markNeedsBuild(); // Rebuild to reflect changes
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () async {
                            // Vérification des mots de passe
                            if (newPasswordController.text != confirmPasswordController.text) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Passwords do not match!')),
                              );
                              return;
                            }

                            try {
                              User? user = FirebaseAuth.instance.currentUser;

                              // Utiliser le mot de passe actuel pour re-authentifier l'utilisateur
                              AuthCredential credential = EmailAuthProvider.credential(
                                email: user?.email ?? '',
                                password: currentPasswordController.text,
                              );

                              await user?.reauthenticateWithCredential(credential);

                              // Mettre à jour le mot de passe
                              await user?.updatePassword(newPasswordController.text);
                              Navigator.pop(context);

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Password changed successfully!')),
                              );
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Error: $e')),
                              );
                            }
                          },
                          child: Text('Save'),
                        ),
                      ],
                    );
                  },
                );
              },
            ),

            const SizedBox(height: 6), // Espacement réduit entre les éléments

            // Politique de sécurité
            _buildListTile(
              context,
              Icons.security,
              'Security Policy',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SecurityPolicyScreen()),
                );
              },
            ),

            const SizedBox(height: 6), // Espacement réduit

            // Politique de confidentialité
            _buildListTile(
              context,
              Icons.privacy_tip,
              'Privacy Policy',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PrivacyPolicyScreen()),
                );
              },
            ),

            const SizedBox(height: 6), // Espacement réduit

            // À propos de nous
            _buildListTile(
              context,
              Icons.info_outline,
              'About Us',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AboutUsScreen()),
                );
              },
            ),

            const SizedBox(height: 6), // Espacement réduit

            // Déconnexion
            _buildListTile(
              context,
              Icons.exit_to_app,
              'Logout',
              onTap: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => SignInPage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // Widget de base pour les ListTiles avec carte
  Widget _buildListTile(BuildContext context, IconData icon, String title, {required VoidCallback onTap}) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 6), // Réduire l'espacement entre les cartes
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16), // Ajuster l'espacement interne
        leading: Icon(icon, color: Colors.blue, size: 24), // Réduire la taille de l'icône
        title: Text(title, style: const TextStyle(fontSize: 16)), // Ajuster la taille du texte
        onTap: onTap,
      ),
    );
  }
}
