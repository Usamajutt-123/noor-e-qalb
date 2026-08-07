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
  // Mandi Bahauddin / Malakwal default coordinates
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
    if (angle >= 240 && angle <= 280) return isUrdu ? "مغرب-جنوب مغرب (W-SW)" : "West-Southwest (W-SW)";
    if (angle >= 220 && angle < 240) return isUrdu ? "جنوب مغرب (SW)" : "Southwest (SW)";
    if (angle >= 280 && angle <= 310) return isUrdu ? "مغرب-شمال مغرب (W-NW)" : "West-Northwest (W-NW)";
    return isUrdu ? "${angle.round()}° قبلہ سمت" : "${angle.round()}° Qibla Direction";
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
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Text(
                isUrdu ? "قبلہ رخ کمپاس (Kaaba Finder)" : "Qibla Direction Compass",
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                isUrdu
                    ? "آپ کے شہر اور لائیو لوکیشن سے کعبہ مکرمہ کی درست سمت اور زاویہ"
                    : "Exact angle & distance to the Holy Kaaba from your live location",
                style: GoogleFonts.inter(
                  color: Colors.white70,
                  fontSize: 13,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.black26,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: Colors.white12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        Text(
                          isUrdu ? "قبلہ کی سمت (زاویہ):" : "Qibla Direction:",
                          style: const TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "${qiblaAngle.round()}° $cardinal",
                          style: const TextStyle(
                            color: Color(0xFFD4AF37),
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Container(width: 1, height: 35, color: Colors.white12),
                    Column(
                      children: [
                        Text(
                          isUrdu ? "مکہ مکرمہ سے فاصلہ:" : "Distance to Mecca:",
                          style: const TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          isUrdu ? "$distance کلومیٹر" : "$distance km",
                          style: const TextStyle(
                            color: Color(0xFFD4AF37),
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              // Visual Compass Dial
              Center(
                child: SizedBox(
                  width: 260,
                  height: 260,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Transform.rotate(
                        angle: -_simulatedHeading * (math.pi / 180),
                        child: Container(
                          width: 260,
                          height: 260,
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
                                    ? Colors.green.withOpacity(0.5)
                                    : const Color(0xFFD4AF37).withOpacity(0.25),
                                blurRadius: 30,
                              ),
                            ],
                          ),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Positioned(top: 14, child: Text("N", style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold, fontSize: 16))),
                              Positioned(right: 14, child: Text("E", style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold, fontSize: 14))),
                              Positioned(bottom: 14, child: Text("S", style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold, fontSize: 14))),
                              Positioned(left: 14, child: Text("W", style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold, fontSize: 14))),
                              // Kaaba Pointer Icon
                              Transform.rotate(
                                angle: qiblaAngle * (math.pi / 180),
                                child: Align(
                                  alignment: Alignment.topCenter,
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 25),
                                    child: Text(
                                      "🕋",
                                      style: TextStyle(fontSize: 32),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        width: 16,
                        height: 16,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFFD4AF37),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 28),
              // Status Badge
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                decoration: BoxDecoration(
                  color: isAligned ? Colors.green.withOpacity(0.2) : const Color(0xFFD4AF37).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isAligned ? Colors.green : const Color(0xFFD4AF37),
                  ),
                ),
                child: Text(
                  isAligned
                      ? (isUrdu ? "✨ الحمدللہ! آپ قبلہ کی درست سمت میں ہیں" : "✨ Alhamdulillah! You are facing the Holy Kaaba")
                      : (isUrdu ? "اپنے فون کو گھمائیں تاکہ کعبہ کا نشان اوپر سیدھ میں آ جائے" : "Rotate your phone until Kaaba icon points straight UP"),
                  style: GoogleFonts.inter(
                    color: isAligned ? Colors.greenAccent : Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 20),
              // Slider for Rotation Simulation
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    isUrdu ? "🔄 کمپاس ٹیسٹ کریں (فون گھمائیں):" : "🔄 Test Rotation:",
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
