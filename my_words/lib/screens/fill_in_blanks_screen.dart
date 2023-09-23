import 'dart:math';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:my_words/models/words_model.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../models/theme_model.dart';
import '../utilities/constants.dart';

class FillInTheBlanksGame extends StatefulWidget {
  @override
  _FillInTheBlanksGameState createState() => _FillInTheBlanksGameState();
}

class _FillInTheBlanksGameState extends State<FillInTheBlanksGame> {
  String _currentWord = '';
  String _currentHint = '';
  String _currentExample = '';
  int isCorrect = -1;
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
      final example = wordsModel.words[_currentIndex].example;

      setState(() {
        _currentWord = word;
        _currentHint = hint;
        _currentExample = example;
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
      backgroundColor: ConstantsColor.primaryBackGroundColor,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.fill_in_the_blank_game,
            style: ConstantsStyle.headingStyle),
        backgroundColor: ConstantsColor.primaryColor,
        toolbarHeight: 70,
        elevation: 3,
        shape: const ContinuousRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(166),
            bottomRight: Radius.circular(166),
          ),
        ),
      ),
      body: _currentWord.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        padding: EdgeInsets.all(15.0),
                        decoration: BoxDecoration(
                          color: ConstantsColor.primaryColor,
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        child: Text(
                          AppLocalizations.of(context)!.score.toUpperCase() + ' : $_score',
                          style: ConstantsStyle.secondaryTextStyle,
                        ),
                      ),
                    ),
                    const SizedBox(height: 50),
                    Center(
                      child: Container(
                        padding: EdgeInsets.all(40.0),
                        decoration: const BoxDecoration(
                          color: ConstantsColor.primaryColor,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(40.0),
                            bottomRight: Radius.circular(40.0),
                          ),
                        ),
                        child: Text(_currentHint,
                            style: ConstantsStyle.headingStyle),
                      ),
                    ),
                    const SizedBox(height: 40),
                    Padding(
                      padding: const EdgeInsets.only(left:8.0, bottom: 10),
                      child: Text(
                        'Cevabınız:',
                        style: ConstantsStyle.primaryTextStyle,
                      ),
                    ),
                    Center(
                      child: TextField(
                        controller: _textController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: ConstantsColor.primaryColor,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            borderSide: BorderSide.none,
                          ),
                          prefixIcon: const Icon(
                            Icons.edit,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: ElevatedButton(
                        onPressed: _checkAnswer,
                        child: Text(AppLocalizations.of(context)!
                            .your_answer
                            .toUpperCase()),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.black,
                          backgroundColor: ConstantsColor.primaryColor,
                          textStyle: ConstantsStyle.secondaryTextStyle,
                          padding: const EdgeInsets.symmetric(
                              vertical: 16.0, horizontal: 10.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(32.0),
                          ),
                          elevation: 8,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    if (isCorrect == 1)
                      Container(
                        padding: EdgeInsets.all(15),
                        decoration: const BoxDecoration(
                          color: ConstantsColor.mainColor,
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(40.0),
                            bottomLeft: Radius.circular(40.0),
                          ),
                        ),
                        child: Center(
                          child: AutoSizeText(
                            _currentExample,
                            style: ConstantsStyle.primaryTextStyle,
                            maxLines: 4,
                            minFontSize: 14,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    if (isCorrect == 0)
                      Container(
                        padding: EdgeInsets.all(15),
                        decoration: const BoxDecoration(
                          color: ConstantsColor.mainColor,
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(40.0),
                            bottomLeft: Radius.circular(40.0),
                          ),
                        ),
                        child: Center(
                          child: AutoSizeText(
                            _currentWord,
                            style: ConstantsStyle.primaryTextStyle,
                            maxLines: 4,
                            minFontSize: 14,
                            overflow: TextOverflow.ellipsis,
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
        isCorrect = 1;
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
        isCorrect = 0;
      });
    }
    Future.delayed(Duration(seconds: 2), () {
      _textController.clear();
      _generateWord();
      setState(() {
        isCorrect = -1;
      });
    });
  }
}
