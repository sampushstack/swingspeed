import 'dart:math' as math;
import 'package:drift/drift.dart';
import '../app_database.dart';

part 'session_dao.g.dart';

@DriftAccessor(tables: [Sessions, Swings, Settings])
class SessionDao extends DatabaseAccessor<AppDatabase>
    with _$SessionDaoMixin {
  SessionDao(super.db);

  Future<int> createSession(double clubLengthOffsetM) async {
    return into(sessions).insert(SessionsCompanion.insert(
      date: DateTime.now().millisecondsSinceEpoch,
      clubLengthOffsetM: clubLengthOffsetM,
    ));
  }

  Future<List<Session>> getCompleteSessions() async {
    return (select(sessions)
          ..where((s) => s.status.equals('COMPLETE'))
          ..orderBy([(s) => OrderingTerm.desc(s.date)]))
        .get();
  }

  Future<Session?> getInProgressSession() async {
    final results = await (select(sessions)
          ..where((s) => s.status.equals('IN_PROGRESS'))
          ..orderBy([(s) => OrderingTerm.desc(s.date)]))
        .get();
    if (results.isEmpty) return null;
    if (results.length > 1) {
      for (final old in results.skip(1)) {
        await (delete(sessions)..where((s) => s.id.equals(old.id))).go();
      }
    }
    return results.first;
  }

  Future<void> discardSession(int sessionId) async {
    await (delete(sessions)..where((s) => s.id.equals(sessionId))).go();
  }

  Future<void> commitSession(int sessionId,
      {List<SwingsCompanion> pendingSwings = const []}) async {
    await transaction(() async {
      if (pendingSwings.isNotEmpty) {
        await batch((b) => b.insertAll(swings, pendingSwings));
      }
      final swingRows = await (select(swings)
            ..where((s) => s.sessionId.equals(sessionId)))
          .get();
      if (swingRows.isEmpty) {
        await (update(sessions)..where((s) => s.id.equals(sessionId)))
            .write(const SessionsCompanion(status: Value('COMPLETE')));
        return;
      }
      final speeds = swingRows.map((s) => s.peakSpeedMph).toList();
      final count = speeds.length;
      final peak = speeds.reduce(math.max);
      final avg = speeds.reduce((a, b) => a + b) / count;
      double? consistency;
      if (count >= 2) {
        final variance =
            speeds.map((s) => (s - avg) * (s - avg)).reduce((a, b) => a + b) /
                count;
        final sigma = math.sqrt(variance);
        consistency = math.max(0.0, 100.0 - sigma * 5.0);
      }
      await (update(sessions)..where((s) => s.id.equals(sessionId))).write(
        SessionsCompanion(
          status: const Value('COMPLETE'),
          swingCount: Value(count),
          peakSpeedMph: Value(peak),
          avgSpeedMph: Value(avg),
          consistencyScore: Value(consistency),
        ),
      );
      final currentSettings =
          await (select(settings)..where((s) => s.id.equals(1))).getSingle();
      if (peak > currentSettings.allTimePeakMph) {
        await (update(settings)..where((s) => s.id.equals(1)))
            .write(SettingsCompanion(allTimePeakMph: Value(peak)));
      }
    });
  }
}
