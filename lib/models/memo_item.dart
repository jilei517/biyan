class MemoItem {
  const MemoItem({
    required this.id,
    required this.title,
    required this.content,
    required this.date,
  });

  final int id;
  final String title;
  final String content;
  final String date;

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'content': content,
        'date': date,
      };

  factory MemoItem.fromJson(Map<String, dynamic> json) {
    return MemoItem(
      id: json['id'] as int,
      title: json['title'] as String,
      content: json['content'] as String,
      date: json['date'] as String,
    );
  }

  MemoItem copyWith({
    int? id,
    String? title,
    String? content,
    String? date,
  }) {
    return MemoItem(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      date: date ?? this.date,
    );
  }
}
