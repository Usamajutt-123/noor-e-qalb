class PrayerTimeItem {
  final String id;
  final String nameUrdu;
  final String nameEnglish;
  final String timeString; // e.g., "05:15 AM"
  final DateTime dateTime;
  final bool isNext;
  final bool isPassed;
  bool isAlarmEnabled;

  PrayerTimeItem({
    required this.id,
    required this.nameUrdu,
    required this.nameEnglish,
    required this.timeString,
    required this.dateTime,
    this.isNext = false,
    this.isPassed = false,
    this.isAlarmEnabled = true,
  });
}

class LocationPreset {
  final String cityName;
  final String countryName;
  final double latitude;
  final double longitude;
  final double timezoneOffset; // in hours from UTC, e.g. +5.0 for Pakistan

  const LocationPreset({
    required this.cityName,
    required this.countryName,
    required this.latitude,
    required this.longitude,
    required this.timezoneOffset,
  });
}

class PrayerSchedule {
  final LocationPreset location;
  final DateTime date;
  final List<PrayerTimeItem> prayers;
  final PrayerTimeItem? nextPrayer;
  final Duration remainingTimeToNext;

  PrayerSchedule({
    required this.location,
    required this.date,
    required this.prayers,
    this.nextPrayer,
    required this.remainingTimeToNext,
  });
}
