class TasbeehModel {
  final String id;
  final String title;
  final String arabicText;
  final String translation;
  final int targetCount; // 33, 100, 1000, etc.
  int currentCount;
  int completedLaps;

  TasbeehModel({
    required this.id,
    required this.title,
    required this.arabicText,
    required this.translation,
    required this.targetCount,
    this.currentCount = 0,
    this.completedLaps = 0,
  });

  void increment() {
    currentCount++;
    if (currentCount >= targetCount) {
      completedLaps++;
      currentCount = 0;
    }
  }

  void reset() {
    currentCount = 0;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'arabicText': arabicText,
      'translation': translation,
      'targetCount': targetCount,
      'currentCount': currentCount,
      'completedLaps': completedLaps,
    };
  }

  factory TasbeehModel.fromJson(Map<String, dynamic> json) {
    return TasbeehModel(
      id: json['id'] as String,
      title: json['title'] as String,
      arabicText: json['arabicText'] as String,
      translation: json['translation'] as String,
      targetCount: json['targetCount'] as int,
      currentCount: (json['currentCount'] as int?) ?? 0,
      completedLaps: (json['completedLaps'] as int?) ?? 0,
    );
  }
}
