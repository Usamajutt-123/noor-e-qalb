import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/language_service.dart';

class QazaItem {
  final String keyName;
  final String titleUr;
  final String titleEn;

  const QazaItem(this.keyName, this.titleUr, this.titleEn);
}

class QazaTrackerScreen extends StatefulWidget {
  const QazaTrackerScreen({super.key});

  @override
  State<QazaTrackerScreen> createState() => _QazaTrackerScreenState();
}

class _QazaTrackerScreenState extends State<QazaTrackerScreen> {
  static const List<QazaItem> _prayers = [
    QazaItem('fajr', 'فجر • 2 فرض', 'Fajr • 2 Fard'),
    QazaItem('dhuhr', 'ظہر • 4 فرض', 'Dhuhr • 4 Fard'),
    QazaItem('asr', 'عصر • 4 فرض', 'Asr • 4 Fard'),
    QazaItem('maghrib', 'مغرب • 3 فرض', 'Maghrib • 3 Fard'),
    QazaItem('isha', 'عشاء • 4 فرض', 'Isha • 4 Fard'),
    QazaItem('witr', 'وتر • 3 واجب', 'Witr • 3 Wajib'),
  ];

  Map<String, int> _counts = {
    'fajr': 0,
    'dhuhr': 0,
    'asr': 0,
    'maghrib': 0,
    'isha': 0,
    'witr': 0,
  };

  int _totalPrayed = 0;

  @override
  void initState() {
    super.initState();
    _loadState();
  }

  Future<void> _loadState() async {
    final prefs = await SharedPreferences.getInstance();
    final String? saved = prefs.getString('qaza_counts_json');
    if (saved != null) {
      final decoded = jsonDecode(saved) as Map<String, dynamic>;
      setState(() {
        _counts = decoded.map((k, v) => MapEntry(k, v as int));
      });
    }
    final int? prayed = prefs.getInt('qaza_fulfilled_total');
    if (prayed != null) {
      setState(() {
        _totalPrayed = prayed;
      });
    }
  }

