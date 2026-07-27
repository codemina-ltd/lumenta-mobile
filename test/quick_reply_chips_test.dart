import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/features/chats/widgets/quick_reply_chips.dart';

void main() {
  testWidgets('renders one display-only chip per title', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: QuickReplyChips(
            titles: ['Pricing', 'Support', 'Talk to a human'],
            textColor: Colors.black,
          ),
        ),
      ),
    );
    expect(find.text('Pricing'), findsOneWidget);
    expect(find.text('Support'), findsOneWidget);
    expect(find.text('Talk to a human'), findsOneWidget);
    // Display-only: nothing tappable in the chip tree.
    expect(find.byType(InkWell), findsNothing);
    expect(find.byType(GestureDetector), findsNothing);
  });

  testWidgets('an Arabic title lays out RTL', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: QuickReplyChips(titles: ['الأسعار'], textColor: Colors.black),
        ),
      ),
    );
    final text = tester.widget<Text>(find.text('الأسعار'));
    expect(text.textDirection, TextDirection.rtl);
  });
}
