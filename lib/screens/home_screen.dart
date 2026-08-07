import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../models/dua_model.dart';
import '../data/islamic_data.dart';
import '../services/premium_service.dart';
import '../services/prayer_service.dart';
import '../services/daily_task_service.dart';
import '../services/language_service.dart';
import '../widgets/ad_banner_widget.dart';
import 'tasbeeh_screen.dart';
import 'duas_screen.dart';
import 'names_screen.dart';
import 'pro_upgrade_screen.dart';
import 'prayer_times_screen.dart';
import 'daily_tasks_screen.dart';
import 'settings_screen.dart';
import 'surahs_screen.dart';
import 'qibla_screen.dart';
import 'hadith_screen.dart';
import 'qaza_tracker_screen.dart';
import 'zakat_screen.dart';
import 'ramadan_screen.dart';
import 'daily_action_plan_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  String _formatDuration(Duration d) {
    if (d.isNegative) return '00h 00m 00s';
    final int hours = d.inHours;
    final int mins = d.inMinutes.remainder(60);
    final int secs = d.inSeconds.remainder(60);
    return '${hours.toString().padLeft(2, '0')}h ${mins.toString().padLeft(2, '0')}m ${secs.toString().padLeft(2, '0')}s';
  }

  @override
  Widget build(BuildContext context) {
    final premiumService = Provider.of<PremiumService>(context);
    final prayerService = Provider.of<PrayerService>(context);
    final taskService = Provider.of<DailyTaskService>(context);
    final langService = Provider.of<LanguageService>(context);
    final schedule = prayerService.getSchedule(DateTime.now());
    final DuaModel dailyDua = IslamicData.defaultDuas.first;

    return Scaffold(
      backgroundColor: const Color(0xFF081B15),
      body: SafeArea(
        child: Column(
          children: [
            // Header Bar with Settings Gear
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'بِسْمِ ٱللَّٰهِ ٱلرَّحْمَـٰنِ ٱلرَّحِيمِ',
                        style: GoogleFonts.amiri(
                          color: const Color(0xFFD4AF37),
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        langService.isUrdu ? 'نورِ قلب' : 'Noor-e-Qalb',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  // Actions: Streak Badge + Settings Icon + Pro
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const DailyTasksScreen()),
                          );
                        },
                        child: Container(
                          margin: const EdgeInsets.only(right: 8),
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: const Color(0xFF194C3D),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: const Color(0xFFD4AF37)),
                          ),
                          child: Row(
                            children: [
                              const Text('🔥', style: TextStyle(fontSize: 14)),
                              const SizedBox(width: 4),
                              Text(
                                '${taskService.streakCount}d',
                                style: GoogleFonts.poppins(
                                  color: const Color(0xFFD4AF37),
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      IconButton(
                        icon: const Icon(Icons.settings, color: Color(0xFFD4AF37)),
                        tooltip: 'Settings',
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const SettingsScreen()),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // NAMAZ TIME & REMAINING COUNTDOWN BANNER
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const PrayerTimesScreen()),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF194C3D), Color(0xFF0F2C23)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(22),
                          border: Border.all(color: const Color(0xFFD4AF37), width: 1.5),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFD4AF37).withOpacity(0.2),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(Icons.location_on, color: Color(0xFFD4AF37), size: 16),
                                      const SizedBox(width: 4),
                                      Text(
                                        '${schedule.location.cityName}, ${schedule.location.countryName}',
                                        style: GoogleFonts.poppins(
                                          color: Colors.white70,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  if (schedule.nextPrayer != null) ...[
                                    Text(
                                      'Next: ${schedule.nextPrayer!.nameEnglish} (${schedule.nextPrayer!.timeString})',
                                      style: GoogleFonts.poppins(
                                        color: Colors.white,
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Remaining: ${_formatDuration(schedule.remainingTimeToNext)}',
                                      style: GoogleFonts.poppins(
                                        color: const Color(0xFFD4AF37),
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                            const Icon(Icons.mosque, color: Color(0xFFD4AF37), size: 38),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 18),

                    // RAMADAN 1448 AH HERO BANNER (SCREEN 11 REFERENCE)
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const RamadanScreen()),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF1A4638), Color(0xFF0C231B)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: const Color(0xFFD4AF37), width: 1.5),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Text('🌙', style: TextStyle(fontSize: 32)),
                                const SizedBox(width: 14),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      langService.isUrdu ? 'رمضان المبارک 1448 ہجری' : 'RAMADAN 1448 AH',
                                      style: GoogleFonts.poppins(
                                        color: const Color(0xFFD4AF37),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                    ),
                                    Text(
                                      langService.isUrdu ? 'آمد کا لائیو کاؤنٹ ڈاؤن، ٹائم ٹیبل اور دعائیں' : 'Live Arrival Countdown, Timetable & Duas',
                                      style: GoogleFonts.poppins(
                                        color: Colors.white70,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const Icon(Icons.arrow_forward_ios, color: Color(0xFFD4AF37), size: 18),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 18),

                    // DAILY ISLAMIC ACTION PLAN & NAMAZ TRACKER HERO BUTTON
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const DailyActionPlanScreen()),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0F2C23),
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: const Color(0xFFD4AF37).withOpacity(0.4)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Text('🌟', style: TextStyle(fontSize: 22)),
                                const SizedBox(width: 12),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      langService.isUrdu ? 'آج کا اسلامی لائحہ عمل اور نماز ٹریکر' : 'Daily Action Plan & Namaz Tracker',
                                      style: GoogleFonts.poppins(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                    Text(
                                      langService.isUrdu ? '5 فرض نمازیں • 4 روحانی اعمال • 🪙 +10 ٹوکنز' : '5 Daily Prayers • 4 Deeds • 🪙 +10 Tokens each',
                                      style: GoogleFonts.poppins(
                                        color: Colors.white60,
                                        fontSize: 11,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const Icon(Icons.arrow_forward_ios, color: Color(0xFFD4AF37), size: 16),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 18),

                    // Daily Dua / Hadith Highlight Card
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0F2C23),
                        borderRadius: BorderRadius.circular(22),
                        border: Border.all(color: const Color(0xFFD4AF37).withOpacity(0.3)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFD4AF37).withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  'DAILY DUA HIGHLIGHT',
                                  style: GoogleFonts.poppins(
                                    color: const Color(0xFFD4AF37),
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 1,
                                  ),
                                ),
                              ),
                              const Icon(Icons.menu_book, color: Color(0xFFD4AF37), size: 20),
                            ],
                          ),
                          const SizedBox(height: 14),
                          Text(
                            dailyDua.title,
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            dailyDua.arabicText,
                            textAlign: TextAlign.right,
                            style: GoogleFonts.amiri(
                              color: const Color(0xFFD4AF37),
                              fontSize: 24,
                              height: 1.6,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            dailyDua.urduTranslation,
                            style: GoogleFonts.poppins(
                              color: Colors.white70,
                              fontSize: 13,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),
                    Text(
                      'Islamic Companion Features',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Feature Grid (Now includes Holy Quran / Surahs!)
                    GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisSpacing: 14,
                      mainAxisSpacing: 14,
                      childAspectRatio: 1.05,
                      children: [
                        _buildFeatureCard(
                          context,
                          title: 'Holy Quran Surahs',
                          subtitle: 'Yaseen, Rahman, Mulk',
                          icon: Icons.auto_stories,
                          isHighlight: true,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const SurahsScreen()),
                            );
                          },
                        ),
                        _buildFeatureCard(
                          context,
                          title: 'Daily Tasks',
                          subtitle: 'Randomized daily streak',
                          icon: Icons.task_alt,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const DailyTasksScreen()),
                            );
                          },
                        ),
                        _buildFeatureCard(
                          context,
                          title: 'Namaz Timings',
                          subtitle: 'Live countdown & alarms',
                          icon: Icons.access_time_filled,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const PrayerTimesScreen()),
                            );
                          },
                        ),
                        _buildFeatureCard(
                          context,
                          title: 'Qibla Compass',
                          subtitle: 'Live Kaaba Direction',
                          icon: Icons.explore,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const QiblaScreen()),
                            );
                          },
                        ),
                        _buildFeatureCard(
                          context,
                          title: 'Hadith of the Day',
                          subtitle: 'Viral WhatsApp Share Card',
                          icon: Icons.brightness_3,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const HadithScreen()),
                            );
                          },
                        ),
                        _buildFeatureCard(
                          context,
                          title: 'Qaza Prayer Log',
                          subtitle: 'Missed Prayers Tracker',
                          icon: Icons.history_edu,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const QazaTrackerScreen()),
                            );
                          },
                        ),
                        _buildFeatureCard(
                          context,
                          title: 'Zakat Calculator',
                          subtitle: 'Shariah 2.5% Nisab',
                          icon: Icons.calculate,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const ZakatScreen()),
                            );
                          },
                        ),
                        _buildFeatureCard(
                          context,
                          title: 'Digital Tasbeeh',
                          subtitle: 'Vibration & custom count',
                          icon: Icons.track_changes,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const TasbeehScreen()),
                            );
                          },
                        ),
                        _buildFeatureCard(
                          context,
                          title: 'Masnoon Duas',
                          subtitle: 'Subah, Sham & Azkar',
                          icon: Icons.menu_book,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const DuasScreen()),
                            );
                          },
                        ),
                        _buildFeatureCard(
                          context,
                          title: '99 Names',
                          subtitle: 'Asma-ul-Husna meanings',
                          icon: Icons.auto_awesome,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const NamesScreen()),
                            );
                          },
                        ),
                        _buildFeatureCard(
                          context,
                          title: '6 Kalimas of Islam',
                          subtitle: 'Arabic, Trans & Audio',
                          icon: Icons.star_border,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const DuasScreen()),
                            );
                          },
                        ),
                        _buildFeatureCard(
                          context,
                          title: 'Namaz Guide',
                          subtitle: 'Janazah, Eid & Nawafil',
                          icon: Icons.menu_book,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const PrayerTimesScreen()),
                            );
                          },
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),

            // Google AdMob Banner
            const AdBannerWidget(),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
    bool isHighlight = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isHighlight ? const Color(0xFF194C3D) : const Color(0xFF0F2C23),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isHighlight
                ? const Color(0xFFD4AF37)
                : const Color(0xFFD4AF37).withOpacity(0.2),
            width: isHighlight ? 1.5 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFF081B15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: const Color(0xFFD4AF37), size: 26),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: GoogleFonts.poppins(
                    color: Colors.white60,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
