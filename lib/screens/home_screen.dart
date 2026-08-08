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

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Bottom navigation current index - fix to show all tabs
  int _bottomNavIndex = 0;

  String _formatDuration(Duration d) {
    if (d.isNegative) return '00h 00m 00s';
    final int hours = d.inHours;
    final int mins = d.inMinutes.remainder(60);
    final int secs = d.inSeconds.remainder(60);
    return '${hours.toString().padLeft(2, '0')}h ${mins.toString().padLeft(2, '0')}m ${secs.toString().padLeft(2, '0')}s';
  }

  @override
  Widget build(BuildContext context) {
    // Define bottom navigation pages - all wrapped to keep provider tree intact
    final List<Widget> pages = [
      _buildDashboard(context),
      const SurahsScreen(),
      const TasbeehScreen(),
      const QiblaScreen(),
      const DuasScreen(),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF082017),
      body: IndexedStack(
        index: _bottomNavIndex,
        children: pages,
      ),
      // FIX: Restored Bottom Navigation - fixed type to show all tabs including last four that were missing
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _bottomNavIndex,
        onTap: (idx) {
          setState(() {
            _bottomNavIndex = idx;
          });
        },
        backgroundColor: const Color(0xFF163024),
        selectedItemColor: const Color(0xFFCCA236),
        unselectedItemColor: Colors.white54,
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: true,
        selectedLabelStyle: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w600),
        unselectedLabelStyle: GoogleFonts.poppins(fontSize: 10),
        elevation: 12,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            label: 'Home',
            tooltip: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.auto_stories),
            label: 'Quran',
            tooltip: 'Holy Quran Surahs',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.track_changes),
            label: 'Tasbeeh',
            tooltip: 'Tasbeeh Counter',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.explore),
            label: 'Qibla',
            tooltip: 'Qibla Compass',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book),
            label: 'Duas',
            tooltip: 'Masnoon Duas',
          ),
        ],
      ),
    );
  }

  Widget _buildDashboard(BuildContext context) {
    final premiumService = Provider.of<PremiumService>(context);
    final prayerService = Provider.of<PrayerService>(context);
    final taskService = Provider.of<DailyTaskService>(context);
    final langService = Provider.of<LanguageService>(context);
    final schedule = prayerService.getSchedule(DateTime.now());
    final DuaModel dailyDua = IslamicData.defaultDuas.first;

    return SafeArea(
      child: Column(
        children: [
          // Header Bar with Settings Gear
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'بِسْمِ ٱللَّٰهِ ٱلرَّحْمَـٰنِ ٱلرَّحِيمِ',
                          style: GoogleFonts.amiri(
                            color: const Color(0xFFCCA236),
                            fontSize: 17,
                          ),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        langService.isUrdu ? 'نورِ قلب' : 'Noor-e-Qalb',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const DailyTasksScreen()),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E4A39),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: const Color(0xFFCCA236)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text('🔥', style: TextStyle(fontSize: 13)),
                            const SizedBox(width: 4),
                            Text(
                              '${taskService.streakCount}d',
                              style: GoogleFonts.poppins(
                                color: const Color(0xFFCCA236),
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                    SizedBox(
                      width: 40,
                      height: 40,
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        icon: const Icon(Icons.settings, color: Color(0xFFCCA236), size: 22),
                        tooltip: 'Settings',
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const SettingsScreen()),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          Expanded(
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
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
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF1E4A39), Color(0xFF163024)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0xFFCCA236), width: 1.5),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFCCA236).withOpacity(0.15),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Icon(Icons.location_on, color: Color(0xFFCCA236), size: 14),
                                    const SizedBox(width: 4),
                                    Flexible(
                                      child: Text(
                                        '${schedule.location.cityName}, ${schedule.location.countryName}',
                                        style: GoogleFonts.poppins(
                                          color: Colors.white70,
                                          fontSize: 11,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                if (schedule.nextPrayer != null) ...[
                                  Text(
                                    'Next: ${schedule.nextPrayer!.nameEnglish}',
                                    style: GoogleFonts.poppins(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    '${schedule.nextPrayer!.timeString} • ${_formatDuration(schedule.remainingTimeToNext)} left',
                                    style: GoogleFonts.poppins(
                                      color: const Color(0xFFCCA236),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                          const SizedBox(width: 10),
                          const Icon(Icons.mosque, color: Color(0xFFCCA236), size: 36),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 14),

                  // RAMADAN 1448 AH HERO BANNER
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const RamadanScreen()),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF1E4A3C), Color(0xFF0E241C)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0xFFCCA236).withOpacity(0.6), width: 1.2),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFCCA236).withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: const Color(0xFFCCA236).withOpacity(0.15),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Text('🌙', style: TextStyle(fontSize: 24)),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  langService.isUrdu ? 'رمضان المبارک 1448 ہجری' : 'Ramadan 1448 AH Suite',
                                  style: GoogleFonts.poppins(
                                    color: const Color(0xFFCCA236),
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  langService.isUrdu
                                      ? 'سحری، افطار، شبِ قدر اور 30 دن کا مکمل ٹائم ٹیبل'
                                      : 'Suhoor, Iftar, Laylatul Qadr & full 30-day schedule',
                                  style: GoogleFonts.poppins(
                                    color: Colors.white70,
                                    fontSize: 11,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(Icons.chevron_right, color: Color(0xFFCCA236), size: 22),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 14),

                  // DAILY DUA CARD
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const DuasScreen()),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF163024), Color(0xFF0A201A)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: const Color(0xFFCCA236).withOpacity(0.3)),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: const Color(0xFFCCA236).withOpacity(0.12),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(Icons.menu_book, color: Color(0xFFCCA236), size: 20),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  langService.isUrdu ? 'آج کی دعا' : 'Daily Dua',
                                  style: GoogleFonts.poppins(
                                    color: const Color(0xFFCCA236),
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  dailyDua.arabicText,
                                  style: GoogleFonts.amiri(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  textDirection: TextDirection.rtl,
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  dailyDua.title,
                                  style: GoogleFonts.poppins(
                                    color: Colors.white70,
                                    fontSize: 11,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(Icons.chevron_right, color: Colors.white38, size: 20),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 18),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    child: Text(
                      'Islamic Companion Features',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Feature Grid - FIXED: ensure all 12 items including last four are visible
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1.0,
                    children: [
                      _buildFeatureCard(
                        context,
                        title: 'Holy Quran',
                        subtitle: 'Surahs & Recitation',
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
                        subtitle: 'Streak & Rewards',
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
                        title: 'Namaz Times',
                        subtitle: 'Countdown & Alarms',
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
                        subtitle: 'Kaaba Direction',
                        icon: Icons.explore,
                        onTap: () {
                          setState(() {
                            _bottomNavIndex = 3; // Qibla tab
                          });
                        },
                      ),
                      _buildFeatureCard(
                        context,
                        title: 'Hadith',
                        subtitle: 'Prophetic Wisdom',
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
                        title: 'Qaza Tracker',
                        subtitle: 'Missed Prayers Log',
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
                        title: 'Zakat',
                        subtitle: '2.5% Nisab Calc',
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
                        title: 'Tasbeeh',
                        subtitle: 'Digital Counter',
                        icon: Icons.track_changes,
                        onTap: () {
                          setState(() {
                            _bottomNavIndex = 2; // Tasbeeh tab
                          });
                        },
                      ),
                      _buildFeatureCard(
                        context,
                        title: 'Masnoon Duas',
                        subtitle: 'Morning & Evening',
                        icon: Icons.menu_book,
                        onTap: () {
                          setState(() {
                            _bottomNavIndex = 4; // Duas tab
                          });
                        },
                      ),
                      _buildFeatureCard(
                        context,
                        title: '99 Names',
                        subtitle: 'Asma-ul-Husna',
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
                        title: '6 Kalimas',
                        subtitle: 'Pillars of Faith',
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
                        subtitle: 'Eid, Janazah',
                        icon: Icons.book,
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
                  // Extra bottom padding to ensure last four menu options are not cut by system nav or ad
                  SizedBox(height: MediaQuery.of(context).padding.bottom + 12),
                ],
              ),
            ),
          ),
            // Ad banner inside dashboard - above bottom nav
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
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isHighlight ? const Color(0xFF1E4A39) : const Color(0xFF163024),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isHighlight
                ? const Color(0xFFCCA236)
                : const Color(0xFFCCA236).withOpacity(0.15),
            width: isHighlight ? 1.5 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF082017),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: const Color(0xFFCCA236), size: 22),
            ),
            const SizedBox(height: 6),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 1),
                  Text(
                    subtitle,
                    style: GoogleFonts.poppins(
                      color: Colors.white60,
                      fontSize: 10,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
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
