import 'package:flutter/material.dart';
import '../theme/augusta_theme.dart';

class SwingResultCard extends StatelessWidget {
  final double peakSpeedMph;
  final int durationMs;
  final double? delta;

  const SwingResultCard({super.key, required this.peakSpeedMph, required this.durationMs, this.delta});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: AugustaTheme.surface, border: Border(top: BorderSide(color: AugustaTheme.gold, width: 2))),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        _StatColumn(label: 'PEAK', value: peakSpeedMph.toStringAsFixed(1), unit: 'mph'),
        _StatColumn(label: 'DURATION', value: (durationMs / 1000).toStringAsFixed(2), unit: 's'),
        _StatColumn(
          label: 'DELTA',
          value: delta != null ? '${delta! >= 0 ? '+' : ''}${delta!.toStringAsFixed(1)}' : '—',
          unit: delta != null ? 'mph' : '',
          valueColor: delta != null ? (delta! >= 0 ? Colors.green.shade300 : Colors.red.shade300) : null,
        ),
      ]),
    );
  }
}

class _StatColumn extends StatelessWidget {
  final String label;
  final String value;
  final String unit;
  final Color? valueColor;

  const _StatColumn({required this.label, required this.value, required this.unit, this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisSize: MainAxisSize.min, children: [
      Text(label, style: TextStyle(fontFamily: 'Inter', fontSize: 10, fontWeight: FontWeight.bold, color: AugustaTheme.gold, letterSpacing: 3)),
      const SizedBox(height: 4),
      Text(value, style: TextStyle(fontFamily: 'Inter', fontSize: 24, fontWeight: FontWeight.bold, color: valueColor ?? AugustaTheme.textPrimary)),
      if (unit.isNotEmpty) Text(unit, style: TextStyle(fontFamily: 'Inter', fontSize: 11, color: AugustaTheme.textSecondary)),
    ]);
  }
}
