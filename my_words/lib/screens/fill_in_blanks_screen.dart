import 'dart:math';
import 'package:flutter/material.dart';
import 'package:my_words/models/words_model.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../models/theme_model.dart';

class FillInTheBlanksGame extends StatefulWidget {
  @override
  _FillInTheBlanksGameState createState() => _FillInTheBlanksGameState();
}

class _FillInTheBlanksGameState extends State<FillInTheBlanksGame> {
  String _currentWord = '';
  String _currentHint = '';
  int _score = 0;
  int _currentIndex = -1;
  int _previousIndex = -1;
  TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _generateWord();
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _generateWord() {
    final wordsModel = Provider.of<WordsModel>(context, listen: false);
    final random = Random();

    if (wordsModel.words.isNotEmpty) {
      int newIndex;
      do {
        newIndex = random.nextInt(wordsModel.words.length);
      } while (newIndex == _currentIndex || newIndex == _previousIndex);

      _previousIndex = _currentIndex;
      _currentIndex = newIndex;

      final word = wordsModel.words[_currentIndex].english;
      final hint = _generateHint(word);

      setState(() {
        _currentWord = word;
        _currentHint = hint;
      });
    }
  }

  String _generateHint(String word) {
    final random = Random();
    final List<String> chars = word.split('');
    for (int i = 0; i < chars.length ~/ 2; i++) {
      final index = random.nextInt(chars.length);
      chars[index] = '_';
    }
    return chars.join('');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.fill_in_the_blank_game),
        backgroundColor: Colors.purple,
      ),
      body: _currentWord.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.score + ' : $_score',
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      AppLocalizations.of(context)!.word + ': $_currentHint',
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _textController,
                      decoration: InputDecoration(
                        hintText: AppLocalizations.of(context)!
                            .write_your_answer_here,
                        border: const OutlineInputBorder(),
                        focusedBorder: const OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.purple, width: 2.0),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Center(
                      child: ElevatedButton(
                        onPressed: _checkAnswer,
                        child: Text(AppLocalizations.of(context)!.your_answer),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.purple,
                          textStyle: const TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  void _checkAnswer() {
    final themeModel = Provider.of<ThemeModel>(context, listen: false);
    ThemeData themeData = themeModel.currentTheme;

    if (_textController.text.trim().toLowerCase() ==
        _currentWord.toLowerCase()) {
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
        _score++;
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
    }
    _textController.clear();
    _generateWord();
  }
}
