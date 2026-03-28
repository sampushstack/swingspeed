import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'app_database.g.dart';

class Sessions extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get date => integer()();
  TextColumn get status => text().withDefault(const Constant('IN_PROGRESS'))();
  IntColumn get swingCount => integer().withDefault(const Constant(0))();
  RealColumn get peakSpeedMph => real().withDefault(const Constant(0.0))();
  RealColumn get avgSpeedMph => real().withDefault(const Constant(0.0))();
  RealColumn get consistencyScore => real().nullable()();
  RealColumn get clubLengthOffsetM => real()();
}

class Swings extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get sessionId => integer().references(Sessions, #id, onDelete: KeyAction.cascade)();
  IntColumn get timestamp => integer()();
  RealColumn get peakSpeedMph => real()();
  IntColumn get durationMs => integer()();
  RealColumn get attackAngleDeg => real().nullable()();
  RealColumn get swingPathDeg => real().nullable()();
}

class Settings extends Table {
  IntColumn get id => integer().withDefault(const Constant(1))();
  // 'club' = phone mounted on club shaft, 'freehand' = phone held in hand
  TextColumn get swingMode => text().withDefault(const Constant('club'))();
  // In freehand mode, which club to estimate speed for (e.g. 'driver', '7_iron')
  TextColumn get selectedClubType => text().withDefault(const Constant('driver'))();
  RealColumn get clubLengthOffsetM => real().withDefault(const Constant(0.5))();
  RealColumn get allTimePeakMph => real().withDefault(const Constant(0.0))();
  RealColumn get swingStartThreshold => real().withDefault(const Constant(3.0))();
  RealColumn get swingEndThreshold => real().withDefault(const Constant(1.0))();
  IntColumn get cooldownMs => integer().withDefault(const Constant(1500))();
  RealColumn get lagFactor => real().withDefault(const Constant(1.2))();

  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(tables: [Sessions, Swings, Settings])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor])
      : super(executor ?? driftDatabase(name: 'swingspeed'));

  @override
  int get schemaVersion => 4;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (Migrator m) async {
          await m.createAll();
          await into(settings).insert(SettingsCompanion.insert());
        },
        onUpgrade: (Migrator m, int from, int to) async {
          if (from < 2) {
            await m.addColumn(settings, settings.swingMode);
          }
          if (from < 3) {
            await m.addColumn(settings, settings.selectedClubType);
          }
          if (from < 4) {
            await m.addColumn(settings, settings.lagFactor);
            await m.addColumn(swings, swings.attackAngleDeg);
            await m.addColumn(swings, swings.swingPathDeg);
          }
        },
        beforeOpen: (details) async {
          await customStatement('PRAGMA foreign_keys = ON');
        },
      );
}
