import 'package:flutter/material.dart';
import 'package:my_words/models/words_model.dart';
import 'package:my_words/screens/add_word_screen.dart';
import 'package:my_words/screens/category_words_screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CategoryListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title:  Text(AppLocalizations.of(context)!.categories),
        backgroundColor: themeData.primaryColor,
      ),
      body: Consumer<WordsModel>(
        builder: (context, wordsModel, child) {
          List<String> categories = wordsModel.getCategories();
          return ListView.separated(
            itemCount: categories.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(
                  categories[index],
                  style: TextStyle(fontSize: 21, color:themeData.textSelectionTheme.cursorColor),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CategoryWordsScreen(
                        category: categories[index],
                      ),
                    ),
                  );
                },
              );
            },
            separatorBuilder: (BuildContext context, int index) => const Divider(
              color: Colors.grey,
            ),
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
        backgroundColor:themeData.primaryColor,
        child: const Icon(Icons.add),
      ),
    );
  }
}