import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:my_words/models/theme_model.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'screens/home_screen.dart';
import 'models/words_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final wordsModel = WordsModel();
  wordsModel.init();
  final themeModel = ThemeModel();
  await themeModel.loadTheme(); 
  FlutterNativeSplash.removeAfter(initialization);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<WordsModel>.value(value: wordsModel),
        ChangeNotifierProvider<ThemeModel>(create: (_) => ThemeModel()),
      ],
      child: const MyApp(),
    ),
  );
}
Future initialization(BuildContext? context) async{
  await Future.delayed(const Duration(seconds: 3));
}
 
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ChangeNotifierProvider(
        create: (context) => ThemeModel(),
        child: const KelimeKumbarasiApp(),
      ),
    );
  }
}

class KelimeKumbarasiApp extends StatelessWidget {
  const KelimeKumbarasiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Consumer<ThemeModel>(
        builder: (context, themeModel, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            navigatorKey: navigatorKey,
            title: 'Kelime Kumbarası',
            supportedLocales: const [
  Locale('en', ''), // İngilizce
  Locale('tr', ''), // Türkçe
  Locale('fr', ''), // Fransızca
  Locale('de', ''), // Almanca
  Locale('it', ''), // İtalyanca
  Locale('ru', ''), // Rusça
  Locale('es', ''), // İspanyolca
  Locale('pt', ''), // Portekizce
  Locale('el', ''), // Yunanca
  Locale('ko', ''), // Korece
  Locale('hu', ''), // Macarca
  Locale('pl', ''), // Lehçe
  Locale('da', ''), // Danca
],
localizationsDelegates: const [
  AppLocalizations.delegate,
  GlobalMaterialLocalizations.delegate,
  GlobalWidgetsLocalizations.delegate,
  GlobalCupertinoLocalizations.delegate,
],

            theme: themeModel.currentTheme,
            home: const HomeScreen(),
          );
        },
      ),
    );
  }
}
