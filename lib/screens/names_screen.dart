import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/name_model.dart';
import '../data/islamic_data.dart';
import '../widgets/ad_banner_widget.dart';

class NamesScreen extends StatelessWidget {
  const NamesScreen({super.key});

  void _showNameDetail(BuildContext context, AsmaUlHusnaModel name) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF163024),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              name.arabic,
              style: GoogleFonts.amiri(
                color: const Color(0xFFCCA236),
                fontSize: 38,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              name.transliteration,
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 14),
            Text(
              'Urdu Meaning: ${name.urduMeaning}',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(color: Colors.white70, fontSize: 14),
            ),
            const SizedBox(height: 6),
            Text(
              'English: ${name.englishMeaning}',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(color: Colors.white54, fontSize: 13),
            ),
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF1B382C),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '✨ Benefit of Recitation:\n${name.benefit}',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(color: const Color(0xFFCCA236), fontSize: 12),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF082017),
      appBar: AppBar(
        backgroundColor: const Color(0xFF163024),
        elevation: 0,
        title: Text(
          '99 Names of Allah',
          style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 16),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(14),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.9,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: IslamicData.asmaUlHusnaList.length,
              itemBuilder: (ctx, idx) {
                final name = IslamicData.asmaUlHusnaList[idx];
                return GestureDetector(
                  onTap: () => _showNameDetail(context, name),
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF163024),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFCCA236).withOpacity(0.25)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.15),
                          blurRadius: 5,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                '#${name.number}',
                                style: GoogleFonts.poppins(
                                  color: Colors.white30,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            name.arabic,
                            style: GoogleFonts.amiri(
                              color: const Color(0xFFCCA236),
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            name.transliteration,
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 3),
                          Text(
                            name.englishMeaning,
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.poppins(
                              color: Colors.white54,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
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
