class Word {
final int id;
  final String english;
  final String turkish;
  final String example;
  final DateTime createdAt;
  bool isFavorite;

  Word({
    required this.id,
    required this.english,
    required this.turkish,
    required this.example,
    required this.createdAt,
    this.isFavorite = false,
  });

  factory Word.fromJson(Map<String, dynamic> json) {
    return Word(
      id: json['id'],
      english: json['english'],
      turkish: json['turkish'],
      example: json['example'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'english': english,
      'turkish': turkish,
      'example': example,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
