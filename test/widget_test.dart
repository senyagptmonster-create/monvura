import 'package:flutter_test/flutter_test.dart';
import 'package:monvura/monvura_app.dart';

void main() {
  testWidgets('MonvuraApp smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const MonvuraApp());
    expect(find.text('Chronotype Profile'), findsOneWidget);
  });
}
