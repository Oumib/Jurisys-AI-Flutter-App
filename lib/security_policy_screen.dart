import 'package:flutter/material.dart';

class SecurityPolicyScreen extends StatelessWidget {
  const SecurityPolicyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Arrière-plan blanc

      appBar: AppBar(
        title: const Text("Security Policy"),
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              const SizedBox(height: 16),
              const Text(
                'Your security is important to us. We ensure your data is protected using industry-standard encryption technologies. We constantly monitor our systems to prevent unauthorized access and regularly update our security practices to ensure we remain compliant with privacy regulations.',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              const Text(
                '1. **Data Encryption**: All sensitive data is encrypted using the latest encryption standards to protect against data breaches.',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 8),
              const Text(
                '2. **Two-Factor Authentication**: For added protection, we encourage using two-factor authentication for all accounts.',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 8),
              const Text(
                '3. **Secure Connections**: All interactions with our platform are secured using HTTPS, ensuring safe communication between users and our servers.',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              // Ajouter plus de contenu de politique de sécurité ici
            ],
          ),
        ),
      ),
    );
  }
}
