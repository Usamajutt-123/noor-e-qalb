import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../services/premium_service.dart';

class ProUpgradeScreen extends StatelessWidget {
  const ProUpgradeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final premiumService = Provider.of<PremiumService>(context);

    return Scaffold(
      backgroundColor: const Color(0xFF081B15),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        child: Column(
          children: [
            // Crown / Gold Icon
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFF0F2C23),
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFD4AF37), width: 2),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFD4AF37).withOpacity(0.3),
                    blurRadius: 30,
                    spreadRadius: 4,
                  ),
                ],
              ),
              child: const Icon(Icons.workspace_premium, color: Color(0xFFD4AF37), size: 70),
            ),
            const SizedBox(height: 24),

            Text(
              'Noor-e-Qalb PRO',
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Tamam Ads khatam karein aur exclusive golden themes unlock karein',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                color: Colors.white70,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 32),

            // Benefit 1
            _buildBenefitRow(
              icon: Icons.block,
              title: '100% Ad-Free Experience',
              desc: 'Koi Banner ya Interstitial ad nahi. Tasbeeh aur Duas be-ghair kisi rukawat ke padhein.',
            ),
            const SizedBox(height: 16),

            // Benefit 2
            _buildBenefitRow(
              icon: Icons.color_lens,
              title: 'Exclusive Gold & Night Themes',
              desc: 'Khoobsurat Islamic golden themes aur AMOLED Dark mode access.',
            ),
            const SizedBox(height: 16),

            // Benefit 3
            _buildBenefitRow(
              icon: Icons.cloud_done,
              title: 'Support Islamic App Development',
              desc: 'Aap ka tawun mazeed Islamic features aur Duas shamil karne mein madad deta hai.',
            ),
            const SizedBox(height: 36),

            // Price / Purchase Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF194C3D), Color(0xFF0F2C23)],
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFD4AF37)),
              ),
              child: Column(
                children: [
                  Text(
                    'Lifetime Access (One-Time Payment)',
                    style: GoogleFonts.poppins(color: const Color(0xFFD4AF37), fontSize: 13),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'PKR 950 / \$2.99',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFD4AF37),
                        foregroundColor: const Color(0xFF081B15),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        elevation: 4,
                      ),
                      onPressed: premiumService.isLoading
                          ? null
                          : () {
                              premiumService.buyProUpgrade();
                            },
                      child: premiumService.isLoading
                          ? const CircularProgressIndicator(color: Color(0xFF081B15))
                          : Text(
                              premiumService.isProUser ? 'ALREADY UNLOCKED (PRO)' : 'UPGRADE TO PRO NOW',
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Developer / Tester Mode Toggle
            TextButton.icon(
              onPressed: () {
                premiumService.toggleSimulatedProMode();
              },
              icon: Icon(
                premiumService.isProUser ? Icons.toggle_on : Icons.toggle_off,
                color: const Color(0xFFD4AF37),
                size: 24,
              ),
              label: Text(
                premiumService.isProUser
                    ? 'Switch to Free Mode'
                    : 'Simulate Pro Purchase',
                style: GoogleFonts.poppins(color: Colors.white60, fontSize: 12),
              ),
            ),
            if (premiumService.statusMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  premiumService.statusMessage,
                  style: GoogleFonts.poppins(color: const Color(0xFFD4AF37), fontSize: 12),
                ),
              ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildBenefitRow({required IconData icon, required String title, required String desc}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFF0F2C23),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: const Color(0xFFD4AF37), size: 24),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                desc,
                style: GoogleFonts.poppins(
                  color: Colors.white60,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
