import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../services/language_service.dart';

class ZakatScreen extends StatefulWidget {
  const ZakatScreen({super.key});

  @override
  State<ZakatScreen> createState() => _ZakatScreenState();
}

class _ZakatScreenState extends State<ZakatScreen> {
  String _nisabBasis = 'silver';
  String _selectedCurr = 'PKR';
  static const Map<String, Map<String, dynamic>> _currencyRates = {
    'PKR': {'nameUr': 'پاکستان', 'nameEn': 'Pakistan', 'flag': '🇵🇰', 'silver': 198000.0, 'gold': 1850000.0, 'sStr': '198K PKR', 'gStr': '1.85M PKR'},
    'SAR': {'nameUr': 'سعودی عرب', 'nameEn': 'Saudi Arabia', 'flag': '🇸🇦', 'silver': 2140.0, 'gold': 24500.0, 'sStr': '2,140 SAR', 'gStr': '24.5K SAR'},
    'AED': {'nameUr': 'امارات', 'nameEn': 'UAE', 'flag': '🇦🇪', 'silver': 2080.0, 'gold': 24000.0, 'sStr': '2,080 AED', 'gStr': '24K AED'},
    'GBP': {'nameUr': 'برطانیہ', 'nameEn': 'United Kingdom', 'flag': '🇬🇧', 'silver': 440.0, 'gold': 5250.0, 'sStr': '£440', 'gStr': '£5.2K'},
    'USD': {'nameUr': 'امریکہ', 'nameEn': 'USA', 'flag': '🇺🇸', 'silver': 560.0, 'gold': 6560.0, 'sStr': '\$560', 'gStr': '\$6.5K'},
    'INR': {'nameUr': 'بھارت', 'nameEn': 'India', 'flag': '🇮🇳', 'silver': 52000.0, 'gold': 630000.0, 'sStr': '₹52K', 'gStr': '₹630K'},
  };

  final TextEditingController _cashController = TextEditingController();
  final TextEditingController _goldController = TextEditingController();
  final TextEditingController _businessController = TextEditingController();
  final TextEditingController _investController = TextEditingController();
  final TextEditingController _debtController = TextEditingController();

  double _totalAssets = 0.0;
  double _payableZakat = 0.0;

  @override
  void initState() {
    super.initState();
    _cashController.addListener(_calculate);
    _goldController.addListener(_calculate);
    _businessController.addListener(_calculate);
    _investController.addListener(_calculate);
    _debtController.addListener(_calculate);
  }

  void _calculate() {
    final double cash = double.tryParse(_cashController.text) ?? 0.0;
    final double gold = double.tryParse(_goldController.text) ?? 0.0;
    final double business = double.tryParse(_businessController.text) ?? 0.0;
    final double invest = double.tryParse(_investController.text) ?? 0.0;
    final double debt = double.tryParse(_debtController.text) ?? 0.0;

    final double total = cash + gold + business + invest;
    final double net = math.max(0.0, total - debt);
    final rate = _currencyRates[_selectedCurr]!;
    final double nisab = _nisabBasis == 'gold' ? (rate['gold'] as double) : (rate['silver'] as double);

    double zakat = 0.0;
    if (net >= nisab && total > 0) {
      zakat = net * 0.025;
    }

    setState(() {
      _totalAssets = total;
      _payableZakat = zakat;
    });
  }

  void _resetAll() {
    _cashController.clear();
    _goldController.clear();
    _businessController.clear();
    _investController.clear();
    _debtController.clear();
    _calculate();
  }

