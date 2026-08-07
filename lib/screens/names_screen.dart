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
      backgroundColor: const Color(0xFF0F2C23),
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
                color: const Color(0xFFD4AF37),
                fontSize: 42,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              name.transliteration,
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Urdu Meaning: ${name.urduMeaning}',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(color: Colors.white70, fontSize: 15),
            ),
            const SizedBox(height: 8),
            Text(
              'English: ${name.englishMeaning}',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(color: Colors.white54, fontSize: 14),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF13382D),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '✨ Benefit of Recitation:\n${name.benefit}',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(color: const Color(0xFFD4AF37), fontSize: 13),
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
      backgroundColor: const Color(0xFF081B15),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F2C23),
        elevation: 0,
        title: Text(
          '99 Names of Allah (Asma-ul-Husna)',
          style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.95,
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
              ),
              itemCount: IslamicData.asmaUlHusnaList.length,
              itemBuilder: (ctx, idx) {
                final name = IslamicData.asmaUlHusnaList[idx];
                return GestureDetector(
                  onTap: () => _showNameDetail(context, name),
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF0F2C23),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFD4AF37).withOpacity(0.25)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
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
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            name.arabic,
                            style: GoogleFonts.amiri(
                              color: const Color(0xFFD4AF37),
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            name.transliteration,
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            name.englishMeaning,
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.poppins(
                              color: Colors.white54,
                              fontSize: 11,
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
