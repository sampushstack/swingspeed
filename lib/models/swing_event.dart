/// A single gyroscope reading at a point in time during the swing.
class GyroSample {
  final double x, y, z; // rad/s
  final double omega; // magnitude
  const GyroSample(
      {required this.x,
      required this.y,
      required this.z,
      required this.omega});
}

class SwingEvent {
  final double peakSpeedMph;
  final int durationMs;
  final DateTime timestamp;
  final double? attackAngleDeg; // positive = hitting up, negative = hitting down
  final double? swingPathDeg; // positive = in-to-out, negative = out-to-in
  final double? detectedLagFactor; // dynamic lag: 1.0 = no lag, >1.0 = wrist release detected

  /// Raw gyro samples captured during the downswing for 3D path reconstruction.
  /// In-memory only — not persisted to database.
  final List<GyroSample> downswingSamples;

  const SwingEvent({
    required this.peakSpeedMph,
    required this.durationMs,
    required this.timestamp,
    this.attackAngleDeg,
    this.swingPathDeg,
    this.detectedLagFactor,
    this.downswingSamples = const [],
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SwingEvent &&
          peakSpeedMph == other.peakSpeedMph &&
          durationMs == other.durationMs &&
          timestamp == other.timestamp &&
          attackAngleDeg == other.attackAngleDeg &&
          swingPathDeg == other.swingPathDeg &&
          detectedLagFactor == other.detectedLagFactor;

  @override
  int get hashCode =>
      Object.hash(peakSpeedMph, durationMs, timestamp, attackAngleDeg, swingPathDeg, detectedLagFactor);
}
