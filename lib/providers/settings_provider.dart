import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../database/app_database.dart';
import 'database_provider.dart';

final settingsProvider = FutureProvider<Setting>((ref) async {
  return ref.watch(settingsDaoProvider).getSettings();
});
