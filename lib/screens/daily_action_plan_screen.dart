import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/language_service.dart';

class NamazTaskItem {
  final String id;
  final String ur;
  final String en;
  bool completed;

  NamazTaskItem({
    required this.id,
    required this.ur,
    required this.en,
    this.completed = false,
  });
}

class DailyActionPlanScreen extends StatefulWidget {
  const DailyActionPlanScreen({super.key});

  @override
  State<DailyActionPlanScreen> createState() => _DailyActionPlanScreenState();
}

class _DailyActionPlanScreenState extends State<DailyActionPlanScreen> {
  int _tokenBalance = 10;
  final List<NamazTaskItem> _namazTasks = [
    NamazTaskItem(id: 'fajr', ur: 'نمازِ فجر (باجماعت یا وقت پر ادا کریں)', en: 'Fajr Prayer (Obligatory 2 Rakats)'),
    NamazTaskItem(id: 'dhuhr', ur: 'نمازِ ظہر (باجماعت یا وقت پر ادا کریں)', en: 'Dhuhr Prayer (Obligatory 4 Rakats)'),
    NamazTaskItem(id: 'asr', ur: 'نمازِ عصر (باجماعت یا وقت پر ادا کریں)', en: 'Asr Prayer (Obligatory 4 Rakats)'),
    NamazTaskItem(id: 'maghrib', ur: 'نمازِ مغرب (باجماعت یا وقت پر ادا کریں)', en: 'Maghrib Prayer (Obligatory 3 Rakats)'),
    NamazTaskItem(id: 'isha', ur: 'نمازِ عشاء (باجماعت یا وقت پر ادا کریں)', en: 'Isha Prayer (Obligatory 4 Rakats)'),
  ];

  @override
  void initState() {
    super.initState();
    _loadState();
  }

  Future<void> _loadState() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _tokenBalance = prefs.getInt('noor_e_qalb_tokens_balance_v10') ?? 10;

      final completedNamaz = prefs.getStringList('noor_namaz_completed_ids_v10') ?? [];
      for (var t in _namazTasks) {
        t.completed = completedNamaz.contains(t.id);
      }
    });
  }

  Future<void> _saveState() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('noor_e_qalb_tokens_balance_v10', _tokenBalance);
    await prefs.setStringList('noor_namaz_completed_ids_v10', _namazTasks.where((t) => t.completed).map((t) => t.id).toList());
  }

  void _toggleNamaz(int idx) {
    setState(() {
      _namazTasks[idx].completed = !_namazTasks[idx].completed;
      if (_namazTasks[idx].completed) {
        _tokenBalance += 2;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              Provider.of<LanguageService>(context, listen: false).isUrdu
                  ? '✨ الحمدللہ! +2 نور ٹوکنز آپ کے والٹ میں شامل کر دیے گئے ہیں!'
                  : '✨ Alhamdulillah! +2 Noor Tokens added to your wallet!',
            ),
            backgroundColor: const Color(0xFF0F2C23),
          ),
        );
      }
    });
    _saveState();
  }

  @override
  Widget build(BuildContext context) {
    final langService = Provider.of<LanguageService>(context);
    final isUrdu = langService.isUrdu;
    int completedCount = _namazTasks.where((t) => t.completed).length;

    return Scaffold(
      backgroundColor: const Color(0xFF081B15),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0C231B),
        elevation: 0,
        title: Text(
          isUrdu ? 'نور روحانی ٹوکن والٹ اور لائحہ عمل' : 'Noor Token Wallet & Action Plan',
          style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
        ),
        centerTitle: true,
        actions: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFD4AF37),
              borderRadius: BorderRadius.circular(16),
            ),
            alignment: Alignment.center,
            child: Text(
              '🪙 $_tokenBalance',
              style: GoogleFonts.poppins(color: const Color(0xFF081B15), fontWeight: FontWeight.bold, fontSize: 13),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Hero Action Card
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [Color(0xFF1A4638), Color(0xFF0C231B)]),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFD4AF37), width: 1.5),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 15),
                ],
              ),
              child: Column(
                children: [
                  Text(
                    isUrdu ? 'آپ کا موجودہ بیلنس (جمع کردہ ٹوکنز)' : 'Your Token Balance (Earned Tokens)',
                    style: GoogleFonts.poppins(color: Colors.white70, fontSize: 12),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '$_tokenBalance 🪙',
                    style: GoogleFonts.poppins(color: const Color(0xFFD4AF37), fontSize: 38, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    isUrdu ? '🕌 ہر فرض نماز: +2 ٹوکن • 🤲 ہر روحانی عمل: +2 ٹوکن' : '🕌 Each Prayer: +2 Tokens • 🤲 Each Deed: +2 Tokens',
                    style: GoogleFonts.poppins(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Leaderboard Coming Soon Trophy Banner
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [Color(0xFF13382D), Color(0xFF081B15)]),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFD4AF37), width: 1.5),
              ),
              child: Column(
                children: [
                  const Text('🏆', style: TextStyle(fontSize: 36)),
                  const SizedBox(height: 6),
                  Text(
                    isUrdu
                        ? 'عالمی لیڈر بورڈ اور مقابلہ (اگلی اپڈیٹ میں آ رہا ہے!)'
                        : 'Global Leaderboard (Coming in Next Update!)',
                    style: GoogleFonts.poppins(
                      color: const Color(0xFFD4AF37),
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    isUrdu
                        ? 'آپ کے جمع کردہ تمام نور ٹوکنز محفوظ ہیں۔ اگلی اپڈیٹ میں دنیا بھر کے مسلمانوں کے ساتھ روحانی لیڈر بورڈ کا مقابلہ شروع ہوگا!'
                        : 'Your earned Noor Tokens are safely saved. Compete with Muslims worldwide on the spiritual leaderboard in our next release!',
                    style: GoogleFonts.poppins(
                      color: Colors.white70,
                      fontSize: 12,
                      height: 1.6,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // 5 Daily Prayers List
            Text(
              isUrdu ? '🕌 5 فرض نمازیں (باجماعت یا وقت پر ادا کریں):' : '🕌 5 Daily Obligatory Prayers (Fajr to Isha):',
              style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const SizedBox(height: 10),
            ..._namazTasks.asMap().entries.map((entry) {
              final idx = entry.key;
              final task = entry.value;
              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  color: task.completed ? const Color(0xFF13382D) : Colors.white10,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: task.completed ? const Color(0xFFD4AF37) : Colors.white12),
                ),
                child: Row(
                  children: [
                    Text(task.completed ? '✅' : '🕌', style: const TextStyle(fontSize: 18)),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        isUrdu ? task.ur : task.en,
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontWeight: task.completed ? FontWeight.bold : FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFFD4AF37).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text('🪙 +2', style: TextStyle(color: Color(0xFFD4AF37), fontSize: 11, fontWeight: FontWeight.bold)),
                    ),
                    Checkbox(
                      value: task.completed,
                      activeColor: const Color(0xFFD4AF37),
                      checkColor: const Color(0xFF081B15),
                      onChanged: (_) => _toggleNamaz(idx),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
