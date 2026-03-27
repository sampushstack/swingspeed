import 'dart:math' as math;

class SpeedCalculator {
  static const double _metersPerSecToMph = 2.23694;

  static double toMph({required double peakOmega, required double clubLengthOffsetM}) {
    return peakOmega * clubLengthOffsetM * _metersPerSecToMph;
  }

  static double angularMagnitude(double x, double y, double z) {
    return math.sqrt(x * x + y * y + z * z);
  }

  static double rollingAverage(List<num> samples) {
    if (samples.isEmpty) return 0.0;
    return samples.reduce((a, b) => a + b) / samples.length;
  }
}
