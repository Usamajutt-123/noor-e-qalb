import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import '../services/language_service.dart';
import '../theme/noor_theme.dart';
import '../widgets/noor_ui.dart';

class HadithItem {
  final int id;
  final String arabic;
  final String urdu;
  final String eng;
  final String refUr;
  final String refEn;
  final String catUr;
  final String catEn;

  const HadithItem({required this.id, required this.arabic, required this.urdu, required this.eng, required this.refUr, required this.refEn, required this.catUr, required this.catEn});
}

class HadithScreen extends StatefulWidget {
  const HadithScreen({super.key});

  @override
  State<HadithScreen> createState() => _HadithScreenState();
}

class _HadithScreenState extends State<HadithScreen> {
  static const _items = <HadithItem>[
    HadithItem(id: 1, arabic: 'إِنَّمَا الأَعْمَالُ بِالنِّيَّاتِ', urdu: 'اعمال کا دار و مدار نیتوں پر ہے۔', eng: 'Actions are judged by intentions.', refUr: 'صحیح بخاری 1', refEn: 'Sahih Bukhari 1', catUr: 'ایمان', catEn: 'Faith'),
    HadithItem(id: 2, arabic: 'خَيْرُكُمْ مَنْ تَعَلَّمَ الْقُرْآنَ وَعَلَّمَهُ', urdu: 'تم میں سے بہترین وہ ہے جو قرآن سیکھے اور سکھائے۔', eng: 'The best of you are those who learn the Quran and teach it.', refUr: 'صحیح بخاری 5027', refEn: 'Sahih Bukhari 5027', catUr: 'قرآن', catEn: 'Quran'),
    HadithItem(id: 3, arabic: 'مَنْ لاَ يَرْحَمْ لاَ يُرْحَمْ', urdu: 'جو رحم نہیں کرتا اس پر رحم نہیں کیا جاتا۔', eng: 'The one who does not show mercy will not be shown mercy.', refUr: 'صحیح بخاری 7376', refEn: 'Sahih Bukhari 7376', catUr: 'اخلاق', catEn: 'Character'),
    HadithItem(id: 4, arabic: 'الْكَلِمَةُ الطَّيِّبَةُ صَدَقَةٌ', urdu: 'اچھی اور پاکیزہ بات کہنا بھی صدقہ ہے۔', eng: 'A good word is charity.', refUr: 'صحیح بخاری 2989', refEn: 'Sahih Bukhari 2989', catUr: 'اعمال', catEn: 'Deeds'),
    HadithItem(id: 5, arabic: 'لاَ ضَرَرَ وَلاَ ضِرَارَ', urdu: 'نہ خود نقصان پہنچاؤ اور نہ دوسرے کو نقصان دو۔', eng: 'There should be neither harm nor reciprocating harm.', refUr: 'سنن ابن ماجہ 2340', refEn: 'Sunan Ibn Majah 2340', catUr: 'معاملات', catEn: 'Conduct'),
  ];

  String _query = '';
  String _category = 'All';
  final Set<int> _favorites = <int>{};

