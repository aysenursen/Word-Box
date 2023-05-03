import 'package:flutter/material.dart';

class Flashcard extends StatefulWidget {
  final String englishWord;
  final String turkishWord;
  final String example;
  final int index;
  final bool isFavorite;
  final Function(bool) onFavoriteChanged;
  final VoidCallback onDelete;
  final Color cardColor;

  const Flashcard({
    Key? key,
    required this.englishWord,
    required this.turkishWord,
    required this.example,
    required this.index,
    required this.isFavorite,
    required this.onFavoriteChanged,
    required this.onDelete,
    required this.cardColor,
  }) : super(key: key);

  @override
  _FlashcardState createState() => _FlashcardState();
}

class _FlashcardState extends State<Flashcard> {
  bool _showBackSide = false;

  void _toggleSide() {
    setState(() {
      _showBackSide = !_showBackSide;
    });
  }

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: [
              widget.cardColor,
              widget.cardColor,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 0, 0),
                  child: Text(
                    '${widget.index + 1}',
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    widget.isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: widget.isFavorite ? Colors.red.shade50 : themeData.iconTheme.color,
                    size: 28,
                  ),
                  onPressed: () {
                    widget.onFavoriteChanged(!widget.isFavorite);
                  },
                ),
              ],
            ),
            const SizedBox(height: 8),
            Center(
              child: Column(
                children: [
                  Text(
                    _showBackSide
                        ? widget.turkishWord.toUpperCase()
                        : widget.englishWord.toUpperCase(),
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: _showBackSide
                          ? Colors.white.withOpacity(0.85)
                          : Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40),
                  Text(
                    'Cümle: ' + widget.example.toUpperCase(),
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.delete,
                    size: 28,
                  ),
                  color: Colors.white,
                  onPressed: widget.onDelete,
                ),
                IconButton(
                  icon: Icon(
                    _showBackSide ? Icons.rotate_left : Icons.rotate_right,
                    size: 42,
                  ),
                  color: themeData.iconTheme.color,
                  onPressed: _toggleSide,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

