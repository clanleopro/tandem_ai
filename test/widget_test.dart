import 'package:flutter_test/flutter_test.dart';
import 'package:tandem/main.dart';

void main() {
  testWidgets('RigGuard App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const RigGuardApp());
    expect(find.text('RIGGUARD'), findsOneWidget);
  });
}
