import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/history_provider.dart';
import '../theme/augusta_theme.dart';
import 'session_summary_screen.dart';

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyAsync = ref.watch(historyProvider);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('SESSION HISTORY',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: AugustaTheme.gold,
                    letterSpacing: 3,
                  ),
                  textAlign: TextAlign.center),
              const SizedBox(height: 24),
              historyAsync.when(
                data: (sessions) {
                  if (sessions.isEmpty) {
                    return Expanded(
                      child: Center(
                        child: Text('No sessions yet',
                            style: TextStyle(
                                color: AugustaTheme.textSecondary,
                                fontFamily: 'Inter')),
                      ),
                    );
                  }
                  return Expanded(
                    child: Column(
                      children: [
                        // Trend chart
                        if (sessions.length < 2)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 24),
                            child: Text(
                              'Complete more sessions to see your trend',
                              style: TextStyle(
                                  color: AugustaTheme.textSecondary,
                                  fontFamily: 'Inter',
                                  fontSize: 13),
                              textAlign: TextAlign.center,
                            ),
                          )
                        else
                          SizedBox(
                            height: 150,
                            child: LineChart(LineChartData(
                              gridData: const FlGridData(show: false),
                              titlesData: const FlTitlesData(show: false),
                              borderData: FlBorderData(show: false),
                              lineBarsData: [
                                LineChartBarData(
                                  spots: sessions.reversed
                                      .toList()
                                      .asMap()
                                      .entries
                                      .map((e) => FlSpot(
                                          e.key.toDouble(),
                                          e.value.peakSpeedMph))
                                      .toList(),
                                  color: AugustaTheme.gold,
                                  dotData: FlDotData(
                                    show: true,
                                    getDotPainter: (_, __, ___, ____) =>
                                        FlDotCirclePainter(
                                      radius: 3,
                                      color: AugustaTheme.gold,
                                    ),
                                  ),
                                  belowBarData: BarAreaData(
                                    show: true,
                                    color: AugustaTheme.gold.withValues(alpha: 0.1),
                                  ),
                                ),
                              ],
                            )),
                          ),
                        const SizedBox(height: 16),
                        // Session list
                        Expanded(
                          child: ListView.builder(
                            itemCount: sessions.length,
                            itemBuilder: (_, i) {
                              final s = sessions[i];
                              final date = DateTime
                                  .fromMillisecondsSinceEpoch(s.date);
                              return GestureDetector(
                                onTap: () => Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => SessionSummaryScreen(
                                      sessionId: s.id,
                                      isReadOnly: true,
                                    ),
                                  ),
                                ),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 14, horizontal: 16),
                                  margin: const EdgeInsets.only(bottom: 8),
                                  decoration: BoxDecoration(
                                    color: AugustaTheme.surface,
                                    border: Border(
                                        left: BorderSide(
                                            color: AugustaTheme.gold,
                                            width: 2)),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '${date.month}/${date.day}/${date.year}',
                                        style: TextStyle(
                                            color: AugustaTheme.textPrimary,
                                            fontFamily: 'Inter'),
                                      ),
                                      Text('${s.swingCount} swings',
                                          style: TextStyle(
                                              color:
                                                  AugustaTheme.textSecondary,
                                              fontFamily: 'Inter')),
                                      Text(
                                        '${s.peakSpeedMph.toStringAsFixed(1)} mph',
                                        style: TextStyle(
                                          color: AugustaTheme.gold,
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
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
                loading: () =>
                    const Expanded(
                        child: Center(child: CircularProgressIndicator())),
                error: (_, __) => const Expanded(child: SizedBox()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