  Future<void> _saveState() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('qaza_counts_json', jsonEncode(_counts));
    await prefs.setInt('qaza_fulfilled_total', _totalPrayed);
  }

  int get _totalRemaining => _counts.values.fold(0, (a, b) => a + b);

  void _increment(String key, [int amount = 1]) {
    setState(() {
      _counts[key] = (_counts[key] ?? 0) + amount;
    });
    _saveState();
  }

  void _decrement(String key, bool isUrdu) {
    if ((_counts[key] ?? 0) > 0) {
      setState(() {
        _counts[key] = _counts[key]! - 1;
        _totalPrayed++;
      });
      _saveState();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isUrdu
                ? '✨ الحمدللہ! آپ نے 1 قضا نماز ادا کر لی!'
                : '✨ Alhamdulillah! 1 Qaza prayer fulfilled!',
          ),
          backgroundColor: Colors.green.shade800,
          duration: const Duration(seconds: 1),
        ),
      );
    }
  }

  void _bulkAddDays(int days, bool isUrdu) {
    setState(() {
      for (final k in _counts.keys) {
        _counts[k] = (_counts[k] ?? 0) + days;
      }
    });
    _saveState();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isUrdu
              ? '✨ الحمدللہ! $days دن کی قضا نمازوں کا ریکارڈ درج کر دیا گیا ہے۔'
              : '✨ Alhamdulillah! $days day(s) of missed prayers added.',
        ),
        backgroundColor: const Color(0xFF0F2C23),
      ),
    );
  }

  void _resetAll(bool isUrdu) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF0F2C23),
        title: Text(
          isUrdu ? 'ری سیٹ کریں' : 'Reset Tracker',
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        content: Text(
          isUrdu
              ? 'کیا آپ واقعی تمام قضا نمازوں کا ریکارڈ ری سیٹ کرنا چاہتے ہیں؟'
              : 'Are you sure you want to reset all Qaza prayer counts?',
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(isUrdu ? 'منسوخ' : 'Cancel', style: const TextStyle(color: Colors.white60)),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _counts = {
                  'fajr': 0,
                  'dhuhr': 0,
                  'asr': 0,
                  'maghrib': 0,
                  'isha': 0,
                  'witr': 0,
                };
                _totalPrayed = 0;
              });
              _saveState();
              Navigator.pop(ctx);
            },
            child: Text(
              isUrdu ? 'ری سیٹ کریں' : 'Reset All',
              style: const TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final langService = Provider.of<LanguageService>(context);
    final bool isUrdu = langService.isUrdu;

    return Scaffold(
      backgroundColor: const Color(0xFF081B15),
      appBar: AppBar(
        backgroundColor: const Color(0xFF081B15),
        elevation: 0,
        title: Text(
          isUrdu ? "قضا نمازوں کا ٹریکر (Qaza Prayer Log)" : "Qaza Prayer Log",
          style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // Stats Pills Row
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
                      decoration: BoxDecoration(
                        color: const Color(0xFFD4AF37).withOpacity(0.12),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFD4AF37)),
                      ),
                      child: Column(
                        children: [
                          Text(
                            isUrdu ? "کل باقی قضا نمازیں:" : "Total Remaining Qaza:",
                            style: const TextStyle(color: Color(0xFFD4AF37), fontSize: 11),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "$_totalRemaining",
                            style: GoogleFonts.inter(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.green),
                      ),
                      child: Column(
                        children: [
                          Text(
                            isUrdu ? "الحمدللہ! ادا کیں:" : "Fulfilled Prayers:",
                            style: const TextStyle(color: Colors.greenAccent, fontSize: 11),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "$_totalPrayed",
                            style: GoogleFonts.inter(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Bulk Add Days Row
              Text(
                isUrdu ? "⚡ فوری اضافہ کریں (Bulk Add Missed Days):" : "⚡ Bulk Add Missed Days:",
                style: const TextStyle(color: Colors.white70, fontSize: 12),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                alignment: WrapAlignment.center,
                children: [
                  _buildQuickBtn("+1 دن (1 Day)", () => _bulkAddDays(1, isUrdu)),
                  _buildQuickBtn("+7 دن (1 Week)", () => _bulkAddDays(7, isUrdu)),
                  _buildQuickBtn("+30 دن (1 Month)", () => _bulkAddDays(30, isUrdu)),
                  _buildQuickBtn(
                    isUrdu ? "ری سیٹ کریں" : "Reset All",
                    () => _resetAll(isUrdu),
                    color: Colors.redAccent,
                  ),
                ],
              ),
              const SizedBox(height: 24),
              // The 6 Prayer Rows
              ..._prayers.map((item) {
                final int count = _counts[item.keyName] ?? 0;
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isUrdu ? item.titleUr : item.titleEn,
                            style: GoogleFonts.inter(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            "$count ${isUrdu ? 'باقی' : 'left'}",
                            style: const TextStyle(color: Color(0xFFD4AF37), fontSize: 12),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          ElevatedButton(
                            onPressed: count > 0 ? () => _decrement(item.keyName, isUrdu) : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green.shade700,
                              foregroundColor: Colors.white,
                              disabledBackgroundColor: Colors.white12,
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            child: Text(isUrdu ? "ادا کی -1" : "Prayed -1"),
                          ),
                          const SizedBox(width: 8),
                          InkWell(
                            onTap: () => _increment(item.keyName, 1),
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                color: const Color(0xFFD4AF37).withOpacity(0.15),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: const Color(0xFFD4AF37)),
                              ),
                              child: const Icon(Icons.add, color: Color(0xFFD4AF37), size: 18),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.black26,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  isUrdu
                      ? "\"اللہ تعالیٰ توبہ کرنے والوں اور اپنی قضا نمازیں ادا کرنے والوں سے بے حد محبت فرماتا ہے۔\""
                      : "\"Allah loves those who turn to Him in repentance and fulfill their missed prayers.\"",
                  style: GoogleFonts.inter(
                    color: const Color(0xFFD4AF37),
                    fontStyle: FontStyle.italic,
                    fontSize: 13,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickBtn(String text, VoidCallback onTap, {Color? color}) {
    return OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        foregroundColor: color ?? Colors.white70,
        side: BorderSide(color: color ?? Colors.white24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
      child: Text(text, style: const TextStyle(fontSize: 11)),
    );
  }
}
