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
    AdMobService().showInterstitialAfterTasbeeh(premiumService);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF0F2C23),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            const Icon(Icons.stars, color: Color(0xFFD4AF37), size: 28),
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
                  Expanded(
                    child: Text(
                      'Select Dhikr / Tasbeeh',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white60),
                    onPressed: () => Navigator.of(ctx).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
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
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        decoration: BoxDecoration(
                          color: isSelected ? const Color(0xFF194C3D) : const Color(0xFF081B15),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: isSelected ? const Color(0xFFD4AF37) : Colors.white12,
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    t.title,
                                    style: GoogleFonts.poppins(
                                      color: isSelected ? const Color(0xFFD4AF37) : Colors.white,
                                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                                      fontSize: 14,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Target: ${t.targetCount}x',
                                    style: GoogleFonts.poppins(
                                      color: Colors.white60,
                                      fontSize: 11,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              t.arabicText,
                              style: GoogleFonts.amiri(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
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
          'Digital Tasbeeh',
          style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 16),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: Icon(
              _vibrationEnabled ? Icons.vibration : Icons.mobile_off,
              color: _vibrationEnabled ? const Color(0xFFD4AF37) : Colors.grey,
              size: 20,
            ),
            tooltip: 'Toggle Vibration',
            onPressed: () {
              setState(() {
                _vibrationEnabled = !_vibrationEnabled;
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white70, size: 20),
            tooltip: 'Reset Count',
            onPressed: _resetCounter,
          ),
        ],
      ),
      body: Column(
        children: [
          // CUSTOM DHIKR SELECTOR
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            color: const Color(0xFF0F2C23),
            child: GestureDetector(
              onTap: () => _showDhikrPickerModal(context),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFF081B15),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFD4AF37).withOpacity(0.4)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.menu_book, color: Color(0xFFD4AF37), size: 18),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _selectedTasbeeh.title,
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            'Target: ${_selectedTasbeeh.targetCount}x',
                            style: GoogleFonts.poppins(
                              color: Colors.white60,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0F2C23),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.keyboard_arrow_down, color: Color(0xFFD4AF37), size: 18),
                    ),
                  ],
                ),
              ),
            ),
          ),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Arabic Display Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 14),
                    decoration: BoxDecoration(
                      color: const Color(0xFF13382D),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: const Color(0xFFD4AF37).withOpacity(0.3)),
                    ),
                    child: Column(
                      children: [
                        Text(
                          _selectedTasbeeh.arabicText,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.amiri(
                            color: const Color(0xFFD4AF37),
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _selectedTasbeeh.translation,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const Spacer(),

                  // Giant Circular Counter Button with Progress Ring
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final double size = constraints.maxWidth > 240 ? 220 : constraints.maxWidth * 0.7;
                      return GestureDetector(
                        onTap: _onTapCount,
                        child: ScaleTransition(
                          scale: _scaleAnimation,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              SizedBox(
                                width: size,
                                height: size,
                                child: CircularProgressIndicator(
                                  value: progress,
                                  strokeWidth: 8,
                                  backgroundColor: const Color(0xFF13382D),
                                  valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFD4AF37)),
                                ),
                              ),
                              Container(
                                width: size - 24,
                                height: size - 24,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: const LinearGradient(
                                    colors: [Color(0xFF194C3D), Color(0xFF0F2C23)],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFFD4AF37).withOpacity(0.2),
                                      blurRadius: 16,
                                      spreadRadius: 1,
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
                                        fontSize: 46,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      '/ ${_selectedTasbeeh.targetCount}',
                                      style: GoogleFonts.poppins(
                                        color: const Color(0xFFD4AF37),
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'TAP TO COUNT',
                                      style: GoogleFonts.poppins(
                                        color: Colors.white38,
                                        fontSize: 10,
                                        letterSpacing: 2,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),

                  const Spacer(),

                  // Completed Laps Badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0F2C23),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: Colors.white12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.history, color: Color(0xFFD4AF37), size: 16),
                        const SizedBox(width: 8),
                        Text(
                          'Completed Laps: ${_selectedTasbeeh.completedLaps}',
                          style: GoogleFonts.poppins(color: Colors.white, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          const AdBannerWidget(),
        ],
      ),
    );
  }
}
