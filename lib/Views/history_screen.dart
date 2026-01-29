import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'dart:math';

import '../providers/transaction_providers.dart';
import '../providers/settings_providers.dart';
import '../providers/app_database.dart';

const Map<String, String> categoryEmojis = {
  'food': '🍔', 'transport': '🚕', 'shopping': '🛍️', 'entertainment': '🍿', 'bills': '⚡', 'health': '❤️', 'education': '🎓', 'other': '📦',
  'salary': '💸', 'freelance': '💻', 'invest': '📈', 'gift': '🎁', 'rental': '🏠', 'refund': '↩️',
};

class HistoryScreen extends ConsumerStatefulWidget {
  const HistoryScreen({super.key});

  @override
  ConsumerState<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends ConsumerState<HistoryScreen> {
  String _filterType = 'All';
  late DateTimeRange _dateRange;

  final Color _bg = const Color(0xFFFFFDF5);
  final Color _black = const Color(0xFF111111);
  final Color _lime = const Color(0xFFD4FF5E);
  final Color _white = const Color(0xFFFFFFFF);
  final Color _red = const Color(0xFFEF4444);
  final Color _green = const Color(0xFF22C55E);

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _dateRange = DateTimeRange(start: now.subtract(const Duration(days: 30)), end: now);
  }

  Future<void> _pickDateRange() async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      initialDateRange: _dateRange,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(primary: _black, onPrimary: _white, surface: _lime),
            dialogBackgroundColor: _white,
          ),
          child: child!,
        );
      },
    );
    if (picked != null) setState(() => _dateRange = picked);
  }

  void _deleteTransaction(Transaction t) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: _white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: BorderSide(color: _black, width: 3)),
        title: Text("DELETE?", style: GoogleFonts.syne(fontWeight: FontWeight.w800, fontSize: 20)),
        content: Text("Permanently remove this transaction?", style: GoogleFonts.plusJakartaSans(fontSize: 14, fontWeight: FontWeight.w600)),
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
              await ref.read(transactionRepositoryProvider).deleteTransaction(t.id);
              if (mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Transaction Deleted", style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold, color: _white)),
                      backgroundColor: _black,
                      behavior: SnackBarBehavior.floating,
                    )
                );
              }
            },
            child: Text("DELETE", style: GoogleFonts.syne(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void _showDetails(Transaction t, String currency) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _NeoDetailsSheet(
          t: t,
          currency: currency,
          onDelete: () {
            Navigator.pop(context);
            _deleteTransaction(t);
          }
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currencyAsync = ref.watch(currencyProvider);
    final currencySymbol = currencyAsync.value ?? '₹';
    final transactionListAsync = ref.watch(transactionListProvider);

    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: _bg,
        elevation: 0,
        centerTitle: true,
        toolbarHeight: 70,
        title: Text("HISTORY", style: GoogleFonts.syne(color: _black, fontSize: 22, fontWeight: FontWeight.w800)),
      ),
      body: transactionListAsync.when(
        loading: () => Center(child: CircularProgressIndicator(color: _black)),
        error: (err, stack) => Center(child: Text('Error: $err')),
        data: (allTransactions) {
          final filtered = allTransactions.where((t) {
            final isAfterStart = t.date.isAfter(_dateRange.start.subtract(const Duration(seconds: 1)));
            final isBeforeEnd = t.date.isBefore(_dateRange.end.add(const Duration(days: 1)));
            final matchesType = _filterType == 'All' || (_filterType == 'Income' && t.type == 'income') || (_filterType == 'Expense' && t.type == 'expense');
            return isAfterStart && isBeforeEnd && matchesType;
          }).toList();

          filtered.sort((a, b) => b.date.compareTo(a.date));

          return Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: _pickDateRange,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        decoration: BoxDecoration(color: _white, borderRadius: BorderRadius.circular(12), border: Border.all(color: _black, width: 2), boxShadow: const [BoxShadow(color: Colors.black, offset: Offset(4, 4))]),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(children: [Icon(LucideIcons.calendar, size: 20, color: _black), const SizedBox(width: 12), Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text("DATE RANGE", style: GoogleFonts.plusJakartaSans(fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1)), Text("${DateFormat('dd MMM').format(_dateRange.start)} - ${DateFormat('dd MMM').format(_dateRange.end)}", style: GoogleFonts.plusJakartaSans(fontSize: 14, fontWeight: FontWeight.w800, color: _black))])]),
                            Icon(LucideIcons.chevronDown, size: 20, color: _black),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(color: _white, borderRadius: BorderRadius.circular(12), border: Border.all(color: _black, width: 2)),
                      child: Row(children: [_NeoFilterTab(label: "ALL", isActive: _filterType == 'All', onTap: () => setState(() => _filterType = 'All'), activeColor: _lime), _NeoFilterTab(label: "INCOME", isActive: _filterType == 'Income', onTap: () => setState(() => _filterType = 'Income'), activeColor: _green), _NeoFilterTab(label: "EXPENSE", isActive: _filterType == 'Expense', onTap: () => setState(() => _filterType = 'Expense'), activeColor: _red)]),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: filtered.isEmpty
                    ? Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(LucideIcons.ghost, size: 48, color: Colors.grey[400]), const SizedBox(height: 16), Text("NO DATA FOUND", style: GoogleFonts.syne(color: Colors.grey[500], fontWeight: FontWeight.bold, fontSize: 16))]))
                    : ListView.separated(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 100),
                  itemCount: filtered.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final t = filtered[index];
                    bool showHeader = index == 0 || !_isSameDay(filtered[index - 1].date, t.date);
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (showHeader) Padding(padding: const EdgeInsets.only(top: 8, bottom: 8), child: Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: _black, borderRadius: BorderRadius.circular(4)), child: Text(DateFormat('MMM dd, yyyy').format(t.date).toUpperCase(), style: GoogleFonts.plusJakartaSans(color: _lime, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1)))),
                        GestureDetector(
                          onTap: () => _showDetails(t, currencySymbol),
                          onLongPress: () => _deleteTransaction(t),
                          child: _NeoHistoryItem(t: t, currency: currencySymbol),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
  bool _isSameDay(DateTime a, DateTime b) => a.year == b.year && a.month == b.month && a.day == b.day;
}

