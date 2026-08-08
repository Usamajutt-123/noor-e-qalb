import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/noor_theme.dart';
import '../widgets/noor_ui.dart';

class ZakatScreen extends StatefulWidget {
  const ZakatScreen({super.key});

  @override
  State<ZakatScreen> createState() => _ZakatScreenState();
}

class _ZakatScreenState extends State<ZakatScreen> {
  final _assetsController = TextEditingController(text: '1250000');
  final _nisabController = TextEditingController(text: '198000');
  final _cashController = TextEditingController(text: '800000');
  final _goldController = TextEditingController(text: '200000');
  final _businessController = TextEditingController(text: '250000');
  double _zakat = 0;

  @override
  void initState() {
    super.initState();
    for (final controller in [_assetsController, _nisabController, _cashController, _goldController, _businessController]) {
      controller.addListener(_calculate);
    }
    _calculate();
  }

  void _calculate() {
    final assets = double.tryParse(_assetsController.text.replaceAll(',', '')) ?? 0;
    final nisab = double.tryParse(_nisabController.text.replaceAll(',', '')) ?? 0;
    final result = assets >= nisab ? assets * 0.025 : 0.0;
    if (!mounted) {
      _zakat = result;
      return;
    }
    setState(() => _zakat = result);
  }

  @override
  void dispose() {
    _assetsController.dispose();
    _nisabController.dispose();
    _cashController.dispose();
    _goldController.dispose();
    _businessController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NoorColors.background,
      appBar: const NoorPageHeader(title: 'Zakat Calculator', subtitle: 'Calculate your annual obligation'),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 2, 16, 28),
        children: [
          NoorPanel(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            color: NoorColors.panelSoft,
            child: Row(
              children: [
                Expanded(child: Text('Calculation Method', style: GoogleFonts.poppins(color: NoorColors.textMuted, fontSize: 10))),
                DropdownButtonHideUnderline(child: DropdownButton<String>(value: 'Hanafi', dropdownColor: NoorColors.panel, style: GoogleFonts.poppins(color: NoorColors.goldBright, fontSize: 10, fontWeight: FontWeight.w600), items: const [DropdownMenuItem(value: 'Hanafi', child: Text('Hanafi')), DropdownMenuItem(value: 'Shafi', child: Text('Shafi'))], onChanged: (_) {})),
              ],
            ),
          ),
          const SizedBox(height: 12),
          _moneyField('Total Assets', _assetsController),
          _moneyField('Nisab Amount', _nisabController),
          const SizedBox(height: 8),
          NoorPanel(
            padding: const EdgeInsets.all(13),
            gradient: const LinearGradient(colors: [NoorColors.panelRaised, NoorColors.panel]),
            border: Border.all(color: NoorColors.gold.withOpacity(0.55)),
            child: Column(
              children: [
                Row(children: [Expanded(child: Text('Zakat (2.5%)', style: GoogleFonts.poppins(color: NoorColors.text, fontSize: 11, fontWeight: FontWeight.w600))), Text('PKR ${_format(_zakat)}', style: GoogleFonts.poppins(color: NoorColors.goldBright, fontSize: 17, fontWeight: FontWeight.w700))]),
                const SizedBox(height: 8),
                NoorProgressBar(value: _zakat > 0 ? 1 : 0, height: 5),
              ],
            ),
          ),
          const SizedBox(height: 18),
          const NoorSectionTitle(title: 'Zakatable Assets'),
          _assetRow('Cash', _cashController, Icons.payments_outlined),
          _assetRow('Gold', _goldController, Icons.diamond_outlined),
          _assetRow('Business', _businessController, Icons.storefront_outlined),
          const SizedBox(height: 14),
          ElevatedButton(
            onPressed: _calculate,
            style: ElevatedButton.styleFrom(backgroundColor: NoorColors.gold, foregroundColor: NoorColors.background, minimumSize: const Size.fromHeight(44), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
            child: Text('Calculate Zakat', style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w700)),
          ),
          const SizedBox(height: 12),
          Text('This calculator is for guidance. Consult a qualified scholar for your personal circumstances.', textAlign: TextAlign.center, style: GoogleFonts.poppins(color: NoorColors.textFaint, fontSize: 8, height: 1.4)),
        ],
      ),
    );
  }

  Widget _moneyField(String label, TextEditingController controller) {
    return NoorPanel(
      margin: const EdgeInsets.only(bottom: 9),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      color: NoorColors.panelSoft,
      child: Row(
        children: [
          Expanded(child: Text(label, style: GoogleFonts.poppins(color: NoorColors.textMuted, fontSize: 10))),
          SizedBox(width: 126, child: TextField(controller: controller, keyboardType: TextInputType.number, textAlign: TextAlign.right, style: GoogleFonts.poppins(color: NoorColors.text, fontSize: 12, fontWeight: FontWeight.w600), decoration: InputDecoration(hintText: '0', prefixText: 'PKR ', prefixStyle: GoogleFonts.poppins(color: NoorColors.gold, fontSize: 9), border: InputBorder.none))),
          const Icon(Icons.keyboard_arrow_down_rounded, color: NoorColors.gold, size: 17),
        ],
      ),
    );
  }

  Widget _assetRow(String label, TextEditingController controller, IconData icon) {
    return NoorPanel(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
      color: NoorColors.panelSoft,
      child: Row(
        children: [
          Icon(icon, color: NoorColors.success, size: 16),
          const SizedBox(width: 8),
          Expanded(child: Text(label, style: GoogleFonts.poppins(color: NoorColors.text, fontSize: 10))),
          SizedBox(width: 115, child: TextField(controller: controller, keyboardType: TextInputType.number, textAlign: TextAlign.right, style: GoogleFonts.poppins(color: NoorColors.text, fontSize: 10), decoration: InputDecoration(hintText: '0', border: InputBorder.none))),
          Text(' PKR', style: GoogleFonts.poppins(color: NoorColors.textFaint, fontSize: 8)),
        ],
      ),
    );
  }

  String _format(double number) => number.round().toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (match) => '${match[1]},');
}
