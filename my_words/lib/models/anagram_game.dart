import 'dart:math';

import 'package:my_words/models/word.dart';

class AnagramGame {
  late List<Word> words;
  int score = 0;
  int _currentIndex = -1;
  int _previousIndex = -1;
  String currentAnagram = '';

  AnagramGame({required this.words});

  String _createAnagram(String word) {
    List<String> charList = word.split('');
    charList.shuffle();
    return charList.join();
  }

  int uniqueRandomInt(int max, int? previous, {int retries = 3}) {
    final rng = Random();
    int newNumber = rng.nextInt(max);

    for (int i = 0; i < retries && newNumber == previous; i++) {
      newNumber = rng.nextInt(max);
    }

    return newNumber;
  }

  void generateNewQuestion() {
    if (words.isEmpty) {
      currentAnagram = '';
      return;
    }

    int newIndex;
    do {
      newIndex = uniqueRandomInt(words.length, _previousIndex);
    } while (newIndex == _currentIndex);

    _previousIndex = _currentIndex;
    _currentIndex = newIndex;
    currentAnagram = _createAnagram(words[_currentIndex].english);
  }

  bool checkAnswer(String answer) {
    return answer.toLowerCase() == words[_currentIndex].english.toLowerCase();
  }

  void incrementScore() {
    score++;
  }
}
