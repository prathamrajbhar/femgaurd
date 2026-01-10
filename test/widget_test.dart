// Basic widget test for FemGuard app
import 'package:flutter_test/flutter_test.dart';
import 'package:mobileapp/main.dart';
import 'package:mobileapp/services/app_state.dart';

void main() {
  testWidgets('App launches successfully', (WidgetTester tester) async {
    // Create a mock app state
    final appState = AppState();
    
    // Build our app and trigger a frame.
    await tester.pumpWidget(FemGuardApp(appState: appState));

    // Verify that the splash screen is shown.
    expect(find.text('FemGuard'), findsOneWidget);
  });
}
