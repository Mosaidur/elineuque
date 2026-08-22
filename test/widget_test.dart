import 'package:flutter_test/flutter_test.dart';
import 'package:elineuque/main.dart';

void main() {
  testWidgets('Elivapp smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const Elivapp());

    // Verify that the app builds without crashing.
    expect(find.byType(Elivapp), findsOneWidget);

    // Fast-forward past the splash screen timer.
    await tester.pump(const Duration(seconds: 3));
    await tester.pumpAndSettle();
  });
}
