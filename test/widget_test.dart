import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:biyan/app.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('已登录时直接进入首页', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({'is_logged_in': true});
    await tester.pumpWidget(const BiyanApp(loggedIn: true));
    await tester.pump();
    expect(find.text('首页'), findsOneWidget);
  });

  testWidgets('未登录时直接进入登录页', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    await tester.pumpWidget(const BiyanApp(loggedIn: false));
    await tester.pump();
    expect(find.text('登录'), findsWidgets);
  });

  testWidgets('退出账号后返回登录页', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({'is_logged_in': true});
    await tester.pumpWidget(const BiyanApp(loggedIn: true));
    await tester.pump();

    await tester.tap(find.text('我的'));
    await tester.pump();
    await tester.tap(find.byIcon(Icons.settings_outlined));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 350));

    await tester.tap(find.text('退出账号'));
    await tester.pump();
    await tester.tap(find.text('确认退出'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 350));

    expect(find.text('登录'), findsWidgets);
    expect(find.text('首页'), findsNothing);
  });
}
