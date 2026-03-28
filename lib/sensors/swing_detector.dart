import 'dart:async';
import 'dart:math' as math;
import '../models/swing_event.dart';
import 'speed_calculator.dart';

/// Four-state gate that separates backswing from downswing.
///
/// IDLE → BACKSWING → DOWNSWING → COOLDOWN → IDLE
///
/// The backswing phase captures the upward motion. The transition to
/// downswing is detected when ω dips (top of swing) then rises again.
/// Only the downswing phase tracks peak speed and emits a SwingEvent.
enum _GateState { idle, backswing, downswing, cooldown }

class SwingDetector {
  final double clubLengthOffsetM;
  final double startThreshold;
  final double endThreshold;
  final int cooldownMs;
  final int smoothingWindow;
  final double baseLagFactor;
  final bool enableDynamicLag;

  /// Number of consecutive falling samples to confirm backswing peak
  static const int _fallingCountRequired = 3;
  /// Number of consecutive rising samples after the dip to confirm transition
  static const int _risingCountRequired = 2;

  final _omegaController = StreamController<double>.broadcast();
  final _swingEventController = StreamController<SwingEvent>.broadcast();

  Stream<double> get omegaStream => _omegaController.stream;
  Stream<SwingEvent> get swingEventStream => _swingEventController.stream;

  _GateState _state = _GateState.idle;
  double _peakOmega = 0.0;
  double _peakGyroX = 0.0;
  double _peakGyroY = 0.0;
  double _peakGyroZ = 0.0;
  DateTime _downswingStartTime = DateTime.now();
  Timer? _cooldownTimer;
  final List<double> _smoothingBuffer = [];
  bool _disposed = false;

  // Backswing → downswing transition detection
  double _prevOmega = 0.0;
  int _fallingCount = 0;   // consecutive samples where ω decreased
  bool _pastPeak = false;  // true once we've seen the backswing peak
  int _risingCount = 0;    // consecutive rising samples after the dip

  /// Collects smoothed ω samples during the downswing only for lag analysis
  final List<double> _downswingSamples = [];

  SwingDetector({
    required this.clubLengthOffsetM,
    this.startThreshold = 3.0,
    this.endThreshold = 1.0,
    this.cooldownMs = 1500,
    this.smoothingWindow = 5,
    this.baseLagFactor = 1.2,
    this.enableDynamicLag = false,
  });

  double _computeDynamicLagFactor(List<double> samples) {
    if (samples.length < 6) return baseLagFactor;

    final accels = <double>[];
    for (var i = 1; i < samples.length; i++) {
      accels.add(samples[i] - samples[i - 1]);
    }

    final midpoint = accels.length ~/ 2;
    final firstHalf = accels.sublist(0, midpoint);
    final secondHalf = accels.sublist(midpoint);

    final peakFirst = firstHalf.reduce(math.max);
    final peakSecond = secondHalf.reduce(math.max);

    if (peakFirst <= 0.01) return baseLagFactor;

    final lagIndex = peakSecond / peakFirst;

    if (lagIndex <= 1.0) return 1.0;
    final factor = 1.0 + (math.log(lagIndex) / math.log(5.0)) * 0.5;
    return factor.clamp(1.0, 1.5);
  }

  void _resetTransitionDetection() {
    _prevOmega = 0.0;
    _fallingCount = 0;
    _pastPeak = false;
    _risingCount = 0;
  }

  void onGyroscopeData(double x, double y, double z) {
    if (_disposed) return;

    final rawOmega = SpeedCalculator.angularMagnitude(x, y, z);

    _smoothingBuffer.add(rawOmega);
    if (_smoothingBuffer.length > smoothingWindow) {
      _smoothingBuffer.removeAt(0);
    }
    final omega = SpeedCalculator.rollingAverage(
        List<num>.from(_smoothingBuffer));

    if (!_omegaController.isClosed) {
      _omegaController.add(omega);
    }

    switch (_state) {
      case _GateState.idle:
        if (omega > startThreshold) {
          _state = _GateState.backswing;
          _resetTransitionDetection();
          _prevOmega = omega;
        }

      case _GateState.backswing:
        // Detect the transition: ω rises during backswing, dips at the top,
        // then rises again as the downswing begins.
        //
        // Step 1: Detect the backswing peak (ω starts falling)
        if (!_pastPeak) {
          if (omega < _prevOmega) {
            _fallingCount++;
            if (_fallingCount >= _fallingCountRequired) {
              _pastPeak = true;
              _risingCount = 0;
            }
          } else {
            _fallingCount = 0;
          }
        }
        // Step 2: After the dip, detect ω rising again (downswing starting)
        if (_pastPeak) {
          if (omega > _prevOmega) {
            _risingCount++;
            if (_risingCount >= _risingCountRequired) {
              // Transition confirmed — enter downswing
              _state = _GateState.downswing;
              _downswingStartTime = DateTime.now();
              _peakOmega = omega;
              _peakGyroX = x;
              _peakGyroY = y;
              _peakGyroZ = z;
              _downswingSamples.clear();
              _downswingSamples.add(omega);
            }
          } else {
            _risingCount = 0;
          }
        }

        // Safety: if ω drops below end threshold during backswing,
        // it was a false trigger (waggle/practice move) — return to idle
        if (omega < endThreshold) {
          _state = _GateState.idle;
        }

        _prevOmega = omega;

      case _GateState.downswing:
        _downswingSamples.add(omega);
        if (omega > _peakOmega) {
          _peakOmega = omega;
          _peakGyroX = x;
          _peakGyroY = y;
          _peakGyroZ = z;
        }
        if (omega < endThreshold) {
          final duration = DateTime.now()
              .difference(_downswingStartTime)
              .inMilliseconds;

          final detectedLag = enableDynamicLag
              ? _computeDynamicLagFactor(_downswingSamples)
              : baseLagFactor;

          final speedMph = SpeedCalculator.toMph(
            peakOmega: _peakOmega,
            clubLengthOffsetM: clubLengthOffsetM,
          );

          final attackAngleDeg = math.atan2(
                _peakGyroX,
                math.sqrt(
                    _peakGyroY * _peakGyroY + _peakGyroZ * _peakGyroZ),
              ) *
              (180.0 / math.pi);
          final swingPathDeg =
              math.atan2(_peakGyroY, _peakGyroZ) * (180.0 / math.pi);

          if (!_swingEventController.isClosed) {
            _swingEventController.add(SwingEvent(
              peakSpeedMph: speedMph,
              durationMs: duration,
              timestamp: _downswingStartTime,
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
