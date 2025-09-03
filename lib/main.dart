import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import pour FirebaseFirestore
import 'package:flutter/material.dart';
import 'choose_options_screen.dart'; // L'écran vers lequel les utilisateurs sont redirigés
import 'jurist/jurist_home_screen.dart'; // L'écran pour le juriste
import 'sign_in_screen.dart'; // L'écran de connexion
import 'onboarding_screen.dart'; // Importez l'écran d'onboarding

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp();
    runApp(MyApp());
  } catch (e) {
    print('Firebase initialization error: $e');
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Login/Signup',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SplashScreen(), // On démarre avec un écran de splash.
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  User? currentUser;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();
    _checkUserState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _checkUserState() async {
    try {
      // Vérifie si un utilisateur est connecté
      User? user = FirebaseAuth.instance.currentUser;
      setState(() {
        currentUser = user;
      });

      // Si l'utilisateur est connecté, on vérifie s'il est un juriste ou un utilisateur
      if (currentUser != null) {
        // Vérifie d'abord dans la collection 'jurists'
        final juristDoc = await FirebaseFirestore.instance.collection('jurists').doc(currentUser!.uid).get();

        if (juristDoc.exists && juristDoc['isJurist'] == true) {
          // Si l'utilisateur est un juriste, on le redirige vers l'écran 'JuristHomeScreen'
          Future.delayed(const Duration(seconds: 2), () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => JuristHomeScreen(juristId: currentUser!.uid)),
            );
          });
        } else {
          // Si l'utilisateur n'est pas un juriste, on le redirige vers l'écran 'ChooseOptionScreen'
          Future.delayed(const Duration(seconds: 2), () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const ChooseOptionScreen()),
            );
          });
        }
      } else {
        // Si l'utilisateur n'est pas connecté, on le redirige vers l'écran d'onboarding
        Future.delayed(const Duration(seconds: 2), () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => OnboardingScreen()), // Affiche l'écran d'onboarding si non connecté
          );
        });
      }
    } catch (e) {
      print('Error checking user state: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Arrière-plan blanc

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/hello.jpg', // Chemin de votre logo
              height: 250, // Taille de l'image
              width: 250,
            ),
            const SizedBox(height: 30),
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(3, (index) {
                    final animationValue = (_controller.value + index / 3) % 1.0;
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: animationValue < 0.5
                              ? Colors.blue
                              : Colors.blue.withOpacity(0.3),
                        ),
                      ),
                    );
                  }),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
