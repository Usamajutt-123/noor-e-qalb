import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/daily_task_model.dart';
import '../data/islamic_data.dart';

class DailyTaskService extends ChangeNotifier {
  static const String _streakKey = 'noor_daily_streak_count';
  static const String _lastCompletedDateKey = 'noor_last_completed_date';

  List<DailyTaskModel> _currentTasks = [];
  int _streakCount = 0;
  bool _allCompletedToday = false;

  List<DailyTaskModel> get currentTasks => _currentTasks;
  int get streakCount => _streakCount;
  bool get allCompletedToday => _allCompletedToday;

  DailyTaskService() {
    _loadState();
  }

  Future<void> _loadState() async {
    final prefs = await SharedPreferences.getInstance();
    _streakCount = prefs.getInt(_streakKey) ?? 1;

    // Pick 4 tasks seeded by today's date
    _generateDailyTasks();

    notifyListeners();
  }

  void _generateDailyTasks() {
    final List<DailyTaskModel> all = List.from(IslamicData.allDailyTasks);
    all.shuffle(Random(DateTime.now().day + DateTime.now().month * 31));
    _currentTasks = all.take(4).toList();
    _checkAllCompleted();
  }

  void shuffleRandomTasks() {
    final List<DailyTaskModel> all = List.from(IslamicData.allDailyTasks);
    all.shuffle();
    _currentTasks = all.take(4).map((t) {
      t.isCompleted = false;
      return t;
    }).toList();
    _allCompletedToday = false;
    notifyListeners();
  }

  void toggleTask(String id) async {
    for (var task in _currentTasks) {
      if (task.id == id) {
        task.isCompleted = !task.isCompleted;
        break;
      }
    }
    _checkAllCompleted();
    notifyListeners();

    if (_allCompletedToday) {
      final prefs = await SharedPreferences.getInstance();
      _streakCount++;
      await prefs.setInt(_streakKey, _streakCount);
      await prefs.setString(_lastCompletedDateKey, DateTime.now().toIso8601String());
    }
  }

  void _checkAllCompleted() {
    _allCompletedToday = _currentTasks.every((t) => t.isCompleted);
  }
}
