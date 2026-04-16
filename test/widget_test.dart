import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:fitforge/core/theme/app_theme.dart';

void main() {
  testWidgets('MaterialApp renders with FitForge theme', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [],
        child: MaterialApp(
          title: 'FitForge',
          theme: AppTheme.light(),
          home: const Scaffold(body: Text('Test')),
        ),
      ),
    );

    expect(find.text('Test'), findsOneWidget);
  });
}
