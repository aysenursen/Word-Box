import 'package:flutter/material.dart';
import 'package:my_words/models/words_model.dart';
import 'package:provider/provider.dart';

class FavoriteWordsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Favori Kelimeler',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.purple,
      ),
      body: Consumer<WordsModel>(
        builder: (context, wordsModel, child) {
          final favoriteWords = wordsModel.favoriteWords;
          return ListView.builder(
            itemCount: favoriteWords.length,
            itemBuilder: (context, index) {
              final word = favoriteWords[index];
              return ListTile(
                tileColor: index % 2 == 0 ? Colors.purple.shade50 : Colors.white,
                title: Text(
                  '${word.english.toUpperCase()} - ${word.turkish.toUpperCase()}',
                  style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.purple),
                ),
                subtitle: Text(
                  word.example,
                  style: TextStyle(fontWeight: FontWeight.normal, color: Colors.purple.shade300),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
