import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import '../services/settings_service.dart';
import '../services/language_service.dart';
import '../services/prayer_service.dart';
import '../services/premium_service.dart';
import 'pro_upgrade_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  void _shareApp(LanguageService lang) {
    final text = lang.isUrdu
        ? 'نورِ قلب (Noor-e-Qalb) ڈاؤن لوڈ کریں: نماز، تسبیح، دعائیں اور 99 اسماء الحسنیٰ کی بہترین اسلامی ایپ!'
        : 'Download Noor-e-Qalb: The best Islamic companion app for Namaz timings, Tasbeeh counter, Duas, and 99 Names of Allah!';
    Share.share(text);
  }

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsService>(context);
    final lang = Provider.of<LanguageService>(context);
    final prayer = Provider.of<PrayerService>(context);
    final premium = Provider.of<PremiumService>(context);

    return Scaffold(
      backgroundColor: const Color(0xFF081B15),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F2C23),
        elevation: 0,
        title: Text(
          lang.isUrdu ? 'سیٹنگز اور ترجیحات' : 'Settings & Preferences',
          style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // LANGUAGE SECTION
          _buildSectionHeader(lang.isUrdu ? 'زبان / Language' : 'Language Selection'),
          _buildCard(
            child: ListTile(
              leading: const Icon(Icons.language, color: Color(0xFFD4AF37)),
              title: Text(
                lang.isUrdu ? 'اردو زبان (Urdu)' : 'English Language',
                style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600),
              ),
              subtitle: Text(
                lang.isUrdu ? 'ایپ مکمل طور پر اردو میں ہے' : 'App is displaying in English',
                style: GoogleFonts.poppins(color: Colors.white60, fontSize: 12),
              ),
              trailing: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFD4AF37),
                  foregroundColor: const Color(0xFF081B15),
                ),
                onPressed: () {
                  lang.setLanguage(!lang.isUrdu);
                },
                child: Text(
                  lang.isUrdu ? 'Switch to English' : 'اردو میں کریں',
                  style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 12),
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // APPEARANCE / THEMES SECTION
          _buildSectionHeader(lang.isUrdu ? 'رنگ اور تھیم (Appearance)' : 'App Theme & Color Palette'),
          _buildCard(
            child: Column(
              children: [
                _buildThemeRadio(
                  settings: settings,
                  lang: lang,
                  value: 'emerald',
                  titleUrdu: 'سبز اور سنہری (Emerald Gold - Default)',
                  titleEnglish: 'Emerald Gold (Default Islamic Theme)',
                  colorDemo: const Color(0xFF0F2C23),
                ),
                const Divider(color: Colors.white10),
                _buildThemeRadio(
                  settings: settings,
                  lang: lang,
                  value: 'amoled',
                  titleUrdu: 'رات کا سیاہ (AMOLED Night Black)',
                  titleEnglish: 'AMOLED Night Black (Battery Saver)',
                  colorDemo: Colors.black,
                ),
                const Divider(color: Colors.white10),
                _buildThemeRadio(
                  settings: settings,
                  lang: lang,
                  value: 'navy',
                  titleUrdu: 'شاہی نیلا اور گولڈ (Royal Navy & Gold)',
                  titleEnglish: 'Royal Navy & Gold Palette',
                  colorDemo: const Color(0xFF0A192F),
                ),
                const Divider(color: Colors.white10),
                _buildThemeRadio(
                  settings: settings,
                  lang: lang,
                  value: 'light',
                  titleUrdu: 'النور الأبيض (Light Theme - White & Gold)',
                  titleEnglish: 'Pure Light (White & Gold Islamic Mode)',
                  colorDemo: const Color(0xFFF4F7F6),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // NOTIFICATIONS & TASBEEH HAPTICS
          _buildSectionHeader(lang.isUrdu ? 'اذان اور اطلاعات (Notifications)' : 'Azan & Notifications'),
          _buildCard(
            child: Column(
              children: [
                SwitchListTile(
                  activeColor: const Color(0xFFD4AF37),
                  title: Text(
                    lang.isUrdu ? 'روزانہ نماز اور اعمال کی یاد دہانی' : 'Daily Namaz & Azkar Reminders',
                    style: GoogleFonts.poppins(color: Colors.white, fontSize: 14),
                  ),
                  subtitle: Text(
                    lang.isUrdu ? 'فجر اور مغرب کے وقت اطلاعات' : 'Receive notifications at Fajr & Maghrib',
                    style: GoogleFonts.poppins(color: Colors.white60, fontSize: 12),
                  ),
                  value: settings.dailyReminders,
                  onChanged: (val) => settings.setDailyReminders(val),
                ),
                const Divider(color: Colors.white10),
                SwitchListTile(
                  activeColor: const Color(0xFFD4AF37),
                  title: Text(
                    lang.isUrdu ? 'تسبیح وائبریشن (Haptic Feedback)' : 'Tasbeeh Haptic Vibration',
                    style: GoogleFonts.poppins(color: Colors.white, fontSize: 14),
                  ),
                  subtitle: Text(
                    lang.isUrdu ? 'تسبیح پر کلک کرتے وقت وائبریشن' : 'Vibrate on each count tap',
                    style: GoogleFonts.poppins(color: Colors.white60, fontSize: 12),
                  ),
                  value: settings.vibrationEnabled,
                  onChanged: (val) => settings.setVibration(val),
                ),
                const Divider(color: Colors.white10),
                ListTile(
                  leading: const Icon(Icons.mosque, color: Color(0xFFD4AF37)),
                  title: Text(
                    lang.isUrdu ? 'مؤذن اور اذان کی آواز منتخب کریں' : 'Select Adhan Audio Voice (Muezzin)',
                    style: GoogleFonts.poppins(color: Colors.white, fontSize: 14),
                  ),
                  subtitle: Text(
                    lang.isUrdu ? 'اذانِ مسجد نبوی (مدینہ منورہ)' : 'Masjid an-Nabawi Adhan (Medina)',
                    style: GoogleFonts.poppins(color: Colors.white60, fontSize: 12),
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios, color: Color(0xFFD4AF37), size: 16),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          lang.isUrdu
                              ? '🕌 مؤذنِ مسجد نبوی (مدینہ منورہ) کی آواز منتخب ہے'
                              : '🕌 Masjid an-Nabawi Adhan (Medina) selected',
                        ),
                        backgroundColor: const Color(0xFF0F2C23),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // PRAYER CALCULATION CONVENTIONS
          _buildSectionHeader(lang.isUrdu ? 'نماز کے حساب کا طریقہ' : 'Prayer Calculation Convention'),
          _buildCard(
            child: ListTile(
              leading: const Icon(Icons.access_time_filled, color: Color(0xFFD4AF37)),
              title: Text(
                lang.isUrdu ? 'عصر کا فقہی طریقہ' : 'Asr Calculation Method',
                style: GoogleFonts.poppins(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
              ),
              subtitle: Text(
                prayer.isHanafi
                    ? (lang.isUrdu ? 'حنفی طریقہ (2 سائے)' : 'Hanafi Method (2 Shadow Lengths)')
                    : (lang.isUrdu ? 'شافعی / مالکی طریقہ (1 سایہ)' : 'Shafi\'i Method (1 Shadow Length)'),
                style: GoogleFonts.poppins(color: Colors.white70, fontSize: 12),
              ),
              trailing: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF194C3D),
                  foregroundColor: const Color(0xFFD4AF37),
                ),
                onPressed: () {
                  prayer.setAsrMethod(!prayer.isHanafi);
                },
                child: Text(
                  prayer.isHanafi ? 'Hanafi' : 'Shafi\'i',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // PRO MEMBERSHIP / SUPPORT
          _buildSectionHeader(lang.isUrdu ? 'پرو ممبرشپ اور سپورٹ' : 'Pro Membership & Support'),
          _buildCard(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.workspace_premium, color: Color(0xFFD4AF37)),
                  title: Text(
                    premium.isProUser
                        ? (lang.isUrdu ? 'پرو ممبرشپ فعال ہے' : 'Pro Membership Active')
                        : (lang.isUrdu ? 'اشتہارات ہٹائیں (پرو ممبرشپ)' : 'Remove Ads (Pro Membership)'),
                    style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text(
                    premium.isProUser
                        ? (lang.isUrdu ? 'تمام اشتہارات ہٹائے جا چکے ہیں' : 'All ads permanently removed')
                        : (lang.isUrdu ? 'ایک بار کی ادائیگی سے تمام اشتہارات ہٹائیں' : 'One-time upgrade for lifetime ad-free experience'),
                    style: GoogleFonts.poppins(color: Colors.white60, fontSize: 12),
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios, color: Color(0xFFD4AF37), size: 16),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const ProUpgradeScreen()));
                  },
                ),
                const Divider(color: Colors.white10),
                ListTile(
                  leading: const Icon(Icons.share, color: Color(0xFFD4AF37)),
                  title: Text(
                    lang.isUrdu ? 'ایپ دوستوں سے شیئر کریں' : 'Share App with Friends',
                    style: GoogleFonts.poppins(color: Colors.white, fontSize: 14),
                  ),
                  onTap: () => _shareApp(lang),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // APP VERSION
          Center(
            child: Text(
              lang.isUrdu ? 'نورِ قلب ورژن 1.0.0 (Play Store Edition)' : 'Noor-e-Qalb v1.0.0 (Play Store Edition)',
              style: GoogleFonts.poppins(color: Colors.white38, fontSize: 12),
            ),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        title,
        style: GoogleFonts.poppins(
          color: const Color(0xFFD4AF37),
          fontSize: 12,
          fontWeight: FontWeight.w700,
          letterSpacing: 1,
        ),
      ),
    );
  }

  Widget _buildCard({required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF0F2C23),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFD4AF37).withOpacity(0.2)),
      ),
      child: child,
    );
  }

  Widget _buildThemeRadio({
    required SettingsService settings,
    required LanguageService lang,
    required String value,
    required String titleUrdu,
    required String titleEnglish,
    required Color colorDemo,
  }) {
    final isSelected = settings.themeStyle == value;
    return ListTile(
      leading: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          color: colorDemo,
          shape: BoxShape.circle,
          border: Border.all(color: const Color(0xFFD4AF37), width: 2),
        ),
      ),
      title: Text(
        lang.isUrdu ? titleUrdu : titleEnglish,
        style: GoogleFonts.poppins(
          color: isSelected ? const Color(0xFFD4AF37) : Colors.white,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          fontSize: 14,
        ),
      ),
      trailing: isSelected ? const Icon(Icons.check_circle, color: Color(0xFFD4AF37)) : null,
      onTap: () {
        settings.setThemeStyle(value);
      },
    );
  }
}
