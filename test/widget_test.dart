import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('renders a basic Material widget tree', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: Center(child: Text('El Trueque'))),
      ),
    );

    expect(find.text('El Trueque'), findsOneWidget);
  });
}
