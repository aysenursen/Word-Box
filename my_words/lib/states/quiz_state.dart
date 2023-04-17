import 'dart:math';

import '../models/word.dart';

class QuizState {
  List<Word> words = [];
  Word? currentQuestion;
  int score = 0;

  void generateNewQuestion() {
    if (words.isNotEmpty) {
      currentQuestion = words[Random().nextInt(words.length)];
    }
  }

  bool checkAnswer(String answer) {
    return currentQuestion?.turkish.toLowerCase() == answer.toLowerCase();
  }

  void incrementScore() {
    score += 1;
  }
}
