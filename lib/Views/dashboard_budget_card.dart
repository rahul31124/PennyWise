import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../services/budget_service.dart';

class DashboardBudgetCard extends StatefulWidget {
  final double monthExpense;
  final String currency;

  const DashboardBudgetCard({
    super.key,
    required this.monthExpense,
    required this.currency,
  });

  @override
  State<DashboardBudgetCard> createState() => _DashboardBudgetCardState();
}

class _DashboardBudgetCardState extends State<DashboardBudgetCard> {
  double _limit = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadBudget();
  }

  Future<void> _loadBudget() async {
    final val = await BudgetService.getBudget();
    if (mounted) {
      setState(() {
        _limit = val;
        _isLoading = false;
      });
    }
  }

  void _showSetDialog() {
    final controller = TextEditingController(text: _limit > 0 ? _limit.toStringAsFixed(0) : "");
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0), side: const BorderSide(color: Colors.black, width: 3)),
        title: Container(
          color: Colors.black,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          child: Text("MONTHLY TARGET", style: GoogleFonts.syne(fontWeight: FontWeight.w800, color: Colors.white, fontSize: 16)),
        ),
        titlePadding: EdgeInsets.zero,
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          autofocus: true,
          style: GoogleFonts.spaceMono(fontWeight: FontWeight.bold, fontSize: 18),
          decoration: InputDecoration(
            hintText: "e.g. 15000",
            filled: true,
            fillColor: const Color(0xFFF4F4F0),
            enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.black, width: 2), borderRadius: BorderRadius.zero),
            focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.black, width: 2), borderRadius: BorderRadius.zero),
          ),
        ),
        actions: [
          if (_limit > 0)
            TextButton(
              onPressed: () async {
                await BudgetService.removeBudget();
                await _loadBudget();
                if (context.mounted) Navigator.pop(context);
              },
              child: Text("REMOVE", style: GoogleFonts.plusJakartaSans(color: Colors.red, fontWeight: FontWeight.bold)),
            ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: const Color(0xFFD4FF5E),
              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
            onPressed: () async {
              final val = double.tryParse(controller.text);
              if (val != null) {
                await BudgetService.setBudget(val);
                await _loadBudget();
              }
              if (context.mounted) Navigator.pop(context);
            },
            child: Text("SAVE TARGET", style: GoogleFonts.syne(fontWeight: FontWeight.bold)),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return const SizedBox(height: 100, child: Center(child: CircularProgressIndicator(color: Colors.black)));

    if (_limit == 0) {
      return GestureDetector(
        onTap: _showSetDialog,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: const Color(0xFFD4FF5E), // Lime
            border: Border.all(color: Colors.black, width: 3),
            boxShadow: const [BoxShadow(color: Colors.black, offset: Offset(6, 6), blurRadius: 0)],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(LucideIcons.target, size: 28, color: Colors.black),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("NO BUDGET SET", style: GoogleFonts.syne(fontSize: 16, fontWeight: FontWeight.w800)),
                  Text("Tap to define limit", style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w600)),
                ],
              ),
            ],
          ),
        ),
      );
    }

    final progress = (widget.monthExpense / _limit).clamp(0.0, 1.0);
    final isOver = widget.monthExpense > _limit;
    final remaining = _limit - widget.monthExpense;

    final statusColor = isOver ? const Color(0xFFFF5252) : const Color(0xFFD4FF5E);
    final statusBg = isOver ? const Color(0xFFFFE5E5) : const Color(0xFFF4F4F0);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black, width: 3),
        boxShadow: const [BoxShadow(color: Colors.black, offset: Offset(6, 6), blurRadius: 0)],
      ),
      child: Column(
        children: [
          // HEADER STRIP
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: const BoxDecoration(
              color: Colors.black,
              border: Border(bottom: BorderSide(color: Colors.black, width: 3)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("MONTHLY TARGET", style: GoogleFonts.syne(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12, letterSpacing: 1)),
                GestureDetector(
                  onTap: _showSetDialog,
                  child: const Icon(LucideIcons.settings, color: Colors.white, size: 16),
                )
              ],
            ),
          ),

          // CONTENT
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Status Pill
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusBg,
                    border: Border.all(color: Colors.black, width: 1.5),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(isOver ? LucideIcons.alertTriangle : LucideIcons.check, size: 12, color: Colors.black),
                      const SizedBox(width: 6),
                      Text(
                        isOver ? "OVER LIMIT" : "${(progress * 100).toInt()}% UTILIZED",
                        style: GoogleFonts.spaceMono(fontSize: 10, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Main Numbers
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      "${widget.currency}${widget.monthExpense.toStringAsFixed(0)}",
                      style: GoogleFonts.syne(fontSize: 36, fontWeight: FontWeight.w900, color: Colors.black, height: 1.0),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "/ ${widget.currency}${_limit.toStringAsFixed(0)}",
                      style: GoogleFonts.spaceMono(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey[600]),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Bold Progress Bar
                Stack(
                  children: [
                    Container(
                        height: 20,
                        width: double.infinity,
                        decoration: BoxDecoration(color: Colors.grey[200], border: Border.all(color: Colors.black, width: 2))
                    ),
                    FractionallySizedBox(
                      widthFactor: progress,
                      child: Container(
                        height: 20,
                        decoration: BoxDecoration(
                          color: statusColor,
                          border: Border.all(color: Colors.black, width: 2),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Footer
                Text(
                  isOver
                      ? "EXCEEDED BY ${widget.currency}${(remaining.abs()).toStringAsFixed(0)}"
                      : "${widget.currency}${remaining.toStringAsFixed(0)} AVAILABLE",
                  style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: isOver ? Colors.red : Colors.grey[600],
                      letterSpacing: 0.5
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}