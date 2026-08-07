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
    NamazTaskItem(id: 'fajr', ur: 'نمازِ فجر (باجماعت)', en: 'Fajr Prayer (2 Rakats)'),
    NamazTaskItem(id: 'dhuhr', ur: 'نمازِ ظہر (باجماعت)', en: 'Dhuhr Prayer (4 Rakats)'),
    NamazTaskItem(id: 'asr', ur: 'نمازِ عصر (باجماعت)', en: 'Asr Prayer (4 Rakats)'),
    NamazTaskItem(id: 'maghrib', ur: 'نمازِ مغرب (باجماعت)', en: 'Maghrib Prayer (3 Rakats)'),
    NamazTaskItem(id: 'isha', ur: 'نمازِ عشاء (باجماعت)', en: 'Isha Prayer (4 Rakats)'),
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
                  ? '✨ الحمدللہ! +2 نور ٹوکنز شامل!'
                  : '✨ Alhamdulillah! +2 Noor Tokens added!',
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

    return Scaffold(
      backgroundColor: const Color(0xFF081B15),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0C231B),
        elevation: 0,
        title: Text(
          isUrdu ? 'نور ٹوکن والٹ' : 'Noor Token Wallet',
          style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
        ),
        centerTitle: true,
        actions: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: const Color(0xFFD4AF37),
              borderRadius: BorderRadius.circular(14),
            ),
            alignment: Alignment.center,
            child: Text(
              '🪙 $_tokenBalance',
              style: GoogleFonts.poppins(color: const Color(0xFF081B15), fontWeight: FontWeight.bold, fontSize: 12),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Hero Action Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [Color(0xFF1A4638), Color(0xFF0C231B)]),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: const Color(0xFFD4AF37), width: 1.5),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.25), blurRadius: 12),
                ],
              ),
              child: Column(
                children: [
                  Text(
                    isUrdu ? 'آپ کا ٹوکن بیلنس' : 'Your Token Balance',
                    style: GoogleFonts.poppins(color: Colors.white70, fontSize: 12),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$_tokenBalance 🪙',
                    style: GoogleFonts.poppins(color: const Color(0xFFD4AF37), fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    isUrdu ? '🕌 ہر فرض نماز: +2 ٹوکن • 🤲 ہر عمل: +2 ٹوکن' : '🕌 Each Prayer: +2 • 🤲 Each Deed: +2',
                    style: GoogleFonts.poppins(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 14),

            // Leaderboard Coming Soon
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [Color(0xFF13382D), Color(0xFF081B15)]),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: const Color(0xFFD4AF37), width: 1.5),
              ),
              child: Column(
                children: [
                  const Text('🏆', style: TextStyle(fontSize: 32)),
                  const SizedBox(height: 4),
                  Text(
                    isUrdu
                        ? 'عالمی لیڈر بورڈ (جلد آ رہا ہے!)'
                        : 'Global Leaderboard (Coming Soon!)',
                    style: GoogleFonts.poppins(
                      color: const Color(0xFFD4AF37),
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    isUrdu
                        ? 'اگلی اپڈیٹ میں دنیا بھر کے مسلمانوں کے ساتھ مقابلہ!'
                        : 'Compete with Muslims worldwide in next release!',
                    style: GoogleFonts.poppins(
                      color: Colors.white70,
                      fontSize: 11,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // 5 Daily Prayers
            Text(
              isUrdu ? '🕌 5 فرض نمازیں:' : '🕌 5 Daily Prayers:',
              style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const SizedBox(height: 8),
            ..._namazTasks.asMap().entries.map((entry) {
              final idx = entry.key;
              final task = entry.value;
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: task.completed ? const Color(0xFF13382D) : Colors.white.withOpacity(0.06),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: task.completed ? const Color(0xFFD4AF37) : Colors.white12),
                ),
                child: Row(
                  children: [
                    Text(task.completed ? '✅' : '🕌', style: const TextStyle(fontSize: 16)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        isUrdu ? task.ur : task.en,
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontWeight: task.completed ? FontWeight.bold : FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFFD4AF37).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text('🪙 +2', style: TextStyle(color: Color(0xFFD4AF37), fontSize: 10, fontWeight: FontWeight.bold)),
                    ),
                    SizedBox(
                      width: 32,
                      height: 32,
                      child: Checkbox(
                        value: task.completed,
                        activeColor: const Color(0xFFD4AF37),
                        checkColor: const Color(0xFF081B15),
                        onChanged: (_) => _toggleNamaz(idx),
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
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
