import 'dart:async';
import 'dart:math' as math;
import '../models/swing_event.dart';
import 'speed_calculator.dart';

enum _GateState { idle, open, cooldown }

class SwingDetector {
  final double clubLengthOffsetM;
  final double startThreshold;
  final double endThreshold;
  final int cooldownMs;
  final int smoothingWindow;
  /// Base lag factor from settings — used as fallback when detection has too few samples
  final double baseLagFactor;
  /// Whether to apply dynamic lag detection
  final bool enableDynamicLag;

  final _omegaController = StreamController<double>.broadcast();
  final _swingEventController = StreamController<SwingEvent>.broadcast();

  Stream<double> get omegaStream => _omegaController.stream;
  Stream<SwingEvent> get swingEventStream => _swingEventController.stream;

  _GateState _state = _GateState.idle;
  double _peakOmega = 0.0;
  double _peakGyroX = 0.0;
  double _peakGyroY = 0.0;
  double _peakGyroZ = 0.0;
  DateTime _gateOpenTime = DateTime.now();
  Timer? _cooldownTimer;
  final List<double> _smoothingBuffer = [];
  bool _disposed = false;

  /// Collects all smoothed ω samples during the gate-open window for lag analysis
  final List<double> _swingSamples = [];

  SwingDetector({
    required this.clubLengthOffsetM,
    this.startThreshold = 3.0,
    this.endThreshold = 1.0,
    this.cooldownMs = 1500,
    this.smoothingWindow = 5,
    this.baseLagFactor = 1.2,
    this.enableDynamicLag = false,
  });

  /// Detect wrist lag from the ω acceleration profile during the swing.
  ///
  /// A swing with good lag shows two phases:
  ///   Phase 1 (early): gradual ω increase — arms pulling, wrists cocked
  ///   Phase 2 (late): sharp ω spike — wrist release
  ///
  /// We compute angular acceleration (Δω between consecutive samples) for
  /// the first and second halves of the swing. The ratio of peak acceleration
  /// in the second half vs the first half indicates lag presence.
  ///
  /// Returns a lag factor: 1.0 (no lag) to ~1.5 (strong lag).
  double _computeDynamicLagFactor(List<double> samples) {
    // Need at least 6 samples to split meaningfully
    if (samples.length < 6) return baseLagFactor;

    // Compute angular acceleration (difference between consecutive samples)
    final accels = <double>[];
    for (var i = 1; i < samples.length; i++) {
      accels.add(samples[i] - samples[i - 1]);
    }

    final midpoint = accels.length ~/ 2;
    final firstHalf = accels.sublist(0, midpoint);
    final secondHalf = accels.sublist(midpoint);

    // Peak positive acceleration in each half
    final peakFirst = firstHalf.reduce(math.max);
    final peakSecond = secondHalf.reduce(math.max);

    // Avoid division by zero; if first half has no acceleration, use base
    if (peakFirst <= 0.01) return baseLagFactor;

    // Lag index: how much stronger the late acceleration is vs early
    final lagIndex = peakSecond / peakFirst;

    // Map lagIndex to a factor:
    //   lagIndex <= 1.0 → factor 1.0 (no lag, smooth single-phase swing)
    //   lagIndex ~2.0   → factor ~1.2 (moderate lag)
    //   lagIndex ~4.0+  → factor ~1.4 (strong pro-level lag)
    // Using a logarithmic mapping clamped to [1.0, 1.5]
    if (lagIndex <= 1.0) return 1.0;
    final factor = 1.0 + (math.log(lagIndex) / math.log(5.0)) * 0.5;
    return factor.clamp(1.0, 1.5);
  }

  void onGyroscopeData(double x, double y, double z) {
    if (_disposed) return;

    final rawOmega = SpeedCalculator.angularMagnitude(x, y, z);

    // Rolling average smoothing
    _smoothingBuffer.add(rawOmega);
    if (_smoothingBuffer.length > smoothingWindow) {
      _smoothingBuffer.removeAt(0);
    }
    final omega = SpeedCalculator.rollingAverage(List<num>.from(_smoothingBuffer));

    if (!_omegaController.isClosed) {
      _omegaController.add(omega);
    }

    switch (_state) {
      case _GateState.idle:
        if (omega > startThreshold) {
          _state = _GateState.open;
          _gateOpenTime = DateTime.now();
          _peakOmega = omega;
          _peakGyroX = x;
          _peakGyroY = y;
          _peakGyroZ = z;
          _swingSamples.clear();
          _swingSamples.add(omega);
        }
      case _GateState.open:
        _swingSamples.add(omega);
        if (omega > _peakOmega) {
          _peakOmega = omega;
          _peakGyroX = x;
          _peakGyroY = y;
          _peakGyroZ = z;
        }
        if (omega < endThreshold) {
          final duration =
              DateTime.now().difference(_gateOpenTime).inMilliseconds;

          // Detect dynamic lag factor from the ω profile
          final detectedLag = enableDynamicLag
              ? _computeDynamicLagFactor(_swingSamples)
              : baseLagFactor;

          // Apply lag factor to speed (only meaningful in freehand mode,
          // but we compute it always — the session provider controls
          // whether the base offset already includes lag or not)
          final speedMph = SpeedCalculator.toMph(
            peakOmega: _peakOmega,
            clubLengthOffsetM: clubLengthOffsetM,
          );

          // Compute attack angle and swing path from peak-moment axis values
          final attackAngleDeg = math.atan2(
                _peakGyroX,
                math.sqrt(_peakGyroY * _peakGyroY + _peakGyroZ * _peakGyroZ),
              ) *
              (180.0 / math.pi);
          final swingPathDeg =
              math.atan2(_peakGyroY, _peakGyroZ) * (180.0 / math.pi);

          if (!_swingEventController.isClosed) {
            _swingEventController.add(SwingEvent(
              peakSpeedMph: speedMph,
              durationMs: duration,
              timestamp: _gateOpenTime,
              attackAngleDeg: attackAngleDeg,
              swingPathDeg: swingPathDeg,
              detectedLagFactor: detectedLag,
            ));
          }

          _state = _GateState.cooldown;
          _cooldownTimer = Timer(
            Duration(milliseconds: cooldownMs),
            () => _state = _GateState.idle,
          );
        }
      case _GateState.cooldown:
        break;
    }
  }

  void dispose() {
    _disposed = true;
    _cooldownTimer?.cancel();
    _omegaController.close();
    _swingEventController.close();
  }
}
