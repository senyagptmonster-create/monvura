import 'package:flutter_test/flutter_test.dart';
import 'package:monvura/monvura_app.dart';

void main() {
  testWidgets('MonvuraApp launches successfully smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const MonvuraApp());
    expect(find.byType(MonvuraApp), findsOneWidget);
  });
}