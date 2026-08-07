class SurahVerseModel {
  final int number;
  final String arabic;
  final String urduTranslation;
  final String urduTafseer;
  final String englishTranslation;
  final String englishTafseer;

  SurahVerseModel({
    required this.number,
    required this.arabic,
    required this.urduTranslation,
    this.urduTafseer = '',
    required this.englishTranslation,
    this.englishTafseer = '',
  });

  Map<String, dynamic> toJson() => {
        'number': number,
        'arabic': arabic,
        'urduTranslation': urduTranslation,
        'urduTafseer': urduTafseer,
        'englishTranslation': englishTranslation,
        'englishTafseer': englishTafseer,
      };

  factory SurahVerseModel.fromJson(Map<String, dynamic> json) => SurahVerseModel(
        number: json['number'] as int,
        arabic: json['arabic'] as String,
        urduTranslation: json['urduTranslation'] as String,
        urduTafseer: (json['urduTafseer'] as String?) ?? '',
        englishTranslation: json['englishTranslation'] as String,
        englishTafseer: (json['englishTafseer'] as String?) ?? '',
      );
}

class SurahModel {
  final int number;
  final String nameArabic;
  final String nameUrdu;
  final String nameEnglish;
  final int versesCount;
  final String revelationType; // 'Meccan' or 'Medinan'
  final String virtueUrdu;
  final String virtueEnglish;
  final List<SurahVerseModel> verses;

  SurahModel({
    required this.number,
    required this.nameArabic,
    required this.nameUrdu,
    required this.nameEnglish,
    required this.versesCount,
    required this.revelationType,
    required this.virtueUrdu,
    required this.virtueEnglish,
    required this.verses,
  });
}
