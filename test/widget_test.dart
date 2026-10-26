import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:biyan/app.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('启动后直接进入首页', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    await tester.pumpWidget(const BiyanApp());
    await tester.pump();
    await tester.pump();
    expect(find.text('首页'), findsOneWidget);
    expect(find.text('请输入手机号码'), findsNothing);
  });

  testWidgets('未登录点击爱好会弹出登录页', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    await tester.pumpWidget(const BiyanApp());
    await tester.pump();
    await tester.pump();

    await tester.tap(find.text('爱好'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 350));

    expect(find.text('请输入手机号码'), findsOneWidget);
  });

  testWidgets('退出账号后仍留在首页', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({'is_logged_in': true});
    await tester.pumpWidget(const BiyanApp());
    await tester.pump();
    await tester.pump();

    await tester.tap(find.text('我的'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 350));
    await tester.tap(find.byIcon(Icons.settings_outlined));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 350));

    await tester.tap(find.text('退出账号'));
    await tester.pump();
    await tester.tap(find.text('确认退出'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 350));

    expect(find.text('首页'), findsOneWidget);
    expect(find.text('登录'), findsNothing);
  });
}
