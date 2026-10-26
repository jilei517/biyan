import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

bool isAssetImagePath(String source) => source.startsWith('assets/');

bool isLocalImagePath(String source) {
  if (isAssetImagePath(source)) return false;
  if (source.startsWith('file://')) return true;
  if (!kIsWeb && (source.startsWith('/') || RegExp(r'^[A-Za-z]:\\').hasMatch(source))) {
    return true;
  }
  return false;
}

String localImagePath(String source) {
  if (source.startsWith('file://')) {
    return Uri.parse(source).toFilePath();
  }
  return source;
}

class AppImage extends StatelessWidget {
  const AppImage({
    super.key,
    required this.url,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.assetFallback = 'assets/images/placeholder.png',
  });

  final String url;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;
  final String assetFallback;

  int? _cacheSize(double? logicalSize, double devicePixelRatio) {
    if (logicalSize == null || !logicalSize.isFinite || logicalSize <= 0) {
      return null;
    }
    return (logicalSize * devicePixelRatio).round();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final devicePixelRatio = MediaQuery.devicePixelRatioOf(context);
        final resolvedWidth = width ??
            (constraints.maxWidth.isFinite ? constraints.maxWidth : null);
        final resolvedHeight = height ??
            (constraints.maxHeight.isFinite ? constraints.maxHeight : null);
        final cacheWidth = _cacheSize(resolvedWidth, devicePixelRatio);
        final cacheHeight = _cacheSize(resolvedHeight, devicePixelRatio);

        Widget image;
        if (url.isEmpty) {
          image = Image.asset(
            assetFallback,
            width: width,
            height: height,
            fit: fit,
            cacheWidth: cacheWidth,
            cacheHeight: cacheHeight,
          );
        } else if (isAssetImagePath(url)) {
          image = Image.asset(
            url,
            width: width,
            height: height,
            fit: fit,
            cacheWidth: cacheWidth,
            cacheHeight: cacheHeight,
            filterQuality: FilterQuality.medium,
            gaplessPlayback: true,
            errorBuilder: (context, error, stackTrace) {
              return Image.asset(
                assetFallback,
                width: width,
                height: height,
                fit: fit,
                cacheWidth: cacheWidth,
                cacheHeight: cacheHeight,
              );
            },
          );
        } else if (isLocalImagePath(url)) {
          image = Image.file(
            File(localImagePath(url)),
            width: width,
            height: height,
            fit: fit,
            cacheWidth: cacheWidth,
            cacheHeight: cacheHeight,
            filterQuality: FilterQuality.medium,
            gaplessPlayback: true,
            errorBuilder: (context, error, stackTrace) {
              return Image.asset(
                assetFallback,
                width: width,
                height: height,
                fit: fit,
                cacheWidth: cacheWidth,
                cacheHeight: cacheHeight,
              );
            },
          );
        } else {
          image = Image.network(
            url,
            width: width,
            height: height,
            fit: fit,
            cacheWidth: cacheWidth,
            cacheHeight: cacheHeight,
            filterQuality: FilterQuality.medium,
            gaplessPlayback: true,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return ColoredBox(
                color: Colors.grey.shade200,
                child: SizedBox(width: width, height: height),
              );
            },
            errorBuilder: (context, error, stackTrace) {
              return Image.asset(
                assetFallback,
                width: width,
                height: height,
                fit: fit,
                cacheWidth: cacheWidth,
                cacheHeight: cacheHeight,
              );
            },
          );
        }

        if (borderRadius != null) {
          image = ClipRRect(borderRadius: borderRadius!, child: image);
        }

        return image;
      },
    );
  }
}
