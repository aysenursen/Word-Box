import 'dart:math';
import 'package:flutter/material.dart';
import 'package:my_words/models/words_model.dart';
import 'package:provider/provider.dart';

class FillInTheBlanksGame extends StatefulWidget {
  @override
  _FillInTheBlanksGameState createState() => _FillInTheBlanksGameState();
}

class _FillInTheBlanksGameState extends State<FillInTheBlanksGame> {
  String _currentWord = '';
  String _currentHint = '';
  int _score = 0;
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
      final word = wordsModel.words[random.nextInt(wordsModel.words.length)].english;
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
        title: Text('Boşluk Doldurma Oyunu'),
        backgroundColor: Colors.purple,
      ),
      body: _currentWord.isEmpty
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Puan: $_score',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Kelime: $_currentHint',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 16),
                    TextField(
                      controller: _textController,
                      decoration: InputDecoration(
                        hintText: 'Cevabınızı buraya yazın',
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.purple, width: 2.0),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    Center(
                      child: ElevatedButton(
                        onPressed: _checkAnswer,
                        child: Text('Cevapla'),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.purple,
                          onPrimary: Colors.white,
                          textStyle: TextStyle(fontSize: 18),
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
    if (_textController.text.trim().toLowerCase() == _currentWord.toLowerCase()) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Doğru!'), backgroundColor: Colors.green));
      setState(() {
        _score++;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Yanlış :('), backgroundColor: Colors.red));
    }
    _textController.clear();
    _generateWord();
  }
}

