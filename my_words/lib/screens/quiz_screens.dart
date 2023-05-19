import 'package:flutter/material.dart';
import 'package:my_words/models/theme_model.dart';
import 'package:my_words/models/words_model.dart';
import 'package:provider/provider.dart';

import '../states/quiz_state.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

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
            .showSnackBar(const SnackBar(content: Text('Doğru!')));
        setState(() {
          _quizState.incrementScore();
          _answerController.clear();
          _quizState.generateNewQuestion();
        });
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Yanlış :(')));
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
      filled: true,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: BorderSide(),
      ),
      labelStyle: TextStyle(color: Colors.white),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.white),
        borderRadius: BorderRadius.circular(10.0),
      ),
    );
  }

 @override
  Widget build(BuildContext context) {
    final themeModel = Provider.of<ThemeModel>(context);
    ThemeData themeData = themeModel.currentTheme;
    TextTheme textTheme = themeData.textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'QUIZ',
          style: textTheme.headline6?.copyWith(color: themeData.colorScheme.onPrimary),
        ),
        backgroundColor: themeData.primaryColor,
      ),
      body: Consumer<WordsModel>(
        builder: (context, wordsModel, child) {
          _quizState.words = wordsModel.words;
          _quizState.generateNewQuestion();
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [themeData.primaryColorLight, themeData.primaryColorDark],
              ),
            ),
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Spacer(),
                  CircleAvatar(
                    radius: 100,
                    backgroundColor: Colors.white70,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.question_answer, size: 50, color: themeData.primaryColor),
                        Text(
                    'Puan: ${_quizState.score}',
                    style: textTheme.displayLarge?.copyWith(color: themeData.primaryColor, fontSize: 24),
                  ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 48),
                  if (_quizState.currentQuestion != null)
                    Text(
                      'Question: ${_quizState.currentQuestion!.english.toUpperCase()}',
                      style: textTheme.headline5?.copyWith(color: Colors.white, fontSize: 24),
                    ),
                  const SizedBox(height: 32),
                  TextFormField(
                    controller: _answerController,
                    decoration: _inputDecoration(labelText: 'Türkçe Karşılığı'),
                    style: textTheme.bodyText1?.copyWith(color: Colors.white),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Lütfen Türkçe karşılığını girin';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _checkAnswer,
                      child: Text(
                        'Cevapla',
                        style: textTheme.button?.copyWith(color: themeData.colorScheme.onPrimary),
                      ),
                      style: ElevatedButton.styleFrom(
                        primary: themeData.primaryColor,
                        onPrimary: themeData.colorScheme.onPrimary,
                        padding: const                         EdgeInsets.symmetric(vertical: 16.0),
                        textStyle: TextStyle(fontSize: 20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  Spacer(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
