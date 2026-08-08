import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../models/prayer_times_model.dart';
import '../services/prayer_service.dart';
import '../services/language_service.dart';
import '../widgets/ad_banner_widget.dart';

class PrayerTimesScreen extends StatefulWidget {
  const PrayerTimesScreen({super.key});

  @override
  State<PrayerTimesScreen> createState() => _PrayerTimesScreenState();
}

class _PrayerTimesScreenState extends State<PrayerTimesScreen> {
  Timer? _ticker;
  late PrayerSchedule _schedule;

  @override
  void initState() {
    super.initState();
    _refreshSchedule();
    _ticker = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _refreshSchedule();
        });
      }
    });
  }

  void _refreshSchedule() {
    final prayerService = Provider.of<PrayerService>(context, listen: false);
    _schedule = prayerService.getSchedule(DateTime.now());
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  String _formatDuration(Duration d, bool isUrdu) {
    if (d.isNegative) return isUrdu ? '00 گھنٹے 00 منٹ' : '00h 00m 00s';
    final int hours = d.inHours;
    final int mins = d.inMinutes.remainder(60);
    final int secs = d.inSeconds.remainder(60);
    if (isUrdu) {
      return 'باقی: ${hours.toString().padLeft(2, '0')}h ${mins.toString().padLeft(2, '0')}m ${secs.toString().padLeft(2, '0')}s';
    }
    return '${hours.toString().padLeft(2, '0')}h ${mins.toString().padLeft(2, '0')}m ${secs.toString().padLeft(2, '0')}s left';
  }

  @override
  Widget build(BuildContext context) {
    final prayerService = Provider.of<PrayerService>(context);
    final lang = Provider.of<LanguageService>(context);

    return Scaffold(
      backgroundColor: const Color(0xFF082017),
      appBar: AppBar(
        backgroundColor: const Color(0xFF163024),
        elevation: 0,
        title: Text(
          lang.isUrdu ? 'نماز کے اوقات' : 'Namaz Timings',
          style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 16),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          // LOCATION SELECTOR & METHOD BAR
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            color: const Color(0xFF163024),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.location_on, color: Color(0xFFCCA236), size: 18),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '${prayerService.selectedLocation.cityName}, ${prayerService.selectedLocation.countryName}',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        lang.isUrdu ? 'عصر کا فقہی طریقہ:' : 'Asr Method:',
                        style: GoogleFonts.poppins(color: Colors.white70, fontSize: 12),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ChoiceChip(
                          label: Text(lang.isUrdu ? 'حنفی' : 'Hanafi', style: const TextStyle(fontSize: 11)),
                          selected: prayerService.isHanafi,
                          selectedColor: const Color(0xFFCCA236),
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          visualDensity: VisualDensity.compact,
                          onSelected: (val) {
                            if (val) prayerService.setAsrMethod(true);
                          },
                        ),
                        const SizedBox(width: 6),
                        ChoiceChip(
                          label: Text(lang.isUrdu ? 'شافعی' : 'Shafi\'i', style: const TextStyle(fontSize: 11)),
                          selected: !prayerService.isHanafi,
                          selectedColor: const Color(0xFFCCA236),
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          visualDensity: VisualDensity.compact,
                          onSelected: (val) {
                            if (val) prayerService.setAsrMethod(false);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(14),
              child: Column(
                children: [
                  // HERO NEXT PRAYER CARD
                  if (_schedule.nextPrayer != null)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF1E4A39), Color(0xFF163024)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(22),
                        border: Border.all(color: const Color(0xFFCCA236), width: 1.5),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFCCA236).withOpacity(0.2),
                            blurRadius: 16,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFF082017),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              lang.isUrdu ? 'اگلی نماز کا وقت' : 'UPCOMING NAMAZ',
                              style: GoogleFonts.poppins(
                                color: const Color(0xFFCCA236),
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.5,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              lang.isUrdu ? _schedule.nextPrayer!.nameUrdu : _schedule.nextPrayer!.nameEnglish,
                              style: GoogleFonts.amiri(
                                color: Colors.white,
                                fontSize: 36,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            _schedule.nextPrayer!.timeString,
                            style: GoogleFonts.poppins(
                              color: const Color(0xFFCCA236),
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 14),
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                color: const Color(0xFF082017),
                                borderRadius: BorderRadius.circular(25),
                                border: Border.all(color: Colors.white12),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.timer, color: Color(0xFFCCA236), size: 16),
                                  const SizedBox(width: 8),
                                  Text(
                                    _formatDuration(_schedule.remainingTimeToNext, lang.isUrdu),
                                    style: GoogleFonts.poppins(
                                      color: Colors.white,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                  const SizedBox(height: 18),

                  // PRAYER SCHEDULE CARDS
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _schedule.prayers.length,
                    itemBuilder: (ctx, idx) {
                      final p = _schedule.prayers[idx];
                      final isNext = _schedule.nextPrayer?.id == p.id;
                      final isSunrise = p.id == 'sunrise';
                      final nameDisplay = lang.isUrdu ? p.nameUrdu : p.nameEnglish;

                      return Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                        decoration: BoxDecoration(
                          color: isNext
                              ? const Color(0xFF1E4A39)
                              : const Color(0xFF163024),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isNext ? const Color(0xFFCCA236) : Colors.white10,
                            width: isNext ? 2 : 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: const Color(0xFF082017),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(
                                isSunrise
                                    ? Icons.wb_sunny
                                    : (isNext ? Icons.notifications_active : Icons.mosque),
                                color: isNext || isSunrise
                                    ? const Color(0xFFCCA236)
                                    : Colors.white60,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    nameDisplay,
                                    style: GoogleFonts.amiri(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                  if (isNext)
                                    Text(
                                      lang.isUrdu ? 'اگلی نماز' : 'Next Prayer',
                                      style: GoogleFonts.poppins(
                                        color: const Color(0xFFCCA236),
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  p.timeString,
                                  style: GoogleFonts.poppins(
                                    color: isNext ? const Color(0xFFCCA236) : Colors.white,
                                    fontSize: 15,
                                    fontWeight: isNext ? FontWeight.bold : FontWeight.w600,
                                  ),
                                ),
                                SizedBox(
                                  width: 36,
                                  height: 36,
                                  child: IconButton(
                                    padding: EdgeInsets.zero,
                                    icon: Icon(
                                      Icons.notifications,
                                      color: p.isAlarmEnabled ? const Color(0xFFCCA236) : Colors.white30,
                                      size: 18,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        p.isAlarmEnabled = !p.isAlarmEnabled;
                                      });
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            p.isAlarmEnabled
                                                ? (lang.isUrdu ? '🕌 اذان الارم فعال: ${p.nameUrdu}' : '🕌 Azan Alarm Enabled: ${p.nameEnglish}')
                                                : (lang.isUrdu ? '🔕 اذان الارم بند کر دیا گیا' : '🔕 Azan Alarm Disabled'),
                                          ),
                                          backgroundColor: const Color(0xFF163024),
                                          duration: const Duration(seconds: 2),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
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
