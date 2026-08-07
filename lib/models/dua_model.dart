class DuaModel {
  final String id;
  final String title;
  final String category; // e.g., "Morning & Evening", "After Prayer", "Daily Life", "Travel"
  final String arabicText;
  final String urduTranslation;
  final String englishTranslation;
  final String reference;
  final String virtue;
  bool isFavorite;

  DuaModel({
    required this.id,
    required this.title,
    required this.category,
    required this.arabicText,
    required this.urduTranslation,
    required this.englishTranslation,
    required this.reference,
    this.virtue = '',
    this.isFavorite = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'category': category,
      'arabicText': arabicText,
      'urduTranslation': urduTranslation,
      'englishTranslation': englishTranslation,
      'reference': reference,
      'virtue': virtue,
      'isFavorite': isFavorite,
    };
  }

  factory DuaModel.fromJson(Map<String, dynamic> json) {
    return DuaModel(
      id: json['id'] as String,
      title: json['title'] as String,
      category: json['category'] as String,
      arabicText: json['arabicText'] as String,
      urduTranslation: json['urduTranslation'] as String,
      englishTranslation: json['englishTranslation'] as String,
      reference: json['reference'] as String,
      virtue: (json['virtue'] as String?) ?? '',
      isFavorite: (json['isFavorite'] as bool?) ?? false,
    );
  }
}
