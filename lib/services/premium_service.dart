import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PremiumService extends ChangeNotifier {
  static const String _proUserKey = 'is_pro_user_noor_e_qalb';
  static const String _proProductId = 'noor_e_qalb_pro_remove_ads'; // Google Play Console Product ID

  bool _isProUser = false;
  bool _isLoading = false;
  String _statusMessage = '';

  bool get isProUser => _isProUser;
  bool get isLoading => _isLoading;
  String get statusMessage => _statusMessage;

  final InAppPurchase _iap = InAppPurchase.instance;

  PremiumService() {
    _loadProStatus();
  }

  Future<void> _loadProStatus() async {
    final prefs = await SharedPreferences.getInstance();
    _isProUser = prefs.getBool(_proUserKey) ?? false;
    notifyListeners();
  }

  Future<void> buyProUpgrade() async {
    _isLoading = true;
    _statusMessage = 'Connecting to Google Play Store...';
    notifyListeners();

    try {
      final bool available = await _iap.isAvailable();
      if (!available) {
        // Fallback for demo or emulator without Google Play Store billing
        _statusMessage = 'Play Store billing not available on device. Simulating Pro Unlock...';
        await Future.delayed(const Duration(seconds: 1));
        await setProStatus(true);
        _isLoading = false;
        return;
      }

      const Set<String> kIds = <String>{_proProductId};
      final ProductDetailsResponse response = await _iap.queryProductDetails(kIds);

      if (response.notFoundIDs.isNotEmpty || response.productDetails.isEmpty) {
        _statusMessage = 'Product not found. Ensure ID is created in Play Console.';
        _isLoading = false;
        notifyListeners();
        return;
      }

      final ProductDetails productDetails = response.productDetails.first;
      final PurchaseParam purchaseParam = PurchaseParam(productDetails: productDetails);
      await _iap.buyNonConsumable(purchaseParam: purchaseParam);
    } catch (e) {
      _statusMessage = 'Error starting purchase: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> setProStatus(bool val) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_proUserKey, val);
    _isProUser = val;
    _statusMessage = val ? 'Alhamdulillah! Pro Version Unlocked. All Ads Removed.' : 'Switched to Free mode with Ads.';
    notifyListeners();
  }

  // Handy toggle for developers & testers to see Ads ON vs Pro mode
  Future<void> toggleSimulatedProMode() async {
    await setProStatus(!_isProUser);
  }
}
