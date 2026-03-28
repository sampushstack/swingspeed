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

    /// Simulates a realistic swing: backswing rise → peak → dip → downswing rise → impact → settle
    void simulateFullSwing({
      double backswingPeak = 6.0,
      double transitionDip = 2.0,
      double downswingPeak = 10.0,
    }) {
      // Backswing: rises above threshold
      detector.onGyroscopeData(4.0, 0.0, 0.0);   // ω=4 enters backswing
      detector.onGyroscopeData(backswingPeak, 0.0, 0.0); // backswing peak

      // Top of swing: ω falls (3 samples to confirm)
      detector.onGyroscopeData(4.5, 0.0, 0.0);    // falling 1
      detector.onGyroscopeData(3.5, 0.0, 0.0);    // falling 2
      detector.onGyroscopeData(transitionDip, 0.0, 0.0); // falling 3 → pastPeak

      // Transition: ω rises again (2 samples to confirm downswing)
      detector.onGyroscopeData(3.0, 0.0, 0.0);    // rising 1
      detector.onGyroscopeData(5.0, 0.0, 0.0);    // rising 2 → enter DOWNSWING

      // Downswing: accelerates to peak
      detector.onGyroscopeData(8.0, 0.0, 0.0);
      detector.onGyroscopeData(downswingPeak, 0.0, 0.0); // downswing peak

      // Impact and follow-through: ω drops below end threshold
      detector.onGyroscopeData(3.0, 0.0, 0.0);
      detector.onGyroscopeData(0.5, 0.0, 0.0);    // ω < 1.0 → emit + COOLDOWN
    }

    test('emits SwingEvent only from downswing, ignoring backswing', () async {
      final events = <SwingEvent>[];
      detector.swingEventStream.listen(events.add);

      simulateFullSwing(backswingPeak: 6.0, downswingPeak: 10.0);

      await Future.delayed(const Duration(milliseconds: 50));
      expect(events.length, 1);
      // Peak should be from downswing (10.0), not backswing (6.0)
      // speed = 10.0 * 0.5 * 2.23694 ≈ 11.18 mph
      expect(events.first.peakSpeedMph, closeTo(11.18, 0.1));
    });

    test('backswing peak is not reported as swing speed', () async {
      final events = <SwingEvent>[];
      detector.swingEventStream.listen(events.add);

      // Backswing with higher ω than downswing
      simulateFullSwing(backswingPeak: 15.0, downswingPeak: 8.0);

      await Future.delayed(const Duration(milliseconds: 50));
      expect(events.length, 1);
      // Should report 8.0 (downswing), not 15.0 (backswing)
      // speed = 8.0 * 0.5 * 2.23694 ≈ 8.95 mph
      expect(events.first.peakSpeedMph, closeTo(8.95, 0.1));
    });

    test('waggle/false trigger returns to idle without emitting', () async {
      final events = <SwingEvent>[];
      detector.swingEventStream.listen(events.add);

      // Starts above threshold but drops below end threshold before transition
      detector.onGyroscopeData(4.0, 0.0, 0.0);  // enters backswing
      detector.onGyroscopeData(3.0, 0.0, 0.0);
      detector.onGyroscopeData(0.5, 0.0, 0.0);  // drops below 1.0 → back to idle

      await Future.delayed(const Duration(milliseconds: 50));
      expect(events, isEmpty);

      // Should be able to start a new swing after the false trigger
      simulateFullSwing();
      await Future.delayed(const Duration(milliseconds: 50));
      expect(events.length, 1);
    });

    test('does not emit during cooldown', () async {
      final events = <SwingEvent>[];
      detector.swingEventStream.listen(events.add);

      simulateFullSwing();
      await Future.delayed(const Duration(milliseconds: 10));
      expect(events.length, 1);

      // During cooldown — should not start a new swing
      simulateFullSwing();
      await Future.delayed(const Duration(milliseconds: 10));
      expect(events.length, 1); // Still 1

      // After cooldown
      await Future.delayed(const Duration(milliseconds: 150));
      simulateFullSwing();
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
