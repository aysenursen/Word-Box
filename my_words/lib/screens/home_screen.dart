import 'package:flutter/material.dart';
import 'package:my_words/models/theme_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:my_words/screens/anagram_screen.dart';
import 'package:my_words/screens/category_list_screen.dart';
import 'package:my_words/screens/favorite_words_screen.dart';
import 'package:my_words/screens/fill_in_blanks_screen.dart';
import 'package:my_words/screens/learning_stats_screen.dart';
import 'package:my_words/screens/quiz_screens.dart';
import 'package:my_words/widgets/flashcard.dart';
import 'package:provider/provider.dart';

import 'add_word_screen.dart';
import '../models/words_model.dart';

class HomeScreen extends StatefulWidget {
  static const int dailyTarget = 20;

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Widget _buildProgressBar(int current, int target) {
    return SizedBox(
      height: 8.0,
      child: LinearProgressIndicator(
        value: current / target,
        backgroundColor: Colors.grey,
        valueColor: const AlwaysStoppedAnimation<Color>(Colors.purple),
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
              AppLocalizations.of(context)!.menu,
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF3a7bd5), Color(0xFF00d2ff)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          _buildDrawerItem(
            context: context,
            icon: Icons.favorite,
            text: AppLocalizations.of(context)!.favoriteWords,
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => FavoriteWordsScreen())),
          ),
          _buildDrawerItem(
            context: context,
            icon: Icons.gamepad,
            text: AppLocalizations.of(context)!.anagramGame,
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => const AnagramScreen())),
          ),
          _buildDrawerItem(
            context: context,
            icon: Icons.bar_chart,
            text: AppLocalizations.of(context)!.learningStatistics,
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => LearningStatsScreen())),
          ),
          _buildDrawerItem(
            context: context,
            icon: Icons.quiz,
            text: AppLocalizations.of(context)!.quiz,
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => const QuizScreen())),
          ),
          _buildDrawerItem(
            context: context,
            icon: Icons.create,
            text: AppLocalizations.of(context)!.fillInTheBlanksGame,
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => FillInTheBlanksGame())),
          ),
          _buildDrawerItem(
            context: context,
            icon: Icons.category,
            text: AppLocalizations.of(context)!.wordCategories,
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => CategoryListScreen())),
          ),
          _buildDrawerItem(
            context: context,
            icon: Icons.color_lens,
            text: AppLocalizations.of(context)!.chooseTheme,
            onTap: () => _showThemeDialog(context),
          ),
          // Burada yeni kategori için bir öğe ekleyin
        ],
      ),
    );
  }

  void _showThemeDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      final themeModel = Provider.of<ThemeModel>(context, listen: false);

      return AlertDialog(
        title:  Text(AppLocalizations.of(context)!.chooseTheme),
        content: SingleChildScrollView(
          child: Column(
            children: [
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 8.0,
                runSpacing: 8.0,
                children: [
                  for (int themeIndex = 0;
                      themeIndex < themeModel.availableThemes.length;
                      themeIndex++)
                    InkWell(
                      onTap: () {
                        themeModel.changeTheme(themeIndex);
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          color: themeModel.availableThemes[themeIndex]
                              .primaryColor,
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}



  Widget _buildDrawerItem(
      {required BuildContext context,
      required IconData icon,
      required String text,
      required VoidCallback onTap,
      ThemeData? themeData}) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            gradient: const LinearGradient(
              colors: [Color(0xFF3a7bd5), Color(0xFF00d2ff)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          margin: const EdgeInsets.symmetric(vertical: 4),
          child: ListTile(
            tileColor: Colors.transparent,
            leading: Icon(icon, color: Colors.white),
            title: Text(
              text,
              style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18),
            ),
            onTap: onTap,
          ),
        ),
        const Divider(),
      ],
    );
  }

  Widget _buildFeatureItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        text,
        style: const TextStyle(fontSize: 18),
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
            title: const Text(
              'Uygulama Özellikleri',
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.purple),
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
                child: const Text(
                  'Kapat',
                  style: TextStyle(color: Colors.purple, fontSize: 18),
                ),
              ),
            ],
          );
        },
      );
    }

    ThemeData themeData = Theme.of(context);
    return Scaffold(
      drawer: _buildDrawer(context),
      appBar: AppBar(
        backgroundColor: themeData.appBarTheme.foregroundColor,
        title: const Text(
          'Kelime Kumbarası',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline, color: Colors.white),
            onPressed: _showFeaturesDialog,
          ),
        ],
      ),
      body: Consumer<WordsModel>(
        builder: (context, wordsModel, child) {
          int todayWordCount = wordsModel.todayWordCount();
          return wordsModel.allWords.length == 0
              ? const Center(
                  child: Text(
                  "             '+' Tuşuna Basarak\n Ekrana Kelime Eklemeyi Deneyin.",
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.purple),
                ))
              : Column(
                  children: [
                    _buildProgressBar(todayWordCount, HomeScreen.dailyTarget),
                    Expanded(
                      child: ListView.separated(
                        itemCount: wordsModel.allWords.length,
                        itemBuilder: (context, index) {
                          final word = wordsModel.allWords[index];
                          return Flashcard(
                            englishWord: word.english,
                            turkishWord: word.turkish,
                            example: word.example,
                            index: index,
                            isFavorite: word.isFavorite,
                            onFavoriteChanged: (bool isFavorite) {
                              setState(() {});
                              wordsModel.toggleFavorite(word);
                            },
                            onDelete: () {
                              wordsModel.removeWord(index);
                            },
                            cardColor: themeData.primaryColor,
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) =>
                            const Divider(
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
        backgroundColor: themeData.iconTheme.color,
        child: const Icon(Icons.add),
      ),
    );
  }
}
