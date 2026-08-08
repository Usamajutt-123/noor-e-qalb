import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../services/language_service.dart';
import 'onboarding_screen.dart';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Route to Home (if onboarding done) or Onboarding after a short branded delay
    Future.delayed(const Duration(seconds: 3), () {
      if (!mounted) return;
      final lang = Provider.of<LanguageService>(context, listen: false);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) =>
              lang.isOnboardingCompleted ? const HomeScreen() : const OnboardingScreen(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF082017),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF082017), Color(0xFF0A201A)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Gold crescent ring (brand mark)
              Container(
                width: 112,
                height: 112,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Color(0xFFCCA236), width: 2.5),
                  color: const Color(0xFF0F2A20),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xFFCCA236).withOpacity(0.25),
                      blurRadius: 24,
                    ),
                  ],
                ),
                child: const Center(
                  child: Text('🌙', style: TextStyle(fontSize: 56)),
                ),
              ),
              const SizedBox(height: 26),
              Text(
                'بِسْمِ ٱللَّٰهِ ٱلرَّحْمَـٰنِ ٱلرَّحِيمِ',
                style: GoogleFonts.amiri(
                  color: Color(0xFFCCA236),
                  fontSize: 18,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 14),
              Text(
                'نورِ قلب',
                style: GoogleFonts.amiri(
                  color: Colors.white,
                  fontSize: 42,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Noor-e-Qalb',
                style: GoogleFonts.poppins(
                  color: Color(0xFFCCA236),
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Islamic Companion',
                style: GoogleFonts.poppins(
                  color: Colors.white60,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 42),
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFCCA236)),
              ),
              const SizedBox(height: 12),
              Text(
                'Loading...',
                style: GoogleFonts.poppins(
                  color: Colors.white38,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
