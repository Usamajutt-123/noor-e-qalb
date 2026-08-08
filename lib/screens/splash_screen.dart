import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../services/language_service.dart';
import '../theme/noor_theme.dart';
import 'home_screen.dart';
import 'onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fade;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 900));
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _scale = Tween<double>(begin: 0.82, end: 1).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));
    _controller.forward();
    Future.delayed(const Duration(milliseconds: 2200), _continue);
  }

  void _continue() {
    if (!mounted) return;
    final language = context.read<LanguageService>();
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => language.isOnboardingCompleted ? const HomeScreen() : const OnboardingScreen()));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NoorColors.background,
      body: Stack(
        children: [
          Positioned(top: -100, right: -80, child: _glow(260, NoorColors.panelRaised.withOpacity(0.30))),
          Positioned(bottom: -120, left: -100, child: _glow(300, NoorColors.panel.withOpacity(0.38))),
          SafeArea(
            child: Center(
              child: FadeTransition(
                opacity: _fade,
                child: ScaleTransition(
                  scale: _scale,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 142,
                        height: 142,
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: NoorColors.panel,
                          border: Border.all(color: NoorColors.gold, width: 1.2),
                          boxShadow: const [BoxShadow(color: Color(0x4DD7AA3A), blurRadius: 32, spreadRadius: 2)],
                        ),
                        child: ClipOval(child: Image.asset('assets/app_icon.png', fit: BoxFit.cover)),
                      ),
                      const SizedBox(height: 25),
                      Text('بِسْمِ ٱللَّٰهِ ٱلرَّحْمَـٰنِ ٱلرَّحِيمِ', style: GoogleFonts.amiri(color: NoorColors.goldBright, fontSize: 17)),
                      const SizedBox(height: 13),
                      Text('نورِ قلب', style: GoogleFonts.amiri(color: NoorColors.text, fontSize: 38, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 1),
                      Text('Noor-e-Qalb', style: GoogleFonts.poppins(color: NoorColors.goldBright, fontSize: 19, fontWeight: FontWeight.w600, letterSpacing: 1.2)),
                      const SizedBox(height: 5),
                      Text('NAMAZ  •  QURAN  •  DAILY GUIDANCE', style: GoogleFonts.poppins(color: NoorColors.textMuted, fontSize: 8, letterSpacing: 1.4)),
                      const SizedBox(height: 44),
                      const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation<Color>(NoorColors.goldBright))),
                      const SizedBox(height: 11),
                      Text('Your peaceful companion', style: GoogleFonts.poppins(color: NoorColors.textFaint, fontSize: 9)),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _glow(double size, Color color) {
    return Container(width: size, height: size, decoration: BoxDecoration(shape: BoxShape.circle, color: color, boxShadow: [BoxShadow(color: color, blurRadius: 80, spreadRadius: 15)]));
  }
}
