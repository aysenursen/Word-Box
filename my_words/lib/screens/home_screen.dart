import 'package:flutter/material.dart';
import 'package:my_words/widgets/drawer.dart';
import 'package:my_words/widgets/flashcard.dart';
import 'package:provider/provider.dart';

import 'add_word_screen.dart';
import '../models/words_model.dart';
import '../widgets/feature_item.dart';

class HomeScreen extends StatefulWidget {
  static const int dailyTarget = 20;

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Build progress bar
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

  // Build features list
  List<Widget> _buildFeaturesList() {
    return [
      FeatureItem(
          text: '1. Anagram oyunu oynayın.', icon: Icons.gamepad_outlined),
      FeatureItem(
          text: '2. Kelimeler ekleyin, düzenleyin ve silin.',
          icon: Icons.edit_outlined),
      FeatureItem(
          text: '3. İstatistiklerinizi görüntüleyin.', icon: Icons.bar_chart),
      FeatureItem(
          text: '4. Favori kelimelerinizi belirleyin.',
          icon: Icons.star_border),
      FeatureItem(
          text: '5. Boşluk doldurma oyunu oynayın.', icon: Icons.quiz_outlined),
      FeatureItem(
          text: '6. Öğrenme istatistiklerinizi inceleyin.',
          icon: Icons.analytics_outlined),
      FeatureItem(
          text: '7. Kelime kategorileri oluşturun.',
          icon: Icons.category_outlined),
    ];
  }

  // Show features dialog
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
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: _buildFeaturesList(),
            ),
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

  // Build app bar
  AppBar _buildAppBar(ThemeData themeData) {
    return AppBar(
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
    );
  }

  // Build floating action button
  Widget _buildFloatingActionButton(ThemeData themeData) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: FloatingActionButton(
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

  // Build body content
  Widget _buildBodyContent(WordsModel wordsModel, ThemeData themeData) {
    int todayWordCount = wordsModel.todayWordCount();

    if (wordsModel.allWords.length == 0) {
      return const Center(
        child: Text(
          "             '+' Tuşuna Basarak\n Ekrana Kelime Eklemeyi Deneyin.",
          style: TextStyle(
              fontSize: 24, fontWeight: FontWeight.bold, color: Colors.purple),
        ),
      );
    } else {
      return Column(
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
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);

    return Scaffold(
      drawer: buildDrawer(context),
      appBar: _buildAppBar(themeData),
      body: Consumer<WordsModel>(
        builder: (context, wordsModel, child) =>
            _buildBodyContent(wordsModel, themeData),
      ),
      floatingActionButton: _buildFloatingActionButton(themeData),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
