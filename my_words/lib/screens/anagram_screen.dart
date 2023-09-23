import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:my_words/models/anagram_game.dart';
import 'package:provider/provider.dart';
import 'package:my_words/models/words_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../models/theme_model.dart';
import '../utilities/constants.dart';

class AnagramScreen extends StatefulWidget {
  const AnagramScreen({super.key});

  @override
  _AnagramScreenState createState() => _AnagramScreenState();
}

class _AnagramScreenState extends State<AnagramScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _answerController = TextEditingController();
  int isCorrect = -1;
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
      Future.delayed(Duration(seconds: 3), () {
        _answerController.clear();
        _anagramGame.generateNewQuestion();
        setState(() {
          isCorrect = -1;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ConstantsColor.primaryBackGroundColor,
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.anagram_game,
          style: ConstantsStyle.headingStyle,
        ),
        centerTitle: true,
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
      body: _anagramGame.words.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Consumer<WordsModel>(
              builder: (context, wordsModel, child) {
                return SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Container(
                            padding: EdgeInsets.all(15.0),
                            decoration: BoxDecoration(
                              color: ConstantsColor.primaryColor,
                              borderRadius: BorderRadius.circular(14.0),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.star,
                                  size: 20,
                                  color: Colors.black,
                                ),
                                Text(
                                  ' ' +
                                      AppLocalizations.of(context)!
                                          .score
                                          .toUpperCase() +
                                      ': ' +
                                      '${_anagramGame.score}',
                                  style: ConstantsStyle.secondaryTextStyle,
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        if (_anagramGame.currentAnagram.isNotEmpty)
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.only(top: 32.0, bottom: 32.0),
                            decoration: BoxDecoration(
                              color: ConstantsColor.primaryColor,
                            ),
                            child: Column(
                              children: [
                                const Icon(
                                  Icons.change_circle,
                                  color: Colors.black,
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  _anagramGame.currentAnagram,
                                  style: const TextStyle(
                                      fontSize: 28, color: Colors.black),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        const SizedBox(height: 36),
                        Padding(
                          padding:
                              const EdgeInsets.only(left: 24.0, bottom: 10.0),
                          child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Cevabınız:',
                                style: ConstantsStyle.primaryTextStyle,
                              )),
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.only(left: 20.0, right: 20.0),
                          child: TextFormField(
                            controller: _answerController,
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
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return AppLocalizations.of(context)!
                                    .write_your_answer_here;
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: _checkAnswer,
                          child: Text(AppLocalizations.of(context)!
                              .your_answer
                              .toUpperCase()),
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.black,
                            backgroundColor: ConstantsColor.primaryColor,
                            textStyle: ConstantsStyle.secondaryTextStyle,
                            padding: const EdgeInsets.symmetric(
                                vertical: 20.0, horizontal: 12.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(32.0),
                            ),
                            elevation: 8,
                          ),
                        ),
                        SizedBox(
                          height: 30,
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
                                _anagramGame.getExample(),
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
                                _anagramGame.getWord(),
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
                );
              },
            ),
    );
  }
}
