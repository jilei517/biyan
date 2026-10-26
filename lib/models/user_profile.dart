import 'package:biyan/data/image_urls.dart';

class UserProfile {
  const UserProfile({
    required this.nickname,
    required this.avatar,
    required this.gender,
    required this.age,
    required this.signature,
  });

  final String nickname;
  final String avatar;
  final String gender;
  final int? age;
  final String signature;

  bool get hasAvatar => avatar.isNotEmpty;

  String get displayGender => gender.isEmpty ? '未设置' : gender;

  String get displayAge => age == null ? '未设置' : '$age岁';

  UserProfile copyWith({
    String? nickname,
    String? avatar,
    String? gender,
    int? age,
    bool clearAge = false,
    String? signature,
  }) {
    return UserProfile(
      nickname: nickname ?? this.nickname,
      avatar: avatar ?? this.avatar,
      gender: gender ?? this.gender,
      age: clearAge ? null : (age ?? this.age),
      signature: signature ?? this.signature,
    );
  }

  Map<String, dynamic> toJson() => {
        'nickname': nickname,
        'avatar': avatar,
        'gender': gender,
        'age': age,
        'signature': signature,
      };

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      nickname: json['nickname'] as String? ?? '',
      avatar: json['avatar'] as String? ?? '',
      gender: json['gender'] as String? ?? '',
      age: json['age'] as int?,
      signature: json['signature'] as String? ?? '',
    );
  }

  static UserProfile forAccount(String? phone) {
    final digits = (phone ?? '').trim();
    final suffix = digits.length >= 4
        ? digits.substring(digits.length - 4)
        : digits;
    return UserProfile(
      nickname: suffix.isEmpty ? '用户' : '用户$suffix',
      avatar: '',
      gender: '',
      age: null,
      signature: '',
    );
  }

  static UserProfile get defaultProfile => UserProfile(
        nickname: '阿颜',
        avatar: ImageUrls.avatarAnimal,
        gender: '女',
        age: 24,
        signature: '有空再改签名',
      );
}
