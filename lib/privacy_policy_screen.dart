import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Arrière-plan blanc

      appBar: AppBar(
        title: const Text("Privacy Policy"),
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
                'We value your privacy and are committed to protecting your personal data. This policy outlines how we handle your information, including the collection, use, and protection of your personal data.',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              const Text(
                '1. **Information Collection**: We collect personal information such as email addresses, names, and other relevant details to improve our service.',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 8),
              const Text(
                '2. **Data Usage**: Your data is used to personalize your experience, send you notifications, and improve our products.',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 8),
              const Text(
                '3. **Data Sharing**: We do not share your personal data with third parties without your explicit consent, except when required by law.',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              // Ajouter plus de contenu de politique de confidentialité ici
            ],
          ),
        ),
      ),
    );
  }
}
