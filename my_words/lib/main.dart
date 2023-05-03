import 'package:flutter/material.dart';
import 'package:my_words/models/theme_model.dart';
import 'package:provider/provider.dart';

import 'screens/home_screen.dart';
import 'models/words_model.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final wordsModel = WordsModel();
  wordsModel.init();
  final themeModel = ThemeModel();
  await themeModel.loadTheme(); //
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<WordsModel>.value(value: wordsModel),
        ChangeNotifierProvider<ThemeModel>(create: (_) => ThemeModel()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ThemeModel(),
      child: KelimeKumbarasiApp(),
    );
  }
}

class KelimeKumbarasiApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeModel>(
      builder: (context, themeModel, child) {
        return MaterialApp(
          navigatorKey: navigatorKey,
          title: 'Kelime Kumbarası',
          theme: themeModel.currentTheme,
          home: HomeScreen(),
        );
      },
    );
  }
}
