import 'package:flutter/material.dart';
import 'package:my_words/widgets/drawer.dart';
import 'package:my_words/widgets/flashcard.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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
          text: AppLocalizations.of(context)!.play_anagram_game,
          icon: Icons.gamepad_outlined),
      FeatureItem(
          text: AppLocalizations.of(context)!.add_edit_delete_words,
          icon: Icons.edit_outlined),
      FeatureItem(
          text: AppLocalizations.of(context)!.examine_your_learning_statistics,
          icon: Icons.bar_chart),
      FeatureItem(
          text: AppLocalizations.of(context)!.determine_your_favorite_words,
          icon: Icons.star_border),
      FeatureItem(
          text: AppLocalizations.of(context)!.play_fill_in_the_blank_game,
          icon: Icons.quiz_outlined),
      FeatureItem(
          text: AppLocalizations.of(context)!.create_word_categories,
          icon: Icons.category_outlined),
    ];
  }

  // Show features dialog
  void _showFeaturesDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            AppLocalizations.of(context)!.app_features,
            style: const TextStyle(
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
              child: Text(
                AppLocalizations.of(context)!.close,
                style: const TextStyle(color: Colors.purple, fontSize: 18),
              ),
            ),
          ],
        );
      },
    );
  }

  // Build app bar
  PreferredSize _buildAppBar(ThemeData themeData) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(kToolbarHeight + 5),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              themeData.primaryColor,
              Colors.blue
            ], // Gradient renklerini kendi renklerinizle değiştirin
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Padding(
            padding: EdgeInsets.fromLTRB(0, 16, 0, 0),
            child: Center(
              child: Text(
                'Word Box',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.help_outline, color: Colors.white),
              onPressed: _showFeaturesDialog,
            ),
          ],
        ),
      ),
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
            MaterialPageRoute(builder: (context) => const AddWordScreen()),
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
      return Center(
        child: Text(
          AppLocalizations.of(context)!.press_plus +
              "\n" +
              AppLocalizations.of(context)!.try_adding_words,
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: themeData.textSelectionTheme.cursorColor),
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
