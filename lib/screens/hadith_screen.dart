import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import '../services/language_service.dart';

class HadithItem {
  final int id;
  final String arabic;
  final String urdu;
  final String eng;
  final String refUr;
  final String refEn;
  final String catUr;
  final String catEn;

  const HadithItem({
    required this.id,
    required this.arabic,
    required this.urdu,
    required this.eng,
    required this.refUr,
    required this.refEn,
    required this.catUr,
    required this.catEn,
  });
}

class HadithScreen extends StatefulWidget {
  const HadithScreen({super.key});

  @override
  State<HadithScreen> createState() => _HadithScreenState();
}

class _HadithScreenState extends State<HadithScreen> {
  static const List<HadithItem> _ahadith = [
    HadithItem(
      id: 1,
      arabic: "خَيْرُكُمْ مَنْ تَعَلَّمَ الْقُرْآنَ وَعَلَّمَهُ",
      urdu: "تم میں سے بہترین شخص وہ ہے جو قرآن سیکھے اور دوسروں کو سکھائے۔",
      eng: "The best of you are those who learn the Quran and teach it.",
      refUr: "صحیح بخاری 5027",
      refEn: "Sahih Bukhari 5027",
      catUr: "قرآن",
      catEn: "Quran",
    ),
    HadithItem(
      id: 2,
      arabic: "أَحَبُّ الأَعْمَالِ إِلَى اللَّهِ أَدْوَمُهَا وَإِنْ قَلَّ",
      urdu: "اللہ کے نزدیک سب سے پسندیدہ عمل وہ ہے جو ہمیشہ کیا جائے، خواہ وہ تھوڑا ہی کیوں نہ ہو۔",
      eng: "The most beloved deed to Allah is the most regular and constant even if it were little.",
      refUr: "صحیح بخاری 6464",
      refEn: "Sahih Bukhari 6464",
      catUr: "اعمال",
      catEn: "Deeds",
    ),
    HadithItem(
      id: 3,
      arabic: "تَبَسُّمُكَ فِي وَجْهِ أَخِيكَ لَكَ صَدَقَةٌ",
      urdu: "اپنے مسلمان بھائی کے سامنے تمہارا مسکرانا بھی صدقہ ہے۔",
      eng: "Your smile in the face of your brother is charity.",
      refUr: "جامع ترمذی 1956",
      refEn: "Sunan At-Tirmidhi 1956",
      catUr: "اخلاق",
      catEn: "Character",
    ),
    HadithItem(
      id: 4,
      arabic: "لاَ يُؤْمِنُ أَحَدُكُمْ حَتَّى يُحِبَّ لأَخِيهِ مَا يُحِبُّ لِنَفْسِهِ",
      urdu: "تم میں سے کوئی شخص اس وقت تک کامل مومن نہیں ہو سکتا جب تک وہ اپنے بھائی کے لیے وہی پسند نہ کرے جو اپنے لیے پسند کرتا ہے۔",
      eng: "None of you truly believes until he loves for his brother what he loves for himself.",
      refUr: "صحیح بخاری 13",
      refEn: "Sahih Bukhari 13",
      catUr: "ایمان",
      catEn: "Faith",
    ),
    HadithItem(
      id: 5,
      arabic: "الْكَلِمَةُ الطَّيِّبَةُ صَدَقَةٌ",
      urdu: "اچھی اور پاکیزہ بات کہنا بھی صدقہ ہے۔",
      eng: "A good word is charity.",
      refUr: "صحیح بخاری 2989",
      refEn: "Sahih Bukhari 2989",
      catUr: "اخلاق",
      catEn: "Character",
    ),
    HadithItem(
      id: 6,
      arabic: "يَسِّرُوا وَلاَ تُعَسِّرُوا، وَبَشِّرُوا وَلاَ تُنَفِّرُوا",
      urdu: "لوگوں کے لیے آسانی پیدا کرو اور سختی نہ کرو، انہیں خوشخبری سناؤ اور نفرت نہ دلاؤ۔",
      eng: "Make things easy for people and do not make them difficult, and cheer people up and do not drive them away.",
      refUr: "صحیح بخاری 69",
      refEn: "Sahih Bukhari 69",
      catUr: "معاملات",
      catEn: "Conduct",
    ),
    HadithItem(
      id: 7,
      arabic: "مَنْ كَانَ يُؤْمِنُ بِاللَّهِ وَالْيَوْمِ الآخِرِ فَلْيَقُلْ خَيْرًا أَوْ لِيَصْمُتْ",
      urdu: "جو شخص اللہ اور آخرت کے دن پر ایمان رکھتا ہے، اسے چاہیے کہ اچھی بات کہے یا خاموش رہے۔",
      eng: "He who believes in Allah and the Last Day let him speak good or remain silent.",
      refUr: "صحیح بخاری 6018",
      refEn: "Sahih Bukhari 6018",
      catUr: "اخلاق",
      catEn: "Character",
    ),
    HadithItem(
      id: 8,
      arabic: "إِنَّ اللَّهَ لاَ يَنْظُرُ إِلَى صُوَرِكُمْ وَأَمْوَالِكُمْ وَلَكِنْ يَنْظُرُ إِلَى قُلُوبِكُمْ وَأَعْمَالِكُمْ",
      urdu: "بے شک اللہ تمہاری صورتوں اور مالوں کو نہیں دیکھتا، بلکہ وہ تمہارے دلوں اور اعمال کو دیکھتا ہے۔",
      eng: "Allah does not look at your forms or your wealth, but He looks at your hearts and your deeds.",
      refUr: "صحیح مسلم 2564",
      refEn: "Sahih Muslim 2564",
      catUr: "اخلاص",
      catEn: "Sincerity",
    ),
    HadithItem(
      id: 9,
      arabic: "مَنْ دَلَّ عَلَى خَيْرٍ فَلَهُ مِثْلُ أَجْرِ فَاعِلِهِ",
      urdu: "جس شخص نے کسی کو نیکی کا راستہ دکھایا، اس کے لیے نیکی کرنے والے کے برابر ثواب ہے۔",
      eng: "Whoever guides someone to goodness will have a reward like one who did it.",
      refUr: "صحیح مسلم 1893",
      refEn: "Sahih Muslim 1893",
      catUr: "نیکی",
      catEn: "Goodness",
    ),
    HadithItem(
      id: 10,
      arabic: "مَا نَقَصَتْ صَدَقَةٌ مِنْ مَالٍ",
      urdu: "صدقہ دینے سے مال میں کبھی کمی نہیں آتی۔",
      eng: "Charity does not decrease wealth.",
      refUr: "صحیح مسلم 2588",
      refEn: "Sahih Muslim 2588",
      catUr: "صدقہ",
      catEn: "Charity",
    ),
  ];

