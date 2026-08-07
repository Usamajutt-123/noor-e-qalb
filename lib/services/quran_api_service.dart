import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../models/surah_model.dart';

class QuranApiService extends ChangeNotifier {
  static const String _cachePrefix = 'noor_surah_api_v2_';

  bool _isLoading = false;
  String _errorMessage = '';
  bool _isOnlineSynced = false;

  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  bool get isOnlineSynced => _isOnlineSynced;

  /// Fetches full verses of any Surah (#1 to #114) from Al-Quran Cloud API with translation & tafseer
  Future<List<SurahVerseModel>> fetchSurahVerses(int surahNumber, {bool forceRefresh = false}) async {
    _isLoading = true;
    _errorMessage = '';
    _isOnlineSynced = false;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    final cacheKey = '$_cachePrefix$surahNumber';

    // 1. Check offline cache if not forcing refresh
    if (!forceRefresh) {
      final cachedJson = prefs.getString(cacheKey);
      if (cachedJson != null && cachedJson.isNotEmpty) {
        try {
          final List<dynamic> decoded = jsonDecode(cachedJson);
          final List<SurahVerseModel> verses = decoded.map((v) {
            return SurahVerseModel.fromJson(v as Map<String, dynamic>);
          }).toList();

          _isLoading = false;
          _isOnlineSynced = true;
          notifyListeners();
          return verses;
        } catch (e) {
          // Cache read error, proceed to network fetch
        }
      }
    }

    // 2. Network fetch from Al-Quran Cloud API (Uthmani Arabic + Urdu Translation + Urdu Tafseer + English Translation + English Tafseer)
    final url = Uri.parse(
      'https://api.alquran.cloud/v1/surah/$surahNumber/editions/quran-uthmani,ur.jalandhry,ur.maududi,en.sahih,en.maududi',
    );

    try {
      final response = await http.get(url).timeout(const Duration(seconds: 15));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> editions = data['data'];

        final List<dynamic> arabicList = editions[0]['ayahs'];
        final List<dynamic> urduTransList = editions[1]['ayahs'];
        final List<dynamic> urduTafseerList = editions[2]['ayahs'];
        final List<dynamic> engTransList = editions[3]['ayahs'];
        final List<dynamic> engTafseerList = editions[4]['ayahs'];

        final List<SurahVerseModel> verses = [];
        final List<Map<String, dynamic>> toCache = [];

        for (int i = 0; i < arabicList.length; i++) {
          final numInSurah = arabicList[i]['numberInSurah'] as int;
          final arabicText = arabicList[i]['text'] as String;
          final urduText = urduTransList[i]['text'] as String;
          final urduTafText = urduTafseerList[i]['text'] as String;
          final engText = engTransList[i]['text'] as String;
          final engTafText = engTafseerList[i]['text'] as String;

          final model = SurahVerseModel(
            number: numInSurah,
            arabic: arabicText,
            urduTranslation: urduText,
            urduTafseer: urduTafText,
            englishTranslation: engText,
            englishTafseer: engTafText,
          );

          verses.add(model);
          toCache.add(model.toJson());
        }

        // Save complete Surah to offline SharedPreferences cache
        await prefs.setString(cacheKey, jsonEncode(toCache));

        _isLoading = false;
        _isOnlineSynced = true;
        notifyListeners();
        return verses;
      } else {
        _errorMessage = 'Al-Quran Cloud API error: Status ${response.statusCode}';
      }
    } catch (e) {
      _errorMessage = 'Network offline or timeout. Using cached/embedded fallback.';
    }

    _isLoading = false;
    notifyListeners();
    return [];
  }
}
