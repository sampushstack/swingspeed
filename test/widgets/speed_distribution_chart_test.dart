import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:swingspeed/widgets/speed_distribution_chart.dart';

void main() {
  group('SpeedDistributionChart', () {
    testWidgets('renders with speed data', (tester) async {
      await tester.pumpWidget(MaterialApp(home: Scaffold(body: SpeedDistributionChart(speeds: [80.0, 85.0, 82.0, 90.0]))));
      expect(find.byType(SpeedDistributionChart), findsOneWidget);
    });

    testWidgets('renders empty state with no data', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: Scaffold(body: SpeedDistributionChart(speeds: []))));
      expect(find.text('No swing data'), findsOneWidget);
    });
  });
}
