import 'package:flutter/material.dart';
import 'package:my_words/models/anagram_game.dart';
import 'package:my_words/models/word.dart';
import 'package:provider/provider.dart';
import 'package:my_words/models/words_model.dart';

class AnagramScreen extends StatefulWidget {
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
  }

  @override
  void dispose() {
    _answerController.dispose();
    super.dispose();
  }

  void _checkAnswer() {
    if (_formKey.currentState!.validate()) {
      if (_anagramGame.checkAnswer(_answerController.text)) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Doğru!')));
        setState(() {
          _anagramGame.incrementScore();
          _answerController.clear();
          _anagramGame.generateNewQuestion();
        });
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Yanlış :(')));
        setState(() {
          _answerController.clear();
          _anagramGame.generateNewQuestion();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Anagram Oyunu',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.purple,
      ),
      body: Consumer<WordsModel>(
        builder: (context, wordsModel, child) {
          _anagramGame.words = wordsModel.words;
          _anagramGame.generateNewQuestion();
          return Padding(
            padding: EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Text(
                    'Puan: ${_anagramGame.score}',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.purple,
                    ),
                  ),
                  SizedBox(height: 16),
                  if (_anagramGame.currentAnagram.isNotEmpty)
                    Text(
                      'Anagram: ${_anagramGame.currentAnagram}',
                      style: TextStyle(fontSize: 32, color: Colors.purple.shade300),
                    ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: _answerController,
                    decoration: InputDecoration(
                      labelText: 'Cevabınız',
                      labelStyle: TextStyle(color: Colors.purple),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.purple, width: 2.0),
                      ),
                                            enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.purple, width: 2.0),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Lütfen cevabınızı girin';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _checkAnswer,
                    child: Text('Cevapla'),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.purple,
                      textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
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

