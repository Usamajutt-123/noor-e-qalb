import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../data/islamic_data.dart';
import '../models/tasbeeh_model.dart';
import '../theme/noor_theme.dart';
import '../widgets/noor_ui.dart';

class TasbeehScreen extends StatefulWidget {
  const TasbeehScreen({super.key});

  @override
  State<TasbeehScreen> createState() => _TasbeehScreenState();
}

class _TasbeehScreenState extends State<TasbeehScreen> {
  late TasbeehModel _selectedTasbeeh;
  bool _history = false;
  int _todayCount = 165;
  final List<int> _historyCounts = [165, 218, 97, 305, 142];

  @override
  void initState() {
    super.initState();
    _selectedTasbeeh = IslamicData.defaultTasbeehs.first;
  }

  void _count() {
    HapticFeedback.lightImpact();
    setState(() {
      _selectedTasbeeh.increment();
      _todayCount++;
    });
  }

  void _reset() => setState(_selectedTasbeeh.reset);

  void _pickTasbeeh() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: NoorColors.panel,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(22))),
      builder: (sheetContext) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(child: Text('Choose Dhikr', style: GoogleFonts.poppins(color: NoorColors.text, fontSize: 14, fontWeight: FontWeight.w700))),
                  NoorIconButton(icon: Icons.close_rounded, onPressed: () => Navigator.pop(sheetContext)),
                ],
              ),
              const SizedBox(height: 8),
              ...IslamicData.defaultTasbeehs.map((tasbeeh) {
                final selected = tasbeeh.id == _selectedTasbeeh.id;
                return NoorPanel(
                  margin: const EdgeInsets.only(bottom: 7),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  color: selected ? NoorColors.panelRaised : NoorColors.background,
                  border: Border.all(color: selected ? NoorColors.gold : NoorColors.gold.withOpacity(0.18)),
                  onTap: () {
                    setState(() => _selectedTasbeeh = tasbeeh);
                    Navigator.pop(sheetContext);
                  },
                  child: Row(
                    children: [
                      Expanded(child: Text(tasbeeh.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: GoogleFonts.poppins(color: selected ? NoorColors.goldBright : NoorColors.text, fontSize: 10, fontWeight: FontWeight.w600))),
                      Text('${tasbeeh.targetCount}x', style: GoogleFonts.poppins(color: NoorColors.textMuted, fontSize: 9)),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final progress = _selectedTasbeeh.currentCount / _selectedTasbeeh.targetCount;
    return Scaffold(
      backgroundColor: NoorColors.background,
      appBar: NoorPageHeader(
        title: 'Tasbeeh',
        subtitle: 'Remember Allah wherever you are',
        actions: [NoorIconButton(icon: Icons.info_outline_rounded, tooltip: 'About Tasbeeh', onPressed: () {}), const SizedBox(width: 5)],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 2, 16, 24),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(color: NoorColors.panelSoft, borderRadius: BorderRadius.circular(24), border: Border.all(color: NoorColors.gold.withOpacity(0.2))),
                child: Row(
                  children: [
                    Expanded(child: _segment('Counter', !_history, () => setState(() => _history = false))),
                    Expanded(child: _segment('History', _history, () => setState(() => _history = true))),
                  ],
                ),
              ),
              const SizedBox(height: 17),
              if (_history) _buildHistory() else ...[
                NoorPanel(
                  onTap: _pickTasbeeh,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  color: NoorColors.panelSoft,
                  child: Row(
                    children: [
                      const Icon(Icons.auto_awesome_rounded, color: NoorColors.goldBright, size: 17),
                      const SizedBox(width: 8),
                      Expanded(child: Text(_selectedTasbeeh.title.split('(').first.trim(), style: GoogleFonts.poppins(color: NoorColors.text, fontSize: 11, fontWeight: FontWeight.w600))),
                      Text('Target ${_selectedTasbeeh.targetCount}', style: GoogleFonts.poppins(color: NoorColors.textMuted, fontSize: 9)),
                      const SizedBox(width: 5),
                      const Icon(Icons.keyboard_arrow_down_rounded, color: NoorColors.goldBright, size: 17),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                Text('${_selectedTasbeeh.currentCount}', style: GoogleFonts.poppins(color: NoorColors.goldBright, fontSize: 35, fontWeight: FontWeight.w700)),
                Text(_selectedTasbeeh.arabicText == 'سُبْحَانَ ٱللَّٰهِ' ? 'SubhanAllah' : _selectedTasbeeh.title.split('(').first.trim(), style: GoogleFonts.poppins(color: NoorColors.textMuted, fontSize: 13)),
                const SizedBox(height: 4),
                Text('${(_selectedTasbeeh.currentCount / _selectedTasbeeh.targetCount * 100).round()}% of today\'s goal', style: GoogleFonts.poppins(color: NoorColors.textFaint, fontSize: 9)),
                const SizedBox(height: 3),
                NoorProgressBar(value: progress, height: 4),
                const SizedBox(height: 14),
                GestureDetector(
                  onTap: _count,
                  child: SizedBox(
                    width: 260,
                    height: 260,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        CustomPaint(size: const Size.square(260), painter: _BeadRingPainter(progress: progress)),
                        Container(
                          width: 118,
                          height: 118,
                          decoration: BoxDecoration(color: NoorColors.panelRaised, shape: BoxShape.circle, border: Border.all(color: NoorColors.gold.withOpacity(0.42), width: 2), boxShadow: const [BoxShadow(color: Color(0x552B1B08), blurRadius: 20)]),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('TAP', style: GoogleFonts.poppins(color: NoorColors.goldBright, fontSize: 15, fontWeight: FontWeight.w700, letterSpacing: 2)),
                              Text('to count', style: GoogleFonts.poppins(color: NoorColors.textMuted, fontSize: 9)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                NoorPanel(
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 7),
                  color: NoorColors.panelSoft,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('${_selectedTasbeeh.currentCount}', style: GoogleFonts.poppins(color: NoorColors.text, fontSize: 14, fontWeight: FontWeight.w700)),
                      const SizedBox(width: 18),
                      NoorIconButton(icon: Icons.add_rounded, size: 26, backgroundColor: NoorColors.gold, color: NoorColors.background, onPressed: _count),
                    ],
                  ),
                ),
                const SizedBox(height: 9),
                OutlinedButton(onPressed: _reset, style: OutlinedButton.styleFrom(foregroundColor: NoorColors.textMuted, side: BorderSide(color: NoorColors.gold.withOpacity(0.35)), minimumSize: const Size(150, 38), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))), child: Text('Reset', style: GoogleFonts.poppins(fontSize: 10))),
                const SizedBox(height: 17),
                Row(children: [_stat('Today\'s Count', '$_todayCount'), const SizedBox(width: 9), _stat('Daily Goal', '${_selectedTasbeeh.targetCount}', action: 'Set Goal')]),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _segment(String label, bool selected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(color: selected ? NoorColors.gold : Colors.transparent, borderRadius: BorderRadius.circular(20)),
        child: Text(label, textAlign: TextAlign.center, style: GoogleFonts.poppins(color: selected ? NoorColors.background : NoorColors.textMuted, fontSize: 10, fontWeight: FontWeight.w600)),
      ),
    );
  }

  Widget _stat(String title, String value, {String? action}) {
    return Expanded(
      child: NoorPanel(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 11),
        color: NoorColors.panelSoft,
        child: Row(
          children: [
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: GoogleFonts.poppins(color: NoorColors.textMuted, fontSize: 8)), const SizedBox(height: 4), Text(value, style: GoogleFonts.poppins(color: NoorColors.text, fontSize: 15, fontWeight: FontWeight.w700))])),
            if (action != null) NoorPill(label: action),
          ],
        ),
      ),
    );
  }

  Widget _buildHistory() {
    return Column(
      children: [
        NoorPanel(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('This week', style: GoogleFonts.poppins(color: NoorColors.text, fontSize: 12, fontWeight: FontWeight.w700)),
              const SizedBox(height: 15),
              ...List.generate(_historyCounts.length, (index) {
                final date = ['Today', 'Yesterday', 'Monday', 'Sunday', 'Saturday'][index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 11),
                  child: Row(children: [Expanded(child: Text(date, style: GoogleFonts.poppins(color: NoorColors.textMuted, fontSize: 10))), Text('${_historyCounts[index]} counts', style: GoogleFonts.poppins(color: NoorColors.goldBright, fontSize: 10, fontWeight: FontWeight.w600))]),
                );
              }),
            ],
          ),
        ),
      ],
    );
  }
}

class _BeadRingPainter extends CustomPainter {
  final double progress;
  const _BeadRingPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center;
    final radius = size.width * 0.36;
    for (var i = 0; i < 24; i++) {
      final angle = i * math.pi * 2 / 24 - math.pi / 2;
      final offset = Offset(center.dx + math.cos(angle) * radius, center.dy + math.sin(angle) * radius);
      final active = i / 24 < progress;
      final paint = Paint()..color = active ? NoorColors.goldBright : NoorColors.goldMuted;
      canvas.drawCircle(offset, 10, paint);
      canvas.drawCircle(offset.translate(-2, -2), 3, Paint()..color = Colors.white.withOpacity(active ? 0.28 : 0.1));
    }
    final tailPaint = Paint()..color = NoorColors.gold;
    canvas.drawLine(Offset(center.dx + radius * 0.52, center.dy + radius * 0.86), Offset(center.dx + radius * 0.66, center.dy + radius * 1.34), tailPaint..strokeWidth = 4);
    canvas.drawCircle(Offset(center.dx + radius * 0.66, center.dy + radius * 1.36), 5, tailPaint);
  }

  @override
  bool shouldRepaint(covariant _BeadRingPainter oldDelegate) => oldDelegate.progress != progress;
}
