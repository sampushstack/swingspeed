class SwingEvent {
  final double peakSpeedMph;
  final int durationMs;
  final DateTime timestamp;

  const SwingEvent({
    required this.peakSpeedMph,
    required this.durationMs,
    required this.timestamp,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SwingEvent &&
          peakSpeedMph == other.peakSpeedMph &&
          durationMs == other.durationMs &&
          timestamp == other.timestamp;

  @override
  int get hashCode => Object.hash(peakSpeedMph, durationMs, timestamp);
}
