import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import '../services/admob_service.dart';
import '../services/premium_service.dart';

class AdBannerWidget extends StatefulWidget {
  const AdBannerWidget({super.key});

  @override
  State<AdBannerWidget> createState() => _AdBannerWidgetState();
}

class _AdBannerWidgetState extends State<AdBannerWidget> {
  BannerAd? _bannerAd;
  bool _isAdLoaded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final premiumService = Provider.of<PremiumService>(context);
    if (!premiumService.isProUser && _bannerAd == null) {
      _loadBanner(premiumService);
    } else if (premiumService.isProUser && _bannerAd != null) {
      _bannerAd!.dispose();
      _bannerAd = null;
      setState(() {
        _isAdLoaded = false;
      });
    }
  }

  void _loadBanner(PremiumService premiumService) {
    final ad = AdMobService().createBannerAd(premiumService);
    if (ad != null) {
      _bannerAd = BannerAd(
        adUnitId: ad.adUnitId,
        size: ad.size,
        request: const AdRequest(),
        listener: BannerAdListener(
          onAdLoaded: (ad) {
            if (mounted) {
              setState(() {
                _isAdLoaded = true;
              });
            }
          },
          onAdFailedToLoad: (ad, error) {
            ad.dispose();
            if (mounted) {
              setState(() {
                _isAdLoaded = false;
              });
            }
          },
        ),
      );
      _bannerAd!.load();
    }
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final premiumService = Provider.of<PremiumService>(context);
    if (premiumService.isProUser || !_isAdLoaded || _bannerAd == null) {
      return const SizedBox.shrink();
    }

    return Container(
      alignment: Alignment.center,
      width: _bannerAd!.size.width.toDouble(),
      height: _bannerAd!.size.height.toDouble(),
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: AdWidget(ad: _bannerAd!),
    );
  }
}
