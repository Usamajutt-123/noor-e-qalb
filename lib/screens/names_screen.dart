import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../data/islamic_data.dart';
import '../models/name_model.dart';
import '../theme/noor_theme.dart';
import '../widgets/noor_ui.dart';

class NamesScreen extends StatefulWidget {
  const NamesScreen({super.key});

  @override
  State<NamesScreen> createState() => _NamesScreenState();
}

class _NamesScreenState extends State<NamesScreen> {
  String _query = '';

  List<AsmaUlHusnaModel> get _names {
    final query = _query.trim().toLowerCase();
    if (query.isEmpty) return IslamicData.asmaUlHusnaList;
    return IslamicData.asmaUlHusnaList.where((name) => name.transliteration.toLowerCase().contains(query) || name.englishMeaning.toLowerCase().contains(query) || name.number.toString() == query).toList();
  }

  @override
  Widget build(BuildContext context) {
    final names = _names;
    return Scaffold(
      backgroundColor: NoorColors.background,
      appBar: const NoorPageHeader(title: '99 Names of Allah', subtitle: 'Asma-ul-Husna'),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 2, 16, 24),
        children: [
          NoorSearchField(hintText: 'Search Name...', onChanged: (value) => setState(() => _query = value)),
          const SizedBox(height: 16),
          ...names.map(_buildNameCard),
        ],
      ),
    );
  }

  Widget _buildNameCard(AsmaUlHusnaModel name) {
    return NoorPanel(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
      color: NoorColors.panelSoft,
      onTap: () => _showNameDetail(name),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(color: NoorColors.background, shape: BoxShape.circle, border: Border.all(color: NoorColors.gold.withOpacity(0.5))),
            alignment: Alignment.center,
            child: Text('${name.number}', style: GoogleFonts.poppins(color: NoorColors.goldBright, fontSize: 9, fontWeight: FontWeight.w700)),
          ),
          const SizedBox(width: 9),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name.transliteration, style: GoogleFonts.poppins(color: NoorColors.text, fontSize: 10.5, fontWeight: FontWeight.w700)),
                const SizedBox(height: 2),
                Text(name.englishMeaning, maxLines: 1, overflow: TextOverflow.ellipsis, style: GoogleFonts.poppins(color: NoorColors.textMuted, fontSize: 8.5)),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(name.arabic, textAlign: TextAlign.right, style: GoogleFonts.amiri(color: NoorColors.goldBright, fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(width: 5),
          const Icon(Icons.chevron_right_rounded, color: NoorColors.gold, size: 16),
        ],
      ),
    );
  }

  void _showNameDetail(AsmaUlHusnaModel name) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: NoorColors.panel,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(22, 20, 22, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(name.arabic, style: GoogleFonts.amiri(color: NoorColors.goldBright, fontSize: 40, fontWeight: FontWeight.bold)),
              const SizedBox(height: 5),
              Text(name.transliteration, style: GoogleFonts.poppins(color: NoorColors.text, fontSize: 18, fontWeight: FontWeight.w700)),
              const SizedBox(height: 4),
              Text(name.englishMeaning, style: GoogleFonts.poppins(color: NoorColors.textMuted, fontSize: 11)),
              const SizedBox(height: 15),
              NoorPanel(
                color: NoorColors.panelSoft,
                child: Text(name.benefit, textAlign: TextAlign.center, style: GoogleFonts.poppins(color: NoorColors.textMuted, fontSize: 10, height: 1.5)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