  List<HadithItem> _filtered(bool isUrdu) {
    final query = _query.trim().toLowerCase();
    return _items.where((item) {
      final category = isUrdu ? item.catUr : item.catEn;
      final matchesCategory = _category == 'All' ||
          category == _category ||
          (isUrdu && _category == 'بخاری' && item.refUr.contains('بخاری')) ||
          (isUrdu && _category == 'مسلم' && item.refUr.contains('مسلم')) ||
          (!isUrdu && _category == 'Sahih Bukhari' && item.refEn.contains('Bukhari')) ||
          (!isUrdu && _category == 'Sahih Muslim' && item.refEn.contains('Muslim'));
      final matchesQuery = query.isEmpty || item.eng.toLowerCase().contains(query) || item.urdu.contains(query) || item.refEn.toLowerCase().contains(query);
      return matchesCategory && matchesQuery;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final isUrdu = context.watch<LanguageService>().isUrdu;
    final items = _filtered(isUrdu);
    final categories = isUrdu ? const ['All', 'بخاری', 'مسلم', 'اخلاق'] : const ['All', 'Sahih Bukhari', 'Sahih Muslim', 'Character'];

    return Scaffold(
      backgroundColor: NoorColors.background,
      appBar: NoorPageHeader(title: isUrdu ? 'احادیث' : 'Hadith', subtitle: isUrdu ? 'نبی کریم ﷺ کی روشن تعلیمات' : 'Words of guidance from the Prophet ﷺ', actions: const [NoorIconButton(icon: Icons.bookmark_border_rounded), SizedBox(width: 5)]),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 2, 16, 24),
        children: [
          NoorSearchField(hintText: isUrdu ? 'حدیث تلاش کریں...' : 'Search Hadith...', onChanged: (value) => setState(() => _query = value)),
          const SizedBox(height: 12),
          SizedBox(
            height: 34,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              separatorBuilder: (_, __) => const SizedBox(width: 7),
              itemBuilder: (_, index) {
                final category = categories[index];
                return NoorPill(label: category, selected: _category == category, onTap: () => setState(() => _category = category));
              },
            ),
          ),
          const SizedBox(height: 16),
          ...items.map((item) => _buildHadithCard(item, isUrdu)),
        ],
      ),
    );
  }

  Widget _buildHadithCard(HadithItem item, bool isUrdu) {
    final favorite = _favorites.contains(item.id);
    return NoorPanel(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.fromLTRB(12, 11, 11, 10),
      color: NoorColors.panelSoft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(child: Text('Hadith ${item.id}', style: GoogleFonts.poppins(color: NoorColors.text, fontSize: 11, fontWeight: FontWeight.w700))),
              IconButton(onPressed: () => setState(() => favorite ? _favorites.remove(item.id) : _favorites.add(item.id)), padding: EdgeInsets.zero, constraints: const BoxConstraints.tightFor(width: 28, height: 28), icon: Icon(favorite ? Icons.favorite_rounded : Icons.favorite_border_rounded, color: NoorColors.goldBright, size: 16)),
            ],
          ),
          Text(item.arabic, textAlign: TextAlign.right, style: GoogleFonts.amiri(color: NoorColors.goldBright, fontSize: 18, height: 1.6)),
          const SizedBox(height: 5),
          Text(isUrdu ? item.urdu : '“${item.eng}”', style: GoogleFonts.poppins(color: NoorColors.text, fontSize: 10, height: 1.5)),
          const SizedBox(height: 7),
          Row(
            children: [
              Expanded(child: Text(isUrdu ? item.refUr : item.refEn, style: GoogleFonts.poppins(color: NoorColors.textMuted, fontSize: 8.5))),
              IconButton(onPressed: () => _copy(item, isUrdu), padding: EdgeInsets.zero, constraints: const BoxConstraints.tightFor(width: 26, height: 26), icon: const Icon(Icons.copy_outlined, color: NoorColors.textMuted, size: 15)),
              IconButton(onPressed: () => _share(item, isUrdu), padding: EdgeInsets.zero, constraints: const BoxConstraints.tightFor(width: 26, height: 26), icon: const Icon(Icons.share_outlined, color: NoorColors.goldBright, size: 15)),
            ],
          ),
        ],
      ),
    );
  }

  void _copy(HadithItem item, bool isUrdu) {
    Clipboard.setData(ClipboardData(text: '${item.arabic}\n\n${isUrdu ? item.urdu : item.eng}\n${isUrdu ? item.refUr : item.refEn}'));
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(isUrdu ? 'حدیث کاپی ہو گئی' : 'Hadith copied')));
  }

  Future<void> _share(HadithItem item, bool isUrdu) async {
    await SharePlus.instance.share(ShareParams(text: '${item.arabic}\n\n${isUrdu ? item.urdu : item.eng}\n\n${isUrdu ? item.refUr : item.refEn}\n\nShared from Noor-e-Qalb'));
  }
}
