import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:swingspeed/widgets/speed_gauge.dart';

void main() {
  group('SpeedGauge', () {
    testWidgets('renders with speed value', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: Scaffold(body: SpeedGauge(speedMph: 85.0))));
      expect(find.text('85.0'), findsOneWidget);
      expect(find.text('MPH'), findsOneWidget);
    });

    testWidgets('renders zero state', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: Scaffold(body: SpeedGauge(speedMph: 0.0))));
      expect(find.text('0.0'), findsOneWidget);
    });
  });
}
