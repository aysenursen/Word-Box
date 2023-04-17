import 'package:flutter/material.dart';
import 'package:my_words/models/words_model.dart';
import 'package:provider/provider.dart';

import '../states/quiz_state.dart';

class QuizScreen extends StatefulWidget {
  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _answerController = TextEditingController();

  late QuizState _quizState;

  @override
  void initState() {
    super.initState();
    _quizState = QuizState();
    _quizState.generateNewQuestion();
  }

  @override
  void dispose() {
    _answerController.dispose();
    super.dispose();
  }

  void _checkAnswer() {
    if (_formKey.currentState!.validate()) {
      if (_quizState.checkAnswer(_answerController.text)) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Doğru!')));
        setState(() {
          _quizState.incrementScore();
          _answerController.clear();
          _quizState.generateNewQuestion();
        });
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Yanlış :(')));
        setState(() {
          _answerController.clear();
          _quizState.generateNewQuestion();
        });
      }
    }
  }

  InputDecoration _inputDecoration({required String labelText}) {
    return InputDecoration(
      labelText: labelText,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.purple, width: 2.0),
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'QUIZ',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.purple,
      ),
      body: Consumer<WordsModel>(
        builder: (context, wordsModel, child) {
          _quizState.words = wordsModel.words;
          _quizState.generateNewQuestion();
          return Padding(
            padding: EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Puan: ${_quizState.score}',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),
                  if (_quizState.currentQuestion != null)
                    Text(
                      'İngilizce: ${_quizState.currentQuestion!.english}',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: _answerController,
                    decoration: _inputDecoration(labelText: 'Türkçe Karşılığı'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Lütfen Türkçe karşılığını girin';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _checkAnswer,
                      child: Text('Cevapla'),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.purple,
                        padding: EdgeInsets.symmetric(vertical: 16.0),
                        textStyle: TextStyle(fontSize: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
