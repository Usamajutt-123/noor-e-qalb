import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../services/daily_task_service.dart';
import '../services/language_service.dart';
import '../services/prayer_service.dart';
import '../widgets/ad_banner_widget.dart';
import '../widgets/noor_ui.dart';
import '../theme/noor_theme.dart';
import 'assistant_screen.dart';
import 'duas_screen.dart';
import 'hadith_screen.dart';
import 'more_screen.dart';
import 'prayer_times_screen.dart';
import 'qibla_screen.dart';
import 'ramadan_screen.dart';
import 'settings_screen.dart';
import 'surahs_screen.dart';
import 'tasbeeh_screen.dart';
import 'zakat_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _bottomNavIndex = 0;

  @override
  Widget build(BuildContext context) {
    final pages = <Widget>[
      _buildDashboard(context),
      const SurahsScreen(),
      const QiblaScreen(),
      const DuasScreen(),
      const MoreScreen(),
    ];

    return Scaffold(
      backgroundColor: NoorColors.background,
      body: IndexedStack(index: _bottomNavIndex, children: pages),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _bottomNavIndex,
        onTap: (index) => setState(() => _bottomNavIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.menu_book_rounded), label: 'Quran'),
          BottomNavigationBarItem(icon: Icon(Icons.explore_rounded), label: 'Qibla'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite_outline_rounded), label: 'Duas'),
          BottomNavigationBarItem(icon: Icon(Icons.grid_view_rounded), label: 'More'),
        ],
      ),
    );
  }

  Widget _buildDashboard(BuildContext context) {
    final language = context.watch<LanguageService>();
    final prayerService = context.watch<PrayerService>();
    final taskService = context.watch<DailyTaskService>();
    final schedule = prayerService.getSchedule(DateTime.now());
    final completedPrayers = schedule.prayers.where((item) => item.isPassed).length.clamp(0, 5).toInt();
    final isUrdu = language.isUrdu;

    return SafeArea(
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 6),
              child: Row(
                children: [
                  const Icon(Icons.menu_rounded, color: NoorColors.textMuted, size: 22),
                  const SizedBox(width: 10),
                  const NoorLogo(size: 36, showLabel: true),
                  const Spacer(),
                  NoorIconButton(
                    icon: Icons.notifications_none_rounded,
                    tooltip: 'Notifications',
                    backgroundColor: NoorColors.panelSoft,
                    onPressed: () => _showMessage(context, 'Prayer reminders are on'),
                  ),
                  const SizedBox(width: 7),
                  NoorIconButton(
                    icon: Icons.settings_outlined,
                    tooltip: 'Settings',
                    backgroundColor: NoorColors.panelSoft,
                    onPressed: () => _push(context, const SettingsScreen()),
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 22),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isUrdu ? 'السلام علیکم' : 'Assalamu Alaikum',
                            style: GoogleFonts.poppins(color: NoorColors.text, fontSize: 19, fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            isUrdu ? 'اللہ آپ کے دن میں برکت دے' : 'May Allah bless your day',
                            style: GoogleFonts.poppins(color: NoorColors.textMuted, fontSize: 10),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 34,
                      height: 34,
                      decoration: const BoxDecoration(color: NoorColors.panelRaised, shape: BoxShape.circle),
                      child: const Icon(Icons.groups_rounded, color: NoorColors.goldBright, size: 18),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildPrayerTracker(
                  context,
                  completedPrayers: completedPrayers,
                  streak: taskService.streakCount,
                  nextPrayer: schedule.nextPrayer?.nameEnglish ?? 'Dhuhr',
                  onTap: () => _push(context, const PrayerTimesScreen()),
                ),
                const SizedBox(height: 12),
                _buildAyahCard(context),
                const SizedBox(height: 16),
                const NoorSectionTitle(title: 'Quick Access'),
                _buildQuickAccess(context),
                const SizedBox(height: 16),
                _buildContinueReading(context),
                const SizedBox(height: 12),
                const AdBannerWidget(),
                SizedBox(height: MediaQuery.of(context).padding.bottom + 10),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrayerTracker(
    BuildContext context, {
    required int completedPrayers,
    required int streak,
    required String nextPrayer,
    required VoidCallback onTap,
  }) {
    final progress = completedPrayers / 5;
    return NoorPanel(
      onTap: onTap,
      padding: const EdgeInsets.all(14),
      gradient: const LinearGradient(
        colors: [NoorColors.panelRaised, NoorColors.panel],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      border: Border.all(color: NoorColors.gold.withOpacity(0.52)),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.access_time_rounded, color: NoorColors.goldBright, size: 17),
              const SizedBox(width: 7),
              Expanded(child: Text('Prayer Tracker', style: GoogleFonts.poppins(color: NoorColors.text, fontSize: 12, fontWeight: FontWeight.w700))),
              Text('$completedPrayers / 5', style: GoogleFonts.poppins(color: NoorColors.goldBright, fontSize: 14, fontWeight: FontWeight.w700)),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(child: NoorProgressBar(value: progress)),
              const SizedBox(width: 12),
              Text('$streak day streak', style: GoogleFonts.poppins(color: NoorColors.textMuted, fontSize: 9)),
              const SizedBox(width: 4),
              const Text('🔥', style: TextStyle(fontSize: 11)),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(child: Text('Next prayer: $nextPrayer', style: GoogleFonts.poppins(color: NoorColors.textMuted, fontSize: 9))),
              const Icon(Icons.chevron_right_rounded, color: NoorColors.goldBright, size: 17),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAyahCard(BuildContext context) {
    return NoorPanel(
      padding: const EdgeInsets.fromLTRB(14, 12, 10, 10),
      color: NoorColors.panelSoft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(Icons.auto_awesome_rounded, color: NoorColors.goldBright, size: 14),
              const SizedBox(width: 6),
              Expanded(child: Text('Ayah of the Day', style: GoogleFonts.poppins(color: NoorColors.text, fontSize: 11, fontWeight: FontWeight.w700))),
              const Icon(Icons.more_horiz_rounded, color: NoorColors.textFaint, size: 17),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            'وَاذْكُرْ رَبَّكَ إِذَا نَسِيتَ',
            textAlign: TextAlign.center,
            style: GoogleFonts.amiri(color: NoorColors.goldBright, fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 5),
          Text(
            'And remember your Lord when you forget.',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(color: NoorColors.textMuted, fontSize: 10, fontStyle: FontStyle.italic),
          ),
          const SizedBox(height: 2),
          Text('(Surah Al-Kahf 18:24)', textAlign: TextAlign.center, style: GoogleFonts.poppins(color: NoorColors.gold, fontSize: 9)),
          const SizedBox(height: 9),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _smallAction(Icons.bookmark_border_rounded, 'Save', () => _showMessage(context, 'Ayah saved')),
              _smallAction(Icons.chat_bubble_outline_rounded, 'Reflect', () => _showMessage(context, 'Take a moment to reflect')),
              _smallAction(Icons.volume_up_outlined, 'Listen', () => _showMessage(context, 'Recitation will be available soon')),
              _smallAction(Icons.share_outlined, 'Share', () => _showMessage(context, 'Ayah ready to share')),
            ],
          ),
        ],
      ),
    );
  }

  Widget _smallAction(IconData icon, String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
        child: Icon(icon, color: NoorColors.textMuted, size: 16),
      ),
    );
  }

  Widget _buildQuickAccess(BuildContext context) {
    final items = <_QuickAccessItem>[
      _QuickAccessItem('Qibla', Icons.explore_outlined, () => setState(() => _bottomNavIndex = 2)),
      _QuickAccessItem('Quran', Icons.menu_book_outlined, () => setState(() => _bottomNavIndex = 1)),
      _QuickAccessItem('Duas', Icons.favorite_outline_rounded, () => setState(() => _bottomNavIndex = 3)),
      _QuickAccessItem('Tasbeeh', Icons.radio_button_checked_rounded, () => _push(context, const TasbeehScreen())),
      _QuickAccessItem('Hadith', Icons.auto_stories_outlined, () => _push(context, const HadithScreen())),
      _QuickAccessItem('Zakat', Icons.calculate_outlined, () => _push(context, const ZakatScreen())),
      _QuickAccessItem('Ramadan', Icons.nightlight_outlined, () => _push(context, const RamadanScreen())),
      _QuickAccessItem('AI Assistant', Icons.auto_awesome_outlined, () => _push(context, const AssistantScreen())),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 0.95,
      ),
      itemBuilder: (_, index) {
        final item = items[index];
        return InkWell(
          onTap: item.onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 8),
            decoration: BoxDecoration(
              color: NoorColors.panel,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: NoorColors.gold.withOpacity(0.22)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(item.icon, color: NoorColors.goldBright, size: 21),
                const SizedBox(height: 6),
                Text(item.label, textAlign: TextAlign.center, maxLines: 2, overflow: TextOverflow.ellipsis, style: GoogleFonts.poppins(color: NoorColors.textMuted, fontSize: 8.5, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildContinueReading(BuildContext context) {
    return NoorPanel(
      onTap: () => setState(() => _bottomNavIndex = 1),
      padding: const EdgeInsets.all(13),
      gradient: const LinearGradient(colors: [NoorColors.panelRaised, NoorColors.panelSoft]),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(color: NoorColors.background, borderRadius: BorderRadius.circular(12), border: Border.all(color: NoorColors.gold.withOpacity(0.25))),
            child: const Icon(Icons.menu_book_rounded, color: NoorColors.goldBright, size: 28),
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Continue Reading', style: GoogleFonts.poppins(color: NoorColors.text, fontSize: 11, fontWeight: FontWeight.w700)),
                const SizedBox(height: 5),
                Text('Surah Al-Baqarah', style: GoogleFonts.poppins(color: NoorColors.textMuted, fontSize: 10)),
                Text('Verse 125', style: GoogleFonts.poppins(color: NoorColors.gold, fontSize: 9)),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward_ios_rounded, color: NoorColors.goldBright, size: 14),
        ],
      ),
    );
  }

  void _push(BuildContext context, Widget screen) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
  }

  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }
}

class _QuickAccessItem {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const _QuickAccessItem(this.label, this.icon, this.onTap);
}
