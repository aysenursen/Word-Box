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

class _FlashcardState extends State<Flashcard>
    with SingleTickerProviderStateMixin {
  bool _showBackSide = false;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
  }

  void _toggleSide() {
    setState(() {
      _showBackSide = !_showBackSide;
    });
  }

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: screenWidth * 0.3,
          maxHeight: screenHeight * 0.2,
        ),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: LinearGradient(
                colors: [
                  themeData.primaryColor,
                  Color.fromARGB(200, 62, 95, 202)
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
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
                        style: TextStyle(
                          fontSize: screenWidth * 0.05,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        widget.isFavorite
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: widget.isFavorite
                            ? Colors.red.shade50
                            : themeData.iconTheme.color,
                        size: screenWidth * 0.07,
                      ),
                      onPressed: () {
                        _controller
                          ..reset()
                          ..forward();
                        widget.onFavoriteChanged(!widget.isFavorite);
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Center(
                  child: AnimatedSwitcher(
                    duration: Duration(milliseconds: 200),
                    transitionBuilder:
                        (Widget child, Animation<double> animation) {
                      return ScaleTransition(
                        child: child,
                        scale: animation,
                      );
                    },
                    child: _showBackSide
                        ? Text(
                            widget.turkishWord.toUpperCase(),
                            style: TextStyle(
                              fontSize: screenWidth * 0.05,
                              fontWeight: FontWeight.bold,
                              color: Colors.white.withOpacity(0.85),
                            ),
                            textAlign: TextAlign.center,
                            key: ValueKey('backSide'),
                          )
                        : Text(
                            widget.englishWord.toUpperCase(),
                            style: TextStyle(
                              fontSize: screenWidth * 0.05,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                            key: ValueKey('frontSide'),
                          ),
                  ),
                ),
                SizedBox(height: screenWidth * 0.035),
                Center(
                  child: Text(
                    'Cümle: ' + widget.example.toUpperCase(),
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w700),
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
        ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
