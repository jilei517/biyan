import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:biyan/app.dart';
import 'package:biyan/services/storage_service.dart';

Future<void> main() async {
  final binding = WidgetsFlutterBinding.ensureInitialized();
  binding.deferFirstFrame();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  try {
    await StorageService.warmup();
    final loggedIn = await StorageService.isLoggedIn();
    runApp(BiyanApp(loggedIn: loggedIn));
  } catch (_) {
    runApp(const BiyanApp(loggedIn: false));
  } finally {
    binding.allowFirstFrame();
  }
}
