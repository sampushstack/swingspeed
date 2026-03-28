import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sensors_plus/sensors_plus.dart';
import '../providers/session_provider.dart';
import '../sensors/speed_calculator.dart';
import '../theme/augusta_theme.dart';
import '../widgets/speed_gauge.dart';
import '../widgets/swing_path_3d.dart';
import '../widgets/swing_result_card.dart';
import 'session_summary_screen.dart';

class ActiveSessionScreen extends ConsumerStatefulWidget {
  const ActiveSessionScreen({super.key});

  @override
  ConsumerState<ActiveSessionScreen> createState() =>
      _ActiveSessionScreenState();
}

class _ActiveSessionScreenState extends ConsumerState<ActiveSessionScreen> {
  bool _sensorAvailable = true;
  bool _lowSensorRate = false;
  bool _noSwingsHint = false;
  bool _showPath3D = false;
  int _lastSwingCount = 0;
  int _sampleCount = 0;
  DateTime? _rateCheckStart;
  StreamSubscription? _gyroSub;
  StreamSubscription? _gaugeSub;
  double _gaugeSpeedMph = 0.0;

  @override
  void initState() {
    super.initState();
    _startSensorListening();
    _startGaugeStream();
    // Show hint after 30s if no swings
    Future.delayed(const Duration(seconds: 30), () {
      final session = ref.read(activeSessionProvider);
      if (mounted && session != null && session.swings.isEmpty) {
        setState(() => _noSwingsHint = true);
      }
    });
  }

  @override
  void dispose() {
    _gyroSub?.cancel();
    _gaugeSub?.cancel();
    super.dispose();
  }

  void _startGaugeStream() {
    // Subscribe to the SwingDetector's omega stream, sampled at 30Hz for the gauge
    final detector = ref.read(activeSessionProvider.notifier).detector;
    if (detector == null) return;
    // sampleTime emits the most recent value every 33ms (30Hz)
    _gaugeSub = detector.omegaStream
        .sampleTime(const Duration(milliseconds: 33))
        .listen((omega) {
      if (mounted) {
        setState(() {
          _gaugeSpeedMph = SpeedCalculator.toMph(
            peakOmega: omega,
            clubLengthOffsetM: detector.clubLengthOffsetM,
          );
        });
      }
    });
  }

  void _startSensorListening() {
    try {
      // Raw gyroscope stream — fed directly to SwingDetector at full sensor rate
      _gyroSub = gyroscopeEventStream(
        samplingPeriod: const Duration(milliseconds: 10), // Request 100Hz
      ).listen(
        (event) {
          // Sensor rate check during first 2 seconds
          _rateCheckStart ??= DateTime.now();
          if (DateTime.now().difference(_rateCheckStart!).inMilliseconds <
              2000) {
            _sampleCount++;
          } else if (_sampleCount > 0 && !_lowSensorRate) {
            final rate = _sampleCount /
                (DateTime.now().difference(_rateCheckStart!).inMilliseconds /
                    1000);
            if (rate < 50 && mounted) {
              setState(() => _lowSensorRate = true);
            }
            _sampleCount = 0; // Stop counting
          }

          final detector =
              ref.read(activeSessionProvider.notifier).detector;
          detector?.onGyroscopeData(event.x, event.y, event.z);
        },
        onError: (_) {
          if (mounted) setState(() => _sensorAvailable = false);
        },
      );
    } catch (_) {
      _sensorAvailable = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final session = ref.watch(activeSessionProvider);
    if (session == null) return const SizedBox();

    // Vibrate on new swing detection
    if (session.swings.length > _lastSwingCount) {
      _lastSwingCount = session.swings.length;
      HapticFeedback.heavyImpact();
    }

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'ACTIVE SESSION',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AugustaTheme.gold,
                      letterSpacing: 3,
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      await ref
                          .read(activeSessionProvider.notifier)
                          .endSession();
                      if (context.mounted) {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (_) => SessionSummaryScreen(
                              sessionId: session.sessionId,
                            ),
                          ),
                        );
                      }
                    },
                    child: Text(
                      'END SESSION',
                      style: TextStyle(
                        color: AugustaTheme.textSecondary,
                        fontFamily: 'Inter',
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Warnings
            if (!_sensorAvailable)
              _WarningBanner(text: 'Gyroscope unavailable on this device'),
            if (_lowSensorRate)
              _WarningBanner(
                  text: 'Sensor rate limited — accuracy may vary'),
            if (_noSwingsHint && session.swings.isEmpty)
              _WarningBanner(
                  text: 'Waiting for swing... ensure phone is secured to shaft'),

            const Spacer(),

            // Live gauge — driven by sampleTime(33ms) omega stream, not raw state
            SpeedGauge(speedMph: _gaugeSpeedMph),

            const SizedBox(height: 24),

            // Swing count + avg
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _MiniStat(label: 'SWINGS', value: '${session.swings.length}'),
                const SizedBox(width: 40),
                _MiniStat(
                  label: 'AVG',
                  value: session.swings.isEmpty
                      ? '---'
                      : session.sessionAvg.toStringAsFixed(1),
                ),
              ],
            ),

            const Spacer(),

            // Last swing result card
            if (session.swings.isNotEmpty)
              SwingResultCard(
                peakSpeedMph: session.swings.last.peakSpeedMph,
                durationMs: session.swings.last.durationMs,
                delta: session.deltaForSwing(session.swings.length - 1),
                attackAngleDeg: session.swings.last.attackAngleDeg,
                swingPathDeg: session.swings.last.swingPathDeg,
                detectedLagFactor: session.swings.last.detectedLagFactor,
              ),

            // Expandable 3D swing path
            if (session.swings.isNotEmpty &&
                session.swings.last.downswingSamples.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () => setState(() => _showPath3D = !_showPath3D),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              _showPath3D
                                  ? Icons.expand_less
                                  : Icons.expand_more,
                              color: AugustaTheme.gold,
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              _showPath3D ? 'HIDE 3D PATH' : 'SHOW 3D PATH',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: AugustaTheme.gold,
                                letterSpacing: 2,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (_showPath3D)
                      SwingPath3D(
                        samples: session.swings.last.downswingSamples,
                        clubLengthM: ref.read(activeSessionProvider.notifier).detector?.clubLengthOffsetM ?? 0.5,
                        peakSpeedMph: session.swings.last.peakSpeedMph,
                      ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _WarningBanner extends StatelessWidget {
  final String text;
  const _WarningBanner({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      color: AugustaTheme.gold.withValues(alpha: 0.15),
      child: Text(text,
          style: TextStyle(
            color: AugustaTheme.gold,
            fontFamily: 'Inter',
            fontSize: 12,
          ),
          textAlign: TextAlign.center),
    );
  }
}

class _MiniStat extends StatelessWidget {
  final String label;
  final String value;
  const _MiniStat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: AugustaTheme.gold,
              letterSpacing: 3,
            )),
        const SizedBox(height: 4),
        Text(value,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AugustaTheme.textPrimary,
            )),
      ],
    );
  }
}
