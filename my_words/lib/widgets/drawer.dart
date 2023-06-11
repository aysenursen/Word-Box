import 'package:flutter/material.dart';
import 'package:my_words/models/theme_model.dart';
import 'package:my_words/screens/anagram_screen.dart';
import 'package:my_words/screens/category_list_screen.dart';
import 'package:my_words/screens/favorite_words_screen.dart';
import 'package:my_words/screens/fill_in_blanks_screen.dart';
import 'package:my_words/screens/learning_stats_screen.dart';
import 'package:my_words/screens/quiz_screens.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:my_words/models/words_model.dart';

void _showThemeDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      final themeModel = Provider.of<ThemeModel>(context, listen: false);

      return AlertDialog(
        title:  Text(AppLocalizations.of(context)!.select_theme),
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

void _showWarningDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        title: Text(
          AppLocalizations.of(context)!.alert,
          style: const TextStyle(
            color: Colors.red,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              RichText(
                text: TextSpan(
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.black54,
                  ),
                  children: <TextSpan>[
                    TextSpan(text: AppLocalizations.of(context)!.before_games),
                    TextSpan(
                      text: AppLocalizations.of(context)!.must_add_words,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text(
              'OKEY',
              style: TextStyle(
                color: Colors.red,
                fontSize: 18,
              ),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}




Widget buildDrawer(BuildContext context) {
  ThemeData themeData = Theme.of(context);
  int wordCount = Provider.of<WordsModel>(context).words.length;

  return Drawer(
    child: ListView(
      padding: EdgeInsets.zero,
      children: [
         DrawerHeader(
          child: Text(
            AppLocalizations.of(context)!.menu,
            style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white),
          ),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [themeData.primaryColor, const Color(0xFF00d2ff)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        buildDrawerItem(
          context: context,
          icon: Icons.favorite,
          text: AppLocalizations.of(context)!.favorite_words,
          onTap: () => Navigator.push(context,
              MaterialPageRoute(builder: (context) => FavoriteWordsScreen())),
        ),
        buildDrawerItem(
          context: context,
          icon: Icons.gamepad,
          text: AppLocalizations.of(context)!.anagram_game,
          onTap: wordCount < 3 
            ? () => _showWarningDialog(context)
            : () => Navigator.push(context,
              MaterialPageRoute(builder: (context) => const AnagramScreen())),
        ),
        buildDrawerItem(
          context: context,
          icon: Icons.bar_chart,
          text: AppLocalizations.of(context)!.learning_statistic,
          onTap: () => Navigator.push(context,
              MaterialPageRoute(builder: (context) => LearningStatsScreen())),
        ),
        buildDrawerItem(
          context: context,
          icon: Icons.quiz,
          text: AppLocalizations.of(context)!.quiz,
          onTap: wordCount < 3 
            ? () => _showWarningDialog(context)
            : () => Navigator.push(context,
              MaterialPageRoute(builder: (context) => const QuizScreen())),
        ),
        buildDrawerItem(
          context: context,
          icon: Icons.create,
          text: AppLocalizations.of(context)!.fill_in_the_blank_game,
          onTap: wordCount < 3 
            ? () => _showWarningDialog(context)
            : () => Navigator.push(context,
              MaterialPageRoute(builder: (context) =>  FillInTheBlanksGame())),
        ),
        buildDrawerItem(
          context: context,
          icon: Icons.category,
          text: AppLocalizations.of(context)!.word_categories,
          onTap: () => Navigator.push(context,
              MaterialPageRoute(builder: (context) => CategoryListScreen())),
        ),
        buildDrawerItem(
          context: context,
          icon: Icons.color_lens,
          text: AppLocalizations.of(context)!.select_theme,
          onTap: () => _showThemeDialog(context),
        ),
      ],
    ),
  );
}

Widget buildDrawerItem(
    {required BuildContext context,
    required IconData icon,
    required String text,
    required VoidCallback onTap,
    ThemeData? themeData}) {
      ThemeData themeData = Theme.of(context);
  return Column(
    children: [
      Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          gradient:  LinearGradient(
            colors: [themeData.primaryColor, const Color(0xFF00d2ff)],
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
