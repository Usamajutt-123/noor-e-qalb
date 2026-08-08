import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../services/language_service.dart';
import '../theme/noor_theme.dart';
import '../widgets/noor_ui.dart';

class QiblaScreen extends StatefulWidget {
  const QiblaScreen({super.key});

  @override
  State<QiblaScreen> createState() => _QiblaScreenState();
}

class _QiblaScreenState extends State<QiblaScreen> {
  static const double _userLat = 32.5542;
  static const double _userLng = 73.3134;
  double _heading = 0;

  double _computeQiblaAngle(double lat, double lng) {
    const kaabaLat = 21.4225;
    const kaabaLng = 39.8262;
    final dLng = (kaabaLng - lng) * math.pi / 180;
    final lat1 = lat * math.pi / 180;
    final lat2 = kaabaLat * math.pi / 180;
    final y = math.sin(dLng);
    final x = math.cos(lat1) * math.tan(lat2) - math.sin(lat1) * math.cos(dLng);
    return (math.atan2(y, x) * 180 / math.pi + 360) % 360;
  }

  int _computeDistance(double lat, double lng) {
    const radius = 6371.0;
    final dLat = (21.4225 - lat) * math.pi / 180;
    final dLng = (39.8262 - lng) * math.pi / 180;
    final a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(lat * math.pi / 180) * math.cos(21.4225 * math.pi / 180) *
            math.sin(dLng / 2) * math.sin(dLng / 2);
    return (radius * 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a))).round();
  }

  String _cardinal(double angle) {
    const labels = ['N', 'NE', 'E', 'SE', 'S', 'SW', 'W', 'NW'];
    return labels[((angle + 22.5) ~/ 45) % 8];
  }

  @override
  Widget build(BuildContext context) {
    final isUrdu = context.watch<LanguageService>().isUrdu;
    final qiblaAngle = _computeQiblaAngle(_userLat, _userLng);
    final distance = _computeDistance(_userLat, _userLng);
    final difference = (qiblaAngle - _heading + 360) % 360;
    final aligned = math.min(difference, 360 - difference) < 6;

    return Scaffold(
      backgroundColor: NoorColors.background,
      appBar: NoorPageHeader(
        title: isUrdu ? 'قبلہ کمپاس' : 'Qibla Compass',
        actions: [NoorIconButton(icon: Icons.more_vert_rounded, onPressed: () {})],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 2, 16, 24),
          child: Column(
            children: [
              NoorPanel(
                padding: const EdgeInsets.fromLTRB(10, 7, 10, 7),
                color: NoorColors.panelSoft,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.location_on_outlined, color: NoorColors.goldBright, size: 14),
                    const SizedBox(width: 5),
                    Text('Mandi Bahauddin, Pakistan', style: GoogleFonts.poppins(color: NoorColors.textMuted, fontSize: 10)),
                    const SizedBox(width: 5),
                    const Icon(Icons.edit_outlined, color: NoorColors.gold, size: 13),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              SizedBox(
                width: 286,
                height: 286,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CustomPaint(
                      size: const Size.square(286),
                      painter: _CompassPainter(heading: _heading, qiblaAngle: qiblaAngle, aligned: aligned),
                    ),
                    Transform.rotate(
                      angle: qiblaAngle * math.pi / 180,
                      child: const Align(
                        alignment: Alignment.topCenter,
                        child: Padding(
                          padding: EdgeInsets.only(top: 28),
                          child: Icon(Icons.navigation_rounded, color: NoorColors.goldBright, size: 29),
                        ),
                      ),
                    ),
                    Container(
                      width: 74,
                      height: 74,
                      decoration: BoxDecoration(
                        color: NoorColors.background,
                        shape: BoxShape.circle,
                        border: Border.all(color: NoorColors.gold, width: 1.5),
                        boxShadow: const [BoxShadow(color: Color(0x553C2910), blurRadius: 18)],
                      ),
                      child: const Icon(Icons.mosque_rounded, color: NoorColors.goldBright, size: 39),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              NoorPanel(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                child: Row(
                  children: [
                    Expanded(child: _metric(isUrdu ? 'سمتِ قبلہ' : 'Direction', '${qiblaAngle.round()}° ${_cardinal(qiblaAngle)}')),
                    Container(width: 1, height: 36, color: NoorColors.gold.withOpacity(0.18)),
                    Expanded(child: _metric(isUrdu ? 'فاصلہ' : 'Distance', '$distance km')),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: () {
                  setState(() => _heading = (_heading + 5) % 360);
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Compass calibrated')));
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: NoorColors.goldBright,
                  side: const BorderSide(color: NoorColors.goldMuted),
                  padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 11),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
                ),
                child: Text(isUrdu ? 'کمپاس کیلیبریٹ کریں' : 'Calibrate Compass', style: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.w600)),
              ),
              const SizedBox(height: 22),
              const NoorSectionTitle(title: 'Nearby Mosques'),
              _mosqueTile('Jamia Masjid Bahauddin', '0.8 km'),
              _mosqueTile('Markazi Jamia Masjid', '1.4 km'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _metric(String label, String value) {
    return Column(
      children: [
        Text(label, style: GoogleFonts.poppins(color: NoorColors.textMuted, fontSize: 9)),
        const SizedBox(height: 3),
        Text(value, style: GoogleFonts.poppins(color: NoorColors.goldBright, fontSize: 15, fontWeight: FontWeight.w700)),
      ],
    );
  }

  Widget _mosqueTile(String name, String distance) {
    return NoorPanel(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      color: NoorColors.panelSoft,
      child: Row(
        children: [
          Container(width: 36, height: 36, decoration: BoxDecoration(color: NoorColors.background, borderRadius: BorderRadius.circular(10)), child: const Icon(Icons.mosque_outlined, color: NoorColors.goldBright, size: 20)),
          const SizedBox(width: 10),
          Expanded(child: Text(name, style: GoogleFonts.poppins(color: NoorColors.text, fontSize: 10, fontWeight: FontWeight.w600))),
          Text(distance, style: GoogleFonts.poppins(color: NoorColors.textMuted, fontSize: 9)),
          const SizedBox(width: 8),
          const Icon(Icons.location_on_outlined, color: NoorColors.goldBright, size: 16),
        ],
      ),
    );
  }
}

class _CompassPainter extends CustomPainter {
  final double heading;
  final double qiblaAngle;
  final bool aligned;

  const _CompassPainter({required this.heading, required this.qiblaAngle, required this.aligned});

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center;
    final radius = size.width / 2 - 6;
    final base = Paint()..style = PaintingStyle.stroke;
    base.color = NoorColors.gold.withOpacity(0.75);
    base.strokeWidth = 1.8;
    canvas.drawCircle(center, radius, base);
    base.color = NoorColors.gold.withOpacity(0.30);
    base.strokeWidth = 8;
    canvas.drawCircle(center, radius - 12, base);
    base.strokeWidth = 1;
    for (var i = 0; i < 36; i++) {
      final angle = i * math.pi * 2 / 36 - math.pi / 2;
      final inner = radius - (i % 3 == 0 ? 22 : 15);
      canvas.drawLine(
        Offset(center.dx + math.cos(angle) * inner, center.dy + math.sin(angle) * inner),
        Offset(center.dx + math.cos(angle) * (radius - 4), center.dy + math.sin(angle) * (radius - 4)),
        base,
      );
    }

    final pointerAngle = (qiblaAngle - heading) * math.pi / 180 - math.pi / 2;
    final pointer = Paint()..color = aligned ? NoorColors.success : NoorColors.goldBright;
    final tip = Offset(center.dx + math.cos(pointerAngle) * (radius - 30), center.dy + math.sin(pointerAngle) * (radius - 30));
    final left = Offset(center.dx + math.cos(pointerAngle + 2.7) * 18, center.dy + math.sin(pointerAngle + 2.7) * 18);
    final right = Offset(center.dx + math.cos(pointerAngle - 2.7) * 18, center.dy + math.sin(pointerAngle - 2.7) * 18);
    canvas.drawPath(Path()..moveTo(tip.dx, tip.dy)..lineTo(left.dx, left.dy)..lineTo(right.dx, right.dy)..close(), pointer);

    _drawLabel(canvas, center, 'N', 0, NoorColors.goldBright);
    _drawLabel(canvas, center, 'E', 90, NoorColors.textMuted);
    _drawLabel(canvas, center, 'S', 180, NoorColors.textMuted);
    _drawLabel(canvas, center, 'W', 270, NoorColors.textMuted);
  }

  void _drawLabel(Canvas canvas, Offset center, String label, double degrees, Color color) {
    final angle = (degrees - 90) * math.pi / 180;
    final offset = Offset(center.dx + math.cos(angle) * 105, center.dy + math.sin(angle) * 105);
    final painter = TextPainter(text: TextSpan(text: label, style: TextStyle(color: color, fontSize: 13, fontWeight: FontWeight.w700)), textDirection: TextDirection.ltr)..layout();
    painter.paint(canvas, offset - Offset(painter.width / 2, painter.height / 2));
  }

  @override
  bool shouldRepaint(covariant _CompassPainter oldDelegate) => oldDelegate.heading != heading || oldDelegate.qiblaAngle != qiblaAngle || oldDelegate.aligned != aligned;
}
