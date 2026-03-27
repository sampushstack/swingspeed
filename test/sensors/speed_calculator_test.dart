import 'package:flutter_test/flutter_test.dart';
import 'package:swingspeed/sensors/speed_calculator.dart';

void main() {
  group('SpeedCalculator', () {
    test('converts angular velocity to mph with default offset', () {
      // v = omega * r * 2.23694
      // omega = 20 rad/s, r = 0.5m => v = 20 * 0.5 * 2.23694 = 22.3694 mph
      final mph = SpeedCalculator.toMph(peakOmega: 20.0, clubLengthOffsetM: 0.5);
      expect(mph, closeTo(22.37, 0.01));
    });

    test('angular magnitude from xyz', () {
      // sqrt(3^2 + 4^2 + 0^2) = 5.0
      final omega = SpeedCalculator.angularMagnitude(3.0, 4.0, 0.0);
      expect(omega, closeTo(5.0, 0.001));
    });

    test('rolling average of 5 samples', () {
      final avg = SpeedCalculator.rollingAverage([1, 2, 3, 4, 5]);
      expect(avg, 3.0);
    });
  });
}
