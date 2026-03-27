import 'dart:math' as math;
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../theme/augusta_theme.dart';

class SpeedDistributionChart extends StatelessWidget {
  final List<double> speeds;
  const SpeedDistributionChart({super.key, required this.speeds});

  @override
  Widget build(BuildContext context) {
    if (speeds.isEmpty) {
      return Center(child: Text('No swing data', style: TextStyle(color: AugustaTheme.textSecondary)));
    }
    final minSpeed = speeds.reduce(math.min);
    final maxSpeed = speeds.reduce(math.max);
    final binStart = ((minSpeed - 5) / 5).floor() * 5.0;
    final binEnd = ((maxSpeed + 5) / 5).ceil() * 5.0;
    final binCount = ((binEnd - binStart) / 5).round();
    final bins = List.filled(binCount, 0);
    for (final s in speeds) {
      final idx = ((s - binStart) / 5).floor().clamp(0, binCount - 1);
      bins[idx]++;
    }
    return SizedBox(
      height: 200,
      child: BarChart(BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: (bins.reduce(math.max) + 1).toDouble(),
        barTouchData: BarTouchData(enabled: false),
        titlesData: FlTitlesData(
          leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true,
            getTitlesWidget: (value, meta) {
              final idx = value.toInt();
              if (idx < 0 || idx >= binCount) return const SizedBox();
              return Text('${(binStart + idx * 5).toInt()}', style: TextStyle(color: AugustaTheme.textSecondary, fontSize: 10, fontFamily: 'Inter'));
            },
          )),
        ),
        gridData: const FlGridData(show: false),
        borderData: FlBorderData(show: false),
        barGroups: List.generate(binCount, (i) => BarChartGroupData(x: i, barRods: [
          BarChartRodData(toY: bins[i].toDouble(), color: AugustaTheme.gold, width: 24,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(2))),
        ])),
      )),
    );
  }
}
