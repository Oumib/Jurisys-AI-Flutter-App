import 'package:flutter/material.dart';
import 'chat_screen.dart'; // Assurez-vous que le fichier chat_screen.dart existe
import 'sign_up_screen.dart'; // Assurez-vous que le fichier sign_up_screen.dart existe
import 'widgets/custom_text_field.dart'; // Assurez-vous que le fichier custom_text_field.dart existe
import 'package:firebase_auth/firebase_auth.dart'; // Import de Firebase Auth pour la gestion des utilisateurs
import 'package:signin_firebase/choose_options_screen.dart';
import 'package:signin_firebase/jurist/jurist_home_screen.dart'; // Importez l'écran pour les juristes
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore pour accéder aux collections

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _formSignInKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool rememberPassword = true;
  bool isLoading = false;

  Future<void> _signIn() async {
    if (_formSignInKey.currentState!.validate()) {
      setState(() => isLoading = true);
      try {
        // Connexion avec Firebase Auth
        UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        // Récupérer l'utilisateur actuellement connecté
        User? user = userCredential.user;

        if (user != null) {
          // Vérifier si l'utilisateur est un juriste en consultant la collection 'jurists'
          DocumentSnapshot juristDoc = await FirebaseFirestore.instance.collection('jurists').doc(user.uid).get();

          if (juristDoc.exists && juristDoc['isJurist'] == true) {
            // Si l'utilisateur est un juriste, le rediriger vers l'écran JuristHomeScreen
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => JuristHomeScreen(juristId: user.uid)),
            );
          } else {
            // Si l'utilisateur n'est pas un juriste, le rediriger vers la page ChooseOptionScreen
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const ChooseOptionScreen()),
            );
          }
        }
      } on FirebaseAuthException catch (e) {
        String message = 'An error occurred. Please try again.';
        if (e.code == 'user-not-found') {
          message = 'No user found for this email.';
        } else if (e.code == 'wrong-password') {
          message = 'Invalid password.';
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );
      } finally {
        setState(() => isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Arrière-plan blanc
      body: Stack(
        children: [
          // Image de fond
          Positioned.fill(
            child: Image.asset('assets/bg1.png', fit: BoxFit.cover),
          ),
          // Contenu principal
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Expanded(
                  flex: 1,
                  child: Container(),
                ),
                Expanded(
                  flex: 7,
                  child: Container(
                    padding: const EdgeInsets.all(20.0),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
                    ),
                    child: SingleChildScrollView(
                      child: Form(
                        key: _formSignInKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Titre
                            const Text(
                              'Welcome Back',
                              style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                              ),
                            ),
                            const SizedBox(height: 40),
                            // Champ email
                            CustomTextField(
                              controller: _emailController,
                              label: 'Email',
                              hintText: 'Enter Email',
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter Email';
                                } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                                  return 'Enter a valid Email';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),
                            // Champ mot de passe
                            CustomTextField(
                              controller: _passwordController,
                              label: 'Password',
                              hintText: 'Enter Password',
                              isPassword: true,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter Password';
                                } else if (value.length < 6) {
                                  return 'Password must be at least 6 characters';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),
                            // Options supplémentaires
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Checkbox(
                                      value: rememberPassword,
                                      onChanged: (value) =>
                                          setState(() => rememberPassword = value!),
                                    ),
                                    const Text('Remember Me'),
                                  ],
                                ),
                                GestureDetector(
                                  onTap: () {
                                    // Ajoutez ici la logique pour le mot de passe oublié
                                  },
                                  child: const Text(
                                    'Forgot Password?',
                                    style: TextStyle(color: Colors.blue),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            // Bouton Sign In
                            isLoading
                                ? const CircularProgressIndicator()
                                : ElevatedButton(
                              onPressed: _signIn,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 16.0),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                minimumSize: const Size(double.infinity, 50),
                              ),
                              child: const Text(
                                'Sign In',
                                style: TextStyle(fontSize: 18.0),
                              ),
                            ),
                            const SizedBox(height: 20),
                            // Lien vers Sign Up
                            GestureDetector(
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const SignUpScreen(),
                                ),
                              ),
                              child: RichText(
                                text: TextSpan(
                                  text: "Don't have an account? ",
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: 'Sign Up',
                                      style: const TextStyle(
                                        color: Colors.blue,
                                        fontWeight: FontWeight.bold,
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
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
