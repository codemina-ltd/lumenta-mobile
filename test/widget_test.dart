import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/features/auth/splash_screen.dart';

void main() {
  testWidgets('Splash renders the brand mark', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: SplashScreen()));
    expect(find.text('Lumenta'), findsOneWidget);
  });
}
