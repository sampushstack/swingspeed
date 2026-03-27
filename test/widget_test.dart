import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:swingspeed/main.dart';

void main() {
  testWidgets('App renders SwingSpeed text', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: SwingSpeedApp()),
    );
    expect(find.text('SwingSpeed'), findsOneWidget);
  });
}
