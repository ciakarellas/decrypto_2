// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester utility in the flutter_test package.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:decrypto_2/main.dart';

void main() {
  testWidgets('HomeScreen displays correctly and buttons are present', (
    WidgetTester tester,
  ) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that the HomeScreen is displayed by checking for its title.
    expect(find.text('Decrypto'), findsOneWidget);

    // Verify that the "Start Game" and "Settings" buttons are present.
    expect(find.widgetWithText(ElevatedButton, 'Start Game'), findsOneWidget);
    expect(find.widgetWithText(TextButton, 'Settings'), findsOneWidget);
  });
}
