import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart'; // Needed for the font style
import 'package:lucide_icons/lucide_icons.dart';

import '../providers/settings_providers.dart';

class CurrencySelectionScreen extends ConsumerStatefulWidget {
  const CurrencySelectionScreen({super.key});

  @override
  ConsumerState<CurrencySelectionScreen> createState() => _CurrencySelectionScreenState();
}

class _CurrencySelectionScreenState extends ConsumerState<CurrencySelectionScreen> {
  String _selectedCurrency = 'INR';

  final Color _bg = const Color(0xFFFFFDF5);
  final Color _black = const Color(0xFF111111);
  final Color _lime = const Color(0xFFD4FF5E);
  final Color _white = const Color(0xFFFFFFFF);

  final List<Map<String, String>> _currencies = [
    {'code': 'INR', 'symbol': '₹', 'name': 'Indian Rupee'},
    {'code': 'USD', 'symbol': '\$', 'name': 'US Dollar'},
    {'code': 'EUR', 'symbol': '€', 'name': 'Euro'},
    {'code': 'GBP', 'symbol': '£', 'name': 'British Pound'},
    {'code': 'JPY', 'symbol': '¥', 'name': 'Japanese Yen'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Spacer(),

              Center(
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: _lime,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: _black, width: 3),
                    boxShadow: [BoxShadow(color: _black, offset: const Offset(4, 4), blurRadius: 0)],
                  ),
                  child: Icon(LucideIcons.wallet, size: 48, color: _black),
                ),
              ),
              const SizedBox(height: 48),


              Text(
                "SETUP\nCURRENCY",
                style: GoogleFonts.syne(
                  fontSize: 42,
                  fontWeight: FontWeight.w900,
                  height: 1.0,
                  color: _black,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                "Select your default currency to track your wealth accurately.",
                style: GoogleFonts.plusJakartaSans(fontSize: 16, color: _black, fontWeight: FontWeight.w500, height: 1.5),
              ),

              const SizedBox(height: 48),


              Text(
                  "PREFERENCE",
                  style: GoogleFonts.spaceMono(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[600],
                  )
              ),
              const SizedBox(height: 10),


              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                decoration: BoxDecoration(
                  color: _white,
                  border: Border.all(color: _black, width: 2),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(color: _black, offset: const Offset(4, 4), blurRadius: 0),
                  ],
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedCurrency,
                    isExpanded: true,
                    icon: Icon(LucideIcons.chevronDown, color: _black),
                    dropdownColor: _white,
                    items: _currencies.map((currency) {
                      return DropdownMenuItem(
                        value: currency['code'],
                        child: Row(
                          children: [
                            Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                color: _lime,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: _black, width: 1.5),
                              ),
                              child: Center(
                                child: Text(
                                  currency['symbol']!,
                                  style: GoogleFonts.spaceMono(
                                      color: _black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                    currency['code']!,
                                    style: GoogleFonts.plusJakartaSans(
                                        fontWeight: FontWeight.bold,
                                        color: _black,
                                        fontSize: 16
                                    )
                                ),
                                Text(
                                    currency['name']!,
                                    style: GoogleFonts.plusJakartaSans(
                                        fontSize: 12,
                                        color: Colors.grey[600],
                                        fontWeight: FontWeight.w600
                                    )
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _selectedCurrency = value;
                        });
                      }
                    },
                  ),
                ),
              ),

              const Spacer(),


              SizedBox(
                width: double.infinity,
                height: 64,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _black,
                    foregroundColor: _lime,
                    elevation: 0,
                    side: BorderSide(color: _black, width: 2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    shadowColor: Colors.transparent,
                  ),
                  onPressed: () async {
                    await ref.read(currencyProvider.notifier).saveCurrency(_selectedCurrency);
                    if (context.mounted) {
                      context.go('/');
                    }
                  },
                  child: Text(
                    "GET STARTED",
                    style: GoogleFonts.syne(fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 1),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}