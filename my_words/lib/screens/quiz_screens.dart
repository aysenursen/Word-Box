import 'package:flutter/material.dart';
import 'package:my_words/models/theme_model.dart';
import 'package:my_words/models/words_model.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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
    final themeModel = Provider.of<ThemeModel>(context, listen: false);
    ThemeData themeData = themeModel.currentTheme;
    if (_formKey.currentState!.validate()) {
      if (_quizState.checkAnswer(_answerController.text)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            content: Row(
              children: [
                Icon(
                  Icons.check_circle,
                  color: themeData.colorScheme.onSecondary,
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  'Doğru!',
                  style: TextStyle(
                    color: themeData.colorScheme.onSecondary,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            backgroundColor: themeData.colorScheme.secondary,
            duration: Duration(seconds: 1),
          ),
        );
        setState(() {
          _quizState.incrementScore();
          _answerController.clear();
          _quizState.generateNewQuestion();
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            content: Row(
              children: [
                Icon(
                  Icons.error,
                  color: themeData.colorScheme.onError,
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  'Yanlış :(',
                  style: TextStyle(
                    color: themeData.colorScheme.onError,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            backgroundColor: themeData.colorScheme.error,
            duration: Duration(seconds: 1),
          ),
        );
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
        borderSide: const BorderSide(),
      ),
      labelStyle: const TextStyle(color: Colors.white),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.white),
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
          style: textTheme.headline6
              ?.copyWith(color: themeData.colorScheme.onPrimary),
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
                colors: [
                  themeData.primaryColorLight,
                  themeData.primaryColorDark
                ],
              ),
            ),
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Spacer(),
                  CircleAvatar(
                    radius: 100,
                    backgroundColor: Colors.white70,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.question_answer,
                            size: 50, color: themeData.primaryColor),
                        Text(
                          AppLocalizations.of(context)!.score +
                              ' : ${_quizState.score}',
                          style: textTheme.displayLarge?.copyWith(
                              color: themeData.primaryColor, fontSize: 24),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 48),
                  if (_quizState.currentQuestion != null)
                    Text(
                      AppLocalizations.of(context)!.question +
                          ' : ${_quizState.currentQuestion!.english.toUpperCase()}',
                      style: textTheme.headlineSmall
                          ?.copyWith(color: Colors.white, fontSize: 24),
                    ),
                  const SizedBox(height: 32),
                  TextFormField(
                    controller: _answerController,
                    decoration: _inputDecoration(
                        labelText: AppLocalizations.of(context)!
                            .write_your_answer_here),
                    style: textTheme.bodyLarge?.copyWith(color: Colors.white),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the answer in your native language';
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
                        AppLocalizations.of(context)!.your_answer,
                        style: textTheme.labelLarge
                            ?.copyWith(color: themeData.colorScheme.onPrimary),
                      ),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: themeData.colorScheme.onPrimary,
                        backgroundColor: themeData.primaryColor,
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        textStyle: const TextStyle(fontSize: 20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  const Spacer(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
