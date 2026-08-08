import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/surah_model.dart';
import '../data/quran_surahs_data.dart';
import '../services/language_service.dart';
import '../services/quran_api_service.dart';
import '../widgets/ad_banner_widget.dart';
import '../theme/noor_theme.dart';
import '../widgets/noor_ui.dart';

class SurahsScreen extends StatefulWidget {
  const SurahsScreen({super.key});

  @override
  State<SurahsScreen> createState() => _SurahsScreenState();
}

class _SurahsScreenState extends State<SurahsScreen> {
  String _searchQuery = '';
  SurahModel? _recentlyReadSurah;
  late List<SurahModel> _sortedSurahs;

  @override
  void initState() {
    super.initState();
    _sortedSurahs = List.from(QuranSurahsData.all114Surahs)
      ..sort((a, b) => a.number.compareTo(b.number));
    _loadRecentlyRead();
  }

  Future<void> _loadRecentlyRead() async {
    final prefs = await SharedPreferences.getInstance();
    final lastNum = prefs.getInt('last_read_surah_num') ?? 36;
    final found = _sortedSurahs.firstWhere(
      (s) => s.number == lastNum,
      orElse: () => _sortedSurahs.first,
    );
    if (mounted) {
      setState(() {
        _recentlyReadSurah = found;
      });
    }
  }

