import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:us_screener/main.dart';

void main() {
  testWidgets('notes app and sample stock notes are visible', (WidgetTester tester) async {
    await tester.pumpWidget(const UScreenerNotesApp());

    expect(find.text('US Screener Notes'), findsOneWidget);
    expect(find.text('AAPL pullback watch'), findsOneWidget);
    expect(find.text('NVDA earnings setup'), findsOneWidget);
    expect(find.text('MSFT cloud momentum'), findsOneWidget);
  });

  testWidgets('can create new note from editor', (WidgetTester tester) async {
    await tester.pumpWidget(const UScreenerNotesApp());

    await tester.tap(find.widgetWithText(FloatingActionButton, 'New note'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byKey(const Key('titleField')), 'Breakout plan');
    await tester.enterText(find.byKey(const Key('tickerField')), 'tsla');
    await tester.enterText(
      find.byKey(const Key('contentField')),
      'Wait for volume confirmation above resistance.',
    );

    await tester.tap(find.widgetWithText(FilledButton, 'Save'));
    await tester.pumpAndSettle();

    expect(find.text('Breakout plan'), findsOneWidget);
    expect(find.text('TSLA'), findsOneWidget);
  });

  testWidgets('search filters notes by ticker and content', (WidgetTester tester) async {
    await tester.pumpWidget(const UScreenerNotesApp());

    await tester.enterText(find.byKey(const Key('searchField')), 'nvda');
    await tester.pumpAndSettle();

    expect(find.text('NVDA earnings setup'), findsOneWidget);
    expect(find.text('AAPL pullback watch'), findsNothing);
  });
}
