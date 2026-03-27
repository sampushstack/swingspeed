import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../database/app_database.dart';
import '../models/club_types.dart';
import '../models/swing_event.dart';
import '../sensors/swing_detector.dart';
import 'database_provider.dart';
import 'settings_provider.dart';
import 'history_provider.dart';

class ActiveSessionState {
  final int sessionId;
  final List<SwingEvent> swings;
  final double? currentOmega;
  final List<SwingsCompanion> pendingSwings;

  ActiveSessionState({
    required this.sessionId,
    this.swings = const [],
    this.currentOmega,
    this.pendingSwings = const [],
  });

  double get sessionPeak =>
      swings.isEmpty
          ? 0.0
          : swings.map((s) => s.peakSpeedMph).reduce((a, b) => a > b ? a : b);

  double get sessionAvg =>
      swings.isEmpty
          ? 0.0
          : swings.map((s) => s.peakSpeedMph).reduce((a, b) => a + b) /
              swings.length;

  double? deltaForSwing(int index) {
    if (index == 0) return null;
    final priorAvg =
        swings.take(index).map((s) => s.peakSpeedMph).reduce((a, b) => a + b) /
            index;
    return swings[index].peakSpeedMph - priorAvg;
  }

  ActiveSessionState copyWith({
    List<SwingEvent>? swings,
    double? currentOmega,
    List<SwingsCompanion>? pendingSwings,
  }) {
    return ActiveSessionState(
      sessionId: sessionId,
      swings: swings ?? this.swings,
      currentOmega: currentOmega ?? this.currentOmega,
      pendingSwings: pendingSwings ?? this.pendingSwings,
    );
  }
}

class ActiveSessionNotifier extends StateNotifier<ActiveSessionState?> {
  final Ref ref;
  SwingDetector? _detector;
  StreamSubscription<double>? _omegaSub;
  StreamSubscription<SwingEvent>? _swingEventSub;

  ActiveSessionNotifier(this.ref) : super(null);

  Future<void> startSession() async {
    final settings = await ref.read(settingsDaoProvider).getSettings();

    // Compute effective pivot distance based on mode
    double effectiveOffset;
    if (settings.swingMode == 'freehand') {
      final armLength = settings.clubLengthOffsetM; // arm length in freehand mode
      final club = getClubTypeById(settings.selectedClubType);
      final shaftLength = club?.shaftLengthM ?? 0.0;
      effectiveOffset = armLength + shaftLength;
    } else {
      effectiveOffset = settings.clubLengthOffsetM;
    }

    final sessionId = await ref.read(sessionDaoProvider).createSession(
      effectiveOffset,
    );

    _detector = SwingDetector(
      clubLengthOffsetM: effectiveOffset,
      startThreshold: settings.swingStartThreshold,
      endThreshold: settings.swingEndThreshold,
      cooldownMs: settings.cooldownMs,
    );

    state = ActiveSessionState(sessionId: sessionId);

    _omegaSub = _detector!.omegaStream.listen((omega) {
      if (state != null) {
        state = state!.copyWith(currentOmega: omega);
      }
    });

    _swingEventSub = _detector!.swingEventStream.listen((event) async {
      if (state == null) return;
      state = state!.copyWith(swings: [...state!.swings, event]);

      try {
        await ref.read(swingDaoProvider).insertSwing(
          SwingsCompanion.insert(
            sessionId: state!.sessionId,
            timestamp: event.timestamp.millisecondsSinceEpoch,
            peakSpeedMph: event.peakSpeedMph,
            durationMs: event.durationMs,
          ),
        );
      } catch (e) {
        // Retry once
        try {
          await ref.read(swingDaoProvider).insertSwing(
            SwingsCompanion.insert(
              sessionId: state!.sessionId,
              timestamp: event.timestamp.millisecondsSinceEpoch,
              peakSpeedMph: event.peakSpeedMph,
              durationMs: event.durationMs,
            ),
          );
        } catch (_) {
          // Queue for later batch insert during commit
          state = state!.copyWith(
            pendingSwings: [
              ...state!.pendingSwings,
              SwingsCompanion.insert(
                sessionId: state!.sessionId,
                timestamp: event.timestamp.millisecondsSinceEpoch,
                peakSpeedMph: event.peakSpeedMph,
                durationMs: event.durationMs,
              ),
            ],
          );
        }
      }
    });
  }

  SwingDetector? get detector => _detector;

  Future<void> endSession() async {
    _omegaSub?.cancel();
    _swingEventSub?.cancel();
    _detector?.dispose();
    _detector = null;
  }

  Future<void> commitSession() async {
    if (state == null) return;
    await ref.read(sessionDaoProvider).commitSession(
      state!.sessionId,
      pendingSwings: state!.pendingSwings,
    );
    ref.invalidate(historyProvider);
    ref.invalidate(settingsProvider);
    state = null;
  }

  void discardAndClear() {
    _omegaSub?.cancel();
    _swingEventSub?.cancel();
    _detector?.dispose();
    _detector = null;
    state = null;
  }
}

final activeSessionProvider =
    StateNotifierProvider<ActiveSessionNotifier, ActiveSessionState?>((ref) {
  return ActiveSessionNotifier(ref);
});
