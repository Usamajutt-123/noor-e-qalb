import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'premium_service.dart';

class AdMobService {
  static final AdMobService _instance = AdMobService._internal();
  factory AdMobService() => _instance;
  AdMobService._internal();

  bool _isInitialized = false;
  InterstitialAd? _interstitialAd;
  int _tasbeehCompletionCounter = 0;

  // TEST AD UNIT IDS (Replace with your actual AdMob IDs in Google Play Console)
  static String get bannerAdUnitId {
    if (kDebugMode) {
      return Platform.isAndroid
          ? 'ca-app-pub-3940256099942544/6300978111'
          : 'ca-app-pub-3940256099942544/2934735716';
    }
    // Replace with Real Android AdMob Banner ID for Play Store
    return 'ca-app-pub-xxxxxxxxxxxxxxxx/xxxxxxxxxx';
  }

  static String get interstitialAdUnitId {
    if (kDebugMode) {
      return Platform.isAndroid
          ? 'ca-app-pub-3940256099942544/1033173712'
          : 'ca-app-pub-3940256099942544/4411468910';
    }
    // Replace with Real Android AdMob Interstitial ID for Play Store
    return 'ca-app-pub-xxxxxxxxxxxxxxxx/xxxxxxxxxx';
  }

  Future<void> initialize() async {
    if (_isInitialized) return;
    await MobileAds.instance.initialize();
    _isInitialized = true;
    _loadInterstitialAd();
  }

  void _loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
        },
        onAdFailedToLoad: (error) {
          _interstitialAd = null;
        },
      ),
    );
  }

  BannerAd? createBannerAd(PremiumService premiumService) {
    if (premiumService.isProUser) return null; // No ads for Pro users!

    return BannerAd(
      adUnitId: bannerAdUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
        },
      ),
    );
  }

  void showInterstitialAfterTasbeeh(PremiumService premiumService) {
    if (premiumService.isProUser) return; // Never show interstitial to Pro users

    _tasbeehCompletionCounter++;
    // Show interstitial every 3 completed Tasbeeh laps to balance earning & UX
    if (_tasbeehCompletionCounter % 3 == 0 && _interstitialAd != null) {
      _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) {
          ad.dispose();
          _loadInterstitialAd();
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          ad.dispose();
          _loadInterstitialAd();
        },
      );
      _interstitialAd!.show();
      _interstitialAd = null;
    }
  }
}
