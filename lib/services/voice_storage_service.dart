import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';

class VoiceStorageService {
  VoiceStorageService._();

  static const int maxDurationSeconds = 60;
  static final AudioRecorder _recorder = AudioRecorder();

  static Future<bool> hasPermission() => _recorder.hasPermission();

  static Future<String> createTempPath() async {
    final dir = await getTemporaryDirectory();
    final voiceDir = Directory(p.join(dir.path, 'diary_voice_temp'));
    if (!await voiceDir.exists()) {
      await voiceDir.create(recursive: true);
    }
    return p.join(
      voiceDir.path,
      'voice_${DateTime.now().millisecondsSinceEpoch}.m4a',
    );
  }

  static Future<void> startRecording(String path) async {
    await _recorder.start(
      const RecordConfig(
        encoder: AudioEncoder.aacLc,
        bitRate: 128000,
        sampleRate: 44100,
      ),
      path: path,
    );
  }

  static Future<bool> isRecording() => _recorder.isRecording();

  static Future<String?> stopRecording() => _recorder.stop();

  static Future<void> cancelRecording() async {
    if (await _recorder.isRecording()) {
      await _recorder.cancel();
    }
  }

  static Future<String> persistVoice(String tempPath) async {
    final dir = await getApplicationDocumentsDirectory();
    final voiceDir = Directory(p.join(dir.path, 'diary_voices'));
    if (!await voiceDir.exists()) {
      await voiceDir.create(recursive: true);
    }

    final extension = p.extension(tempPath);
    final safeExtension = extension.isEmpty ? '.m4a' : extension;
    final fileName =
        'voice_${DateTime.now().millisecondsSinceEpoch}$safeExtension';
    final savedPath = p.join(voiceDir.path, fileName);

    final source = File(tempPath);
    if (!await source.exists()) {
      throw StateError('录音文件不存在');
    }
    await source.copy(savedPath);
    try {
      await source.delete();
    } catch (_) {}
    return savedPath;
  }

  static Future<void> deleteVoice(String? path) async {
    if (path == null || path.isEmpty) return;
    final file = File(path);
    if (await file.exists()) {
      await file.delete();
    }
  }

  static Future<void> dispose() => _recorder.dispose();
}
