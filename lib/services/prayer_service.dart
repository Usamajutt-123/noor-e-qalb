import 'dart:math' as math;
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:geolocator/geolocator.dart';
import '../models/prayer_times_model.dart';

class PrayerService extends ChangeNotifier {
  static final List<LocationPreset> presets = [
    const LocationPreset(
      cityName: 'Malakwal / Mandi Bahauddin',
      countryName: 'Pakistan',
      latitude: 32.5542,
      longitude: 73.3134,
      timezoneOffset: 5.0,
    ),
    const LocationPreset(
      cityName: 'Lahore / Punjab',
      countryName: 'Pakistan',
      latitude: 31.5204,
      longitude: 74.3587,
      timezoneOffset: 5.0,
    ),
    const LocationPreset(
      cityName: 'Islamabad / Rawalpindi',
      countryName: 'Pakistan',
      latitude: 33.6844,
      longitude: 73.0479,
      timezoneOffset: 5.0,
    ),
    const LocationPreset(
      cityName: 'Karachi / Sindh',
      countryName: 'Pakistan',
      latitude: 24.8607,
      longitude: 67.0011,
      timezoneOffset: 5.0,
    ),
    const LocationPreset(
      cityName: 'Peshawar / KPK',
      countryName: 'Pakistan',
      latitude: 34.0151,
      longitude: 71.5249,
      timezoneOffset: 5.0,
    ),
    const LocationPreset(
      cityName: 'Multan / South Punjab',
      countryName: 'Pakistan',
      latitude: 30.1798,
      longitude: 71.5249,
      timezoneOffset: 5.0,
    ),
    const LocationPreset(
      cityName: 'Mecca / Makkah',
      countryName: 'Saudi Arabia',
      latitude: 21.4225,
      longitude: 39.8262,
      timezoneOffset: 3.0,
    ),
    const LocationPreset(
      cityName: 'London',
      countryName: 'United Kingdom',
      latitude: 51.5074,
      longitude: -0.1278,
      timezoneOffset: 0.0,
    ),
    const LocationPreset(
      cityName: 'New York',
      countryName: 'USA',
      latitude: 40.7128,
      longitude: -74.0060,
      timezoneOffset: -5.0,
    ),
  ];

  late LocationPreset _selectedLocation;
  bool _isHanafi = true; // Hanafi Asr (Shadow length = 2)
  bool _isDetectingGps = false;
  String _statusMessage = '';

  LocationPreset get selectedLocation => _selectedLocation;
  bool get isHanafi => _isHanafi;
  bool get isDetectingGps => _isDetectingGps;
  String get statusMessage => _statusMessage;

  PrayerService() {
    _selectedLocation = presets.first; // Default Malakwal / Mandi Bahauddin
  }

  void setLocation(LocationPreset location) {
    _selectedLocation = location;
    _statusMessage = 'Location updated to ${location.cityName}';
    notifyListeners();
  }

  void setAsrMethod(bool isHanafi) {
    _isHanafi = isHanafi;
    notifyListeners();
  }

