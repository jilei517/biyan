import 'package:flutter/material.dart';

class DiaryEntry {
  const DiaryEntry({
    required this.id,
    required this.day,
    required this.monthWeek,
    required this.emotionIcon,
    required this.text,
    required this.images,
    required this.emotionText,
    required this.time,
    this.year = 2024,
    this.month = 3,
    this.fullDate,
    this.voicePath,
    this.voiceDurationSeconds,
  });

  final int id;
  final String day;
  final String monthWeek;
  final String emotionIcon;
  final String text;
  final List<String> images;
  final String emotionText;
  final String time;
  final int year;
  final int month;
  final String? fullDate;
  final String? voicePath;
  final int? voiceDurationSeconds;

  int get imgCount => images.length;

  bool get hasVoice =>
      voicePath != null && voicePath!.isNotEmpty && (voiceDurationSeconds ?? 0) > 0;

  Color get emotionColor {
    switch (emotionText) {
      case '开心':
        return Colors.amber;
      case '难过':
        return Colors.blue;
      case '满足':
        return Colors.redAccent;
      case '记录':
        return const Color(0xFF9D62F5);
      default:
        return const Color(0xFFFF8696);
    }
  }

  Color get calendarBgColor {
    switch (emotionText) {
      case '开心':
        return const Color(0xFFFFF59D);
      case '难过':
        return Colors.blue;
      case '满足':
        return Colors.redAccent;
      default:
        return const Color(0xFFFF8696);
    }
  }

  bool get calendarTextWhite {
    return emotionText == '难过' || emotionText == '满足';
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'day': day,
        'monthWeek': monthWeek,
        'emotionIcon': emotionIcon,
        'text': text,
        'images': images,
        'emotionText': emotionText,
        'time': time,
        'year': year,
        'month': month,
        'fullDate': fullDate,
        'voicePath': voicePath,
        'voiceDurationSeconds': voiceDurationSeconds,
      };

  factory DiaryEntry.fromJson(Map<String, dynamic> json) {
    return DiaryEntry(
      id: json['id'] as int,
      day: json['day'] as String,
      monthWeek: json['monthWeek'] as String,
      emotionIcon: json['emotionIcon'] as String,
      text: json['text'] as String,
      images: (json['images'] as List<dynamic>).cast<String>(),
      emotionText: json['emotionText'] as String,
      time: json['time'] as String,
      year: json['year'] as int? ?? 2024,
      month: json['month'] as int? ?? 3,
      fullDate: json['fullDate'] as String?,
      voicePath: json['voicePath'] as String?,
      voiceDurationSeconds: json['voiceDurationSeconds'] as int?,
    );
  }

  DiaryEntry copyWith({
    int? id,
    String? day,
    String? monthWeek,
    String? emotionIcon,
    String? text,
    List<String>? images,
    String? emotionText,
    String? time,
    int? year,
    int? month,
    String? fullDate,
    String? voicePath,
    int? voiceDurationSeconds,
    bool clearVoice = false,
  }) {
    return DiaryEntry(
      id: id ?? this.id,
      day: day ?? this.day,
      monthWeek: monthWeek ?? this.monthWeek,
      emotionIcon: emotionIcon ?? this.emotionIcon,
      text: text ?? this.text,
      images: images ?? this.images,
      emotionText: emotionText ?? this.emotionText,
      time: time ?? this.time,
      year: year ?? this.year,
      month: month ?? this.month,
      fullDate: fullDate ?? this.fullDate,
      voicePath: clearVoice ? null : (voicePath ?? this.voicePath),
      voiceDurationSeconds:
          clearVoice ? null : (voiceDurationSeconds ?? this.voiceDurationSeconds),
    );
  }
}
