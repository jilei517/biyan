import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:biyan/models/watched_movie.dart';
import 'package:biyan/theme/app_colors.dart';
import 'package:biyan/widgets/screen_header.dart';

class MoviesScreen extends StatefulWidget {
  const MoviesScreen({
    super.key,
    required this.movies,
    required this.onBack,
    required this.onMoviesChanged,
  });

  final List<WatchedMovie> movies;
  final VoidCallback onBack;
  final ValueChanged<List<WatchedMovie>> onMoviesChanged;

  @override
  State<MoviesScreen> createState() => _MoviesScreenState();
}

class _MoviesScreenState extends State<MoviesScreen> {
  late List<WatchedMovie> _movies;

  @override
  void initState() {
    super.initState();
    _movies = List<WatchedMovie>.from(widget.movies);
  }

  void _showAddDialog() {
    final controller = TextEditingController();
    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('添加电影'),
          content: TextField(
            controller: controller,
            autofocus: true,
            decoration: const InputDecoration(
              hintText: '输入电影名称',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('取消'),
            ),
            TextButton(
              onPressed: () {
                final title = controller.text.trim();
                if (title.isEmpty) return;
                final now = DateFormat('MM-dd').format(DateTime.now());
                final movie = WatchedMovie(
                  id: DateTime.now().millisecondsSinceEpoch,
                  title: title,
                  date: now,
                );
                setState(() => _movies = [movie, ..._movies]);
                widget.onMoviesChanged(_movies);
                Navigator.pop(context);
              },
              child: const Text('添加'),
            ),
          ],
        );
      },
    );
  }

  void _deleteMovie(int id) {
    setState(() {
      _movies = _movies.where((movie) => movie.id != id).toList();
    });
    widget.onMoviesChanged(_movies);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundGray,
      body: Column(
        children: [
          ScreenHeader(
            title: '看过的电影',
            onBack: widget.onBack,
            rightWidget: IconButton(
              onPressed: _showAddDialog,
              icon: const Icon(Icons.add, color: AppColors.purple),
            ),
          ),
          Container(
            width: double.infinity,
            margin: const EdgeInsets.fromLTRB(20, 0, 20, 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFFDF2F8), Color(0xFFF3E8FF)],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.purpleLight),
            ),
            child: Row(
              children: [
                const Icon(Icons.movie_outlined, color: AppColors.purple, size: 24),
                const SizedBox(width: 12),
                Text(
                  '共看过 ${_movies.length} 部',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: _movies.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.movie_creation_outlined,
                          size: 48,
                          color: Colors.grey.shade300,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          '还没有记录，点击右上角添加吧',
                          style: TextStyle(color: Colors.grey.shade400),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                    itemCount: _movies.length,
                    itemBuilder: (context, index) {
                      final movie = _movies[index];
                      return Dismissible(
                        key: ValueKey(movie.id),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          margin: const EdgeInsets.only(bottom: 10),
                          decoration: BoxDecoration(
                            color: Colors.red.shade400,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Icon(Icons.delete_outline, color: Colors.white),
                        ),
                        onDismissed: (_) => _deleteMovie(movie.id),
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: AppColors.purpleLight,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  '${index + 1}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.purple,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      movie.title,
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      '观看于 ${movie.date}',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: AppColors.textMuted,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                onPressed: () => _deleteMovie(movie.id),
                                icon: Icon(
                                  Icons.close,
                                  size: 18,
                                  color: Colors.grey.shade400,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
