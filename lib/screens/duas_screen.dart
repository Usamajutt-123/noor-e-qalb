import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';
import '../models/dua_model.dart';
import '../data/islamic_data.dart';
import '../widgets/ad_banner_widget.dart';

class DuasScreen extends StatefulWidget {
  const DuasScreen({super.key});

  @override
  State<DuasScreen> createState() => _DuasScreenState();
}

class _DuasScreenState extends State<DuasScreen> {
  String _selectedCategory = 'All';

  List<String> get _categories {
    final cats = IslamicData.defaultDuas.map((d) => d.category).toSet().toList();
    return ['All', ...cats];
  }

  List<DuaModel> get _filteredDuas {
    if (_selectedCategory == 'All') return IslamicData.defaultDuas;
    return IslamicData.defaultDuas.where((d) => d.category == _selectedCategory).toList();
  }

  void _shareDua(DuaModel dua) {
    final text = '''
🌟 ${dua.title} 🌟

${dua.arabicText}

Urdu: ${dua.urduTranslation}
English: ${dua.englishTranslation}

Reference: ${dua.reference}
---
Shared from Noor-e-Qalb Islamic App
''';
    Share.share(text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF081B15),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F2C23),
        elevation: 0,
        title: Text(
          'Masnoon Duas & Azkar',
          style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          // Category Horizontal Chips
          SizedBox(
            height: 60,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              itemCount: _categories.length,
              itemBuilder: (ctx, idx) {
                final cat = _categories[idx];
                final isSelected = cat == _selectedCategory;
                return Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: ChoiceChip(
                    label: Text(
                      cat,
                      style: GoogleFonts.poppins(
                        color: isSelected ? const Color(0xFF081B15) : Colors.white,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                        fontSize: 12,
                      ),
                    ),
                    selected: isSelected,
                    selectedColor: const Color(0xFFD4AF37),
                    backgroundColor: const Color(0xFF0F2C23),
                    onSelected: (selected) {
                      if (selected) {
                        setState(() {
                          _selectedCategory = cat;
                        });
                      }
                    },
                  ),
                );
              },
            ),
          ),

          // Dua List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _filteredDuas.length,
              itemBuilder: (ctx, idx) {
                final dua = _filteredDuas[idx];
                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0F2C23),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFD4AF37).withOpacity(0.2)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Title & Share
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                dua.title,
                                style: GoogleFonts.poppins(
                                  color: const Color(0xFFD4AF37),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.share, color: Colors.white60, size: 20),
                              onPressed: () => _shareDua(dua),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        // Arabic Text
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: const Color(0xFF13382D),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            dua.arabicText,
                            textAlign: TextAlign.right,
                            style: GoogleFonts.amiri(
                              color: Colors.white,
                              fontSize: 26,
                              height: 1.6,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 14),

                        // Urdu Translation
                        Text(
                          dua.urduTranslation,
                          textAlign: TextAlign.right,
                          style: GoogleFonts.notoNastaliqUrdu(
                            color: Colors.white70,
                            fontSize: 14,
                            height: 1.8,
                          ),
                        ),
                        const SizedBox(height: 8),

                        // English Translation
                        Text(
                          dua.englishTranslation,
                          style: GoogleFonts.poppins(
                            color: Colors.white54,
                            fontSize: 12,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Reference & Virtue
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              dua.reference,
                              style: GoogleFonts.poppins(
                                color: const Color(0xFFD4AF37),
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            if (dua.virtue.isNotEmpty)
                              Tooltip(
                                message: dua.virtue,
                                child: const Row(
                                  children: [
                                    Icon(Icons.info_outline, color: Colors.white54, size: 14),
                                    SizedBox(width: 4),
                                    Text(
                                      'Virtue',
                                      style: TextStyle(color: Colors.white54, fontSize: 11),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // Google AdMob Banner
          const AdBannerWidget(),
        ],
      ),
    );
  }
}