  @override
  void dispose() {
    _cashController.dispose();
    _goldController.dispose();
    _businessController.dispose();
    _investController.dispose();
    _debtController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final langService = Provider.of<LanguageService>(context);
    final bool isUrdu = langService.isUrdu;
    final currRate = _currencyRates[_selectedCurr]!;
    final double nisabVal = _nisabBasis == 'gold' ? (currRate['gold'] as double) : (currRate['silver'] as double);

    return Scaffold(
      backgroundColor: const Color(0xFF082017),
      appBar: AppBar(
        backgroundColor: const Color(0xFF082017),
        elevation: 0,
        title: Text(
          isUrdu ? "زکوٰۃ کیلکولیٹر" : "Zakat Calculator",
          style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Multi-Currency Choice Chips
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: _currencyRates.keys.map((code) {
                    final rate = _currencyRates[code]!;
                    final isSel = (_selectedCurr == code);
                    return Padding(
                      padding: const EdgeInsets.only(right: 6),
                      child: ChoiceChip(
                        label: Text(
                          '${rate['flag']} $code',
                          style: TextStyle(
                            color: isSel ? const Color(0xFF082017) : Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 11,
                          ),
                        ),
                        selected: isSel,
                        selectedColor: const Color(0xFFCCA236),
                        backgroundColor: const Color(0xFF0E241C),
                        visualDensity: VisualDensity.compact,
                        onSelected: (_) {
                          setState(() => _selectedCurr = code);
                          _calculate();
                        },
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 12),

              // Nisab Toggle
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _nisabBasis == 'silver' ? const Color(0xFFCCA236) : const Color(0xFF0E241C),
                        foregroundColor: _nisabBasis == 'silver' ? const Color(0xFF082017) : Colors.white,
                        side: const BorderSide(color: Color(0xFFCCA236)),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        visualDensity: VisualDensity.compact,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                      ),
                      onPressed: () {
                        setState(() => _nisabBasis = 'silver');
                        _calculate();
                      },
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          isUrdu
                              ? '🪙 چاندی (~${_currencyRates[_selectedCurr]!['sStr']})'
                              : '🪙 Silver (~${_currencyRates[_selectedCurr]!['sStr']})',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _nisabBasis == 'gold' ? const Color(0xFFCCA236) : const Color(0xFF0E241C),
                        foregroundColor: _nisabBasis == 'gold' ? const Color(0xFF082017) : Colors.white,
                        side: const BorderSide(color: Color(0xFFCCA236)),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        visualDensity: VisualDensity.compact,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                      ),
                      onPressed: () {
                        setState(() => _nisabBasis = 'gold');
                        _calculate();
                      },
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          isUrdu
                              ? '👑 سونا (~${_currencyRates[_selectedCurr]!['gStr']})'
                              : '👑 Gold (~${_currencyRates[_selectedCurr]!['gStr']})',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              // Executive Summary Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [Color(0xFF163024), Color(0xFF0A201A)]),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: const Color(0xFFCCA236), width: 1.5),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 16),
                  ],
                ),
                child: Column(
                  children: [
                    _buildSummaryRow(
                      isUrdu ? "کل اثاثے:" : "Total Assets:",
                      "${_totalAssets.round().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')} $_selectedCurr",
                    ),
                    const SizedBox(height: 8),
                    _buildSummaryRow(
                      isUrdu ? "نصاب کی حد:" : "Nisab:",
                      "${nisabVal.round().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')} $_selectedCurr",
                    ),
                    const SizedBox(height: 10),
                    const Divider(color: Color(0xFFCCA236)),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            isUrdu ? "واجب الزکوٰۃ (2.5%):" : "Zakat Payable (2.5%):",
                            style: GoogleFonts.inter(
                              color: const Color(0xFFCCA236),
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Flexible(
                          child: Text(
                            "${_payableZakat.round().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')} $_selectedCurr",
                            style: GoogleFonts.inter(
                              color: const Color(0xFFCCA236),
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              // Zakatable Assets
              Text(
                isUrdu ? "زکوٰۃ کے قابل اثاثے:" : "Zakatable Assets:",
                style: const TextStyle(color: Color(0xFFCCA236), fontWeight: FontWeight.bold, fontSize: 13),
              ),
              const SizedBox(height: 8),
              _buildInputRow(
                icon: "💵",
                label: isUrdu ? "نقد رقم اور بینک:" : "Cash & Bank:",
                controller: _cashController,
              ),
              _buildInputRow(
                icon: "🪙",
                label: isUrdu ? "سونا اور چاندی:" : "Gold & Silver:",
                controller: _goldController,
              ),
              _buildInputRow(
                icon: "📦",
                label: isUrdu ? "تجارتی مال:" : "Business:",
                controller: _businessController,
              ),
              _buildInputRow(
                icon: "📈",
                label: isUrdu ? "سرمایہ کاری:" : "Investments:",
                controller: _investController,
              ),
              const SizedBox(height: 14),
              Text(
                isUrdu ? "قرضہ اور واجبات:" : "Liabilities / Loans:",
                style: const TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold, fontSize: 13),
              ),
              const SizedBox(height: 8),
              _buildInputRow(
                icon: "🔻",
                label: isUrdu ? "فوری قرضہ:" : "Immediate Debts:",
                controller: _debtController,
              ),
              const SizedBox(height: 22),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _resetAll,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.redAccent,
                        side: const BorderSide(color: Colors.redAccent),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      icon: const Icon(Icons.refresh, size: 16),
                      label: Text(isUrdu ? "ری سیٹ" : "Reset", style: const TextStyle(fontSize: 12)),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              isUrdu
                                  ? "✨ الحمدللہ! واجب الزکوٰۃ: ${_payableZakat.round()} PKR"
                                  : "✨ Zakat Payable: ${_payableZakat.round()} PKR",
                            ),
                            backgroundColor: const Color(0xFF163024),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFCCA236),
                        foregroundColor: const Color(0xFF082017),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      icon: const Icon(Icons.save_alt, size: 16),
                      label: Text(
                        isUrdu ? "محفوظ کریں" : "Save",
                        style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 12),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String val) {
    return Row(
      children: [
        Expanded(child: Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12))),
        Flexible(
          child: Text(val, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14), overflow: TextOverflow.ellipsis),
        ),
      ],
    );
  }

  Widget _buildInputRow({
    required String icon,
    required String label,
    required TextEditingController controller,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white12),
      ),
      child: Row(
        children: [
          Text(icon, style: const TextStyle(fontSize: 16)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 100,
            child: TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.right,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
              decoration: const InputDecoration(
                hintText: '0',
                hintStyle: TextStyle(color: Colors.white30),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.symmetric(vertical: 8),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
