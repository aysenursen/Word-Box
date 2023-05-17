import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeModel extends ChangeNotifier {
  ThemeData currentTheme = ThemeData.light();
  // Mevcut tema indeksi
  int currentThemeIndex = 0;

  ThemeModel() {
    loadTheme();
  }

  // Yeni bir özellik: Tema indeksini SharedPreferences'tan yükleme
  Future<void> loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    currentThemeIndex = prefs.getInt('themeIndex') ?? 0;
    currentTheme = availableThemes[currentThemeIndex];
    notifyListeners();
  }

  // Yeni bir özellik: Tema indeksini SharedPreferences'a kaydetme
  Future<void> saveTheme(int themeIndex) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('themeIndex', themeIndex);
  }

  // Temaları bir dizi içinde saklama
  List<ThemeData> availableThemes = [
    ThemeData.light(),
    ThemeData.dark().copyWith(
      textSelectionTheme: const TextSelectionThemeData(
        cursorColor: Colors.white,
      ),
    ),
    ThemeData(
      primarySwatch: Colors.green,
      brightness: Brightness.light,
      textSelectionTheme: const TextSelectionThemeData(
        cursorColor: Colors.green,
      ),
    ),
    ThemeData(
      primarySwatch: Colors.purple,
      brightness: Brightness.light,
      textSelectionTheme: const TextSelectionThemeData(
        cursorColor: Colors.purple,
      ),
    ),
  ];

  // Mevcut temayı değiştiren bir fonksiyon
  void changeTheme(int themeIndex) {
    currentThemeIndex = themeIndex;
    currentTheme = availableThemes[themeIndex];
    saveTheme(themeIndex); // Seçilen tema indeksini SharedPreferences'a kaydet
    notifyListeners();
  }
}
