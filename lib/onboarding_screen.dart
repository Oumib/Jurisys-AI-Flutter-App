import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'sign_in_screen.dart';  // Importation de la page de connexion

class OnboardingScreen extends StatefulWidget {
  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController(initialPage: 0);
  static const int totalPages = 3;
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Arrière-plan blanc

      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          PageView(
            controller: _pageController,
            onPageChanged: (page) => setState(() => currentIndex = page),
            children: [
              createPage(
                image: 'assets/hello.jpg',
                title: 'Welcome to the App',
                description: 'Talk to me like a knowledgeable friend!',
              ),
              createPage(
                image: 'assets/hello.jpg',
                title: 'Personalize Your Experience',
                description: 'Our technology saves you time and money!',
              ),
              createPage(
                image: 'assets/hello.jpg',
                title: 'Let\'s Get Started!',
                description: '',
              ),
            ],
          ),
          Positioned(
            bottom: 80,
            child: SmoothPageIndicator(
              controller: _pageController,
              count: totalPages,
              effect: WormEffect(
                dotColor: Colors.grey.shade300,
                activeDotColor: Colors.blue,
              ),
            ),
          ),
          Positioned(
            bottom: 30,
            right: 20,
            child: FloatingActionButton(
              onPressed: () {
                if (currentIndex < totalPages - 1) {
                  _pageController.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                } else {
                  // Navigation vers la page de connexion après la dernière page
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => SignInPage()),
                  );
                }
              },
              child: const Icon(Icons.arrow_forward),
            ),
          ),
        ],
      ),
    );
  }

  Widget createPage({
    required String image,
    required String title,
    required String description,
  }) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(image, height: 200),
          const SizedBox(height: 20),
          Text(
            title,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Text(
            description,
            style: const TextStyle(fontSize: 16, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
