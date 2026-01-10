// Basic widget test for HerHealth app
import 'package:flutter_test/flutter_test.dart';
import 'package:mobileapp/main.dart';

void main() {
  testWidgets('App launches successfully', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const HerHealthApp());

    // Verify that the splash screen is shown.
    expect(find.text('HerHealth'), findsOneWidget);
  });
}
