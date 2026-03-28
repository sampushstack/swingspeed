import 'package:drift/drift.dart';
import '../app_database.dart';

part 'settings_dao.g.dart';

@DriftAccessor(tables: [Settings])
class SettingsDao extends DatabaseAccessor<AppDatabase>
    with _$SettingsDaoMixin {
  SettingsDao(super.db);

  Future<Setting> getSettings() async {
    return (select(settings)..where((s) => s.id.equals(1))).getSingle();
  }

  Future<void> updateSwingMode(String mode) async {
    // When switching modes, also update the offset to the mode's default
    final defaultOffset = mode == 'freehand' ? 0.7 : 0.5;
    await (update(settings)..where((s) => s.id.equals(1))).write(
      SettingsCompanion(
        swingMode: Value(mode),
        clubLengthOffsetM: Value(defaultOffset),
      ),
    );
  }

  Future<void> updateSelectedClubType(String clubTypeId) async {
    await (update(settings)..where((s) => s.id.equals(1)))
        .write(SettingsCompanion(selectedClubType: Value(clubTypeId)));
  }

  Future<void> updateClubOffset(double offsetM) async {
    await (update(settings)..where((s) => s.id.equals(1)))
        .write(SettingsCompanion(clubLengthOffsetM: Value(offsetM)));
  }

  Future<void> updateAllTimePeak(double peakMph) async {
    await (update(settings)..where((s) => s.id.equals(1)))
        .write(SettingsCompanion(allTimePeakMph: Value(peakMph)));
  }

  Future<void> updateLagFactor(double lagFactor) async {
    await (update(settings)..where((s) => s.id.equals(1)))
        .write(SettingsCompanion(lagFactor: Value(lagFactor)));
  }

  Future<void> updateThresholds({
    double? startThreshold,
    double? endThreshold,
    int? cooldownMs,
  }) async {
    await (update(settings)..where((s) => s.id.equals(1))).write(
      SettingsCompanion(
        swingStartThreshold: startThreshold != null
            ? Value(startThreshold)
            : const Value.absent(),
        swingEndThreshold: endThreshold != null
            ? Value(endThreshold)
            : const Value.absent(),
        cooldownMs:
            cooldownMs != null ? Value(cooldownMs) : const Value.absent(),
      ),
    );
  }
}
