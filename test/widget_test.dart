import 'package:flutter_test/flutter_test.dart';
import 'package:z01auth/main.dart';

void main() {
  testWidgets('Z01AuthApp loads and displays auth screen', (WidgetTester tester) async {
    await tester.pumpWidget(const Z01AuthApp());
    expect(find.text('Z01auth'), findsOneWidget);
  });
}
