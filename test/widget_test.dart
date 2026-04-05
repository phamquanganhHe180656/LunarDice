import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lunar_dice/main.dart';

void main() {
  testWidgets('App starts and shows home screen', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: LunarDiceApp()),
    );

    // The home screen should display the game name.
    expect(find.text('Bầu Cua Tôm Cá'), findsWidgets);
    expect(find.text('Vào Game'), findsOneWidget);
  });

  testWidgets('Player name validation rejects empty input',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: LunarDiceApp()),
    );

    // Tap the play button without entering a name.
    await tester.tap(find.text('Vào Game'));
    await tester.pump();

    expect(find.text('Vui lòng nhập tên của bạn'), findsOneWidget);
  });
}
