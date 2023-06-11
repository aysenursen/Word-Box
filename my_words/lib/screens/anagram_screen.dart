import 'package:flutter/material.dart';
import 'package:my_words/models/anagram_game.dart';
import 'package:provider/provider.dart';
import 'package:my_words/models/words_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../models/theme_model.dart';

class AnagramScreen extends StatefulWidget {
  const AnagramScreen({super.key});

  @override
  _AnagramScreenState createState() => _AnagramScreenState();
}

class _AnagramScreenState extends State<AnagramScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _answerController = TextEditingController();

  late AnagramGame _anagramGame;

  @override
  void initState() {
    super.initState();
    _anagramGame = AnagramGame(words: []);
    Future.microtask(() {
      _anagramGame = AnagramGame(words: context.read<WordsModel>().words);
      _anagramGame.generateNewQuestion();
      setState(() {});
    });
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
      if (_anagramGame.checkAnswer(_answerController.text)) {
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
                  color: themeData.colorScheme.primary,
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  'Doğru!',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            backgroundColor: Colors.white,
            duration: Duration(seconds: 1),
          ),
        );
        setState(() {
          _anagramGame.incrementScore();
          _answerController.clear();
          _anagramGame.generateNewQuestion();
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
            duration: Duration(seconds: 2),
          ),
        );
        setState(() {
          _answerController.clear();
          _anagramGame.generateNewQuestion();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.anagram_game,
          style:
              const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: themeData.primaryColor,
      ),
      body: _anagramGame.words.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Consumer<WordsModel>(
              builder: (context, wordsModel, child) {
                return Container(
                  decoration: BoxDecoration(color: themeData.primaryColor),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              AppLocalizations.of(context)!.score +
                                  ': ' +
                                  '${_anagramGame.score}',
                              style: const TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          if (_anagramGame.currentAnagram.isNotEmpty)
                            Text(
                              'Anagram: ${_anagramGame.currentAnagram}',
                              style: const TextStyle(
                                  fontSize: 32, color: Colors.white),
                            ),
                          const SizedBox(height: 16),
                          TextFormField(
                            cursorColor: Colors.white,
                            controller: _answerController,
                            decoration: InputDecoration(
                              labelText: AppLocalizations.of(context)!
                                  .write_your_answer_here,
                              labelStyle: const TextStyle(color: Colors.white),
                              focusedBorder: const OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.white, width: 2.0),
                              ),
                              enabledBorder: const OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.white, width: 2.0),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return AppLocalizations.of(context)!
                                    .write_your_answer_here;
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: _checkAnswer,
                            child:
                                Text(AppLocalizations.of(context)!.your_answer),
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.black,
                              backgroundColor: Colors.white,
                              textStyle: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 40, vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                                side: const BorderSide(color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
