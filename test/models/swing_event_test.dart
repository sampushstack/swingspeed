import 'package:flutter_test/flutter_test.dart';
import 'package:swingspeed/models/swing_event.dart';

void main() {
  group('SwingEvent', () {
    test('creates with required fields', () {
      final event = SwingEvent(
        peakSpeedMph: 87.4,
        durationMs: 320,
        timestamp: DateTime(2026, 3, 28),
      );
      expect(event.peakSpeedMph, 87.4);
      expect(event.durationMs, 320);
      expect(event.timestamp, DateTime(2026, 3, 28));
    });

    test('equality by value', () {
      final a = SwingEvent(peakSpeedMph: 87.4, durationMs: 320, timestamp: DateTime(2026, 3, 28));
      final b = SwingEvent(peakSpeedMph: 87.4, durationMs: 320, timestamp: DateTime(2026, 3, 28));
      expect(a, equals(b));
    });
  });
}
