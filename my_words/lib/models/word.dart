class Word {
  final int id;
  final String english;
  final String turkish;
  final String example;
  final DateTime createdAt;
  bool isFavorite;
  final String category;

  Word({
    required this.id,
    required this.english,
    required this.turkish,
    required this.example,
    required this.createdAt,
    this.isFavorite = false,
    required this.category,
  });

  factory Word.fromJson(Map<String, dynamic> json) {
    return Word(
      id: json['id'],
      english: json['english'],
      turkish: json['turkish'],
      example: json['example'],
      createdAt: DateTime.parse(json['createdAt']),
      category: json['category'] == null || json['category'].isEmpty ? "Kategorisiz" : json['category'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'english': english,
      'turkish': turkish,
      'example': example,
      'createdAt': createdAt.toIso8601String(),
      'category': category,
    };
  }
}
