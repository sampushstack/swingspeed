import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:swingspeed/database/app_database.dart';
import 'package:swingspeed/database/daos/session_dao.dart';
import 'package:swingspeed/database/daos/swing_dao.dart';
import 'package:swingspeed/database/daos/settings_dao.dart';

void main() {
  late AppDatabase db;
  late SessionDao sessionDao;
  late SwingDao swingDao;
  late SettingsDao settingsDao;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    sessionDao = SessionDao(db);
    swingDao = SwingDao(db);
    settingsDao = SettingsDao(db);
  });
  tearDown(() => db.close());

  test('createSession creates IN_PROGRESS session', () async {
    final id = await sessionDao.createSession(0.5);
    final inProgress = await sessionDao.getInProgressSession();
    expect(inProgress, isNotNull);
    expect(inProgress!.id, id);
    expect(inProgress.status, 'IN_PROGRESS');
  });

  test('commitSession computes derived fields and marks COMPLETE', () async {
    final sid = await sessionDao.createSession(0.5);
    await swingDao.insertSwing(SwingsCompanion.insert(
        sessionId: sid,
        timestamp: 1000,
        peakSpeedMph: 80.0,
        durationMs: 300));
    await swingDao.insertSwing(SwingsCompanion.insert(
        sessionId: sid,
        timestamp: 2000,
        peakSpeedMph: 90.0,
        durationMs: 280));
    await sessionDao.commitSession(sid);
    final sessions = await sessionDao.getCompleteSessions();
    expect(sessions.length, 1);
    final s = sessions.first;
    expect(s.status, 'COMPLETE');
    expect(s.swingCount, 2);
    expect(s.peakSpeedMph, 90.0);
    expect(s.avgSpeedMph, 85.0);
    expect(s.consistencyScore, isNotNull);
    expect(s.consistencyScore, closeTo(75.0, 0.1));
  });

  test('commitSession updates allTimePeakMph in settings', () async {
    final sid = await sessionDao.createSession(0.5);
    await swingDao.insertSwing(SwingsCompanion.insert(
        sessionId: sid,
        timestamp: 1000,
        peakSpeedMph: 95.0,
        durationMs: 300));
    await sessionDao.commitSession(sid);
    final settings = await settingsDao.getSettings();
    expect(settings.allTimePeakMph, 95.0);
  });

  test('commitSession with single swing sets consistencyScore null', () async {
    final sid = await sessionDao.createSession(0.5);
    await swingDao.insertSwing(SwingsCompanion.insert(
        sessionId: sid,
        timestamp: 1000,
        peakSpeedMph: 80.0,
        durationMs: 300));
    await sessionDao.commitSession(sid);
    final sessions = await sessionDao.getCompleteSessions();
    expect(sessions.first.consistencyScore, isNull);
  });

  test('commitSession flushes pending in-memory swings first', () async {
    final sid = await sessionDao.createSession(0.5);
    final pending = [
      SwingsCompanion.insert(
          sessionId: sid,
          timestamp: 1000,
          peakSpeedMph: 70.0,
          durationMs: 300)
    ];
    await sessionDao.commitSession(sid, pendingSwings: pending);
    final sessions = await sessionDao.getCompleteSessions();
    expect(sessions.first.swingCount, 1);
    expect(sessions.first.peakSpeedMph, 70.0);
  });

  test('discardSession cascades to swings via ON DELETE CASCADE', () async {
    final sid = await sessionDao.createSession(0.5);
    await swingDao.insertSwing(SwingsCompanion.insert(
        sessionId: sid,
        timestamp: 1000,
        peakSpeedMph: 80.0,
        durationMs: 300));
    await sessionDao.discardSession(sid);
    final swings = await swingDao.getSwingsForSession(sid);
    expect(swings, isEmpty);
  });

  test('getInProgressSession auto-discards older IN_PROGRESS sessions',
      () async {
    await sessionDao.createSession(0.5);
    await Future.delayed(const Duration(milliseconds: 10));
    final newestId = await sessionDao.createSession(0.6);
    final inProgress = await sessionDao.getInProgressSession();
    expect(inProgress!.id, newestId);
    final all = await (db.select(db.sessions)).get();
    expect(all.length, 1);
  });
}
