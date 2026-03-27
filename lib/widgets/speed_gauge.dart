import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme/augusta_theme.dart';

class SpeedGauge extends StatelessWidget {
  final double speedMph;
  final double maxSpeed;

  const SpeedGauge({super.key, required this.speedMph, this.maxSpeed = 150.0});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 280, height: 200,
      child: CustomPaint(
        painter: _GaugePainter(value: speedMph, maxValue: maxSpeed),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 40),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Text(speedMph.toStringAsFixed(1),
                  style: const TextStyle(fontFamily: 'PlayfairDisplay', fontSize: 48, fontWeight: FontWeight.bold, color: AugustaTheme.textPrimary)),
              Text('MPH', style: TextStyle(fontFamily: 'Inter', fontSize: 14, fontWeight: FontWeight.bold, color: AugustaTheme.gold, letterSpacing: 4)),
            ]),
          ),
        ),
      ),
    );
  }
}

class _GaugePainter extends CustomPainter {
  final double value;
  final double maxValue;
  _GaugePainter({required this.value, required this.maxValue});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height * 0.85);
    final radius = size.width * 0.45;
    const startAngle = math.pi * 0.8;
    const sweepAngle = math.pi * 1.4;
    final valueAngle = sweepAngle * (value / maxValue).clamp(0.0, 1.0);

    // Background arc
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), startAngle, sweepAngle, false,
        Paint()..color = AugustaTheme.surface..style = PaintingStyle.stroke..strokeWidth = 12..strokeCap = StrokeCap.round);

    // Value arc
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), startAngle, valueAngle, false,
        Paint()..color = AugustaTheme.gold..style = PaintingStyle.stroke..strokeWidth = 12..strokeCap = StrokeCap.round);

    // Needle
    final needleAngle = startAngle + valueAngle;
    final needleEnd = Offset(center.dx + (radius - 20) * math.cos(needleAngle), center.dy + (radius - 20) * math.sin(needleAngle));
    canvas.drawLine(center, needleEnd, Paint()..color = AugustaTheme.textPrimary..strokeWidth = 2.5..strokeCap = StrokeCap.round);

    // Center dot
    canvas.drawCircle(center, 6, Paint()..color = AugustaTheme.gold);
  }

  @override
  bool shouldRepaint(_GaugePainter old) => old.value != value || old.maxValue != maxValue;
}
