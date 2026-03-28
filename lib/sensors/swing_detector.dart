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

  SwingDetector({
    required this.clubLengthOffsetM,
    this.startThreshold = 3.0,
    this.endThreshold = 1.0,
    this.cooldownMs = 1500,
    this.smoothingWindow = 5,
  });

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
        }
      case _GateState.open:
        if (omega > _peakOmega) {
          _peakOmega = omega;
          _peakGyroX = x;
          _peakGyroY = y;
          _peakGyroZ = z;
        }
        if (omega < endThreshold) {
          final duration =
              DateTime.now().difference(_gateOpenTime).inMilliseconds;
          final speedMph = SpeedCalculator.toMph(
            peakOmega: _peakOmega,
            clubLengthOffsetM: clubLengthOffsetM,
          );

          // Compute attack angle and swing path from peak-moment axis values
          // With phone screen = club face:
          // X-axis rotation = pitch (vertical arc) -> attack angle
          // Y-axis rotation = yaw (horizontal deviation) -> swing path
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
