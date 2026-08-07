import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:vibration/vibration.dart';
import '../models/tasbeeh_model.dart';
import '../data/islamic_data.dart';
import '../services/admob_service.dart';
import '../services/premium_service.dart';
import '../widgets/ad_banner_widget.dart';

class TasbeehScreen extends StatefulWidget {
  const TasbeehScreen({super.key});

  @override
  State<TasbeehScreen> createState() => _TasbeehScreenState();
}

class _TasbeehScreenState extends State<TasbeehScreen> with SingleTickerProviderStateMixin {
  late TasbeehModel _selectedTasbeeh;
  bool _vibrationEnabled = true;
  late AnimationController _pulseController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _selectedTasbeeh = IslamicData.defaultTasbeehs.first;
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.93).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  void _onTapCount() async {
    _pulseController.forward().then((_) => _pulseController.reverse());

    if (_vibrationEnabled) {
      bool? hasVibrator = await Vibration.hasVibrator();
      if (hasVibrator == true) {
        Vibration.vibrate(duration: 40);
      } else {
        HapticFeedback.lightImpact();
      }
    }

    setState(() {
      _selectedTasbeeh.increment();
    });

    if (_selectedTasbeeh.currentCount == 0 && _selectedTasbeeh.completedLaps > 0) {
      _showLapCompletedDialog();
    }
  }

  void _showLapCompletedDialog() {
    final premiumService = Provider.of<PremiumService>(context, listen: false);
    
    // Trigger AdMob interstitial if not a Pro user
    AdMobService().showInterstitialAfterTasbeeh(premiumService);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF0F2C23),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            const Icon(Icons.stars, color: Color(0xFFD4AF37), size: 30),
            const SizedBox(width: 10),
            Text(
              'MashaAllah!',
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: Text(
          'Aapne "${_selectedTasbeeh.title}" ka ek dor (${_selectedTasbeeh.targetCount} martaba) mukammal kar liya hai!\n\nTotal completed laps: ${_selectedTasbeeh.completedLaps}',
          style: GoogleFonts.poppins(color: Colors.white70, fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(
              'JazakAllah Khair',
              style: GoogleFonts.poppins(
                color: const Color(0xFFD4AF37),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _resetCounter() {
    setState(() {
      _selectedTasbeeh.reset();
    });
  }

  void _showDhikrPickerModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF0F2C23),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Select Dhikr / Tasbeeh',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white60),
                    onPressed: () => Navigator.of(ctx).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  itemCount: IslamicData.defaultTasbeehs.length,
                  itemBuilder: (ctx, idx) {
                    final t = IslamicData.defaultTasbeehs[idx];
                    final isSelected = t.id == _selectedTasbeeh.id;

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedTasbeeh = t;
                        });
                        Navigator.of(ctx).pop();
                      },
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        decoration: BoxDecoration(
                          color: isSelected ? const Color(0xFF194C3D) : const Color(0xFF081B15),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: isSelected ? const Color(0xFFD4AF37) : Colors.white12,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  t.title,
                                  style: GoogleFonts.poppins(
                                    color: isSelected ? const Color(0xFFD4AF37) : Colors.white,
                                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                                    fontSize: 15,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Target: ${t.targetCount}x',
                                  style: GoogleFonts.poppins(
                                    color: Colors.white60,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              t.arabicText,
                              style: GoogleFonts.amiri(
                                color: Colors.white,
                                fontSize: 24,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final progress = _selectedTasbeeh.currentCount / _selectedTasbeeh.targetCount;

    return Scaffold(
      backgroundColor: const Color(0xFF081B15),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F2C23),
        elevation: 0,
        title: Text(
          'Digital Tasbeeh Counter',
          style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: Icon(
              _vibrationEnabled ? Icons.vibration : Icons.mobile_off,
              color: _vibrationEnabled ? const Color(0xFFD4AF37) : Colors.grey,
            ),
            tooltip: 'Toggle Vibration',
            onPressed: () {
              setState(() {
                _vibrationEnabled = !_vibrationEnabled;
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white70),
            tooltip: 'Reset Count',
            onPressed: _resetCounter,
          ),
        ],
      ),
      body: Column(
        children: [
          // CUSTOM DHIKR SELECTOR (Replaces ugly default dropdown)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            color: const Color(0xFF0F2C23),
            child: GestureDetector(
              onTap: () => _showDhikrPickerModal(context),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFF081B15),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFD4AF37).withOpacity(0.4)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.menu_book, color: Color(0xFFD4AF37), size: 20),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _selectedTasbeeh.title,
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              'Target: ${_selectedTasbeeh.targetCount}x',
                              style: GoogleFonts.poppins(
                                color: Colors.white60,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0F2C23),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.keyboard_arrow_down, color: Color(0xFFD4AF37), size: 20),
                    ),
                  ],
                ),
              ),
            ),
          ),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Arabic Display Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF13382D),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFFD4AF37).withOpacity(0.3)),
                    ),
                    child: Column(
                      children: [
                        Text(
                          _selectedTasbeeh.arabicText,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.amiri(
                            color: const Color(0xFFD4AF37),
                            fontSize: 34,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          _selectedTasbeeh.translation,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            color: Colors.white70,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const Spacer(),

                  // Giant Circular Counter Button with Progress Ring
                  GestureDetector(
                    onTap: _onTapCount,
                    child: ScaleTransition(
                      scale: _scaleAnimation,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          SizedBox(
                            width: 240,
                            height: 240,
                            child: CircularProgressIndicator(
                              value: progress,
                              strokeWidth: 10,
                              backgroundColor: const Color(0xFF13382D),
                              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFD4AF37)),
                            ),
                          ),
                          Container(
                            width: 210,
                            height: 210,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: const LinearGradient(
                                colors: [Color(0xFF194C3D), Color(0xFF0F2C23)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFFD4AF37).withOpacity(0.25),
                                  blurRadius: 20,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '${_selectedTasbeeh.currentCount}',
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontSize: 54,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  '/ ${_selectedTasbeeh.targetCount}',
                                  style: GoogleFonts.poppins(
                                    color: const Color(0xFFD4AF37),
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  'TAP TO COUNT',
                                  style: GoogleFonts.poppins(
                                    color: Colors.white38,
                                    fontSize: 11,
                                    letterSpacing: 2,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const Spacer(),

                  // Completed Laps Badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0F2C23),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: Colors.white12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.history, color: Color(0xFFD4AF37), size: 18),
                        const SizedBox(width: 8),
                        Text(
                          'Completed Laps: ${_selectedTasbeeh.completedLaps}',
                          style: GoogleFonts.poppins(color: Colors.white, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Google AdMob Banner at bottom for Free Users
          const AdBannerWidget(),
        ],
      ),
    );
  }
}
