import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:google_fonts/google_fonts.dart';

import '../providers/settings_providers.dart';
import '../providers/transaction_providers.dart';
import 'dashboard_budget_card.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  final Color _bg = const Color(0xFFFFFDF5);
  final Color _black = const Color(0xFF111111);
  final Color _white = const Color(0xFFFFFFFF);
  final Color _limePop = const Color(0xFFD4FF5E);
  final Color _purple = const Color(0xFF8B5CF6);
  final Color _yellow = const Color(0xFF022215);

  final double _borderWidth = 2.0;
  final double _shadowOffset = 4.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currencyAsync = ref.watch(currencyProvider);
    final currencySymbol = currencyAsync.value ?? '₹';
    final transactionListAsync = ref.watch(transactionListProvider);


    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 360;

    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: _bg,
        elevation: 0,
        toolbarHeight: 80,
        title: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: _limePop,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: _black, width: _borderWidth),
            boxShadow: [
              BoxShadow(
                  color: _black,
                  offset: const Offset(3, 3),
                  blurRadius: 0
              )
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(LucideIcons.zap, size: 20, color: Colors.black),
              const SizedBox(width: 8),
              Flexible(
                child: RichText(
                  overflow: TextOverflow.ellipsis,
                  text: TextSpan(
                    style: GoogleFonts.syne(
                      fontSize: isSmallScreen ? 10 : 13,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.5,
                    ),
                    children: [
                      TextSpan(text: "Penny", style: TextStyle(color: _black)),
                      TextSpan(text: "Wise", style: TextStyle(color: _yellow)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        centerTitle: false,
        actions: [
          GestureDetector(
            onTap: () {
           //Todo
            },
            child: Container(
              margin: const EdgeInsets.only(right: 20),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: _white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: _black, width: _borderWidth),
                boxShadow: [BoxShadow(color: _black, offset: Offset(2, 2), blurRadius: 0)],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(LucideIcons.star, size: 16, color: _black),
                  if (!isSmallScreen) ...[
                    const SizedBox(width: 6),
                    Text("RATE US", style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w800, color: _black)),
                  ]
                ],
              ),
            ),
          )
        ],
      ),

      body: transactionListAsync.when(
        loading: () => Center(child: CircularProgressIndicator(color: _black)),
        error: (err, stack) => Center(child: Text('Error: $err')),
        data: (transactions) {
          double totalIncome = 0;
          double totalExpense = 0;
          for (var t in transactions) {
            if (t.type == 'income') totalIncome += t.amount;
            else totalExpense += t.amount;
          }
          final totalBalance = totalIncome - totalExpense;

          final now = DateTime.now();
          final currentMonthExpenses = transactions.where((t) =>
          t.type == 'expense' &&
              t.date.year == now.year &&
              t.date.month == now.month
          ).fold(0.0, (sum, t) => sum + t.amount);

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [


                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: _purple,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: _black, width: _borderWidth),
                    boxShadow: [BoxShadow(color: _black, offset: Offset(_shadowOffset, _shadowOffset), blurRadius: 0)],
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("TOTAL BALANCE", style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w700, letterSpacing: 1.0, color: _white)),
                                InkWell(
                                  onTap: () => context.go('/history'),
                                  child: Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(color: _white, shape: BoxShape.circle),
                                    child: Icon(LucideIcons.arrowRight, size: 16, color: _purple),
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(height: 12),
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                "$currencySymbol ${totalBalance.toStringAsFixed(0)}",
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 42,
                                  fontWeight: FontWeight.w800,
                                  color: _white,
                                  height: 1.1,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      Container(height: _borderWidth, color: _white),

                      IntrinsicHeight(
                        child: Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(children: [
                                      Icon(LucideIcons.arrowDownLeft, size: 16, color: _limePop),
                                      SizedBox(width: 6),
                                      Expanded(
                                          child: Text("INCOME", style: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.w800, color: _white.withOpacity(0.9)))
                                      )
                                    ]),
                                    const SizedBox(height: 4),
                                    FittedBox(
                                      fit: BoxFit.scaleDown,
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                          "$currencySymbol${totalIncome.toInt()}",
                                          style: GoogleFonts.plusJakartaSans(fontSize: 18, fontWeight: FontWeight.w700, color: _white)
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            Container(width: _borderWidth, color: _white),

                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(children: [
                                      Icon(LucideIcons.arrowUpRight, size: 16, color: _white),
                                      SizedBox(width: 6),
                                      Expanded(
                                          child: Text("EXPENSE", style: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.w800, color: _white.withOpacity(0.9)))
                                      )
                                    ]),
                                    const SizedBox(height: 4),
                                    FittedBox(
                                      fit: BoxFit.scaleDown,
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                          "$currencySymbol${totalExpense.toInt()}",
                                          style: GoogleFonts.plusJakartaSans(fontSize: 18, fontWeight: FontWeight.w700, color: _white)
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),

                const SizedBox(height: 40),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("BUDGET TRACKER", style: GoogleFonts.plusJakartaSans(fontSize: 16, fontWeight: FontWeight.w800, color: _black, letterSpacing: 0.5)),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(20)),
                      child: Text("THIS MONTH", style: GoogleFonts.plusJakartaSans(fontSize: 10, fontWeight: FontWeight.bold)),
                    )
                  ],
                ),

                const SizedBox(height: 20),

                DashboardBudgetCard(
                  monthExpense: currentMonthExpenses,
                  currency: currencySymbol,
                ),

                const SizedBox(height: 100),
              ],
            ),
          );
        },
      ),
    );
  }
}