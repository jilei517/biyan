class OutfitTip {
  const OutfitTip({
    required this.title,
    required this.desc,
  });

  final String title;
  final String desc;
}

class OutfitItem {
  const OutfitItem({
    required this.id,
    required this.style,
    required this.desc,
    required this.tags,
    required this.brand,
    required this.authorId,
    required this.authorName,
    required this.image,
    this.content = '',
    this.items = const [],
    this.scene = '',
    this.tips = const [],
  });

  final int id;
  final String style;
  final String desc;
  final List<String> tags;
  final String brand;
  final String authorId;
  final String authorName;
  final String image;
  final String content;
  final List<String> items;
  final String scene;
  final List<OutfitTip> tips;

  Map<String, dynamic> toJson() => {
        'id': id,
        'style': style,
        'desc': desc,
        'tags': tags,
        'brand': brand,
        'authorId': authorId,
        'authorName': authorName,
        'image': image,
        'content': content,
        'items': items,
        'scene': scene,
      };

  factory OutfitItem.fromJson(Map<String, dynamic> json) {
    return OutfitItem(
      id: json['id'] as int,
      style: json['style'] as String,
      desc: json['desc'] as String,
      tags: (json['tags'] as List<dynamic>).cast<String>(),
      brand: json['brand'] as String,
      authorId: json['authorId'] as String? ?? '',
      authorName: json['authorName'] as String? ?? '',
      image: json['image'] as String,
      content: json['content'] as String? ?? '',
      items: (json['items'] as List<dynamic>?)?.cast<String>() ?? const [],
      scene: json['scene'] as String? ?? '',
    );
  }
}
