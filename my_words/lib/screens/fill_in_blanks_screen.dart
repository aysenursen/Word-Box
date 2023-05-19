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
        title: const Text('Boşluk Doldurma Oyunu'),
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
                      'Puan: $_score',
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Kelime: $_currentHint',
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _textController,
                      decoration: const InputDecoration(
                        hintText: 'Cevabınızı buraya yazın',
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.purple, width: 2.0),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Center(
                      child: ElevatedButton(
                        onPressed: _checkAnswer,
                        child: const Text('Cevapla'),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white, backgroundColor: Colors.purple,
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
    if (_textController.text.trim().toLowerCase() == _currentWord.toLowerCase()) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Doğru!'), backgroundColor: Colors.green));
      setState(() {
        _score++;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Yanlış :('), backgroundColor: Colors.red));
    }
    _textController.clear();
    _generateWord();
  }
}
