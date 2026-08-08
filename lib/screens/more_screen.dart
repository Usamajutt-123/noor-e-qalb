import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/noor_theme.dart';
import '../widgets/noor_ui.dart';
import 'assistant_screen.dart';
import 'daily_action_plan_screen.dart';
import 'daily_tasks_screen.dart';
import 'hadith_screen.dart';
import 'names_screen.dart';
import 'qaza_tracker_screen.dart';
import 'ramadan_screen.dart';
import 'settings_screen.dart';
import 'zakat_screen.dart';

class MoreScreen extends StatefulWidget {
  const MoreScreen({super.key});

  @override
  State<MoreScreen> createState() => _MoreScreenState();
}

class _MoreScreenState extends State<MoreScreen> {
  bool _downloadsEnabled = false;
  bool _offlineMode = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NoorColors.background,
      appBar: const NoorPageHeader(title: 'More', showBack: false),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 26),
        children: [
          NoorPanel(
            padding: const EdgeInsets.all(14),
            gradient: const LinearGradient(colors: [NoorColors.panelRaised, NoorColors.panel]),
            child: Row(
              children: [
                const NoorLogo(size: 44),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Noor-e-Qalb', style: GoogleFonts.poppins(color: NoorColors.text, fontSize: 15, fontWeight: FontWeight.w700)),
                      const SizedBox(height: 3),
                      Text('A calmer way to stay close to Allah', style: GoogleFonts.poppins(color: NoorColors.textMuted, fontSize: 10)),
                    ],
                  ),
                ),
                NoorPill(label: 'Free', icon: Icons.star_outline_rounded),
              ],
            ),
          ),
          const SizedBox(height: 18),
          const NoorSectionTitle(title: 'Tools & Learning'),
          _buildGroup([
            _MoreItem(Icons.track_changes_rounded, 'Prayer Tracker', 'Track today\'s five prayers', () => _push(const DailyTasksScreen())),
            _MoreItem(Icons.calendar_month_outlined, 'Islamic Calendar', 'Hijri dates and important days', () => _push(const RamadanScreen())),
            _MoreItem(Icons.auto_awesome_outlined, 'Daily Ayah & Hadith', 'A reminder for your heart', () => _push(const HadithScreen())),
            _MoreItem(Icons.volunteer_activism_outlined, 'Hisnul Muslim', 'Duas for everyday life', () => _push(const DailyActionPlanScreen())),
            _MoreItem(Icons.graphic_eq_rounded, 'Quran Recitation', 'Listen while you read', () => _push(const AssistantScreen())),
          ]),
          const SizedBox(height: 18),
          const NoorSectionTitle(title: 'Your Library'),
          _buildGroup([
            _MoreItem(Icons.download_outlined, 'Downloads', 'Keep selected content on device', null, switchValue: _downloadsEnabled, onSwitch: (value) => setState(() => _downloadsEnabled = value)),
            _MoreItem(Icons.wifi_off_rounded, 'Offline Mode', 'Use embedded content without internet', null, switchValue: _offlineMode, onSwitch: (value) => setState(() => _offlineMode = value)),
            _MoreItem(Icons.bookmark_outline_rounded, 'Saved Items', 'Your bookmarked duas and ayahs', () => _push(const NamesScreen())),
          ]),
          const SizedBox(height: 18),
          const NoorSectionTitle(title: 'App'),
          _buildGroup([
            _MoreItem(Icons.settings_outlined, 'Settings', 'Language, reminders and theme', () => _push(const SettingsScreen())),
            _MoreItem(Icons.support_agent_outlined, 'Support', 'We are here to help', () => _showMessage('Support centre coming soon')),
            _MoreItem(Icons.info_outline_rounded, 'About Noor-e-Qalb', 'Version 1.0.0', () => _showAbout()),
          ]),
          const SizedBox(height: 14),
          _buildSmallShortcuts(),
        ],
      ),
    );
  }

  Widget _buildGroup(List<_MoreItem> items) {
    return NoorPanel(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          for (var i = 0; i < items.length; i++) ...[
            _buildTile(items[i]),
            if (i != items.length - 1) const Divider(indent: 52, endIndent: 12),
          ],
        ],
      ),
    );
  }

  Widget _buildTile(_MoreItem item) {
    return InkWell(
      onTap: item.onTap,
      borderRadius: BorderRadius.circular(14),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
        child: Row(
          children: [
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(color: NoorColors.background, borderRadius: BorderRadius.circular(9)),
              child: Icon(item.icon, color: NoorColors.goldBright, size: 16),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.title, style: GoogleFonts.poppins(color: NoorColors.text, fontSize: 11, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 2),
                  Text(item.subtitle, style: GoogleFonts.poppins(color: NoorColors.textFaint, fontSize: 8.5)),
                ],
              ),
            ),
            if (item.onSwitch != null)
              Switch.adaptive(
                value: item.switchValue,
                onChanged: item.onSwitch,
                activeColor: NoorColors.goldBright,
                activeTrackColor: NoorColors.goldMuted,
              )
            else
              const Icon(Icons.chevron_right_rounded, color: NoorColors.gold, size: 18),
          ],
        ),
      ),
    );
  }

  Widget _buildSmallShortcuts() {
    return Row(
      children: [
        Expanded(child: _shortcut(Icons.calculate_outlined, 'Zakat', () => _push(const ZakatScreen()))),
        const SizedBox(width: 8),
        Expanded(child: _shortcut(Icons.history_edu_rounded, 'Qaza', () => _push(const QazaTrackerScreen()))),
        const SizedBox(width: 8),
        Expanded(child: _shortcut(Icons.favorite_outline_rounded, 'Names', () => _push(const NamesScreen()))),
      ],
    );
  }

  Widget _shortcut(IconData icon, String label, VoidCallback onTap) {
    return NoorPanel(
      padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 4),
      onTap: onTap,
      child: Column(
        children: [
          Icon(icon, color: NoorColors.goldBright, size: 18),
          const SizedBox(height: 5),
          Text(label, style: GoogleFonts.poppins(color: NoorColors.textMuted, fontSize: 9)),
        ],
      ),
    );
  }

  void _push(Widget page) => Navigator.push(context, MaterialPageRoute(builder: (_) => page));

  void _showMessage(String message) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));

  void _showAbout() {
    showAboutDialog(
      context: context,
      applicationName: 'Noor-e-Qalb',
      applicationVersion: '1.0.0',
      applicationIcon: const NoorLogo(size: 44),
      applicationLegalese: 'A mindful Islamic companion for every day.',
    );
  }
}

class _MoreItem {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;
  final bool switchValue;
  final ValueChanged<bool>? onSwitch;

  const _MoreItem(this.icon, this.title, this.subtitle, this.onTap, {this.switchValue = false, this.onSwitch});
}
