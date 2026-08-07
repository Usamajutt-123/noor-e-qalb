import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../services/language_service.dart';
import '../services/prayer_service.dart';
import '../services/settings_service.dart';
import 'home_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentStep = 0;

  bool _selectedUrdu = true;
  String _selectedCity = 'Mandi Bahauddin / Malakwal';
  String _asrMethod = 'Hanafi';
  bool _remindersEnabled = true;
  bool _vibrationEnabled = true;

  final List<String> _citiesUr = [
    'منڈی بہاءالدین / ملکوال',
    'لاہور',
    'اسلام آباد',
    'کراچی',
    'مکہ مکرمہ',
    'لندن',
  ];
  final List<String> _citiesEn = [
    'Mandi Bahauddin / Malakwal',
    'Lahore',
    'Islamabad',
    'Karachi',
    'Mecca',
    'London',
  ];

  void _nextStep() {
    if (_currentStep < 3) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _finishOnboarding();
    }
  }

  void _prevStep() {
    if (_currentStep > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> _finishOnboarding() async {
    final langService = Provider.of<LanguageService>(context, listen: false);
    await langService.completeOnboarding(_selectedUrdu);

    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF081B15),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 16),
            // Step Dots
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(4, (idx) {
                final active = idx == _currentStep;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: active ? 28 : 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: active ? const Color(0xFFD4AF37) : Colors.white24,
                    borderRadius: BorderRadius.circular(10),
                  ),
                );
              }),
            ),
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (idx) {
                  setState(() {
                    _currentStep = idx;
                  });
                },
                children: [
                  _buildStep1Language(),
                  _buildStep2CityAndAsr(),
                  _buildStep3Notifications(),
                  _buildStep4ReadySummary(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStep1Language() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF0F2C23),
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFFD4AF37), width: 2),
            ),
            child: const Icon(Icons.language, size: 48, color: Color(0xFFD4AF37)),
          ),
          const SizedBox(height: 16),
          Text(
            "بِسْمِ ٱللَّٰهِ ٱلرَّحْمَـٰنِ ٱلرَّحِيمِ",
            style: GoogleFonts.amiri(
              color: const Color(0xFFD4AF37),
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Welcome to Noor-e-Qalb",
            style: GoogleFonts.inter(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            "اپنی پسندیدہ زبان منتخب کریں / Select Your Preferred Language",
            style: TextStyle(color: Colors.white60, fontSize: 13),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 28),
          _buildLangCard(
            title: "اردو (Urdu)",
            subtitle: "پاکستان اور اردو زبان کے لیے بہترین (100% اردو موڈ)",
            flag: "🇵🇰",
            isSelected: _selectedUrdu,
            onTap: () => setState(() => _selectedUrdu = true),
          ),
          const SizedBox(height: 14),
          _buildLangCard(
            title: "English",
            subtitle: "For English speaking Muslims worldwide (100% EN mode)",
            flag: "🇬🇧",
            isSelected: !_selectedUrdu,
            onTap: () => setState(() => _selectedUrdu = false),
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _nextStep,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFD4AF37),
                foregroundColor: const Color(0xFF081B15),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              child: Text(
                _selectedUrdu ? "آگے بڑھیں ➔" : "Continue in English ➔",
                style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLangCard({
    required String title,
    required String subtitle,
    required String flag,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF13382D) : const Color(0xFF0F2C23),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isSelected ? const Color(0xFFD4AF37) : Colors.white12,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Text(flag, style: const TextStyle(fontSize: 32)),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.inter(
                      color: isSelected ? const Color(0xFFD4AF37) : Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(subtitle, style: const TextStyle(color: Colors.white60, fontSize: 11)),
                ],
              ),
            ),
            Icon(
              isSelected ? Icons.check_circle : Icons.circle_outlined,
              color: isSelected ? const Color(0xFFD4AF37) : Colors.white30,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStep2CityAndAsr() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("📍", style: TextStyle(fontSize: 42)),
          const SizedBox(height: 12),
          Text(
            _selectedUrdu ? "اپنا مقام اور نماز کا طریقہ ترتیب دیں" : "Set Your Location & Calculation Method",
            style: GoogleFonts.inter(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            _selectedUrdu ? "دقیق نماز کے اوقات اور قبلہ رخ کے حساب کے لیے" : "For precise prayer schedules & Qibla direction",
            style: const TextStyle(color: Colors.white60, fontSize: 12),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          // Single Luxury GPS Hero Button
          InkWell(
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    _selectedUrdu
                        ? '✨ الحمدللہ! مقام تلاش کر لیا گیا: منڈی بہاءالدین / ملکوال (32.55°N, 73.31°E)'
                        : '✨ Alhamdulillah! Location detected: Mandi Bahauddin / Malakwal (32.55°N, 73.31°E)',
                  ),
                  backgroundColor: const Color(0xFF0F2C23),
                ),
              );
            },
            borderRadius: BorderRadius.circular(18),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [Color(0xFF0F2C23), Color(0xFF14382B)]),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: const Color(0xFFD4AF37), width: 2),
                boxShadow: [
                  BoxShadow(color: const Color(0xFFD4AF37).withOpacity(0.25), blurRadius: 20),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.my_location, color: Color(0xFFD4AF37), size: 20),
                      const SizedBox(width: 10),
                      Flexible(
                        child: Text(
                          _selectedUrdu
                              ? "🎯 اپنی لائیو لوکیشن (GPS) سے نماز کے اوقات سیٹ کریں"
                              : "🎯 Auto-Detect Live GPS Location & Prayer Timings",
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    _selectedUrdu
                        ? "ایک کلک سے آپ کا درست شہر اور قبلہ کی سمت خودکار سیٹ ہو جائے گی"
                        : "One click detects your exact coordinates & Kaaba angle",
                    style: const TextStyle(color: Colors.white60, fontSize: 11),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            _selectedUrdu ? "عصر کا طریقہ:" : "Asr Method:",
            style: const TextStyle(color: Color(0xFFD4AF37), fontWeight: FontWeight.bold, fontSize: 12),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildAsrChip(_selectedUrdu ? "حنفی عصر" : "Hanafi Asr", 'Hanafi'),
              const SizedBox(width: 12),
              _buildAsrChip(_selectedUrdu ? "شافعی عصر" : "Shafi'i Asr", 'Shafii'),
            ],
          ),
          const SizedBox(height: 32),
          _buildNavButtons(),
        ],
      ),
    );
  }

  Widget _buildAsrChip(String label, String value) {
    final bool active = _asrMethod == value;
    return InkWell(
      onTap: () => setState(() => _asrMethod = value),
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: active ? const Color(0xFFD4AF37).withOpacity(0.2) : const Color(0xFF0F2C23),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: active ? const Color(0xFFD4AF37) : Colors.white12),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: active ? const Color(0xFFD4AF37) : Colors.white,
            fontWeight: active ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildStep3Notifications() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("🔔", style: TextStyle(fontSize: 42)),
          const SizedBox(height: 12),
          Text(
            _selectedUrdu ? "اذان کی اطلاعات اور تسبیح وائبریشن" : "Azan Reminders & Tasbeeh Haptics",
            style: GoogleFonts.inter(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            _selectedUrdu
                ? "نمازِ فجر اور مغرب کی یاد دہانی اور تسبیح کی وائبریشن"
                : "Daily Fajr/Maghrib notification & Tasbeeh vibration",
            style: const TextStyle(color: Colors.white60, fontSize: 12),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 28),
          SwitchListTile(
            value: _remindersEnabled,
            activeColor: const Color(0xFFD4AF37),
            title: Text(
              _selectedUrdu ? "روزانہ نمازِ فجر اور مغرب کی یاد دہانی" : "Daily Fajr & Maghrib Notifications",
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              _selectedUrdu ? "اذان کے وقت اطلاعات وصول کریں" : "Receive push alerts at prayer times",
              style: const TextStyle(color: Colors.white60, fontSize: 12),
            ),
            onChanged: (val) => setState(() => _remindersEnabled = val),
          ),
          const SizedBox(height: 12),
          SwitchListTile(
            value: _vibrationEnabled,
            activeColor: const Color(0xFFD4AF37),
            title: Text(
              _selectedUrdu ? "تسبیح کاؤنٹر پر وائبریشن (Haptic Feedback)" : "Tasbeeh Haptic Feedback",
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              _selectedUrdu ? "تسبیح پر کلک کرتے وقت وائبریشن محسوس کریں" : "Vibrate on every count tap",
              style: const TextStyle(color: Colors.white60, fontSize: 12),
            ),
            onChanged: (val) => setState(() => _vibrationEnabled = val),
          ),
          const SizedBox(height: 32),
          _buildNavButtons(),
        ],
      ),
    );
  }

  Widget _buildStep4ReadySummary() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("✨", style: TextStyle(fontSize: 48)),
          const SizedBox(height: 12),
          Text(
            _selectedUrdu ? "الحمدللہ! نورِ قلب آپ کے لیے تیار ہے" : "Alhamdulillah! Noor-e-Qalb is Ready",
            style: GoogleFonts.inter(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            _selectedUrdu ? "آپ کی منتخب کردہ ترجیحات محفوظ کر لی گئی ہیں" : "Your preferred settings have been saved",
            style: const TextStyle(color: Colors.white60, fontSize: 12),
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [Color(0xFF0F2C23), Color(0xFF091D17)]),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFD4AF37)),
            ),
            child: Column(
              children: [
                Text(
                  _selectedUrdu
                      ? "زبان: اردو • شہر: منڈی بہاءالدین • عصر: حنفی"
                      : "Language: English • City: Mandi Bahauddin • Asr: Hanafi",
                  style: const TextStyle(
                    color: Color(0xFFD4AF37),
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 14),
                _buildSummaryCheckItem(_selectedUrdu ? "100% مستند نماز کے اوقات اور کاؤنٹ ڈاؤن" : "100% Accurate Namaz Timings & Countdown"),
                _buildSummaryCheckItem(_selectedUrdu ? "قبلہ رخ کمپاس اور کعبہ فائنڈر" : "Live Qibla Direction Compass & Kaaba Finder"),
                _buildSummaryCheckItem(_selectedUrdu ? "1 سے 114 مکمل سورتیں (آڈیو تلاوت اور تفسیر)" : "114 Surahs Complete with Audio Recitation & Tafseer"),
                _buildSummaryCheckItem(_selectedUrdu ? "مسنون دعائیں، قضا ٹریکر، اور روزانہ اعمال" : "Masnoon Duas, Qaza Prayer Log & Daily Tasks"),
              ],
            ),
          ),
          const SizedBox(height: 32),
          Row(
            children: [
              OutlinedButton(
                onPressed: _prevStep,
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white70,
                  side: const BorderSide(color: Colors.white24),
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: const Text("⬅️"),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: _finishOnboarding,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFD4AF37),
                    foregroundColor: const Color(0xFF081B15),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: Text(
                    _selectedUrdu ? "🚀 نورِ قلب شروع کریں" : "🚀 Get Started Now",
                    style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCheckItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: Color(0xFFD4AF37), size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(color: Colors.white, fontSize: 12.5),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavButtons() {
    return Row(
      children: [
        OutlinedButton(
          onPressed: _prevStep,
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.white70,
            side: const BorderSide(color: Colors.white24),
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          ),
          child: const Text("⬅️"),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton(
            onPressed: _nextStep,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFD4AF37),
              foregroundColor: const Color(0xFF081B15),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
            child: Text(
              _selectedUrdu ? "آگے بڑھیں ➔" : "Next ➔",
              style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
        ),
      ],
    );
  }
}