class _NeoHistoryItem extends StatelessWidget {
  final Transaction t;
  final String currency;
  const _NeoHistoryItem({required this.t, required this.currency});

  @override
  Widget build(BuildContext context) {
    final isExpense = t.type == 'expense';
    final String emoji = categoryEmojis[t.categoryId] ?? (isExpense ? '💸' : '💰');

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.black, width: 2), boxShadow: const [BoxShadow(color: Colors.black, offset: Offset(2, 2))]),
      child: Row(children: [
        Container(width: 44, height: 44, alignment: Alignment.center, decoration: BoxDecoration(color: isExpense ? const Color(0xFFFFE5E5) : const Color(0xFFE5FFE9), borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.black, width: 2)), child: Text(emoji, style: const TextStyle(fontSize: 22))),
        const SizedBox(width: 16),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(t.note ?? "Untitled", style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black), maxLines: 1, overflow: TextOverflow.ellipsis), Text(DateFormat('hh:mm a').format(t.date), style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.grey[500]))])),
        Text("${isExpense ? '-' : '+'} $currency${t.amount.toStringAsFixed(0)}", style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w800, fontSize: 16, color: isExpense ? const Color(0xFFEF4444) : const Color(0xFF16A34A))),
      ]),
    );
  }
}

class _NeoFilterTab extends StatelessWidget {
  final String label; final bool isActive; final VoidCallback onTap; final Color activeColor;
  const _NeoFilterTab({required this.label, required this.isActive, required this.onTap, required this.activeColor});
  @override Widget build(BuildContext context) => Expanded(child: GestureDetector(onTap: onTap, child: AnimatedContainer(duration: const Duration(milliseconds: 150), padding: const EdgeInsets.symmetric(vertical: 10), decoration: BoxDecoration(color: isActive ? activeColor : Colors.transparent, borderRadius: BorderRadius.circular(10), border: isActive ? Border.all(color: Colors.black, width: 2) : null), alignment: Alignment.center, child: Text(label, style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w800, color: Colors.black)))));
}

class _NeoDetailsSheet extends StatelessWidget {
  final Transaction t;
  final String currency;
  final VoidCallback onDelete;

