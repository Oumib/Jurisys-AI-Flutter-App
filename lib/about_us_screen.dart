import 'package:flutter/material.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Arrière-plan blanc

      appBar: AppBar(
        title: const Text("About Us"),
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Centrer l'image logo.jpg
            Center(
              child: Image.asset(
                'assets/logo.jpg', // Chemin de l'image dans le dossier "assets"
                height: 100, // Ajuster la taille de l'image si nécessaire
              ),
            ),
            const SizedBox(height: 20),

            const Text(
              'About Us',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              'We are a team of passionate developers working to build innovative solutions. Our goal is to provide useful tools for everyday tasks, empowering people to be more efficient and organized.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            const Text(
              'Our Team: A group of creative minds working to bring new ideas to life. We believe in continuous improvement and value user feedback.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            const Text(
              'Contact Us: bounekhlaoumaima@gmail.com',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            const Text(
              'Follow us on social media for updates and news.',
              style: TextStyle(fontSize: 16),
            ),
            // Ajouter plus d'informations sur l'application ici
          ],
        ),
      ),
    );
  }
}
