import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:swingspeed/database/app_database.dart';
import 'package:swingspeed/main.dart';
import 'package:swingspeed/providers/database_provider.dart';

void main() {
  testWidgets('App renders bottom navigation', (WidgetTester tester) async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(() => db.close());

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          databaseProvider.overrideWithValue(db),
        ],
        child: const SwingSpeedApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Home'), findsOneWidget);
    expect(find.text('History'), findsOneWidget);
    expect(find.text('Settings'), findsOneWidget);
  });
}
