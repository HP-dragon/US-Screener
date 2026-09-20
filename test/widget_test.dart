import 'package:flutter_test/flutter_test.dart';
import 'package:us_screener/main.dart';

void main() {
  testWidgets('US Screener app loads', (WidgetTester tester) async {
    await tester.pumpWidget(const UScreenerApp());

    expect(find.text('US Screener'), findsAtLeastNWidgets(1));
    expect(find.text('Recruitment overview'), findsOneWidget);
  });
}
