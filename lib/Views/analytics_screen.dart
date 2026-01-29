import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:intl/intl.dart';

import '../providers/app_database.dart';
import '../providers/transaction_providers.dart';

class AnalyticsScreen extends ConsumerStatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  ConsumerState<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends ConsumerState<AnalyticsScreen> {
  late DateTimeRange _dateRange;
  String _chartMode = 'Breakdown';
  String _graphView = 'Daily';


  final Color _bg = const Color(0xFFF8F8F6);
  final Color _black = const Color(0xFF111111);
  final Color _lime = const Color(0xFFD4FF5E);
  final Color _white = const Color(0xFFFFFFFF);
  final Color _purple = const Color(0xFF9F7AEA);

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _dateRange = DateTimeRange(start: now.subtract(const Duration(days: 30)), end: now);
  }

  Future<void> _pickDateRange() async {
    final picked = await showDateRangePicker(
      context: context,
      initialDateRange: _dateRange,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: ColorScheme.light(primary: _black, onPrimary: _white, surface: _lime),
          dialogBackgroundColor: _white,
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _dateRange = picked);
  }

  @override
  Widget build(BuildContext context) {
    final transactionListAsync = ref.watch(transactionListProvider);

    const double bottomNavSpacer = 90.0;

    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: _bg,
        elevation: 0,
        centerTitle: true,
        toolbarHeight: 60,
        title: Text(
          "ANALYTICS",
          style: GoogleFonts.syne(color: _black, fontWeight: FontWeight.w800, fontSize: 22, letterSpacing: -0.5),
        ),
      ),
      body: transactionListAsync.when(
        loading: () => Center(child: CircularProgressIndicator(color: _black)),
        error: (err, stack) => Center(child: Text('Error: $err')),
        data: (transactions) {
          final filteredDocs = _filterByDate(transactions);
          final expenses = filteredDocs.where((t) => t.type == 'expense').toList();

          return SafeArea(
            bottom: false,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: _NeoButton(
                    onTap: _pickDateRange,
                    icon: LucideIcons.calendarDays,
                    label: "${DateFormat('MMM dd').format(_dateRange.start)} — ${DateFormat('MMM dd').format(_dateRange.end)}",
                    bgColor: _white,
                    textColor: _black,
                    height: 48,
                  ),
                ),

                const SizedBox(height: 16),

                Expanded(
                  child: Container(
                    margin: const EdgeInsets.fromLTRB(20, 0, 20, bottomNavSpacer),
                    decoration: _neoDecor(color: _white),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: const BorderRadius.vertical(top: Radius.circular(13)),
                              border: Border(bottom: BorderSide(color: _black, width: 2))
                          ),
                          child: Row(
                            children: [
                              _ChartTab("BREAKDOWN", _chartMode == 'Breakdown', () => setState(() => _chartMode = 'Breakdown')),
                              const SizedBox(width: 4),
                              _ChartTab("TREND", _chartMode == 'Trend', () => setState(() => _chartMode = 'Trend')),
                              const SizedBox(width: 4),
                              _ChartTab("CATEGORY", _chartMode == 'Category', () => setState(() => _chartMode = 'Category')),
                            ],
                          ),
                        ),

                        Expanded(
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            child: KeyedSubtree(
                              key: ValueKey(_chartMode),
                              child: _buildChartContent(expenses),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildChartContent(List<Transaction> expenses) {
    if (expenses.isEmpty) return _emptyChartState();

    switch (_chartMode) {
      case 'Breakdown':
        return _buildBreakdownView(expenses);
      case 'Trend':
        return _buildTrendView(expenses);
      case 'Category':
        return _buildCategoryBarView(expenses);
      default:
        return _emptyChartState();
    }
  }

  Widget _buildBreakdownView(List<Transaction> expenses) {
    return LayoutBuilder(
        builder: (context, constraints) {
          final double chartSize = constraints.maxHeight * 0.55;

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: chartSize, child: _buildDonutChart(expenses)),
                const SizedBox(height: 24),
                _buildCategoryLegend(expenses),
              ],
            ),
          );
        }
    );
  }

  Widget _buildTrendView(List<Transaction> expenses) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 12, 24, 16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              _GraphToggle("D", _graphView == 'Daily', () => setState(() => _graphView = 'Daily')),
              const SizedBox(width: 4),
              _GraphToggle("W", _graphView == 'Weekly', () => setState(() => _graphView = 'Weekly')),
              const SizedBox(width: 4),
              _GraphToggle("M", _graphView == 'Monthly', () => setState(() => _graphView = 'Monthly')),
            ],
          ),
          const SizedBox(height: 12),
          Expanded(child: _buildDynamicLineChart(expenses)),
        ],
      ),
    );
  }


  Widget _buildCategoryBarView(List<Transaction> expenses) {
    Map<String, double> totals = {};
    for (var t in expenses) {
      totals[t.categoryId] = (totals[t.categoryId] ?? 0) + t.amount;
    }
    var sorted = totals.entries.toList()..sort((a,b) => b.value.compareTo(a.value));
    final topList = sorted.take(6).toList();

    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 30, 16, 10),
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: topList.isEmpty ? 100 : topList.first.value * 1.2,
          barTouchData: BarTouchData(
            touchTooltipData: BarTouchTooltipData(
                getTooltipColor: (_) => _black,
                getTooltipItem: (group, groupIndex, rod, rodIndex) {
                  final catName = topList[group.x.toInt()].key.toUpperCase();
                  return BarTooltipItem(
                      "$catName\n",
                      GoogleFonts.plusJakartaSans(color: Colors.grey[400], fontSize: 10, fontWeight: FontWeight.bold),
                      children: [
                        TextSpan(
                          text: "₹${rod.toY.toInt()}",
                          style: GoogleFonts.spaceMono(color: _white, fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                      ]
                  );
                }
            ),
          ),
          titlesData: FlTitlesData(
            show: true,
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),

            leftTitles: AxisTitles(
                sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 34,
                    getTitlesWidget: (value, meta) {
                      if (value == 0) return const SizedBox();
                      return Text(
                        _compactNumber(value),
                        style: GoogleFonts.spaceMono(color: Colors.grey[500], fontSize: 10),
                      );
                    }
                )
            ),

            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 30,
                getTitlesWidget: (value, meta) {
                  if (value.toInt() >= topList.length) return const SizedBox();
                  final id = topList[value.toInt()].key;
                  return Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(_getEmoji(id), style: const TextStyle(fontSize: 14)),
                  );
                },
              ),
            ),
          ),
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            getDrawingHorizontalLine: (_) => FlLine(color: Colors.grey.shade200, strokeWidth: 1),
          ),
          borderData: FlBorderData(show: false),
          barGroups: topList.asMap().entries.map((entry) {
            final index = entry.key;
            final data = entry.value;
            final colors = [_lime, _purple, const Color(0xFFFF9F1C), const Color(0xFF2EC4B6), const Color(0xFFFF3366)];
            final color = colors[index % colors.length];

            return BarChartGroupData(
              x: index,
              barRods: [
                BarChartRodData(
                  toY: data.value,
                  color: color,
                  width: 18,
                  borderRadius: BorderRadius.circular(4),
                  backDrawRodData: BackgroundBarChartRodData(
                    show: true,
                    toY: topList.first.value * 1.2,
                    color: Colors.grey[50],
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _emptyChartState() {
    return Container(
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(LucideIcons.barChart2, color: Colors.grey[300], size: 48),
          const SizedBox(height: 12),
          Text("NO DATA AVAILABLE", style: GoogleFonts.spaceMono(color: Colors.grey[400], fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }


  Widget _buildDynamicLineChart(List<Transaction> expenses) {
    Map<int, double> spots = {};
    int intervalCount = 0;

    if (_graphView == 'Daily') {
      intervalCount = _dateRange.end.difference(_dateRange.start).inDays + 1;
      for (var t in expenses) {
        final idx = t.date.difference(_dateRange.start).inDays;
        if (idx >= 0) spots[idx] = (spots[idx] ?? 0) + t.amount;
      }
    } else if (_graphView == 'Weekly') {
      intervalCount = (_dateRange.end.difference(_dateRange.start).inDays / 7).ceil() + 1;
      for (var t in expenses) {
        final idx = (t.date.difference(_dateRange.start).inDays / 7).floor();
        if (idx >= 0) spots[idx] = (spots[idx] ?? 0) + t.amount;
      }
    } else {
      intervalCount = ((_dateRange.end.year - _dateRange.start.year) * 12) + _dateRange.end.month - _dateRange.start.month + 1;
      for (var t in expenses) {
        final idx = ((t.date.year - _dateRange.start.year) * 12) + t.date.month - _dateRange.start.month;
        if (idx >= 0) spots[idx] = (spots[idx] ?? 0) + t.amount;
      }
    }

    List<FlSpot> flSpots = [];
    for (int i = 0; i < intervalCount; i++) {
      flSpots.add(FlSpot(i.toDouble(), spots[i] ?? 0));
    }


    double xInterval = 1;
    if (intervalCount > 10) xInterval = intervalCount / 5;

    return LineChart(
      LineChartData(
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
              getTooltipColor: (spot) => _black,
              getTooltipItems: (touchedSpots) {
                return touchedSpots.map((spot) => LineTooltipItem("₹${spot.y.toInt()}", GoogleFonts.spaceMono(color: _white, fontWeight: FontWeight.bold))).toList();
              }
          ),
          handleBuiltInTouches: true,
        ),
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          getDrawingHorizontalLine: (_) => FlLine(color: Colors.grey.shade200, strokeWidth: 1, dashArray: [4, 4]),
        ),
        titlesData: FlTitlesData(
          show: true,
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),

          leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 34,
                interval: flSpots.map((e)=>e.y).reduce((a,b)=> a>b?a:b) / 4, // Smart Y interval
                getTitlesWidget: (value, meta) {
                  if (value == 0) return const SizedBox();
                  return Padding(
                    padding: const EdgeInsets.only(right: 4),
                    child: Text(_compactNumber(value), style: GoogleFonts.spaceMono(fontSize: 10, color: Colors.grey[500])),
                  );
                },
              )
          ),

          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 22,
              interval: xInterval,
              getTitlesWidget: (value, meta) {
                if (value % 1 != 0) return const SizedBox();
                String text = "";

                if (_graphView == 'Daily') {
                  final date = _dateRange.start.add(Duration(days: value.toInt()));
                  text = DateFormat('dd').format(date);
                } else if (_graphView == 'Weekly') {
                  final date = _dateRange.start.add(Duration(days: value.toInt() * 7));
                  text = "W${(date.day / 7).ceil()}";
                } else {
                  final date = DateTime(_dateRange.start.year, _dateRange.start.month + value.toInt());
                  text = DateFormat('MMM').format(date);
                }

                return Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text(text, style: GoogleFonts.plusJakartaSans(color: Colors.grey[500], fontSize: 10, fontWeight: FontWeight.bold)),
                );
              },
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: flSpots,
            isCurved: true,
            color: _black,
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: FlDotData(show: false),
            belowBarData: BarAreaData(show: true, gradient: LinearGradient(colors: [_lime.withOpacity(0.4), _lime.withOpacity(0.0)], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
          ),
        ],
        minY: 0,
      ),
    );
  }

  Widget _buildDonutChart(List<Transaction> expenses) {
    Map<String, double> totals = {};
    for (var t in expenses) totals[t.categoryId] = (totals[t.categoryId] ?? 0) + t.amount;
    final colors = [_lime, _purple, const Color(0xFFFF9F1C), const Color(0xFF2EC4B6), const Color(0xFFFF3366)];
    int i = 0;
    return PieChart(PieChartData(sections: totals.entries.map((e) {
      final color = colors[i++ % colors.length];
      return PieChartSectionData(color: color, value: e.value, radius: 45, showTitle: false, badgeWidget: Container(padding: const EdgeInsets.all(4), decoration: BoxDecoration(color: _white, borderRadius: BorderRadius.circular(4), border: Border.all(width: 1)), child: Text("${((e.value/expenses.fold(0.0,(s,t)=>s+t.amount))*100).toInt()}%", style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold))), badgePositionPercentageOffset: 1.2);
    }).toList(), centerSpaceRadius: 40, sectionsSpace: 4));
  }

  Widget _buildCategoryLegend(List<Transaction> expenses) {
    Map<String, double> totals = {};
    for (var t in expenses) totals[t.categoryId] = (totals[t.categoryId] ?? 0) + t.amount;
    var sorted = totals.entries.toList()..sort((a,b) => b.value.compareTo(a.value));
    final colors = [_lime, _purple, const Color(0xFFFF9F1C), const Color(0xFF2EC4B6), const Color(0xFFFF3366)];

    return Column(
      children: sorted.take(5).toList().asMap().entries.map((entry) {
        final index = entry.key;
        final data = entry.value;
        final color = colors[index % colors.length];
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey[200]!, width: 1))),
          child: Row(children: [Container(width: 12, height: 12, decoration: BoxDecoration(color: color, shape: BoxShape.circle, border: Border.all(color: _black))), const SizedBox(width: 12), Text(data.key.toUpperCase(), style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.bold)), const Spacer(), Text("₹${data.value.toInt()}", style: GoogleFonts.spaceMono(fontSize: 12, fontWeight: FontWeight.bold, color: _black))]),
        );
      }).toList(),
    );
  }

  String _getEmoji(String id) {
    const map = {'food': '🍔', 'transport': '🚕', 'shopping': '🛍️', 'entertainment': '🍿', 'bills': '⚡', 'health': '❤️', 'education': '🎓'};
    return map[id] ?? '📦';
  }

  String _compactNumber(double value) {
    if (value >= 1000000) return '${(value / 1000000).toStringAsFixed(1)}M';
    if (value >= 1000) return '${(value / 1000).toStringAsFixed(1)}k';
    return value.toInt().toString();
  }

  List<Transaction> _filterByDate(List<Transaction> all) => all.where((t) => t.date.isAfter(_dateRange.start.subtract(const Duration(seconds: 1))) && t.date.isBefore(_dateRange.end.add(const Duration(days: 1)))).toList();

  BoxDecoration _neoDecor({required Color color}) {
    return BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: _black, width: 3),
      boxShadow: const [BoxShadow(color: Colors.black, offset: Offset(4, 4), blurRadius: 0)],
    );
  }
}