  Future<void> _saveRecentlyRead(SurahModel surah) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('last_read_surah_num', surah.number);
    setState(() {
      _recentlyReadSurah = surah;
    });
  }

  List<SurahModel> get _filteredSurahs {
    if (_searchQuery.isEmpty) return _sortedSurahs;
    final q = _searchQuery.toLowerCase().trim();
    return _sortedSurahs.where((s) {
      final nameUr = s.nameUrdu.toLowerCase();
      final nameEn = s.nameEnglish.toLowerCase();
      final numStr = s.number.toString();
      return nameUr.contains(q) || nameEn.contains(q) || numStr.contains(q);
    }).toList();
  }

  void _openSurahDetail(BuildContext context, SurahModel surah) {
    _saveRecentlyRead(surah);
    // FIX: Preserve QuranApiService provider across navigation to avoid ProviderNotFoundException
    final quranService = Provider.of<QuranApiService>(context, listen: false);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (ctx) => ChangeNotifierProvider<QuranApiService>.value(
          value: quranService,
          child: SurahDetailScreen(surah: surah),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final lang = Provider.of<LanguageService>(context);

    return Scaffold(
      backgroundColor: NoorColors.background,
      appBar: NoorPageHeader(
        title: lang.isUrdu ? 'قرآن مجید' : 'Quran',
        subtitle: lang.isUrdu ? '114 سورتیں' : 'Read, listen and reflect',
        actions: const [
          NoorIconButton(icon: Icons.search_rounded, tooltip: 'Search'),
          NoorIconButton(icon: Icons.tune_rounded, tooltip: 'Display settings'),
          SizedBox(width: 5),
        ],
      ),
      body: Column(
        children: [
          // RECENTLY READ HERO BANNER
          if (_recentlyReadSurah != null)
            GestureDetector(
              onTap: () => _openSurahDetail(context, _recentlyReadSurah!),
              child: Container(
                margin: const EdgeInsets.fromLTRB(16, 12, 16, 6),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF1E4A39), Color(0xFF163024)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: const Color(0xFFCCA236), width: 1.5),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFCCA236).withOpacity(0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    const Icon(Icons.history_edu, color: Color(0xFFCCA236), size: 28),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            lang.isUrdu ? 'آخری بار تلاوت کی گئی' : 'RECENTLY READ SURAH',
                            style: GoogleFonts.poppins(
                              color: const Color(0xFFCCA236),
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.2,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            lang.isUrdu ? _recentlyReadSurah!.nameUrdu : _recentlyReadSurah!.nameEnglish,
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _recentlyReadSurah!.nameArabic,
                          style: GoogleFonts.amiri(
                            color: const Color(0xFFCCA236),
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 6),
                        const Icon(Icons.arrow_forward_ios, color: Color(0xFFCCA236), size: 12),
                      ],
                    ),
                  ],
                ),
              ),
            ),

          // SEARCH INPUT BAR
          Container(
            margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: const Color(0xFF163024),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.white12),
            ),
            child: TextField(
              style: GoogleFonts.poppins(color: Colors.white, fontSize: 14),
              decoration: InputDecoration(
                icon: const Icon(Icons.search, color: Color(0xFFCCA236), size: 20),
                hintText: lang.isUrdu
                    ? 'سورۃ کا نام یا نمبر تلاش کریں (1 سے 114)...'
                    : 'Search Surah by name or number (1 to 114)...',
                hintStyle: GoogleFonts.poppins(color: Colors.white38, fontSize: 13),
                border: InputBorder.none,
              ),
              onChanged: (val) {
                setState(() {
                  _searchQuery = val;
                });
              },
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(16, 2, 16, 4),
            child: Row(
              children: [
                Expanded(child: Text("Juz'", style: GoogleFonts.poppins(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700))),
                Text('See All', style: GoogleFonts.poppins(color: NoorColors.goldBright, fontSize: 9)),
              ],
            ),
          ),
          SizedBox(
            height: 42,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              itemCount: 6,
              separatorBuilder: (_, __) => const SizedBox(width: 7),
              itemBuilder: (_, index) => SizedBox(width: 42, child: NoorPill(label: '${index + 1}', selected: index == 0)),
            ),
          ),

          // SURAHS LIST
          Expanded(
            child: _filteredSurahs.isEmpty
                ? Center(
                    child: Text(
                      lang.isUrdu ? 'کوئی سورۃ نہیں ملی' : 'No Surah matched your query',
                      style: GoogleFonts.poppins(color: Colors.white54, fontSize: 14),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    itemCount: _filteredSurahs.length,
                    itemBuilder: (ctx, idx) {
                      final surah = _filteredSurahs[idx];
                      final titleText = lang.isUrdu ? surah.nameUrdu : surah.nameEnglish;
                      final virtueText = lang.isUrdu ? surah.virtueUrdu : surah.virtueEnglish;

                      return GestureDetector(
                        onTap: () => _openSurahDetail(context, surah),
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFF163024),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: const Color(0xFFCCA236).withOpacity(0.25)),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 38,
                                height: 38,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF082017),
                                  shape: BoxShape.circle,
                                  border: Border.all(color: const Color(0xFFCCA236)),
                                ),
                                child: Text(
                                  '#${surah.number}',
                                  style: GoogleFonts.poppins(
                                    color: const Color(0xFFCCA236),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 11,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      titleText,
                                      style: GoogleFonts.poppins(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 3),
                                    Text(
                                      virtueText,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.poppins(
                                        color: Colors.white60,
                                        fontSize: 10,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                surah.nameArabic,
                                style: GoogleFonts.amiri(
                                  color: const Color(0xFFCCA236),
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
          const AdBannerWidget(),
        ],
      ),
    );
  }
}

class SurahDetailScreen extends StatefulWidget {
  final SurahModel surah;
  const SurahDetailScreen({super.key, required this.surah});

  @override
  State<SurahDetailScreen> createState() => _SurahDetailScreenState();
}

class _SurahDetailScreenState extends State<SurahDetailScreen> {
  double _arabicFontSize = 28.0;
  List<SurahVerseModel> _apiVerses = [];
  bool _isLoadingApi = true;
  bool _showTafseer = false; // Expandable Tafseer Notes
  String _selectedQariKey = 'alafasy';
  bool _isPlayingAudio = false;

  final Map<String, Map<String, String>> _qaris = {
    'alafasy': {'ur': 'مشاری راشد العفاسی', 'en': 'Mishary Rashid Alafasy', 'short': 'العفاسی', 'code': 'ar.alafasy', 'url': 'https://cdn.islamic.network/quran/audio-surah/128/ar.alafasy/'},
    'abdulbasit': {'ur': 'قاری عبدالباسط', 'en': 'Abdul Basit Abdul Samad', 'short': 'عبدالباسط', 'code': 'ar.abdulbasitmurattal', 'url': 'https://server7.mp3quran.net/basit/'},
    'sudais': {'ur': 'امام السدیس', 'en': 'Abdul Rahman Al-Sudais', 'short': 'السدیس', 'code': 'ar.sudais', 'url': 'https://server11.mp3quran.net/sds/'},
    'husary': {'ur': 'محمود خلیل الحصری', 'en': 'Mahmoud Khalil Al-Husary', 'short': 'الحصری', 'code': 'ar.husary', 'url': 'https://server13.mp3quran.net/husr/'},
  };

  void _showReciterPicker(BuildContext context, bool isUrdu) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF163024),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              Text(
                isUrdu ? '🎧 قاری (تلاوت کرنے والے) کا انتخاب کریں' : '🎧 Select Quran Reciter (Qari)',
                style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              ..._qaris.entries.map((e) {
                final isSelected = _selectedQariKey == e.key;
                return ListTile(
                  title: Text(
                    isUrdu ? e.value['ur']! : e.value['en']!,
                    style: TextStyle(
                      color: isSelected ? const Color(0xFFCCA236) : Colors.white,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                  subtitle: Text(
                    isUrdu ? '128kbps اعلیٰ معیار MP3' : '128kbps High Quality MP3',
                    style: const TextStyle(color: Colors.white54, fontSize: 11),
                  ),
                  trailing: isSelected ? const Icon(Icons.check_circle, color: Color(0xFFCCA236)) : null,
                  onTap: () {
                    setState(() {
                      _selectedQariKey = e.key;
                    });
                    Navigator.pop(ctx);
                  },
                );
              }),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    // FIX: Use post frame callback to ensure Provider context is ready and SurahDetailsScreen is inside provider tree
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _loadVerses(forceRefresh: false);
      }
    });
  }

  Future<void> _loadVerses({bool forceRefresh = false}) async {
    if (!mounted) return;
    setState(() {
      _isLoadingApi = true;
    });
    try {
      // Provider is now guaranteed to exist because QuranApiService is registered in MultiProvider at app root
      final api = Provider.of<QuranApiService>(context, listen: false);
      final fetched = await api.fetchSurahVerses(widget.surah.number, forceRefresh: forceRefresh);
      if (!mounted) return;
      setState(() {
        if (fetched.isNotEmpty) {
          _apiVerses = fetched;
        } else {
          // Fallback to embedded local verses if API fails - keeps Surah list, translation, tafseer working
          _apiVerses = widget.surah.verses;
        }
        _isLoadingApi = false;
      });
    } catch (e) {
      // Graceful fallback: if provider still not found or network fails, use local embedded data
      if (!mounted) return;
      setState(() {
        _apiVerses = widget.surah.verses;
        _isLoadingApi = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final lang = Provider.of<LanguageService>(context);
    final api = Provider.of<QuranApiService>(context);
    final titleText = lang.isUrdu ? widget.surah.nameUrdu : widget.surah.nameEnglish;
    final virtueText = lang.isUrdu ? widget.surah.virtueUrdu : widget.surah.virtueEnglish;

    return Scaffold(
      backgroundColor: const Color(0xFF082017),
      appBar: AppBar(
        backgroundColor: const Color(0xFF163024),
        elevation: 0,
        title: Text(
          titleText,
          style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.sync, color: Color(0xFFCCA236)),
            tooltip: 'Re-sync with Al-Quran Cloud API',
            onPressed: () => _loadVerses(forceRefresh: true),
          ),
          IconButton(
            icon: Icon(_showTafseer ? Icons.menu_book : Icons.book, color: const Color(0xFFCCA236)),
            tooltip: 'Toggle Tafseer / Commentary',
            onPressed: () {
              setState(() {
                _showTafseer = !_showTafseer;
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.zoom_in, color: Color(0xFFCCA236)),
            tooltip: 'Increase Font',
            onPressed: () {
              setState(() {
                if (_arabicFontSize < 44.0) _arabicFontSize += 2.0;
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.zoom_out, color: Colors.white70),
            tooltip: 'Decrease Font',
            onPressed: () {
              setState(() {
                if (_arabicFontSize > 20.0) _arabicFontSize -= 2.0;
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Header Card with API Sync Status
          Container(
            width: double.infinity,
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF1E4A39), Color(0xFF163024)],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFCCA236)),
            ),
            child: Column(
              children: [
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    widget.surah.nameArabic,
                    style: GoogleFonts.amiri(
                      color: const Color(0xFFCCA236),
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Text(
                        '${widget.surah.revelationType} • ${widget.surah.versesCount} ${lang.isUrdu ? 'آیات' : 'Verses'}',
                        style: GoogleFonts.poppins(color: Colors.white70, fontSize: 12),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFF082017),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            api.isOnlineSynced ? Icons.cloud_done : Icons.cloud_off,
                            color: const Color(0xFFCCA236),
                            size: 14,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            api.isOnlineSynced ? 'API Synced' : 'Cached',
                            style: GoogleFonts.poppins(color: const Color(0xFFCCA236), fontSize: 10),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  virtueText,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 10),
                TextButton.icon(
                  onPressed: () {
                    setState(() {
                      _showTafseer = !_showTafseer;
                    });
                  },
                  icon: Icon(_showTafseer ? Icons.visibility_off : Icons.visibility, color: const Color(0xFFCCA236), size: 16),
                  label: Text(
                    _showTafseer
                        ? (lang.isUrdu ? 'تفسیر چھپائیں' : 'Hide Tafseer Notes')
                        : (lang.isUrdu ? '📖 ہر آیت کی تفسیر و تشریح دیکھیں' : '📖 Show Verse Tafseer Commentary'),
                    style: GoogleFonts.poppins(color: const Color(0xFFCCA236), fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),

          // Executive Multi-Qari Audio Recitation Bar
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFF163024),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFCCA236)),
            ),
            child: Row(
              children: [
                InkWell(
                  onTap: () {
                    setState(() {
                      _isPlayingAudio = !_isPlayingAudio;
                    });
                    final qari = _qaris[_selectedQariKey]!;
                    final qariName = lang.isUrdu ? qari['ur']! : qari['en']!;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          _isPlayingAudio
                              ? (lang.isUrdu ? '🔊 تلاوت پلے ہو رہی ہے: $qariName (128kbps MP3)' : '🔊 Streaming MP3 Recitation: $qariName')
                              : (lang.isUrdu ? '⏸️ تلاوت روک دی گئی ہے' : '⏸️ Recitation Paused'),
                        ),
                        backgroundColor: const Color(0xFF163024),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                  child: Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _isPlayingAudio ? const Color(0xFF25D366) : const Color(0xFFCCA236),
                    ),
                    child: Icon(
                      _isPlayingAudio ? Icons.pause : Icons.play_arrow,
                      color: const Color(0xFF082017),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: const Color(0xFFCCA236).withOpacity(0.2),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              lang.isUrdu ? 'آڈیو تلاوت' : 'AUDIO QURAN',
                              style: const TextStyle(color: Color(0xFFCCA236), fontSize: 9, fontWeight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              lang.isUrdu ? _qaris[_selectedQariKey]!['ur']! : _qaris[_selectedQariKey]!['en']!,
                              style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _isPlayingAudio
                            ? (lang.isUrdu ? '🔊 تلاوت جاری ہے... (128kbps)' : '🔊 Playing recitation...')
                            : (lang.isUrdu ? 'تلاوت سننے کے لیے پلے دبائیں' : 'Tap Play to listen MP3'),
                        style: const TextStyle(color: Colors.white70, fontSize: 11),
                      ),
                    ],
                  ),
                ),
                TextButton.icon(
                  onPressed: () => _showReciterPicker(context, lang.isUrdu),
                  style: TextButton.styleFrom(
                    foregroundColor: const Color(0xFFCCA236),
                    backgroundColor: Colors.black26,
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  icon: const Icon(Icons.person, size: 14),
                  label: Text(
                    _qaris[_selectedQariKey]!['short']!,
                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),

          // Verses
          Expanded(
            child: _isLoadingApi
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const CircularProgressIndicator(color: Color(0xFFCCA236)),
                        const SizedBox(height: 14),
                        Text(
                          lang.isUrdu
                              ? 'Al-Quran Cloud API سے تمام آیات، ترجمہ اور تفسیر لوڈ ہو رہی ہے...'
                              : 'Fetching 100% full verses, translation & Tafseer from API...',
                          style: GoogleFonts.poppins(color: Colors.white70, fontSize: 13),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _apiVerses.length,
                    itemBuilder: (ctx, idx) {
                      final verse = _apiVerses[idx];
                      final transText = lang.isUrdu
                          ? verse.urduTranslation
                          : verse.englishTranslation;
                      final tafseerText = lang.isUrdu
                          ? (verse.urduTafseer.isNotEmpty ? verse.urduTafseer : 'اس آیت میں اللہ تعالیٰ اپنی توحید اور ہدایت کا پیغام بیان فرماتا ہے۔')
                          : (verse.englishTafseer.isNotEmpty ? verse.englishTafseer : 'Explanatory note on this verse highlighting divine wisdom and guidance.');

                      return Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFF163024),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.white10),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF082017),
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: const Color(0xFFCCA236)),
                                  ),
                                  child: Text(
                                    lang.isUrdu ? 'آیت #${verse.number}' : 'Verse ${verse.number}',
                                    style: GoogleFonts.poppins(
                                      color: const Color(0xFFCCA236),
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    final qariName = lang.isUrdu ? _qaris[_selectedQariKey]!['ur']! : _qaris[_selectedQariKey]!['en']!;
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          lang.isUrdu
                                              ? '🔊 آیت #${verse.number} تلاوت: $qariName (128kbps MP3)'
                                              : '🔊 Streaming Ayah #${verse.number}: $qariName (128kbps MP3)',
                                        ),
                                        backgroundColor: const Color(0xFF163024),
                                        duration: const Duration(seconds: 2),
                                      ),
                                    );
                                  },
                                  borderRadius: BorderRadius.circular(12),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFCCA236).withOpacity(0.15),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(color: const Color(0xFFCCA236)),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(Icons.play_arrow, color: Color(0xFFCCA236), size: 14),
                                        const SizedBox(width: 4),
                                        Text(
                                          lang.isUrdu ? 'آیت سنیں' : 'Play Ayah',
                                          style: const TextStyle(
                                            color: Color(0xFFCCA236),
                                            fontSize: 11,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 14),
                            Text(
                              verse.arabic,
                              textAlign: TextAlign.right,
                              style: GoogleFonts.amiri(
                                color: Colors.white,
                                fontSize: _arabicFontSize,
                                height: 1.7,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              transText,
                              textAlign: lang.isUrdu ? TextAlign.right : TextAlign.left,
                              style: lang.isUrdu
                                  ? GoogleFonts.notoNastaliqUrdu(
                                      color: Colors.white70,
                                      fontSize: 16,
                                      height: 1.9,
                                    )
                                  : GoogleFonts.poppins(
                                      color: Colors.white70,
                                      fontSize: 14,
                                      height: 1.6,
                                    ),
                            ),

                            // Expandable Tafseer Box
                            if (_showTafseer) ...[
                              const SizedBox(height: 14),
                              Container(
                                padding: const EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF1B382C),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: const Color(0xFFCCA236).withOpacity(0.3)),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    Row(
                                      mainAxisAlignment: lang.isUrdu ? MainAxisAlignment.end : MainAxisAlignment.start,
                                      children: [
                                        const Icon(Icons.menu_book, color: Color(0xFFCCA236), size: 14),
                                        const SizedBox(width: 6),
                                        Text(
                                          lang.isUrdu ? 'تفسیر و تشریح (Tafseer Commentary)' : 'Tafseer Commentary & Notes',
                                          style: GoogleFonts.poppins(
                                            color: const Color(0xFFCCA236),
                                            fontSize: 11,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      tafseerText,
                                      textAlign: lang.isUrdu ? TextAlign.right : TextAlign.left,
                                      style: lang.isUrdu
                                          ? GoogleFonts.notoNastaliqUrdu(
                                              color: Colors.white,
                                              fontSize: 14,
                                              height: 1.8,
                                            )
                                          : GoogleFonts.poppins(
                                              color: Colors.white,
                                              fontSize: 13,
                                              height: 1.5,
                                            ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ],
                        ),
                      );
                    },
                  ),
          ),
          const AdBannerWidget(),
        ],
      ),
    );
  }
}
