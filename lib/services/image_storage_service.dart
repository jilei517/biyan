import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class ImageStorageService {
  ImageStorageService._();

  static const int maxDiaryImages = 3;
  static final ImagePicker _picker = ImagePicker();

  static Future<String> persistImage(XFile file, {int index = 0}) async {
    return _persistImage(file, subdir: 'diary_images', index: index);
  }

  static Future<String> _persistImage(
    XFile file, {
    required String subdir,
    int index = 0,
  }) async {
    final dir = await getApplicationDocumentsDirectory();
    final imagesDir = Directory(p.join(dir.path, subdir));
    if (!await imagesDir.exists()) {
      await imagesDir.create(recursive: true);
    }

    final extension = p.extension(file.path);
    final safeExtension = extension.isEmpty ? '.jpg' : extension;
    final fileName =
        '${DateTime.now().millisecondsSinceEpoch}_$index$safeExtension';
    final savedPath = p.join(imagesDir.path, fileName);

    final bytes = await file.readAsBytes();
    await File(savedPath).writeAsBytes(bytes, flush: true);
    return savedPath;
  }

  static Future<String?> pickAvatarFromGallery() async {
    final picked = await _pickImages(1);
    if (picked.isEmpty) return null;
    return _persistImage(picked.first, subdir: 'avatar_images');
  }

  static Future<String?> pickSingleFromGallery() async {
    final picked = await _pickImages(1);
    if (picked.isEmpty) return null;
    return _persistImage(picked.first, subdir: 'diary_images');
  }

  static Future<List<String>> pickFromGallery({
    required int currentCount,
  }) async {
    final remaining = maxDiaryImages - currentCount;
    if (remaining <= 0) return [];

    final picked = await _pickImages(remaining);
    if (picked.isEmpty) return [];

    final saved = <String>[];
    for (var i = 0; i < picked.length && i < remaining; i++) {
      saved.add(await persistImage(picked[i], index: i));
    }
    return saved;
  }

  static Future<List<XFile>> _pickImages(int remaining) async {
    if (remaining <= 0) return [];

    if (remaining == 1) {
      final file = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
        requestFullMetadata: false,
      );
      return file == null ? [] : [file];
    }

    try {
      final files = await _picker.pickMultiImage(
        imageQuality: 85,
        limit: remaining,
        requestFullMetadata: false,
      );
      if (files.isNotEmpty) return files.take(remaining).toList();
    } catch (_) {
    }

    final fallback = <XFile>[];
    for (var i = 0; i < remaining; i++) {
      final file = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
        requestFullMetadata: false,
      );
      if (file == null) break;
      fallback.add(file);
    }
    return fallback;
  }
}
