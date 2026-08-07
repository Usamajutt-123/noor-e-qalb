import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'services/admob_service.dart';
import 'services/premium_service.dart';
import 'services/prayer_service.dart';
import 'services/daily_task_service.dart';
import 'services/language_service.dart';
import 'services/settings_service.dart';
import 'screens/home_screen.dart';
import 'screens/onboarding_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Google AdMob SDK
  await AdMobService().initialize();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PremiumService()),
        ChangeNotifierProvider(create: (_) => PrayerService()),
        ChangeNotifierProvider(create: (_) => DailyTaskService()),
        ChangeNotifierProvider(create: (_) => LanguageService()),
        ChangeNotifierProvider(create: (_) => SettingsService()),
      ],
      child: const NoorEQalbApp(),
    ),
  );
}

class NoorEQalbApp extends StatelessWidget {
  const NoorEQalbApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageService>(
      builder: (context, langService, child) {
        return MaterialApp(
          title: langService.isUrdu ? 'نورِ قلب - اسلامی ساتھی' : 'Noor-e-Qalb - Islamic Companion',
          debugShowCheckedModeBanner: false,
          themeMode: ThemeMode.dark,
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            scaffoldBackgroundColor: const Color(0xFF081B15),
            primaryColor: const Color(0xFF0F2C23),
            colorScheme: const ColorScheme.dark(
              primary: Color(0xFFD4AF37),
              secondary: Color(0xFF13382D),
              surface: Color(0xFF0F2C23),
            ),
            textTheme: GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme),
          ),
          home: langService.isOnboardingCompleted ? const HomeScreen() : const OnboardingScreen(),
        );
      },
    );
  }
}
