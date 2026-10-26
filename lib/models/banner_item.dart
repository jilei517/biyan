class BannerTip {
  const BannerTip({
    required this.title,
    required this.desc,
  });

  final String title;
  final String desc;
}

class BannerMoreItem {
  const BannerMoreItem({
    required this.title,
    required this.summary,
    required this.content,
  });

  final String title;
  final String summary;
  final String content;
}

class BannerItem {
  const BannerItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.tag,
    required this.content,
    required this.authorId,
    required this.authorName,
    required this.image,
    this.tips = const [],
    this.moreItems = const [],
  });

  final int id;
  final String title;
  final String subtitle;
  final String tag;
  final String content;
  final String authorId;
  final String authorName;
  final String image;
  final List<BannerTip> tips;
  final List<BannerMoreItem> moreItems;

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'subtitle': subtitle,
        'tag': tag,
        'content': content,
        'authorId': authorId,
        'authorName': authorName,
        'image': image,
      };

  factory BannerItem.fromJson(Map<String, dynamic> json) {
    return BannerItem(
      id: json['id'] as int,
      title: json['title'] as String,
      subtitle: json['subtitle'] as String,
      tag: json['tag'] as String,
      content: json['content'] as String,
      authorId: json['authorId'] as String? ?? '',
      authorName: json['authorName'] as String? ?? '',
      image: json['image'] as String,
    );
  }
}
