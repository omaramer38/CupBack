import 'package:flutter_test/flutter_test.dart';
import 'package:cupback_mobile/main.dart';

void main() {
  testWidgets('CupBackApp renders properly', (WidgetTester tester) async {
    await tester.pumpWidget(const CupBackApp());
    expect(find.byType(CupBackApp), findsOneWidget);
  });
}