class _ChartTab extends StatelessWidget {
  final String label; final bool isSelected; final VoidCallback onTap;
  const _ChartTab(this.label, this.isSelected, this.onTap);
  @override Widget build(BuildContext context) {
    return Expanded(child: GestureDetector(onTap: onTap, child: Container(padding: const EdgeInsets.symmetric(vertical: 12), decoration: BoxDecoration(color: isSelected ? const Color(0xFFD4FF5E) : Colors.transparent, borderRadius: BorderRadius.circular(10), border: isSelected ? Border.all(color: Colors.black, width: 2) : null), alignment: Alignment.center, child: Text(label, style: GoogleFonts.plusJakartaSans(color: Colors.black, fontWeight: FontWeight.w900, fontSize: 10, letterSpacing: 0.5)))));
  }
}

class _GraphToggle extends StatelessWidget {
  final String label; final bool isSelected; final VoidCallback onTap;
  const _GraphToggle(this.label, this.isSelected, this.onTap);
  @override Widget build(BuildContext context) {
    return GestureDetector(onTap: onTap, child: Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6), decoration: BoxDecoration(color: isSelected ? Colors.black : Colors.transparent, borderRadius: BorderRadius.circular(6)), child: Text(label, style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w800, fontSize: 11, color: isSelected ? Colors.white : Colors.black))));
  }
}

class _NeoButton extends StatelessWidget {
  final VoidCallback onTap; final IconData icon; final String label; final Color bgColor; final Color textColor; final double height;
  const _NeoButton({required this.onTap, required this.icon, required this.label, required this.bgColor, required this.textColor, this.height = 60});
  @override Widget build(BuildContext context) {
    return GestureDetector(onTap: onTap, child: Container(height: height, padding: const EdgeInsets.symmetric(horizontal: 16), decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.black, width: 3), boxShadow: const [BoxShadow(color: Colors.black, offset: Offset(4, 4), blurRadius: 0)]), child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(icon, color: textColor, size: 20), if (label.isNotEmpty) ...[const SizedBox(width: 8), Text(label, style: GoogleFonts.plusJakartaSans(color: textColor, fontWeight: FontWeight.bold, fontSize: 14))]])));
  }
}