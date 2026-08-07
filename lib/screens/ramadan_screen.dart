import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/language_service.dart';
import 'zakat_screen.dart';

class RamadanDua {
  final String keyName;
  final String titleUr;
  final String titleEn;
  final String arabic;
  final String urdu;
  final String eng;
  final String refUr;
  final String refEn;

  const RamadanDua({
    required this.keyName,
    required this.titleUr,
    required this.titleEn,
    required this.arabic,
    required this.urdu,
    required this.eng,
    required this.refUr,
    required this.refEn,
  });
}

class RamadanScreen extends StatefulWidget {
  const RamadanScreen({super.key});

  @override
  State<RamadanScreen> createState() => _RamadanScreenState();
}

class _RamadanScreenState extends State<RamadanScreen> {
  static const List<RamadanDua> _duas = [
    RamadanDua(
      keyName: 'suhoor',
      titleUr: "روزہ رکھنے کی نیت (سحری کی دعا)",
      titleEn: "Suhoor Intention (Intending to Fast)",
      arabic: "وَبِصَوْمِ غَدٍ نَوَيْتُ مِنْ شَهْرِ رَمَضَانَ",
      urdu: "اور میں نے ماہِ رمضان کے کل کے روزے کی نیت کی۔",
      eng: "And I intend to keep the fast for tomorrow in the month of Ramadan.",
      refUr: "سنن ابوداؤد، سنن النسائی",
      refEn: "Sunan Abu Dawood, An-Nasa'i",
    ),
    RamadanDua(
      keyName: 'iftar',
      titleUr: "افطار کرنے کی مسنون دعا",
      titleEn: "Iftar Supplication (Breaking Fast)",
      arabic: "اَللَّهُمَّ إِنِّي لَكَ صُمْتُ وَبِكَ آمَنْتُ وَعَلَيْكَ تَوَكَّلْتُ وَعَلَى رِزْقِكَ أَفْطَرْتُ",
      urdu: "اے اللہ! میں نے تیرے ہی لیے روزہ رکھا، اور تجھ پر ایمان لایا، اور تجھ پر ہی بھروسہ کیا، اور تیرے ہی رزق سے افطار کیا۔",
      eng: "O Allah! I fasted for You, and I believe in You, and I put my trust in You, and I break my fast with Your sustenance.",
      refUr: "سنن ابوداؤد 2358",
      refEn: "Sunan Abu Dawood 2358",
    ),
    RamadanDua(
      keyName: 'ashra1',
      titleUr: "پہلے عشرے کی دعا (رحمت کا عشرہ 1 سے 10 رمضان)",
      titleEn: "1st Ashra Dua (1-10 Ramadan: Mercy)",
      arabic: "رَبِّ اغْفِرْ وَارْحَمْ وَأَنْتَ خَيْرُ الرَّاحِمِينَ",
      urdu: "اے میرے رب! مجھے بخش دے اور مجھ پر رحم فرما، اور تو سب رحم کرنے والوں سے بہتر ہے۔",
      eng: "O my Lord! Forgive and have mercy, for You are the Best of those who show mercy.",
      refUr: "سورۃ المؤمنون 23:118",
      refEn: "Surah Al-Mu'minun 23:118",
    ),
    RamadanDua(
      keyName: 'ashra2',
      titleUr: "دوسرے عشرے کی دعا (مغفرت کا عشرہ 11 سے 20 رمضان)",
      titleEn: "2nd Ashra Dua (11-20 Ramadan: Forgiveness)",
      arabic: "أَسْتَغْفِرُ اللَّهَ رَبِّي مِنْ كُلِّ ذَنْبٍ وَأَتُوبُ إِلَيْهِ",
      urdu: "میں اللہ سے اپنے تمام گناہوں کی بخشش مانگتا ہوں جو میرا رب ہے اور اسی کی طرف رجوع کرتا ہوں۔",
      eng: "I seek forgiveness from Allah, my Lord, from every sin and I turn to Him in repentance.",
      refUr: "مسنون استغفار",
      refEn: "Authentic Istighfar",
    ),
    RamadanDua(
      keyName: 'ashra3',
      titleUr: "تیسرے عشرے کی دعا (جہنم سے نجات کا عشرہ 21 سے 30 رمضان)",
      titleEn: "3rd Ashra Dua (21-30 Ramadan: Safety from Fire)",
      arabic: "اَللَّهُمَّ أَجِرْنِي مِنَ النَّارِ",
      urdu: "اے اللہ! مجھے جہنم کی آگ سے نجات عطا فرما۔",
      eng: "O Allah! Save me from the Fire of Hell.",
      refUr: "سنن ابوداؤد 5079",
      refEn: "Sunan Abu Dawood 5079",
    ),
    RamadanDua(
      keyName: 'qadr',
      titleUr: "شبِ قدر کی خصوصی مسنون دعا",
      titleEn: "Laylatul Qadr Dua (Night of Power)",
      arabic: "اَللَّهُمَّ إِنَّكَ عَفُوٌّ تُحِبُّ الْعَفْوَ فَاعْفُ عَنِّي",
      urdu: "اے اللہ! بے شک تو بہت معاف فرمانے والا ہے، معاف کرنے کو پسند فرماتا ہے، پس مجھے معاف فرما دے۔",
      eng: "O Allah, You are Most Forgiving, and You love forgiveness, so forgive me.",
      refUr: "جامع ترمذی 3513",
      refEn: "Jami At-Tirmidhi 3513",
    ),
  ];

