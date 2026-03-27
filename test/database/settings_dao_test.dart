import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:swingspeed/database/app_database.dart';
import 'package:swingspeed/database/daos/settings_dao.dart';

void main() {
  late AppDatabase db;
  late SettingsDao dao;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    dao = SettingsDao(db);
  });
  tearDown(() => db.close());

  test('settings row seeded with defaults on create', () async {
    final s = await dao.getSettings();
    expect(s.clubLengthOffsetM, 0.5);
    expect(s.allTimePeakMph, 0.0);
    expect(s.swingStartThreshold, 3.0);
    expect(s.swingEndThreshold, 1.0);
    expect(s.cooldownMs, 1500);
  });

  test('updateClubOffset persists new value', () async {
    await dao.updateClubOffset(0.7);
    final s = await dao.getSettings();
    expect(s.clubLengthOffsetM, 0.7);
  });

  test('updateAllTimePeak persists new value', () async {
    await dao.updateAllTimePeak(95.2);
    final s = await dao.getSettings();
    expect(s.allTimePeakMph, 95.2);
  });
}
