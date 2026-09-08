import 'package:flutter/material.dart';
import 'package:biyan/screens/auth/auth_gate.dart';
import 'package:biyan/theme/app_theme.dart';

class BiyanApp extends StatelessWidget {
  const BiyanApp({
    super.key,
    required this.loggedIn,
  });

  final bool loggedIn;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '彼颜',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: AuthGate(loggedIn: loggedIn),
    );
  }
}