  int _currentIndex = 0;

  void _nextHadith() {
    setState(() {
      _currentIndex = (_currentIndex + 1) % _ahadith.length;
    });
  }

  Future<void> _shareHadith(bool isUrdu) async {
    final h = _ahadith[_currentIndex];
    final String text = isUrdu
        ? "*آج کی حدیثِ نبوی ﷺ*\n\n\"${h.arabic}\"\n\n*ترجمہ:* ${h.urdu}\n\n_${h.refUr}_\n\n📲 *نورِ قلب (Noor-e-Qalb)* اسلامی ایپ سے شیئر کیا گیا:"
        : "*Hadith of the Day*\n\n\"${h.arabic}\"\n\n*Translation:* ${h.eng}\n\n_${h.refEn}_\n\n📲 Shared via *Noor-e-Qalb* Islamic App:";
    await SharePlus.instance.share(ShareParams(text: text));
  }

  void _copyHadith(bool isUrdu) {
    final h = _ahadith[_currentIndex];
    final String text = isUrdu
        ? "${h.arabic}\n\nترجمہ: ${h.urdu}\n${h.refUr}\n\n— نورِ قلب"
        : "${h.arabic}\n\nTranslation: ${h.eng}\n${h.refEn}\n\n— Noor-e-Qalb";

    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(isUrdu ? '✅ حدیث کاپی ہو گئی!' : '✅ Hadith copied!'),
        backgroundColor: const Color(0xFF163024),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final langService = Provider.of<LanguageService>(context);
    final bool isUrdu = langService.isUrdu;
    final h = _ahadith[_currentIndex];

    return Scaffold(
      backgroundColor: const Color(0xFF082017),
      appBar: AppBar(
        backgroundColor: const Color(0xFF082017),
        elevation: 0,
        title: Text(
          isUrdu ? "آج کی حدیث" : "Hadith of the Day",
          style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Share Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF163024), Color(0xFF0A201A)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFCCA236), width: 1.5),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      "بِسْمِ ٱللَّٰهِ ٱلرَّحْمَـٰنِ ٱلرَّحِيمِ",
                      style: GoogleFonts.amiri(
                        color: const Color(0xFFCCA236),
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: const Color(0xFFCCA236).withOpacity(0.2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            isUrdu ? h.catUr : h.catEn,
                            style: const TextStyle(
                              color: Color(0xFFCCA236),
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          isUrdu ? "حدیثِ نبوی ﷺ" : "Hadith of the Day",
                          style: const TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Text(
                      h.arabic,
                      style: GoogleFonts.amiri(
                        color: const Color(0xFFCCA236),
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        height: 1.7,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 14),
                    Text(
                      isUrdu ? h.urdu : h.eng,
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 14,
                        height: 1.7,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 14),
                    Text(
                      "📚 ${isUrdu ? h.refUr : h.refEn}",
                      style: const TextStyle(
                        color: Color(0xFFCCA236),
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Divider(color: Colors.white12),
                    const SizedBox(height: 8),
                    Text(
                      isUrdu
                          ? "🌙 نورِ قلب • مفت ڈاؤن لوڈ کریں"
                          : "🌙 Noor-e-Qalb • Free on Play Store",
                      style: const TextStyle(color: Colors.white38, fontSize: 10),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _shareHadith(isUrdu),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF25D366),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      icon: const Icon(Icons.share, color: Colors.white, size: 16),
                      label: Text(
                        isUrdu ? "شیئر کریں" : "Share",
                        style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  SizedBox(
                    height: 44,
                    child: ElevatedButton(
                      onPressed: () => _copyHadith(isUrdu),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white12,
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      child: const Icon(Icons.copy, color: Colors.white, size: 16),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: _nextHadith,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFFCCA236),
                    side: const BorderSide(color: Color(0xFFCCA236)),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  icon: const Icon(Icons.shuffle, size: 16),
                  label: Text(
                    isUrdu ? "اگلی حدیث" : "Next Hadith",
                    style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