  /// Automatically detect user's live GPS location using geolocator
  Future<void> detectLiveGpsLocation() async {
    _isDetectingGps = true;
    _statusMessage = 'Detecting GPS coordinates...';
    notifyListeners();

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _statusMessage = 'Location services are disabled. Using default location.';
        _isDetectingGps = false;
        notifyListeners();
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          _statusMessage = 'Location permission denied. Using selected preset.';
          _isDetectingGps = false;
          notifyListeners();
          return;
        }
      }

      final Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
      );

      // Find closest preset city or use exact coordinates
      LocationPreset? closestCity;
      double minDistance = double.infinity;

      for (var p in presets) {
        final double dist = Geolocator.distanceBetween(
          position.latitude,
          position.longitude,
          p.latitude,
          p.longitude,
        );
        if (dist < minDistance) {
          minDistance = dist;
          closestCity = p;
        }
      }

      // If closest city is within 40 km, use its nice name, otherwise use custom lat/lng
      if (closestCity != null && minDistance < 40000) {
        _selectedLocation = closestCity;
        _statusMessage = 'Auto-Detected: ${closestCity.cityName}';
      } else {
        final double tzOffset = DateTime.now().timeZoneOffset.inMinutes / 60.0;
        _selectedLocation = LocationPreset(
          cityName: 'Live GPS (${position.latitude.toStringAsFixed(2)}°N, ${position.longitude.toStringAsFixed(2)}°E)',
          countryName: 'Detected Location',
          latitude: position.latitude,
          longitude: position.longitude,
          timezoneOffset: tzOffset,
        );
        _statusMessage = 'Auto-Detected Live GPS Coordinates';
      }
    } catch (e) {
      _statusMessage = 'GPS detection fallback: $e';
    } finally {
      _isDetectingGps = false;
      notifyListeners();
    }
  }

  /// Calculates astronomical prayer times offline for given date and location
  PrayerSchedule getSchedule(DateTime date) {
    final double lat = _selectedLocation.latitude;
    final double lng = _selectedLocation.longitude;
    final double tz = _selectedLocation.timezoneOffset;

    // Day of the year
    final int dayOfYear = int.parse(DateFormat('D').format(date));
    
    // Solar coordinates approximation
    final double gamma = (2 * math.pi / 365) * (dayOfYear - 1 + (12 - 12) / 24);
    
    // Equation of time (in minutes)
    final double eqTime = 229.18 *
        (0.000075 +
            0.001868 * math.cos(gamma) -
            0.032077 * math.sin(gamma) -
            0.014615 * math.cos(2 * gamma) -
            0.040849 * math.sin(2 * gamma));

    // Solar Declination (in radians)
    final double decl = 0.006918 -
        0.399912 * math.cos(gamma) +
        0.070257 * math.sin(gamma) -
        0.006758 * math.cos(2 * gamma) +
        0.000907 * math.sin(2 * gamma) -
        0.002697 * math.cos(3 * gamma) +
        0.00148 * math.sin(3 * gamma);

    // Solar noon (in hours)
    final double solarNoon = (720 - 4 * lng - eqTime + tz * 60) / 60.0;

    // Helper for Hour Angle calculation
    double getHourAngle(double angleDeg) {
      final double latRad = lat * math.pi / 180.0;
      final double angleRad = angleDeg * math.pi / 180.0;
      final double cosW = (math.sin(angleRad) - math.sin(latRad) * math.sin(decl)) /
          (math.cos(latRad) * math.cos(decl));
      if (cosW < -1.0 || cosW > 1.0) return 0.0;
      return math.acos(cosW) * 180.0 / math.pi;
    }

    // Fajr (18 deg below horizon - University of Islamic Sciences, Karachi)
    final double fajrAngle = getHourAngle(-18.0) / 15.0;
    final double fajrHour = solarNoon - fajrAngle;

    // Sunrise (-0.833 deg below horizon accounting for atmospheric refraction)
    final double sunriseAngle = getHourAngle(-0.833) / 15.0;
    final double sunriseHour = solarNoon - sunriseAngle;

    // Dhuhr (solar noon + 4 mins safety)
    final double dhuhrHour = solarNoon + (4 / 60.0);

    // Asr (Hanafi shadow = 2, Shafi'i shadow = 1)
    final double latRad = lat * math.pi / 180.0;
    final double shadowFactor = _isHanafi ? 2.0 : 1.0;
    final double asrAltRad = math.atan(
      1.0 / (shadowFactor + math.tan((latRad - decl).abs())),
    );
    final double asrAltDeg = asrAltRad * 180.0 / math.pi;
    final double asrAngle = getHourAngle(asrAltDeg) / 15.0;
    final double asrHour = solarNoon + asrAngle;

    // Maghrib (Sunset + 3 mins)
    final double maghribHour = solarNoon + sunriseAngle + (3 / 60.0);

    // Isha (18 deg below horizon - Karachi method)
    final double ishaAngle = getHourAngle(-18.0) / 15.0;
    final double ishaHour = solarNoon + ishaAngle;

    // Convert decimal hours to DateTime for today
    DateTime hourToDateTime(double decimalHours) {
      int h = decimalHours.floor();
      int m = ((decimalHours - h) * 60).round();
      if (m == 60) {
        h += 1;
        m = 0;
      }
      return DateTime(date.year, date.month, date.day, h, m);
    }

    final List<PrayerTimeItem> list = [
      PrayerTimeItem(
        id: 'fajr',
        nameUrdu: 'فَجْر',
        nameEnglish: 'Fajr',
        timeString: DateFormat('hh:mm a').format(hourToDateTime(fajrHour)),
        dateTime: hourToDateTime(fajrHour),
      ),
      PrayerTimeItem(
        id: 'sunrise',
        nameUrdu: 'طُلُوعِ آفتَاب',
        nameEnglish: 'Sunrise',
        timeString: DateFormat('hh:mm a').format(hourToDateTime(sunriseHour)),
        dateTime: hourToDateTime(sunriseHour),
      ),
      PrayerTimeItem(
        id: 'dhuhr',
        nameUrdu: 'ظُهْر',
        nameEnglish: 'Dhuhr',
        timeString: DateFormat('hh:mm a').format(hourToDateTime(dhuhrHour)),
        dateTime: hourToDateTime(dhuhrHour),
      ),
      PrayerTimeItem(
        id: 'asr',
        nameUrdu: 'عَصْر',
        nameEnglish: _isHanafi ? "Asr (Hanafi)" : "Asr (Shafi'i)",
        timeString: DateFormat('hh:mm a').format(hourToDateTime(asrHour)),
        dateTime: hourToDateTime(asrHour),
      ),
      PrayerTimeItem(
        id: 'maghrib',
        nameUrdu: 'مَغْرِب',
        nameEnglish: 'Maghrib',
        timeString: DateFormat('hh:mm a').format(hourToDateTime(maghribHour)),
        dateTime: hourToDateTime(maghribHour),
      ),
      PrayerTimeItem(
        id: 'isha',
        nameUrdu: 'عِشَاء',
        nameEnglish: 'Isha',
        timeString: DateFormat('hh:mm a').format(hourToDateTime(ishaHour)),
        dateTime: hourToDateTime(ishaHour),
      ),
    ];

    final DateTime now = DateTime.now();
    PrayerTimeItem? next;
    Duration minDiff = const Duration(days: 99);

    for (var p in list) {
      if (p.id == 'sunrise') continue; // Don't highlight sunrise as next prayer
      final diff = p.dateTime.difference(now);
      if (diff.isNegative) {
        // Passed prayer today
      } else {
        if (diff < minDiff) {
          minDiff = diff;
          next = p;
        }
      }
    }

    // If all prayers passed today, next is Fajr tomorrow
    if (next == null) {
      final tomorrow = date.add(const Duration(days: 1));
      final tomorrowSchedule = _getScheduleForDate(tomorrow);
      next = tomorrowSchedule.firstWhere((p) => p.id == 'fajr');
      minDiff = next.dateTime.difference(now);
    }

    return PrayerSchedule(
      location: _selectedLocation,
      date: date,
      prayers: list,
      nextPrayer: next,
      remainingTimeToNext: minDiff,
    );
  }

  List<PrayerTimeItem> _getScheduleForDate(DateTime date) {
    return getSchedule(date).prayers;
  }
}
