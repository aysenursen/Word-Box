import 'dart:math';

import '../models/word.dart';

class QuizState {
  List<Word> words = [];
  Word? currentQuestion;
  int currentIndex = -1;
  int previousIndex = -1;
  int score = 0;

  int uniqueRandomInt(int max, int? previous, {int retries = 3}) {
    final rng = Random();
    int newNumber = rng.nextInt(max);

    for (int i = 0; i < retries && newNumber == previous; i++) {
      newNumber = rng.nextInt(max);
    }

    return newNumber;
  }

  void generateNewQuestion() {
    if (words.isNotEmpty) {
      int newIndex;
      do {
        newIndex = uniqueRandomInt(words.length, previousIndex);
      } while (newIndex == currentIndex);

      previousIndex = currentIndex;
      currentIndex = newIndex;
      currentQuestion = words[currentIndex];
    }
  }

  bool checkAnswer(String answer) {
    return currentQuestion?.turkish.toLowerCase() == answer.toLowerCase();
  }

  void incrementScore() {
    score += 1;
  }
}
