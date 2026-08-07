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
  String _nisabBasis = 'silver'; // silver or gold
  String _selectedCurr = 'PKR';
  static const Map<String, Map<String, dynamic>> _currencyRates = {
    'PKR': {'nameUr': 'پاکستان', 'nameEn': 'Pakistan', 'flag': '🇵🇰', 'silver': 198000.0, 'gold': 1850000.0, 'sStr': '198,000 PKR', 'gStr': '1,850,000 PKR'},
    'SAR': {'nameUr': 'سعودی عرب', 'nameEn': 'Saudi Arabia', 'flag': '🇸🇦', 'silver': 2140.0, 'gold': 24500.0, 'sStr': '2,140 SAR', 'gStr': '24,500 SAR'},
    'AED': {'nameUr': 'امارات', 'nameEn': 'UAE', 'flag': '🇦🇪', 'silver': 2080.0, 'gold': 24000.0, 'sStr': '2,080 AED', 'gStr': '24,000 AED'},
    'GBP': {'nameUr': 'برطانیہ', 'nameEn': 'United Kingdom', 'flag': '🇬🇧', 'silver': 440.0, 'gold': 5250.0, 'sStr': '£440 GBP', 'gStr': '£5,250 GBP'},
    'USD': {'nameUr': 'امریکہ / عالمی', 'nameEn': 'USA / Global', 'flag': '🇺🇸', 'silver': 560.0, 'gold': 6560.0, 'sStr': '\$560 USD', 'gStr': '\$6,560 USD'},
    'INR': {'nameUr': 'بھارت', 'nameEn': 'India', 'flag': '🇮🇳', 'silver': 52000.0, 'gold': 630000.0, 'sStr': '₹52,000 INR', 'gStr': '₹630,000 INR'},
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
      zakat = net * 0.025; // 2.5% Shariah Zakat
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
      backgroundColor: const Color(0xFF081B15),
      appBar: AppBar(
        backgroundColor: const Color(0xFF081B15),
        elevation: 0,
        title: Text(
          isUrdu ? "زکوٰۃ کیلکولیٹر (Zakat Calculator)" : "Zakat Calculator",
          style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
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
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text(
                          '${rate['flag']} $code',
                          style: TextStyle(
                            color: isSel ? const Color(0xFF081B15) : Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                        selected: isSel,
                        selectedColor: const Color(0xFFD4AF37),
                        backgroundColor: const Color(0xFF0C231B),
                        onSelected: (_) {
                          setState(() => _selectedCurr = code);
                          _calculate();
                        },
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 14),

              // Custom Islamic Nisab Toggle (No Native Select!)
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _nisabBasis == 'silver' ? const Color(0xFFD4AF37) : const Color(0xFF0C231B),
                        foregroundColor: _nisabBasis == 'silver' ? const Color(0xFF081B15) : Colors.white,
                        side: const BorderSide(color: Color(0xFFD4AF37)),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      onPressed: () {
                        setState(() => _nisabBasis = 'silver');
                        _calculate();
                      },
                      child: Text(
                        isUrdu
                            ? '🪙 چاندی (~${_currencyRates[_selectedCurr]!['sStr']})'
                            : '🪙 Silver (~${_currencyRates[_selectedCurr]!['sStr']})',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _nisabBasis == 'gold' ? const Color(0xFFD4AF37) : const Color(0xFF0C231B),
                        foregroundColor: _nisabBasis == 'gold' ? const Color(0xFF081B15) : Colors.white,
                        side: const BorderSide(color: Color(0xFFD4AF37)),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      onPressed: () {
                        setState(() => _nisabBasis = 'gold');
                        _calculate();
                      },
                      child: Text(
                        isUrdu
                            ? '👑 سونا (~${_currencyRates[_selectedCurr]!['gStr']})'
                            : '👑 Gold (~${_currencyRates[_selectedCurr]!['gStr']})',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Executive Summary Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [Color(0xFF0F2C23), Color(0xFF091D17)]),
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: const Color(0xFFD4AF37), width: 1.5),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.5), blurRadius: 20),
                  ],
                ),
                child: Column(
                  children: [
                    _buildSummaryRow(
                      isUrdu ? "کل اثاثے:" : "Total Assets:",
                      "${_totalAssets.round().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')} $_selectedCurr",
                    ),
                    const SizedBox(height: 10),
                    _buildSummaryRow(
                      isUrdu ? "نصاب کی حد:" : "Nisab Threshold:",
                      "${nisabVal.round().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')} $_selectedCurr",
                    ),
                    const SizedBox(height: 12),
                    const Divider(color: Color(0xFFD4AF37)),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          isUrdu ? "واجب الادا زکوٰۃ (2.5%):" : "Payable Zakat (2.5%):",
                          style: GoogleFonts.inter(
                            color: const Color(0xFFD4AF37),
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "${_payableZakat.round().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')} $_selectedCurr",
                          style: GoogleFonts.inter(
                            color: const Color(0xFFD4AF37),
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // Zakatable Assets
              Text(
                isUrdu ? "زکوٰۃ کے قابل اثاثے (Zakatable Assets):" : "Zakatable Assets:",
                style: const TextStyle(color: Color(0xFFD4AF37), fontWeight: FontWeight.bold, fontSize: 14),
              ),
              const SizedBox(height: 10),
              _buildInputRow(
                icon: "💵",
                label: isUrdu ? "نقد رقم اور بینک بیلنس (Cash):" : "Cash & Bank Balance:",
                controller: _cashController,
              ),
              _buildInputRow(
                icon: "🪙",
                label: isUrdu ? "سونا اور چاندی کی مالیت (Gold/Silver):" : "Gold & Silver Value:",
                controller: _goldController,
              ),
              _buildInputRow(
                icon: "📦",
                label: isUrdu ? "تجارتی مال اور انوینٹری (Business):" : "Business Inventory:",
                controller: _businessController,
              ),
              _buildInputRow(
                icon: "📈",
                label: isUrdu ? "سرمایہ کاری، شیئرز اور پلاٹ (Investments):" : "Investments & Resale Property:",
                controller: _investController,
              ),
              const SizedBox(height: 20),
              Text(
                isUrdu ? "منفی کی جانے والی رقم (Liabilities / Debts):" : "Liabilities / Loans:",
                style: const TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold, fontSize: 14),
              ),
              const SizedBox(height: 10),
              _buildInputRow(
                icon: "🔻",
                label: isUrdu ? "واجب الادا قرضہ یا بل (Immediate Debts):" : "Immediate Debts & Loans:",
                controller: _debtController,
              ),
              const SizedBox(height: 28),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _resetAll,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.redAccent,
                        side: const BorderSide(color: Colors.redAccent),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      icon: const Icon(Icons.refresh),
                      label: Text(isUrdu ? "ری سیٹ کریں" : "Reset All"),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              isUrdu
                                  ? "✨ الحمدللہ! آپ کی واجب الادا زکوٰۃ: ${_payableZakat.round()} PKR"
                                  : "✨ Alhamdulillah! Payable Zakat: ${_payableZakat.round()} PKR",
                            ),
                            backgroundColor: const Color(0xFF0F2C23),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFD4AF37),
                        foregroundColor: const Color(0xFF081B15),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      icon: const Icon(Icons.save_alt),
                      label: Text(
                        isUrdu ? "حساب محفوظ کریں" : "Save Summary",
                        style: GoogleFonts.inter(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String val) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 13)),
        Text(val, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
      ],
    );
  }

  Widget _buildInputRow({
    required String icon,
    required String label,
    required TextEditingController controller,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(icon, style: const TextStyle(fontSize: 18)),
              const SizedBox(width: 8),
              Text(label, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
            ],
          ),
          SizedBox(
            width: 110,
            child: TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.right,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              decoration: const InputDecoration(
                hintText: '0',
                hintStyle: TextStyle(color: Colors.white30),
                border: InputBorder.none,
                isDense: true,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
