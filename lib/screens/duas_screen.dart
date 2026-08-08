import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import '../data/islamic_data.dart';
import '../models/dua_model.dart';
import '../services/language_service.dart';
import '../theme/noor_theme.dart';
import '../widgets/noor_ui.dart';

class DuasScreen extends StatefulWidget {
  const DuasScreen({super.key});

  @override
  State<DuasScreen> createState() => _DuasScreenState();
}

class _DuasScreenState extends State<DuasScreen> {
  String _query = '';
  String _selectedCategory = 'All';
  final Set<String> _favorites = <String>{};

  List<_DuaCategory> get _categories => const [
        _DuaCategory('Morning', Icons.wb_twilight_rounded, 'Subah & Sham'),
        _DuaCategory('Evening', Icons.nightlight_round, 'Subah & Sham'),
        _DuaCategory('Prayer', Icons.mosque_outlined, 'Namaz Ke Baad'),
        _DuaCategory('Travel', Icons.flight_takeoff_rounded, 'Safar & Ghar'),
        _DuaCategory('Sleep', Icons.bedtime_outlined, 'Subah & Sham'),
        _DuaCategory('Daily Life', Icons.favorite_outline_rounded, 'All'),
      ];

  List<DuaModel> get _filteredDuas {
    Iterable<DuaModel> result = IslamicData.defaultDuas;
    if (_selectedCategory != 'All') {
      result = result.where((dua) => dua.category.contains(_selectedCategory));
    }
    if (_query.trim().isNotEmpty) {
      final query = _query.toLowerCase().trim();
      result = result.where((dua) => dua.title.toLowerCase().contains(query) || dua.category.toLowerCase().contains(query) || dua.englishTranslation.toLowerCase().contains(query));
    }
    return result.toList();
  }

  Future<void> _share(DuaModel dua) async {
    await SharePlus.instance.share(ShareParams(text: '${dua.title}\n\n${dua.arabicText}\n\n${dua.englishTranslation}\n\n${dua.reference}\n\nShared from Noor-e-Qalb'));
  }

  @override
  Widget build(BuildContext context) {
    final isUrdu = context.watch<LanguageService>().isUrdu;
    final duas = _filteredDuas;

    return Scaffold(
      backgroundColor: NoorColors.background,
      appBar: NoorPageHeader(
        title: isUrdu ? 'دعائیں' : 'Duas',
        subtitle: isUrdu ? 'مسنون دعائیں اور اذکار' : 'Masnoon duas for everyday life',
        actions: const [NoorIconButton(icon: Icons.bookmark_border_rounded, tooltip: 'Saved'), SizedBox(width: 5)],
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 2, 16, 24),
        children: [
          NoorSearchField(hintText: isUrdu ? 'دعا تلاش کریں...' : 'Search Duas...', onChanged: (value) => setState(() => _query = value)),
          const SizedBox(height: 18),
          const NoorSectionTitle(title: 'Categories'),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _categories.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: 8, mainAxisSpacing: 8, childAspectRatio: 1.12),
            itemBuilder: (_, index) {
              final category = _categories[index];
              final selected = _selectedCategory == category.filter;
              return NoorPanel(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                color: selected ? NoorColors.panelRaised : NoorColors.panel,
                border: Border.all(color: selected ? NoorColors.gold : NoorColors.gold.withOpacity(0.2)),
                onTap: () => setState(() => _selectedCategory = selected ? 'All' : category.filter),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(category.icon, color: NoorColors.goldBright, size: 20),
                    const SizedBox(height: 5),
                    Text(category.title, textAlign: TextAlign.center, maxLines: 1, overflow: TextOverflow.ellipsis, style: GoogleFonts.poppins(color: NoorColors.text, fontSize: 9, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 2),
                    Text(_countFor(category.filter).toString() + ' Duas', style: GoogleFonts.poppins(color: NoorColors.textFaint, fontSize: 7.5)),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 18),
          NoorSectionTitle(title: _selectedCategory == 'All' ? 'Popular Duas' : _selectedCategory, action: '${duas.length} items'),
          if (duas.isEmpty)
            NoorPanel(child: Text('No duas found', style: GoogleFonts.poppins(color: NoorColors.textMuted, fontSize: 11)))
          else
            ...duas.map((dua) => _buildDuaCard(dua, isUrdu)),
        ],
      ),
    );
  }

  int _countFor(String filter) {
    if (filter == 'All') return IslamicData.defaultDuas.length;
    return IslamicData.defaultDuas.where((dua) => dua.category.contains(filter)).length;
  }

  Widget _buildDuaCard(DuaModel dua, bool isUrdu) {
    final favorite = _favorites.contains(dua.id);
    return NoorPanel(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.fromLTRB(12, 11, 12, 12),
      color: NoorColors.panelSoft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(child: Text(dua.title.split('/').first.trim(), maxLines: 1, overflow: TextOverflow.ellipsis, style: GoogleFonts.poppins(color: NoorColors.text, fontSize: 11, fontWeight: FontWeight.w700))),
              IconButton(
                onPressed: () => setState(() => favorite ? _favorites.remove(dua.id) : _favorites.add(dua.id)),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints.tightFor(width: 28, height: 28),
                icon: Icon(favorite ? Icons.favorite_rounded : Icons.favorite_border_rounded, color: NoorColors.goldBright, size: 17),
              ),
              IconButton(
                onPressed: () => _share(dua),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints.tightFor(width: 28, height: 28),
                icon: const Icon(Icons.share_outlined, color: NoorColors.textMuted, size: 16),
              ),
            ],
          ),
          const SizedBox(height: 7),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            decoration: BoxDecoration(color: NoorColors.panel, borderRadius: BorderRadius.circular(10)),
            child: Text(dua.arabicText, textAlign: TextAlign.right, style: GoogleFonts.amiri(color: NoorColors.goldBright, fontSize: 19, height: 1.7, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 7),
          Text(isUrdu ? dua.urduTranslation : dua.englishTranslation, textAlign: isUrdu ? TextAlign.right : TextAlign.left, maxLines: 3, overflow: TextOverflow.ellipsis, style: GoogleFonts.poppins(color: NoorColors.textMuted, fontSize: 9.5, height: 1.5)),
          const SizedBox(height: 7),
          Text(dua.reference, style: GoogleFonts.poppins(color: NoorColors.gold, fontSize: 8.5, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

class _DuaCategory {
  final String title;
  final IconData icon;
  final String filter;

  const _DuaCategory(this.title, this.icon, this.filter);
}
