import 'package:flutter_test/flutter_test.dart';
import 'package:us_screener/main.dart';

void main() {
  testWidgets('initial screen opens navigation menu and routes to Screener', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const UScreenerApp());

    expect(find.text('Recruitment overview'), findsNothing);
    expect(find.text('Daftar notes saham US'), findsNothing);
    expect(find.text('Menu Utama'), findsOneWidget);

    await tester.tap(find.text('Menu Utama'));
    await tester.pumpAndSettle();

    expect(find.text('Screener'), findsOneWidget);

    final screenerMenuItem = find.widgetWithText(
      PopupMenuItem<MainMenuAction>,
      'Screener',
    );
    final screenerMenuEntry = find.descendant(
      of: screenerMenuItem,
      matching: find.text('Screener'),
    );

    await tester.tap(screenerMenuEntry);
    await tester.pumpAndSettle();

    expect(find.text('Daftar notes saham US'), findsOneWidget);
    expect(find.text('Editor note'), findsOneWidget);
    expect(find.byTooltip('Back'), findsOneWidget);

    await tester.tap(find.byTooltip('Back'));
    await tester.pumpAndSettle();

    expect(find.text('Menu Utama'), findsOneWidget);
    expect(find.text('Daftar notes saham US'), findsNothing);
  });
}
