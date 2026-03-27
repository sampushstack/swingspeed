import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'theme/augusta_theme.dart';

void main() {
  runApp(const ProviderScope(child: SwingSpeedApp()));
}

class SwingSpeedApp extends StatelessWidget {
  const SwingSpeedApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SwingSpeed',
      theme: AugustaTheme.dark,
      home: const Scaffold(body: Center(child: Text('SwingSpeed'))),
    );
  }
}
