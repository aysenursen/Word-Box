import 'package:flutter/material.dart';
import 'package:my_words/screens/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int _currentPage = 0;
  final PageController _pageController = PageController();
    Future<void> _completeOnboarding() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool('onboardingCompleted', true);
}

  List<Widget> _slides = [
    Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.language, size: 200),
        Text('Kelime Kumbarası', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        Text('İngilizce kelime öğrenmenin kolay yolu', style: TextStyle(fontSize: 16)),
      ],
    ),
    Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.quiz, size: 200),
        Text('Quiz ile Öğren', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        Text('Eklediğiniz kelimeleri quiz ile öğrenin', style: TextStyle(fontSize: 16)),
      ],
    ),
    Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.favorite, size: 200),
        Text('Favori Kelimeler', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        Text('En çok sevdiğiniz kelimeleri favorilere ekleyin', style: TextStyle(fontSize: 16)),
      ],
    ),
  ];


  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
   
  _completeOnboarding(); // Onboarding'in tamamlandığını kaydedin
  Navigator.of(context).pushReplacement(
    MaterialPageRoute(builder: (context) => HomeScreen()),
  );


    if (_currentPage < _slides.length - 1) {
      _pageController.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    } else {
      Navigator.pushReplacementNamed(context, '/home');
      
    }
  }

  void _skipToHome() {
    Navigator.pushReplacementNamed(context, '/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: _slides.length,
            itemBuilder: (context, index) => _slides[index],
            onPageChanged: (int index) {
              setState(() {
                _currentPage = index;
              });
            },
          ),
          Positioned(
            bottom: 30,
            left: 20,
            child: TextButton(
              onPressed: _skipToHome,
              child: Text(
                'Atla',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ),
          Positioned(
            bottom: 30,
            right: 20,
            child: TextButton(
              onPressed: _nextPage,
              child: Text(
                _currentPage < _slides.length - 1 ? 'İleri' : 'Başla',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
