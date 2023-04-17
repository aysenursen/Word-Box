

import 'package:flutter/material.dart';
import 'package:my_words/screens/anagram_screen.dart';
import 'package:my_words/screens/favorite_words_screen.dart';
import 'package:my_words/screens/fill_in_blanks_screen.dart';
import 'package:my_words/screens/learning_stats_screen.dart';
import 'package:my_words/screens/quiz_screens.dart';
import 'package:provider/provider.dart';

import 'add_word_screen.dart';

import '../models/words_model.dart';

class HomeScreen extends StatelessWidget {
  static const int dailyTarget = 20;

  Widget _buildProgressBar(int current, int target) {
    return SizedBox(
      height: 8.0,
      child: LinearProgressIndicator(
        value: current / target,
        backgroundColor: Colors.grey,
        valueColor: AlwaysStoppedAnimation<Color>(Colors.purple),
      ),
    );
  } 
  

 Widget _buildDrawer(BuildContext context) {
  return Drawer(
    child: ListView(
      padding: EdgeInsets.zero,
      children: [
        DrawerHeader(
          child: Text(
            'Menü',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          decoration: BoxDecoration(
            color: Colors.purple,
          ),
        ),
        _buildDrawerItem(
          context: context,
          icon: Icons.favorite,
          text: 'Favori Kelimeler',
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => FavoriteWordsScreen())),
        ),
        _buildDrawerItem(
          context: context,
          icon: Icons.gamepad,
          text: 'Anagram Oyunu',
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => AnagramScreen())),
        ),
        _buildDrawerItem(
          context: context,
          icon: Icons.bar_chart,
          text: 'Öğrenme İstatistikleri',
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => LearningStatsScreen())),
        ),
        _buildDrawerItem(
          context: context,
          icon: Icons.quiz,
          text: 'QUIZ',
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => QuizScreen())),
        ),
        _buildDrawerItem(
          context: context,
          icon: Icons.create,
          text: 'Boşluk Doldurma Oyunu',
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => FillInTheBlanksGame())),
        ),
      ],
    ),
  );
}

Widget _buildDrawerItem({
  required BuildContext context,
  required IconData icon,
  required String text,
  required VoidCallback onTap,
}) {
  return Column(
    children: [
      ListTile(
        tileColor: Colors.purple[50],
        leading: Icon(icon, color: Colors.purple),
        title: Text(
          text,
          style: TextStyle(color: Colors.purple, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        onTap: onTap,
      ),
      Divider(),
    ],
  );
}

Widget _buildFeatureItem(String text) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 8.0),
    child: Text(
      text,
      style: TextStyle(fontSize: 18),
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    void _showFeaturesDialog() {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(
          'Uygulama Özellikleri',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.purple),
        ),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildFeatureItem('1. Anagram oyunu oynayın.'),
            _buildFeatureItem('2. Kelimeler ekleyin, düzenleyin ve silin.'),
            _buildFeatureItem('3. İstatistiklerinizi görüntüleyin.'),
            _buildFeatureItem('4. Favori kelimelerinizi belirleyin.'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Kapat',
              style: TextStyle(color: Colors.purple, fontSize: 18),
            ),
          ),
        ],
      );
    },
  );
}



    return Scaffold(
      drawer: _buildDrawer(context),
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: Text('Kelime Kumbarası'),
        actions: [
          IconButton(
            icon: Icon(Icons.help_outline),
            onPressed: _showFeaturesDialog,
          ),
        ],
      ),
      body: Consumer<WordsModel>(
        builder: (context, wordsModel, child) {
          int todayWordCount = wordsModel.todayWordCount();
          return Column(
            children: [
              _buildProgressBar(todayWordCount, dailyTarget),
              Expanded(
                child: ListView.separated(
                  itemCount: wordsModel.words.length,
                  itemBuilder: (context, index) {
                    final word = wordsModel.words[index];
                    return ListTile(
                      title: Text(
                        '${index + 1}. ${word.english.toUpperCase()} - ${word.turkish.toUpperCase()}',
                        style: TextStyle(
                            fontSize: 21,
                            color: Colors.purple.shade900,
                            fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text('Örnek: ${word.example}'),
                      leading: IconButton(
                        icon: Icon(
                          word.isFavorite
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: word.isFavorite ? Colors.red : null,
                        ),
                        onPressed: () {
                          wordsModel.toggleFavorite(word);
                        },
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AddWordScreen(
                                  editIndex: index, editWord: word),
                            ),
                          );
                        },
                      ),
                      onLongPress: () async {
                        await showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Kelime Silinsin mi?'),
                              content: Text(
                                  'Bu kelimeyi silmek istediğinizden emin misiniz?'),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: Text('İptal'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    wordsModel.removeWord(index);
                                    Navigator.pop(context);
                                  },
                                  child: Text('Sil'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) =>
                      Divider(
                    color: Colors.grey,
                  ),
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddWordScreen()),
          );
        },
        backgroundColor: Colors.purple,
        child: Icon(Icons.add),
      ),
    );
  }
}
