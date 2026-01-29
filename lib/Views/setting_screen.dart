import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../providers/settings_providers.dart';
import '../providers/transaction_providers.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  final Color _bg = const Color(0xFFFFFDF5);
  final Color _black = const Color(0xFF111111);
  final Color _lime = const Color(0xFFD4FF5E);
  final Color _white = const Color(0xFFFFFFFF);
  final Color _purple = const Color(0xFF9F7AEA);
  final Color _red = const Color(0xFFEF4444);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currencyAsync = ref.watch(currencyProvider);
    final currentCurrency = currencyAsync.value ?? '₹';

    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: _bg,
        elevation: 0,
        centerTitle: true,
        toolbarHeight: 70,
        automaticallyImplyLeading: false,
        title: Text(
          "SETTINGS",
          style: GoogleFonts.syne(
            color: _black,
            fontSize: 22,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 120),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _NeoSectionHeader("GENERAL"),
            const SizedBox(height: 12),
            _NeoSettingsContainer(
              children: [
                _NeoSettingsTile(
                  icon: LucideIcons.banknote,
                  title: "CURRENCY",
                  subtitle: "Active: $currentCurrency",
                  onTap: () => _showCurrencyPicker(context, ref, currentCurrency),
                  iconBg: const Color(0xFFFFD54F),
                ),
                _NeoDivider(),
                _NeoSettingsTile(
                  icon: LucideIcons.bell,
                  title: "NOTIFICATIONS",
                  subtitle: "Manage alerts",
                  onTap: () {},
                  iconBg: const Color(0xFF63B3ED),
                  trailing: Switch.adaptive(
                    value: true,
                    onChanged: (val) {},
                    activeColor: _lime,
                    activeTrackColor: _black,
                    inactiveThumbColor: _black,
                    inactiveTrackColor: Colors.grey[300],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 32),

            _NeoSectionHeader("DATA & SECURITY"),
            const SizedBox(height: 12),
            _NeoSettingsContainer(
              children: [
                _NeoSettingsTile(
                  icon: LucideIcons.cloud,
                  title: "BACKUPS",
                  subtitle: "Google Drive Sync",
                  onTap: () {},
                  iconBg: _purple,
                  trailing: _NeoBadge(text: "SOON"),
                ),
                _NeoDivider(),
                _NeoSettingsTile(
                  icon: LucideIcons.trash2,
                  title: "RESET DATA",
                  subtitle: "Clear all transactions",
                  onTap: () => _showResetDialog(context, ref),
                  iconBg: const Color(0xFFFFE5E5),
                  iconColor: _red,
                ),
              ],
            ),

            const SizedBox(height: 32),

            _NeoSectionHeader("ABOUT"),
            const SizedBox(height: 12),
            _NeoSettingsContainer(
              children: [
                _NeoSettingsTile(
                  icon: LucideIcons.shieldCheck,
                  title: "PRIVACY POLICY",
                  subtitle: "Read our terms",
                  onTap: () => _showPrivacyPolicy(context),
                  iconBg: const Color(0xFF4FD1C5),
                  showArrow: true,
                ),
                _NeoDivider(),
                _NeoSettingsTile(
                  icon: LucideIcons.info,
                  title: "VERSION",
                  subtitle: "v1.0.0 (Beta)",
                  onTap: () {},
                  iconBg: Colors.grey[300]!,
                  showArrow: false,
                ),
              ],
            ),

            const SizedBox(height: 50),

            Center(
              child: Column(
                children: [
                  Icon(LucideIcons.heart, size: 20, color: _black),
                  const SizedBox(height: 8),
                  Text(
                    "PennyWise",
                    style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey[500]),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showResetDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: _white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: BorderSide(color: _black, width: 3)),
        title: Text("WIPE DATA?", style: GoogleFonts.syne(fontWeight: FontWeight.w800, fontSize: 20)),
        content: Text("This will delete ALL your transactions permanently. You cannot undo this.", style: GoogleFonts.plusJakartaSans(fontSize: 14, fontWeight: FontWeight.w600)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("CANCEL", style: GoogleFonts.plusJakartaSans(color: Colors.grey, fontWeight: FontWeight.bold)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: _red, foregroundColor: _white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8), side: BorderSide(color: _black, width: 2)),
              elevation: 0,
            ),
            onPressed: () async {
              await ref.read(transactionRepositoryProvider).clearAllData();
              if (context.mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("All data wiped.", style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold, color: _white)),
                      backgroundColor: _black,
                    )
                );
              }
            },
            child: Text("WIPE ALL", style: GoogleFonts.syne(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void _showCurrencyPicker(BuildContext context, WidgetRef ref, String current) {
    final List<Map<String, String>> currencies = [
      {'symbol': '₹', 'name': 'Indian Rupee'},
      {'symbol': '\$', 'name': 'US Dollar'},
      {'symbol': '€', 'name': 'Euro'},
      {'symbol': '£', 'name': 'British Pound'},
      {'symbol': '¥', 'name': 'Japanese Yen'},
      {'symbol': '₩', 'name': 'Korean Won'},
      {'symbol': '₽', 'name': 'Russian Ruble'},
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.6,
          decoration: BoxDecoration(
            color: _white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            border: Border.all(color: _black, width: 3),
          ),
          child: Column(
            children: [
              const SizedBox(height: 16),
              Center(child: Container(width: 50, height: 6, color: _black)),
              const SizedBox(height: 24),
              Text("SELECT CURRENCY", style: GoogleFonts.syne(fontSize: 20, fontWeight: FontWeight.w800)),
              const SizedBox(height: 20),

              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
                  itemCount: currencies.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final item = currencies[index];
                    final symbol = item['symbol']!;
                    final name = item['name']!;
                    final isSelected = symbol == current;

                    return GestureDetector(
                      onTap: () async {
                        final prefs = await SharedPreferences.getInstance();
                        await prefs.setString('currency_code', symbol);
                        ref.refresh(currencyProvider);
                        if (context.mounted) Navigator.pop(context);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        decoration: BoxDecoration(
                          color: isSelected ? _lime : _white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: _black, width: 2),
                          boxShadow: isSelected
                              ? [const BoxShadow(color: Colors.black, offset: Offset(2, 2))]
                              : [],
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 40, height: 40,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(color: _black, shape: BoxShape.circle),
                              child: Text(symbol, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                            ),
                            const SizedBox(width: 16),
                            Text(name, style: GoogleFonts.plusJakartaSans(fontSize: 16, fontWeight: FontWeight.bold, color: _black)),
                            const Spacer(),
                            if (isSelected) Icon(LucideIcons.checkCircle, color: _black, size: 24),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showPrivacyPolicy(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.7,
          decoration: BoxDecoration(
            color: _white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            border: Border.all(color: _black, width: 3),
          ),
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(child: Container(width: 50, height: 6, color: _black)),
              const SizedBox(height: 24),
              Text("PRIVACY POLICY", style: GoogleFonts.syne(fontSize: 22, fontWeight: FontWeight.w800)),
              const SizedBox(height: 16),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Last Updated: Jan 2026", style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey[600])),
                      const SizedBox(height: 20),
                      Text("1. No Data Collection", style: GoogleFonts.syne(fontSize: 16, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Text("We do not collect, store, or share any of your personal data. PennyWise is a strictly offline-first application.", style: GoogleFonts.plusJakartaSans(fontSize: 14, height: 1.5, color: _black)),
                      const SizedBox(height: 20),
                      Text("2. Local Storage", style: GoogleFonts.syne(fontSize: 16, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Text("All your financial data resides solely on your device's internal storage. We have no access to your transactions or budget details.", style: GoogleFonts.plusJakartaSans(fontSize: 14, height: 1.5, color: _black)),
                      const SizedBox(height: 20),
                      Text("3. Attributions", style: GoogleFonts.syne(fontSize: 16, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Text("Budget icons created by Ida Desi Mariana - Flaticon", style: GoogleFonts.plusJakartaSans(fontSize: 14, height: 1.5, color: _black)),
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _black,
                    foregroundColor: _lime,
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: _black, width: 2)),
                    elevation: 0,
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: Text("I UNDERSTAND", style: GoogleFonts.syne(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}

class _NeoSectionHeader extends StatelessWidget {
  final String title;
  const _NeoSectionHeader(this.title);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: const Color(0xFF111111), borderRadius: BorderRadius.circular(4)),
      child: Text(title, style: GoogleFonts.plusJakartaSans(fontSize: 10, fontWeight: FontWeight.w800, color: Colors.white, letterSpacing: 1)),
    );
  }
}

class _NeoSettingsContainer extends StatelessWidget {
  final List<Widget> children;
  const _NeoSettingsContainer({required this.children});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.black, width: 2), boxShadow: const [BoxShadow(color: Colors.black, offset: Offset(4, 4))]),
      child: Column(children: children),
    );
  }
}

class _NeoSettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final Color iconBg;
  final Color? iconColor;
  final Widget? trailing;
  final bool showArrow;

  const _NeoSettingsTile({required this.icon, required this.title, required this.subtitle, required this.onTap, required this.iconBg, this.iconColor, this.trailing, this.showArrow = false});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: iconBg, borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.black, width: 2)),
              child: Icon(icon, color: iconColor ?? Colors.black, size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: GoogleFonts.plusJakartaSans(fontSize: 14, fontWeight: FontWeight.w800, color: Colors.black)),
                  const SizedBox(height: 2),
                  Text(subtitle, style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.grey[600])),
                ],
              ),
            ),
            if (trailing != null) trailing!,
            if (showArrow) Icon(LucideIcons.arrowRight, size: 20, color: Colors.black),
          ],
        ),
      ),
    );
  }
}

class _NeoDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Divider(height: 1, thickness: 2, color: Colors.black);
}

class _NeoBadge extends StatelessWidget {
  final String text;
  const _NeoBadge({required this.text});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(6)),
      child: Text(text, style: GoogleFonts.plusJakartaSans(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white)),
    );
  }
}