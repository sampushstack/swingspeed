import 'package:flutter_test/flutter_test.dart';
import 'package:swingspeed/models/swing_event.dart';
import 'package:swingspeed/sensors/swing_detector.dart';

void main() {
  group('SwingDetector', () {
    late SwingDetector detector;

    setUp(() {
      detector = SwingDetector(
        clubLengthOffsetM: 0.5,
        startThreshold: 3.0,
        endThreshold: 1.0,
        cooldownMs: 100, // Short cooldown for tests
        smoothingWindow: 1, // No smoothing for test control
      );
    });

    tearDown(() => detector.dispose());

    test('emits SwingEvent when omega crosses start then end threshold', () async {
      final events = <SwingEvent>[];
      detector.swingEventStream.listen(events.add);

      detector.onGyroscopeData(4.0, 0.0, 0.0); // ω=4 > 3.0 → OPEN
      detector.onGyroscopeData(10.0, 0.0, 0.0); // ω=10 peak
      detector.onGyroscopeData(0.5, 0.0, 0.0); // ω=0.5 < 1.0 → COOLDOWN

      await Future.delayed(const Duration(milliseconds: 50));
      expect(events.length, 1);
      // peak = 10.0 * 0.5 * 2.23694 ≈ 11.18 mph
      expect(events.first.peakSpeedMph, closeTo(11.18, 0.1));
    });

    test('does not emit during cooldown', () async {
      final events = <SwingEvent>[];
      detector.swingEventStream.listen(events.add);

      // First swing
      detector.onGyroscopeData(4.0, 0.0, 0.0);
      detector.onGyroscopeData(0.5, 0.0, 0.0);
      await Future.delayed(const Duration(milliseconds: 10));
      expect(events.length, 1);

      // During cooldown — should not open a new gate
      detector.onGyroscopeData(5.0, 0.0, 0.0);
      detector.onGyroscopeData(0.5, 0.0, 0.0);
      await Future.delayed(const Duration(milliseconds: 10));
      expect(events.length, 1); // Still 1

      // After cooldown
      await Future.delayed(const Duration(milliseconds: 150));
      detector.onGyroscopeData(6.0, 0.0, 0.0);
      detector.onGyroscopeData(0.5, 0.0, 0.0);
      await Future.delayed(const Duration(milliseconds: 10));
      expect(events.length, 2);
    });

    test('omegaStream emits values', () async {
      final values = <double>[];
      detector.omegaStream.listen(values.add);

      detector.onGyroscopeData(3.0, 4.0, 0.0); // ω = 5.0
      await Future.delayed(const Duration(milliseconds: 10));
      expect(values.isNotEmpty, true);
      expect(values.first, closeTo(5.0, 0.01));
    });

    test('dispose stops all streams', () async {
      detector.dispose();
      expect(() => detector.onGyroscopeData(1.0, 0.0, 0.0), returnsNormally);
    });
  });
}
