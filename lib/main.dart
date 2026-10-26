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
    runApp(const BiyanApp());
  } catch (_) {
    runApp(const BiyanApp());
  } finally {
    binding.allowFirstFrame();
  }
}
