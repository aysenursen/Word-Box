import 'package:flutter/material.dart';
import 'package:my_words/models/anagram_game.dart';
import 'package:provider/provider.dart';
import 'package:my_words/models/words_model.dart';

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
    if (_formKey.currentState!.validate()) {
      if (_anagramGame.checkAnswer(_answerController.text)) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Doğru!')));
        setState(() {
          _anagramGame.incrementScore();
          _answerController.clear();
          _anagramGame.generateNewQuestion();
        });
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Yanlış :(')));
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
        title: const Text(
          'Anagram Oyunu',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF3a7bd5),
      ),
      body: _anagramGame.words.isEmpty
          ? Center(child: CircularProgressIndicator())
          :Consumer<WordsModel>(
        builder: (context, wordsModel, child) {
       
          return Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF3a7bd5), Color(0xFF00d2ff)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
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
                        'Puan: ${_anagramGame.score}',
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
                        style: const TextStyle(fontSize: 32, color: Colors.white),
                      ),
                    const SizedBox(height: 16),
                    TextFormField(
                      cursorColor: Colors.white,
                      controller: _answerController,
                      decoration: const InputDecoration(
                        labelText: 'Cevabınız',
                        labelStyle: TextStyle(color: Colors.white),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white, width: 2.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white, width: 2.0),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                                                  return 'Lütfen cevabınızı girin';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _checkAnswer,
                      child: const Text('Cevapla'),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.white,
                        onPrimary: Colors.black,
                        textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
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

