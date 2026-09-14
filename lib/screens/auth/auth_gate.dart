import 'package:flutter/material.dart';
import 'package:biyan/screens/main_shell.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  int _homeEpoch = 0;

  void _reloadHome() {
    setState(() => _homeEpoch++);
  }

  @override
  Widget build(BuildContext context) {
    return MainShell(
      key: ValueKey(_homeEpoch),
      onSessionEnded: _reloadHome,
    );
  }
}
