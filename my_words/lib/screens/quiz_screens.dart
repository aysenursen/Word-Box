import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:my_words/models/theme_model.dart';
import 'package:my_words/models/words_model.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../states/quiz_state.dart';
import '../utilities/constants.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _answerController = TextEditingController();
  late QuizState _quizState;
  int isCorrect = -1;

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
        _quizState.generateNewQuestion();
        setState(() {
          isCorrect = -1;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeModel = Provider.of<ThemeModel>(context);
    ThemeData themeData = themeModel.currentTheme;
    TextTheme textTheme = themeData.textTheme;

    return Scaffold(
      backgroundColor: ConstantsColor.primaryBackGroundColor,
      appBar: AppBar(
        title: Text(
          'QUIZ',
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
      body: Consumer<WordsModel>(
        builder: (context, wordsModel, child) {
          _quizState.words = wordsModel.words;
          _quizState.generateNewQuestion();
          return Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 15,
                ),
                CircleAvatar(
                  radius: 42,
                  backgroundColor: ConstantsColor.primaryColor,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.star, size: 20, color: Colors.black),
                      Text(
                        AppLocalizations.of(context)!.score.toUpperCase() +
                            ' : ${_quizState.score}',
                        style: ConstantsStyle.secondaryTextStyle,
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 36,
                ),
                if (_quizState.currentQuestion != null)
                  Container(
                    padding: const EdgeInsets.all(20.0),
                    decoration: const BoxDecoration(
                      color: ConstantsColor.primaryColor,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20.0),
                        bottomRight: Radius.circular(20.0),
                      ),
                    ),
                    child: Column(
                      children: [
                        Icon(Icons.menu_book),
                        Text(
                          '${AppLocalizations.of(context)!.word}:',
                          style: ConstantsStyle.primaryTextStyle,
                        ),
                        const SizedBox(
                            width: 100,
                            height: 20,
                            child: Divider(
                              color: Colors.black,
                            )),
                        Text(
                          _quizState.currentQuestion!.english.toUpperCase(),
                          style: ConstantsStyle.primaryTextStyle,
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 36),
                Padding(
                  padding: const EdgeInsets.only(left: 24.0, bottom: 10.0),
                  child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Cevabınız:',
                        style: ConstantsStyle.primaryTextStyle,
                      )),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20.0, right: 20.0),
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
                        return 'Please enter the answer in your native language';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _checkAnswer,
                  child: Text(
                    AppLocalizations.of(context)!.your_answer.toUpperCase(),
                  ),
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
                        _quizState.currentQuestion!.example,
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
                        _quizState.currentQuestion!.english,
                        style: ConstantsStyle.primaryTextStyle,
                        maxLines: 4,
                        minFontSize: 14,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                //const Spacer(),
              ],
            ),
          );
        },
      ),
    );
  }
}
