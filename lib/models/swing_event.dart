class SwingEvent {
  final double peakSpeedMph;
  final int durationMs;
  final DateTime timestamp;
  final double? attackAngleDeg; // positive = hitting up, negative = hitting down
  final double? swingPathDeg; // positive = in-to-out, negative = out-to-in

  const SwingEvent({
    required this.peakSpeedMph,
    required this.durationMs,
    required this.timestamp,
    this.attackAngleDeg,
    this.swingPathDeg,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SwingEvent &&
          peakSpeedMph == other.peakSpeedMph &&
          durationMs == other.durationMs &&
          timestamp == other.timestamp &&
          attackAngleDeg == other.attackAngleDeg &&
          swingPathDeg == other.swingPathDeg;

  @override
  int get hashCode =>
      Object.hash(peakSpeedMph, durationMs, timestamp, attackAngleDeg, swingPathDeg);
}