  int _selectedDuaIndex = 0;
  List<bool> _fastsTracker = List.filled(30, false);
  List<bool> _taraweehTracker = List.filled(30, false);

  @override
  void initState() {
    super.initState();
    _loadTrackerState();
  }

  Future<void> _loadTrackerState() async {
    final prefs = await SharedPreferences.getInstance();
    final fastsList = prefs.getStringList('noor_ramadan_fasts_30') ?? [];
    final taraweehList = prefs.getStringList('noor_ramadan_taraweeh_30') ?? [];
    if (fastsList.length == 30 && taraweehList.length == 30) {
      setState(() {
        _fastsTracker = fastsList.map((e) => e == 'true').toList();
        _taraweehTracker = taraweehList.map((e) => e == 'true').toList();
      });
    }
  }

  Future<void> _saveTrackerState() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('noor_ramadan_fasts_30', _fastsTracker.map((e) => e.toString()).toList());
    await prefs.setStringList('noor_ramadan_taraweeh_30', _taraweehTracker.map((e) => e.toString()).toList());
  }

  String _formatRamadanTime(int h, int m) {
    String ampm = h >= 12 ? 'PM' : 'AM';
    int hours = h % 12;
    hours = hours == 0 ? 12 : hours;
    String mins = m < 10 ? '0$m' : '$m';
    String hs = hours < 10 ? '0$hours' : '$hours';
    return '$hs:$mins $ampm';
  }

  Widget _buildCountdownPill(String val, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        decoration: BoxDecoration(
          color: Colors.black38,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFD4AF37).withOpacity(0.5)),
        ),
        child: Column(
          children: [
            Text(
              val,
              style: GoogleFonts.poppins(
                color: const Color(0xFFD4AF37),
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: GoogleFonts.poppins(
                color: Colors.white70,
                fontSize: 10,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final langService = Provider.of<LanguageService>(context);
    final isUrdu = langService.isUrdu;
    final currentDua = _duas[_selectedDuaIndex];

    int fastsCompleted = _fastsTracker.where((e) => e).length;
    int taraweehCompleted = _taraweehTracker.where((e) => e).length;

    return Scaffold(
      backgroundColor: const Color(0xFF081B15),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0C231B),
        elevation: 0,
        title: Text(
          isUrdu ? 'رمضان المبارک 1448 ہجری' : 'Ramadan 1448 AH Suite',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Color(0xFFD4AF37)),
            tooltip: isUrdu ? 'ری سیٹ کریں' : 'Reset Tracker',
            onPressed: () {
              setState(() {
                _fastsTracker = List.filled(30, false);
                _taraweehTracker = List.filled(30, false);
              });
              _saveTrackerState();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // HERO SUHOOR / IFTAR ARCH CARD
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF1A4638), Color(0xFF0C231B)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: const Color(0xFFD4AF37), width: 1.5),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Icon(Icons.location_on, color: Color(0xFFD4AF37), size: 16),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          isUrdu ? 'منڈی بہاءالدین / ملکوال (پاکستان)' : 'Mandi Bahauddin / Malakwal',
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: const Color(0xFFD4AF37).withOpacity(0.2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          isUrdu ? 'آمد' : 'COUNTDOWN',
                          style: GoogleFonts.poppins(
                            color: const Color(0xFFD4AF37),
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    isUrdu
                        ? 'متوقع آغاز: 09 فروری 2027 (1 رمضان المبارک 1448 ہجری)'
                        : 'Expected Start: 09 February 2027 (1st Ramadan 1448 AH)',
                    style: GoogleFonts.poppins(
                      color: const Color(0xFFD4AF37),
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      _buildCountdownPill('06', isUrdu ? 'ماہ' : 'Months'),
                      const SizedBox(width: 8),
                      _buildCountdownPill('03', isUrdu ? 'دن' : 'Days'),
                      const SizedBox(width: 8),
                      _buildCountdownPill('14', isUrdu ? 'گھنٹے' : 'Hours'),
                      const SizedBox(width: 8),
                      _buildCountdownPill('25', isUrdu ? 'منٹ' : 'Mins'),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.black26,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFD4AF37).withOpacity(0.5)),
                    ),
                    child: Column(
                      children: [
                        Text(
                          "اللَّهُمَّ بَارِكْ لَنَا فِي رَجَبٍ وَشَعْبَانَ وَبَلِّغْنَا رَمَضَانَ",
                          style: GoogleFonts.amiri(
                            color: const Color(0xFFD4AF37),
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          isUrdu
                              ? "اے اللہ! ہمارے لیے رجب اور شعبان میں برکت عطا فرما اور ہمیں رمضان المبارک تک پہنچا (سنن النسائی)۔"
                              : "O Allah! Bless us in Rajab and Sha'ban and allow us to reach Ramadan (Sunan An-Nasa'i).",
                          style: GoogleFonts.poppins(
                            color: Colors.white70,
                            fontSize: 11,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 22),

            // SECTION 1: RAMADAN SUPPLICATIONS (6 DUAS)
            Text(
              isUrdu ? '🤲 مسنون دعائیں (سحر، افطار اور تینوں عشرے)' : '🤲 Authentic Supplications (Suhoor, Iftar & 3 Ashras)',
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(_duas.length, (idx) {
                  final d = _duas[idx];
                  final isSelected = (_selectedDuaIndex == idx);
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(
                        isUrdu ? d.titleUr.split(' ')[0] : d.titleEn.split(' ')[0],
                        style: GoogleFonts.poppins(
                          color: isSelected ? const Color(0xFF081B15) : Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                      selected: isSelected,
                      selectedColor: const Color(0xFFD4AF37),
                      backgroundColor: const Color(0xFF0C231B),
                      onSelected: (_) => setState(() => _selectedDuaIndex = idx),
                    ),
                  );
                }),
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF0C231B),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: const Color(0xFFD4AF37).withOpacity(0.3)),
              ),
              child: Column(
                children: [
                  Text(
                    isUrdu ? currentDua.titleUr : currentDua.titleEn,
                    style: GoogleFonts.poppins(
                      color: const Color(0xFFD4AF37),
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    currentDua.arabic,
                    style: GoogleFonts.amiri(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    isUrdu ? currentDua.urdu : currentDua.eng,
                    style: GoogleFonts.poppins(
                      color: Colors.white70,
                      fontSize: 13,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 14),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          '📚 ${isUrdu ? currentDua.refUr : currentDua.refEn}',
                          style: GoogleFonts.poppins(
                            color: const Color(0xFFD4AF37),
                            fontSize: 11,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFD4AF37),
                          foregroundColor: const Color(0xFF081B15),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          visualDensity: VisualDensity.compact,
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        ),
                        icon: const Icon(Icons.volume_up, size: 14),
                        label: Text(
                          isUrdu ? 'سنیں' : 'Listen',
                          style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 11),
                        ),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // SECTION 2: 30-DAY RAMADAN TIMETABLE & FASTING/TARAWEEH CHECKLIST
            Text(
              isUrdu ? '📅 30 دن کا سحر و افطار ٹائم ٹیبل اور روزہ ٹریکر' : '📅 30-Day Suhoor & Iftar Schedule & Checklist',
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0C231B),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFFD4AF37).withOpacity(0.4)),
                    ),
                    child: Column(
                      children: [
                        Text(
                          isUrdu ? 'مکمل روزے' : 'Fasts Completed',
                          style: GoogleFonts.poppins(color: Colors.white70, fontSize: 11),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '$fastsCompleted / 30',
                          style: GoogleFonts.poppins(
                            color: const Color(0xFFD4AF37),
                            fontSize: 17,
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
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0C231B),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFFD4AF37).withOpacity(0.4)),
                    ),
                    child: Column(
                      children: [
                        Text(
                          isUrdu ? 'مکمل تراویح' : 'Taraweeh Completed',
                          style: GoogleFonts.poppins(color: Colors.white70, fontSize: 11),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '$taraweehCompleted / 30',
                          style: GoogleFonts.poppins(
                            color: const Color(0xFFD4AF37),
                            fontSize: 17,
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

            // 30-DAY LIST
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF0C231B),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white10),
              ),
              child: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 30,
                separatorBuilder: (_, __) => const Divider(color: Colors.white10, height: 1),
                itemBuilder: (context, i) {
                  int fShift = -(i ~/ 2);
                  int mShift = (i ~/ 2);
                  int fh = 4;
                  int fm = 28 + fShift;
                  int mh = 18;
                  int mm = 58 + mShift;

                  String suhoorStr = _formatRamadanTime(fh, fm);
                  String iftarStr = _formatRamadanTime(mh, mm);

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 60,
                          child: Text(
                            isUrdu ? '${i + 1} رمضان' : '${i + 1} Ram',
                            style: GoogleFonts.poppins(
                              color: const Color(0xFFD4AF37),
                              fontWeight: FontWeight.bold,
                              fontSize: 11,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(suhoorStr, style: GoogleFonts.poppins(color: Colors.white, fontSize: 11)),
                              Text(iftarStr, style: GoogleFonts.poppins(color: Colors.white, fontSize: 11)),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              width: 28,
                              height: 28,
                              child: Checkbox(
                                value: _fastsTracker[i],
                                activeColor: const Color(0xFFD4AF37),
                                checkColor: const Color(0xFF081B15),
                                onChanged: (val) {
                                  setState(() => _fastsTracker[i] = val ?? false);
                                  _saveTrackerState();
                                },
                                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                            ),
                            SizedBox(
                              width: 28,
                              height: 28,
                              child: Checkbox(
                                value: _taraweehTracker[i],
                                activeColor: const Color(0xFFD4AF37),
                                checkColor: const Color(0xFF081B15),
                                onChanged: (val) {
                                  setState(() => _taraweehTracker[i] = val ?? false);
                                  _saveTrackerState();
                                },
                                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 22),

            // FITRANA & ZAKAT NOTE CARD
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF0C231B).withOpacity(0.6),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFD4AF37), style: BorderStyle.solid),
              ),
              child: Column(
                children: [
                  Text(
                    isUrdu ? '💰 صدقہ فطر (فطرانہ) اور زکوٰۃ کا حساب' : '💰 Fitrana (Sadaqah al-Fitr) & Zakat Calculation',
                    style: GoogleFonts.poppins(
                      color: const Color(0xFFD4AF37),
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    isUrdu
                        ? 'عید الفطر کی نماز سے قبل صدقہ فطر ادا کرنا واجب ہے۔ زکوٰۃ کا حساب کرنے کے لیے نیچے زکوٰۃ کیلکولیٹر استعمال کریں۔'
                        : 'Sadaqah al-Fitr is obligatory before Eid-ul-Fitr prayer. Use the Zakat Calculator below for your zakatable assets.',
                    style: GoogleFonts.poppins(
                      color: Colors.white70,
                      fontSize: 11,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFD4AF37),
                      foregroundColor: const Color(0xFF081B15),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const ZakatScreen()),
                      );
                    },
                    child: Text(
                      isUrdu ? 'زکوٰۃ کیلکولیٹر کھولیں ➔' : 'Open Zakat Calculator ➔',
                      style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
