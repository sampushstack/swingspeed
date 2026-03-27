import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../database/app_database.dart';
import 'database_provider.dart';

final historyProvider = FutureProvider<List<Session>>((ref) async {
  return ref.watch(sessionDaoProvider).getCompleteSessions();
});

final inProgressSessionProvider = FutureProvider<Session?>((ref) async {
  return ref.watch(sessionDaoProvider).getInProgressSession();
});
