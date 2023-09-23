import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../models/word.dart';
import '../screens/add_edit_word_screen.dart';

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
    double deviceHeightScale = 0;
    if (screenHeight >= 667.0 && screenHeight <= 685) {
      deviceHeightScale = 0.25;
    } else if (screenHeight >= 686 && screenHeight <= 725) {
      deviceHeightScale = 0.24;
    } else if (screenHeight >= 736 && screenHeight <= 843) {
      deviceHeightScale = 0.23;
    } else if (screenHeight >= 844 && screenHeight <= 879) {
      deviceHeightScale = 0.215;
    } else if (screenHeight >= 880 && screenHeight <= 920) {
      deviceHeightScale = 0.20;
    } else if (screenHeight >= 921 && screenHeight <= 935) {
      deviceHeightScale = 0.19;
    } else {
      deviceHeightScale = 0.28;
    }
    print("yükseklik: " + screenHeight.toString());
    print("genişlik: " + screenWidth.toString());
    // setState(() {
    print(deviceHeightScale);
    // });
    return GestureDetector(
      onLongPress: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return EditWordScreen(
            word: Word(
              id: widget.index, // You should replace this with actual ID
              english: widget.englishWord,
              turkish: widget.turkishWord,
              example: widget.example,
              createdAt: DateTime
                  .now(), // You should replace this with actual createdAt
              isFavorite: widget.isFavorite,
              category: '', // You should replace this with actual category
            ),
            index: widget.index,
          );
        })); 
      },
      child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: screenWidth,
            maxHeight: screenHeight * deviceHeightScale,
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
                    const Color.fromARGB(200, 62, 95, 202)
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              padding: const EdgeInsets.fromLTRB(4, 12, 4, 0),
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
                  //const SizedBox(height: 8),
                  Center(
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
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
                              key: const ValueKey('backSide'),
                            )
                          : Text(
                              widget.englishWord.toUpperCase(),
                              style: TextStyle(
                                fontSize: screenWidth * 0.05,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                              key: const ValueKey('frontSide'),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                    ),
                  ),

                  SizedBox(height: screenWidth * 0.005),
                  Center(
                    child: Text(
                      overflow: TextOverflow.ellipsis,
                      AppLocalizations.of(context)!.sentence +
                          ': ' +
                          widget.example,
                      style: TextStyle(
                        color: Colors.white70,
                        fontWeight: FontWeight.w300,
                        fontSize: screenHeight * 0.015,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.delete,
                          size: screenHeight * 0.035,
                        ),
                        color: Colors.white,
                        onPressed: widget.onDelete,
                      ),
                      IconButton(
                        padding: const EdgeInsets.fromLTRB(0, 0, 16, 0),
                        icon: Icon(
                          _showBackSide
                              ? Icons.rotate_left
                              : Icons.rotate_right,
                          size: screenHeight * 0.055,
                        ),
                        color: themeData.iconTheme.color,
                        onPressed: _toggleSide,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
