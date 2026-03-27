import 'package:drift/drift.dart';
import '../app_database.dart';

part 'swing_dao.g.dart';

@DriftAccessor(tables: [Swings])
class SwingDao extends DatabaseAccessor<AppDatabase> with _$SwingDaoMixin {
  SwingDao(super.db);

  Future<int> insertSwing(SwingsCompanion swing) async {
    return into(swings).insert(swing);
  }

  Future<void> bulkInsertSwings(List<SwingsCompanion> swingList) async {
    await batch((b) => b.insertAll(swings, swingList));
  }

  Future<List<Swing>> getSwingsForSession(int sessionId) async {
    return (select(swings)
          ..where((s) => s.sessionId.equals(sessionId))
          ..orderBy([(s) => OrderingTerm.asc(s.timestamp)]))
        .get();
  }
}
