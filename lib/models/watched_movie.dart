class WatchedMovie {
  const WatchedMovie({
    required this.id,
    required this.title,
    required this.date,
  });

  final int id;
  final String title;
  final String date;

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'date': date,
      };

  factory WatchedMovie.fromJson(Map<String, dynamic> json) {
    return WatchedMovie(
      id: json['id'] as int,
      title: json['title'] as String,
      date: json['date'] as String,
    );
  }
}
