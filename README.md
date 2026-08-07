# Noor-e-Qalb (نورِ قلب) - Islamic Companion & Digital Tasbeeh

A complete, production-ready **Flutter Mobile App** designed for Google Play Store with **long-term earning potential** using **both Google AdMob Ads and In-App Purchases (Pro Ad-Free Upgrade)**.

---

## 🌟 App Features
1. **Digital Tasbeeh Counter**:
   - Custom targets (33, 34, 100, custom).
   - Haptic vibration & sound feedback on count.
   - Automatic completed lap counter & AdMob Interstitial triggers.
2. **Masnoon Duas & Azkar**:
   - Authentic Arabic calligraphy text (`Amiri` font).
   - Urdu & English translations.
   - Categorized by Morning/Evening, After Prayer, Travel, and Protection.
   - Built-in social sharing.
3. **99 Names of Allah (Asma-ul-Husna)**:
   - Arabic names with transliteration, Urdu & English meanings, and benefits of recitation.
4. **Hybrid Monetization (Best for Long-Term Earning)**:
   - **Free Users**: See Google AdMob Banner Ads and periodic Interstitial Ads.
   - **Pro Users (In-App Purchase)**: One-time payment to remove all ads and unlock exclusive golden themes.

---

## 🛠 How to Build & Run
1. Open this folder in **Android Studio** or **VS Code**.
2. Run command in terminal:
   ```bash
   flutter pub get
   ```
3. Run on device or emulator:
   ```bash
   flutter run
   ```

---

## 💰 How to Setup Real Google AdMob IDs
Open `lib/services/admob_service.dart`:
- Replace test Banner ID `ca-app-pub-3940256099942544/6300978111` with your real **Android Banner ID** from Google AdMob account.
- Replace test Interstitial ID `ca-app-pub-3940256099942544/1033173712` with your real **Android Interstitial ID**.
- Update your Google AdMob App ID in `android/app/src/main/AndroidManifest.xml` (when generating the Android project wrapper).

---

## 📦 How to Build App Bundle (.aab) for Google Play Store
To generate a release build ready for Play Store upload:
```bash
flutter build appbundle --release
```
Your compiled bundle will be generated at:
`build/app/outputs/bundle/release/app-release.aab`
