import 'package:flutter_test/flutter_test.dart';
import 'package:tandem/main.dart';

void main() {
  testWidgets('Tandem AI App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const TandemAiApp());
    expect(find.text('TANDEM AI'), findsWidgets);
  });
}
