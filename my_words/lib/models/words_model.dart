import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:my_words/main.dart';
import 'package:my_words/models/category.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'word.dart';

class WordsModel extends ChangeNotifier {
  List<Word> _words = [];
  List<Category> _categories = [];
  List<Word> get words => _words;
  Set<String> _achievements = {};

  WordsModel() {
    fetchWords();
  }
  Map<DateTime, int> _learningStats = {};

  Map<DateTime, int> get learningStats => _learningStats;

  Future<void> fetchWords() async {
    final prefs = await SharedPreferences.getInstance();
    final wordsData = prefs.getStringList('words') ?? [];

    _words = wordsData
        .map((wordJson) => Word.fromJson(jsonDecode(wordJson)))
        .toList();
    await _loadLearningStats();
    notifyListeners();
  }

  DateTime _getTodayDate() {
    DateTime now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  void addWord(Word newWord, BuildContext context) {
    if (newWord.category.isEmpty) {
      newWord = Word(
        id: newWord.id,
        english: newWord.english,
        turkish: newWord.turkish,
        example: newWord.example,
        createdAt: newWord.createdAt,
        isFavorite: newWord.isFavorite,
        category: "Kategorisiz",
      );
    }
    _words.add(newWord);
    notifyListeners();
    _updateLearningStats(newWord);
    _saveWords();
    checkAchievements();
  }

  void _updateLearningStats(Word word, {bool shouldIncrement = true}) {
    final wordDate = word.createdAt;
    final wordDay = DateTime(wordDate.year, wordDate.month, wordDate.day);

    if (shouldIncrement) {
      if (_learningStats.containsKey(wordDay)) {
        _learningStats[wordDay] = _learningStats[wordDay]! + 1;
      } else {
        _learningStats[wordDay] = 1;
      }
    } else {
      if (_learningStats.containsKey(wordDay) && _learningStats[wordDay]! > 0) {
        _learningStats[wordDay] = _learningStats[wordDay]! - 1;
      }
    }
  }

  void updateWord(Word updatedWord, int index) {
    _words[index] = updatedWord;
    notifyListeners();
    _saveWords();
  }

  Future<void> _saveWords() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> wordsJson =
        _words.map((word) => jsonEncode(word.toJson())).toList();
    await prefs.setStringList('wordsData', wordsJson);
  }

  Future<void> removeWord(int index) async {
    Word removedWord = _words[index];
    _updateLearningStats(removedWord, shouldIncrement: false);
    _words.removeAt(index);

    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList(
        'wordsData', _words.map((word) => jsonEncode(word.toJson())).toList());

    _saveLearningStats();

    notifyListeners();
  }

  int todayWordCount() {
    DateTime now = DateTime.now();
    DateTime todayStart = DateTime(now.year, now.month, now.day);
    DateTime todayEnd = todayStart.add(const Duration(days: 1));

    return words
        .where((word) =>
            word.createdAt.isAfter(todayStart) &&
            word.createdAt.isBefore(todayEnd))
        .length;
  }

  List<Word> get favoriteWords {
    return _words.where((word) => word.isFavorite).toList();
  }

  void toggleFavorite(Word word) {
    int index = _words.indexWhere((element) => element.id == word.id);
    if (index != -1) {
      _words[index].isFavorite = !_words[index].isFavorite;
      notifyListeners();
      _saveFavorites();
    }
  }

  Future<void> _saveFavorites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> favoriteIds = _words
        .where((word) => word.isFavorite)
        .map((word) => word.id.toString())
        .toList();
    await prefs.setStringList('favoriteWords', favoriteIds);
  }

  Future<void> _loadFavorites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> favoriteIds = prefs.getStringList('favoriteWords') ?? [];
    _words.forEach((word) {
      if (favoriteIds.contains(word.id.toString())) {
        word.isFavorite = true;
      }
    });
  }

  Future<void> _loadWords() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? wordsData = prefs.getStringList('wordsData');

    if (wordsData != null) {
      List<dynamic> wordsJson =
          wordsData.cast<String>().map(jsonDecode).toList();
      _words = wordsJson.map((json) => Word.fromJson(json)).toList();
    }
  }

  Future<void> _saveLearningStats() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> learningStatsJson = _learningStats.entries
        .map((entry) => jsonEncode({
              'date': entry.key.toIso8601String(),
              'count': entry.value,
            }))
        .toList();
    await prefs.setStringList('learningStats', learningStatsJson);
  }

  Future<void> _loadLearningStats() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? learningStatsData = prefs.getStringList('learningStats');

    if (learningStatsData != null) {
      List<dynamic> learningStatsJson =
          learningStatsData.cast<String>().map(jsonDecode).toList();
      _learningStats = {
        for (var json in learningStatsJson)
          DateTime.parse(json['date']): json['count']
      };
    }

    DateTime startDate = _getTodayDate().subtract(const Duration(days: 30));

    for (int i = 0; i <= 30; i++) {
      DateTime currentDate = startDate.add(Duration(days: i));
      if (!_learningStats.containsKey(currentDate)) {
        _learningStats[currentDate] = 0;
      }
    }

    _learningStats = Map.fromEntries(
      _learningStats.entries.toList()..sort((a, b) => a.key.compareTo(b.key)),
    );
  }

  // words_model.dart dosyasında WordsModel sınıfına bu işlevi ekleyin
// words_model.dart dosyasında WordsModel sınıfına bu işlevi ekleyin
  void _updateLearningStatsOnDelete(DateTime date) {
    DateTime dateOnly = DateTime(date.year, date.month, date.day);
    if (_learningStats.containsKey(dateOnly)) {
      _learningStats[dateOnly] = _learningStats[dateOnly]! - 1;
      if (_learningStats[dateOnly] == 0) {
        _learningStats.remove(dateOnly);
      }
      notifyListeners();
    }
  }

  void checkAchievements() {
    int wordCount = _words.length;
    if (15 > wordCount &&
        wordCount >= 10 &&
        !_achievements.contains('Yeni Başlayan')) {
      _achievements.add('Yeni Başlayan');
      showMotivationMessage('Tebrikler 10 Kelime Kaydettin!');
    } else if (wordCount >= 50 && !_achievements.contains('ORTA Başlayan')) {
      _achievements.add('ORTA Başlayan');
      showMotivationMessage('Tebrikler 50 Kelime Kaydettin!');
    }
    // Diğer başarımlar için benzer koşullar ekle
  }

  void showMotivationMessage(String message) {
    final overlayState = navigatorKey.currentState!.overlay!;

    OverlayEntry overlayEntry = OverlayEntry(builder: (context) {
      return Center(
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                spreadRadius: 5,
                blurRadius: 7,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.emoji_events_outlined,
                size: 48,
                color: Colors.purple,
              ),
              Text(
                message,
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.purple,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      );
    });

    overlayState.insert(overlayEntry);

    Future.delayed(const Duration(seconds: 3)).then((value) {
      overlayEntry.remove();
    });
  }

  List<String> getCategories() {
    Set<String> categories = {};
    for (var word in _words) {
      categories.add(word.category);
    }
    return categories.toList();
  }

  List<Word> getWordsByCategory(String category) {
    return _words.where((word) => word.category == category).toList();
  }

  List<Word> get allWords {
    List<Word> combinedWords = [..._words];
    _categories.forEach((category) {
      combinedWords.addAll(category.words);
    });
    return combinedWords;
  }

  void addUncategorizedWord(Word word) {
    _words.add(word);
    notifyListeners();
  }

  Future<void> init() async {
    await _loadWords();
    await _loadFavorites();
    _saveLearningStats();
    _loadLearningStats();
    notifyListeners();
  }
}
