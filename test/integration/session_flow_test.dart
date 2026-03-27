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

  test('full session lifecycle: start → swings → commit → verify', () async {
    final sid = await sessionDao.createSession(0.5);
    final inProgress = await sessionDao.getInProgressSession();
    expect(inProgress, isNotNull);

    for (var i = 0; i < 5; i++) {
      await swingDao.insertSwing(SwingsCompanion.insert(
        sessionId: sid,
        timestamp: 1000 + i * 5000,
        peakSpeedMph: 75.0 + i * 5,
        durationMs: 280 + i * 10,
      ));
    }

    final swings = await swingDao.getSwingsForSession(sid);
    expect(swings.length, 5);

    await sessionDao.commitSession(sid);

    final sessions = await sessionDao.getCompleteSessions();
    expect(sessions.length, 1);
    final s = sessions.first;
    expect(s.status, 'COMPLETE');
    expect(s.swingCount, 5);
    expect(s.peakSpeedMph, 95.0);
    expect(s.avgSpeedMph, 85.0);
    expect(s.consistencyScore, isNotNull);

    final settings = await settingsDao.getSettings();
    expect(settings.allTimePeakMph, 95.0);
    expect(await sessionDao.getInProgressSession(), isNull);
  });

  test('abandoned session recovery flow', () async {
    final sid = await sessionDao.createSession(0.5);
    await swingDao.insertSwing(SwingsCompanion.insert(
      sessionId: sid,
      timestamp: 1000,
      peakSpeedMph: 80.0,
      durationMs: 300,
    ));

    final recovered = await sessionDao.getInProgressSession();
    expect(recovered, isNotNull);
    expect(recovered!.id, sid);

    await sessionDao.commitSession(sid);
    final sessions = await sessionDao.getCompleteSessions();
    expect(sessions.length, 1);
    expect(sessions.first.peakSpeedMph, 80.0);
  });

  test('discard session cascades to swings', () async {
    final sid = await sessionDao.createSession(0.5);
    await swingDao.insertSwing(SwingsCompanion.insert(
      sessionId: sid,
      timestamp: 1000,
      peakSpeedMph: 80.0,
      durationMs: 300,
    ));

    await sessionDao.discardSession(sid);
    expect(await swingDao.getSwingsForSession(sid), isEmpty);
    expect(await sessionDao.getInProgressSession(), isNull);
  });
}
