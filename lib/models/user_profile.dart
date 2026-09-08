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
  final int age;
  final String signature;

  UserProfile copyWith({
    String? nickname,
    String? avatar,
    String? gender,
    int? age,
    String? signature,
  }) {
    return UserProfile(
      nickname: nickname ?? this.nickname,
      avatar: avatar ?? this.avatar,
      gender: gender ?? this.gender,
      age: age ?? this.age,
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
      nickname: json['nickname'] as String,
      avatar: json['avatar'] as String,
      gender: json['gender'] as String,
      age: json['age'] as int,
      signature: json['signature'] as String,
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
