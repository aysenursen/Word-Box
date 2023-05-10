import 'package:flutter/material.dart';
import 'package:my_words/models/word.dart';
import 'package:my_words/models/words_model.dart';
import 'package:provider/provider.dart';

class CategoryWordsScreen extends StatelessWidget {
  final String category;

  const CategoryWordsScreen({required this.category});

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('$category Kelimeler'),
        backgroundColor: themeData.primaryColor,
      ),
      body: Consumer<WordsModel>(
        builder: (context, wordsModel, child) {
          List<Word> words = wordsModel.getWordsByCategory(category);
          return ListView.separated(
            itemCount: words.length,
            itemBuilder: (context, index) {
              final word = words[index];
              return ListTile(
                title: Text(
                  '${index + 1}. ${word.english.toUpperCase()} - ${word.turkish.toUpperCase()}',
                  style: TextStyle(
                      fontSize: 21,
                      color: themeData.textSelectionTheme.cursorColor,
                      fontWeight: FontWeight.bold),
                ),
                subtitle: Text('Örnek: ${word.example}'),
              );
            },
            separatorBuilder: (BuildContext context, int index) => Divider(
              color: Colors.grey,
            ),
          );
        },
      ),
    );
  }
}
