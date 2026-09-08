import 'package:flutter/material.dart';
import 'package:biyan/screens/auth/login_screen.dart';
import 'package:biyan/screens/main_shell.dart';
import 'package:biyan/services/storage_service.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({
    super.key,
    required this.loggedIn,
  });

  final bool loggedIn;

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  late bool _loggedIn = widget.loggedIn;

  Future<void> _onLogin() async {
    await StorageService.setLoggedIn(true);
    if (!mounted) return;
    setState(() => _loggedIn = true);
  }

  void _endSession() {
    setState(() => _loggedIn = false);
  }

  @override
  Widget build(BuildContext context) {
    if (_loggedIn) {
      return MainShell(onSessionEnded: _endSession);
    }
    return LoginScreen(onLogin: _onLogin);
  }
}
