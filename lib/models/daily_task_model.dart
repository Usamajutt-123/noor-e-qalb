class DailyTaskModel {
  final String id;
  final String titleUrdu;
  final String titleEnglish;
  final String category; // 'Dhikr', 'Quran', 'Sunnah', 'Sadaqah', 'Namaz'
  final String rewardVirtue;
  bool isCompleted;

  DailyTaskModel({
    required this.id,
    required this.titleUrdu,
    required this.titleEnglish,
    required this.category,
    required this.rewardVirtue,
    this.isCompleted = false,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'titleUrdu': titleUrdu,
        'titleEnglish': titleEnglish,
        'category': category,
        'rewardVirtue': rewardVirtue,
        'isCompleted': isCompleted,
      };

  factory DailyTaskModel.fromJson(Map<String, dynamic> json) => DailyTaskModel(
        id: json['id'] as String,
        titleUrdu: json['titleUrdu'] as String,
        titleEnglish: json['titleEnglish'] as String,
        category: json['category'] as String,
        rewardVirtue: (json['rewardVirtue'] as String?) ?? '',
        isCompleted: (json['isCompleted'] as bool?) ?? false,
      );
}
