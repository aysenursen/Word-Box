import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'screens/home_screen.dart';
import 'models/words_model.dart';
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final wordsModel = WordsModel();
  wordsModel.init();

  runApp(
    ChangeNotifierProvider<WordsModel>.value(
      value: wordsModel,
      child: KelimeKumbarasiApp(),
    ),
  );
}


class KelimeKumbarasiApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      title: 'Kelime Kumbarası',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HomeScreen(),
    );
  }
}