  const _NeoDetailsSheet({required this.t, required this.currency, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    final isExpense = t.type == 'expense';
    final String emoji = categoryEmojis[t.categoryId] ?? (isExpense ? '💸' : '💰');

    final Color borderColor = Colors.black;
    final Color paperColor = Colors.white;
    final Color labelColor = Colors.grey[600]!;

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFFFDF5),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        border: Border.all(color: borderColor, width: 3),
      ),
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 120),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(child: Container(width: 50, height: 6, decoration: BoxDecoration(color: borderColor, borderRadius: BorderRadius.circular(3)))),
          const SizedBox(height: 24),

          Text("TRANSACTION DETAILS", style: GoogleFonts.syne(fontSize: 14, fontWeight: FontWeight.w800, letterSpacing: 2)),
          const SizedBox(height: 20),

          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: paperColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: borderColor, width: 2),
              boxShadow: [BoxShadow(color: borderColor, offset: const Offset(6, 6), blurRadius: 0)],
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: isExpense ? const Color(0xFFFFE5E5) : const Color(0xFFE5FFE9),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: borderColor, width: 2),
                        ),
                        child: Text(emoji, style: const TextStyle(fontSize: 20)),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(t.categoryId.toUpperCase(), style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w900, letterSpacing: 1)),
                          Text(isExpense ? "EXPENSE" : "INCOME", style: GoogleFonts.plusJakartaSans(fontSize: 10, fontWeight: FontWeight.bold, color: labelColor)),
                        ],
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: borderColor,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text("SUCCESS", style: GoogleFonts.spaceMono(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                      )
                    ],
                  ),
                ),

                _DashedDivider(color: borderColor),

                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: Column(
                    children: [
                      Text("TOTAL AMOUNT", style: GoogleFonts.spaceMono(fontSize: 10, fontWeight: FontWeight.bold, color: labelColor)),
                      const SizedBox(height: 4),
                      Text(
                          "$currency${t.amount.toStringAsFixed(2)}",
                          style: GoogleFonts.syne(fontSize: 36, fontWeight: FontWeight.w900, color: borderColor)
                      ),
                    ],
                  ),
                ),

                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    border: Border(top: BorderSide(color: borderColor, width: 2)),
                    borderRadius: const BorderRadius.vertical(bottom: Radius.circular(10)),
                  ),
                  child: Column(
                    children: [
                      _ReceiptRow("DATE", DateFormat('dd MMM yyyy').format(t.date)),
                      const SizedBox(height: 12),
                      _ReceiptRow("TIME", DateFormat('hh:mm a').format(t.date)),
                      if (t.note != null && t.note!.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        Container(width: double.infinity, height: 1, color: Colors.grey[300]),
                        const SizedBox(height: 16),
                        Align(alignment: Alignment.centerLeft, child: Text("NOTE", style: GoogleFonts.spaceMono(fontSize: 10, fontWeight: FontWeight.bold, color: labelColor))),
                        const SizedBox(height: 4),
                        Align(alignment: Alignment.centerLeft, child: Text(t.note!, style: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.w600, color: borderColor))),
                      ]
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          SizedBox(
            height: 30,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(40, (index) => Container(
                width: Random().nextInt(3) + 1.0,
                margin: const EdgeInsets.symmetric(horizontal: 1),
                color: Colors.black.withOpacity(Random().nextDouble() > 0.3 ? 1 : 0),
              )),
            ),
          ),
          const SizedBox(height: 8),
          Text("TXN ID: ${t.id.substring(0, 8).toUpperCase()}", style: GoogleFonts.spaceMono(fontSize: 10, color: Colors.grey)),

          const SizedBox(height: 24),

          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  icon: const Icon(LucideIcons.trash2, size: 18),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFE5E5),
                    foregroundColor: const Color(0xFFEF4444),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: borderColor, width: 2)),
                    elevation: 0,
                  ),
                  onPressed: onDelete,
                  label: Text("DELETE", style: GoogleFonts.syne(fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: borderColor,
                    foregroundColor: const Color(0xFFD4FF5E),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: borderColor, width: 2)),
                    elevation: 0,
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: Text("CLOSE", style: GoogleFonts.syne(fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ReceiptRow extends StatelessWidget {
  final String label;
  final String value;
  const _ReceiptRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: GoogleFonts.spaceMono(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey[600])),
        Text(value, style: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.w800, color: Colors.black)),
      ],
    );
  }
}

class _DashedDivider extends StatelessWidget {
  final Color color;
  const _DashedDivider({required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(40, (index) => Expanded(
        child: Container(
          height: 2,
          color: index % 2 == 0 ? color : Colors.transparent,
        ),
      )),
    );
  }
}