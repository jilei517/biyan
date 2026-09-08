import 'package:flutter/material.dart';
import 'package:biyan/models/memo_item.dart';
import 'package:biyan/theme/app_colors.dart';
import 'package:biyan/widgets/screen_header.dart';

class MemoDetailScreen extends StatefulWidget {
  const MemoDetailScreen({
    super.key,
    required this.memo,
    required this.onBack,
    required this.onSave,
  });

  final MemoItem memo;
  final VoidCallback onBack;
  final ValueChanged<MemoItem> onSave;

  @override
  State<MemoDetailScreen> createState() => _MemoDetailScreenState();
}

class _MemoDetailScreenState extends State<MemoDetailScreen> {
  late final TextEditingController _titleController;
  late final TextEditingController _contentController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.memo.title);
    _contentController = TextEditingController(text: widget.memo.content);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _handleSave() {
    widget.onSave(
      widget.memo.copyWith(
        title: _titleController.text.trim().isEmpty
            ? '无标题'
            : _titleController.text.trim(),
        content: _contentController.text,
      ),
    );
    widget.onBack();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.memoBackground,
      body: Column(
        children: [
          ScreenHeader(
            title: '编辑备忘录',
            onBack: _handleSave,
            rightWidget: GestureDetector(
              onTap: _handleSave,
              child: const Text(
                '完成',
                style: TextStyle(
                  color: Color(0xFFCA8A04),
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: _titleController,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                    decoration: const InputDecoration(
                      hintText: '标题',
                      border: InputBorder.none,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.memo.date,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textMuted,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Expanded(
                    child: TextField(
                      controller: _contentController,
                      maxLines: null,
                      expands: true,
                      style: const TextStyle(
                        fontSize: 16,
                        height: 1.7,
                        color: AppColors.textPrimary,
                      ),
                      decoration: const InputDecoration(
                        hintText: '开始记录 ...',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
