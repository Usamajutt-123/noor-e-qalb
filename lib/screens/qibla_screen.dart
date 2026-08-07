import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../services/language_service.dart';

class QiblaScreen extends StatefulWidget {
  const QiblaScreen({super.key});

  @override
  State<QiblaScreen> createState() => _QiblaScreenState();
}

class _QiblaScreenState extends State<QiblaScreen> {
  final double _userLat = 32.5542;
  final double _userLng = 73.3134;

  double _simulatedHeading = 0.0;

  double _computeQiblaAngle(double lat, double lng) {
    const double kaabaLat = 21.4225;
    const double kaabaLng = 39.8262;
    final double dLng = (kaabaLng - lng) * (math.pi / 180);
    final double lat1 = lat * (math.pi / 180);
    final double lat2 = kaabaLat * (math.pi / 180);
    final double y = math.sin(dLng);
    final double x = math.cos(lat1) * math.tan(lat2) - math.sin(lat1) * math.cos(dLng);
    final double angle = math.atan2(y, x) * (180 / math.pi);
    return (angle + 360) % 360;
  }

  int _computeKaabaDistance(double lat, double lng) {
    const double R = 6371.0;
    final double dLat = (21.4225 - lat) * (math.pi / 180);
    final double dLng = (39.8262 - lng) * (math.pi / 180);
    final double a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(lat * (math.pi / 180)) * math.cos(21.4225 * (math.pi / 180)) *
        math.sin(dLng / 2) * math.sin(dLng / 2);
    final double c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    return (R * c).round();
  }

  String _getCardinal(double angle, bool isUrdu) {
    if (angle >= 240 && angle <= 280) return isUrdu ? "مغرب-جنوب مغرب" : "W-Southwest";
    if (angle >= 220 && angle < 240) return isUrdu ? "جنوب مغرب" : "Southwest";
    if (angle >= 280 && angle <= 310) return isUrdu ? "مغرب-شمال مغرب" : "W-Northwest";
    return isUrdu ? "${angle.round()}°" : "${angle.round()}°";
  }

  @override
  Widget build(BuildContext context) {
    final langService = Provider.of<LanguageService>(context);
    final bool isUrdu = langService.isUrdu;
    final double qiblaAngle = _computeQiblaAngle(_userLat, _userLng);
    final int distance = _computeKaabaDistance(_userLat, _userLng);
    final String cardinal = _getCardinal(qiblaAngle, isUrdu);

    final double diff = (qiblaAngle - _simulatedHeading + 360) % 360;
    final double shortestDiff = math.min(diff, 360 - diff);
    final bool isAligned = shortestDiff <= 6.0;

    return Scaffold(
      backgroundColor: const Color(0xFF081B15),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Text(
                isUrdu ? "قبلہ رخ کمپاس" : "Qibla Direction Compass",
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                isUrdu
                    ? "کعبہ مکرمہ کی درست سمت اور زاویہ"
                    : "Exact angle & distance to the Holy Kaaba",
                style: GoogleFonts.inter(
                  color: Colors.white70,
                  fontSize: 12,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
                decoration: BoxDecoration(
                  color: Colors.black26,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            isUrdu ? "قبلہ کی سمت:" : "Qibla Angle:",
                            style: const TextStyle(color: Colors.white70, fontSize: 11),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 4),
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              "${qiblaAngle.round()}° $cardinal",
                              style: const TextStyle(
                                color: Color(0xFFD4AF37),
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(width: 1, height: 30, color: Colors.white12),
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            isUrdu ? "مکہ سے فاصلہ:" : "Distance:",
                            style: const TextStyle(color: Colors.white70, fontSize: 11),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 4),
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              isUrdu ? "$distance کلومیٹر" : "$distance km",
                              style: const TextStyle(
                                color: Color(0xFFD4AF37),
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 22),
              // Visual Compass Dial
              LayoutBuilder(
                builder: (context, constraints) {
                  final double compassSize = constraints.maxWidth > 260 ? 240 : constraints.maxWidth * 0.7;
                  return Center(
                    child: SizedBox(
                      width: compassSize,
                      height: compassSize,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Transform.rotate(
                            angle: -_simulatedHeading * (math.pi / 180),
                            child: Container(
                              width: compassSize,
                              height: compassSize,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: const Color(0xFF0D2C22),
                                border: Border.all(
                                  color: isAligned ? const Color(0xFF4CAF50) : const Color(0xFFD4AF37),
                                  width: 3,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: isAligned
                                        ? Colors.green.withOpacity(0.4)
                                        : const Color(0xFFD4AF37).withOpacity(0.2),
                                    blurRadius: 24,
                                  ),
                                ],
                              ),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Positioned(top: 12, child: Text("N", style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold, fontSize: 14))),
                                  Positioned(right: 12, child: Text("E", style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold, fontSize: 12))),
                                  Positioned(bottom: 12, child: Text("S", style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold, fontSize: 12))),
                                  Positioned(left: 12, child: Text("W", style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold, fontSize: 12))),
                                  Transform.rotate(
                                    angle: qiblaAngle * (math.pi / 180),
                                    child: Align(
                                      alignment: Alignment.topCenter,
                                      child: Padding(
                                        padding: const EdgeInsets.only(top: 22),
                                        child: Text("🕋", style: TextStyle(fontSize: 28)),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            width: 14,
                            height: 14,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xFFD4AF37),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 22),
              // Status Badge
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
                decoration: BoxDecoration(
                  color: isAligned ? Colors.green.withOpacity(0.15) : const Color(0xFFD4AF37).withOpacity(0.12),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isAligned ? Colors.green : const Color(0xFFD4AF37),
                  ),
                ),
                child: Text(
                  isAligned
                      ? (isUrdu ? "✨ آپ قبلہ کی درست سمت میں ہیں" : "✨ You are facing the Holy Kaaba")
                      : (isUrdu ? "فون گھمائیں تاکہ کعبہ اوپر سیدھ میں آ جائے" : "Rotate phone until Kaaba icon points UP"),
                  style: GoogleFonts.inter(
                    color: isAligned ? Colors.greenAccent : Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 16),
              // Slider for Rotation Simulation
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    isUrdu ? "🔄 کمپاس ٹیسٹ:" : "🔄 Test Rotation:",
                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                  Text(
                    "${_simulatedHeading.round()}°",
                    style: const TextStyle(color: Color(0xFFD4AF37), fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Slider(
                value: _simulatedHeading,
                min: 0,
                max: 360,
                activeColor: const Color(0xFFD4AF37),
                onChanged: (val) {
                  setState(() {
                    _simulatedHeading = val;
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
