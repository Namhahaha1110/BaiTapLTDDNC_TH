// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:tuan1_ltdd/main.dart';
import 'package:tuan1_ltdd/state/session.dart';

void main() {
  testWidgets('Login screen is shown', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});

    final session = Session();
    await session.init();

    await tester.pumpWidget(MyApp(session: session));

    expect(find.text('ĐĂNG NHẬP'), findsWidgets);
    expect(find.byIcon(Icons.account_circle), findsOneWidget);
  });
}
