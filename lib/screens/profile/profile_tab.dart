import 'package:flutter/material.dart';
import 'package:biyan/models/memo_item.dart';
import 'package:biyan/models/user_profile.dart';
import 'package:biyan/theme/app_colors.dart';
import 'package:biyan/widgets/user_avatar.dart';

class ProfileTab extends StatefulWidget {
  const ProfileTab({
    super.key,
    required this.profile,
    required this.memos,
    required this.onEditProfile,
    required this.onSettings,
    required this.onAddMemo,
    required this.onDeleteMemo,
    required this.onMemoTap,
  });

  final UserProfile profile;
  final List<MemoItem> memos;
  final VoidCallback onEditProfile;
  final VoidCallback onSettings;
  final void Function(String title, String content) onAddMemo;
  final ValueChanged<int> onDeleteMemo;
  final ValueChanged<MemoItem> onMemoTap;

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  bool _isAddingMemo = false;
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _saveMemo() {
    final title = _titleController.text.trim();
    final content = _contentController.text.trim();
    if (title.isEmpty && content.isEmpty) {
      setState(() => _isAddingMemo = false);
      return;
    }
    widget.onAddMemo(title, content);
    _titleController.clear();
    _contentController.clear();
    setState(() => _isAddingMemo = false);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ListView(
      padding: const EdgeInsets.only(bottom: 100),
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(20, 40, 20, 24),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(32),
              bottomRight: Radius.circular(32),
            ),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  UserAvatar(avatar: widget.profile.avatar),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.profile.nickname,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.profile.signature.isEmpty
                              ? '写一句个性签名吧'
                              : widget.profile.signature,
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            UserProfileChip(label: widget.profile.gender),
                            const SizedBox(width: 8),
                            UserProfileChip(label: '${widget.profile.age}岁'),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: widget.onEditProfile,
                  icon: const Icon(Icons.edit_outlined, size: 18),
                  label: const Text('编辑资料'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.purple,
                    side: const BorderSide(color: AppColors.purpleLight),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '备忘录',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              GestureDetector(
                onTap: () => setState(() => _isAddingMemo = true),
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: const BoxDecoration(
                    color: AppColors.textPrimary,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.add, color: Colors.white, size: 18),
                ),
              ),
            ],
          ),
        ),
        if (_isAddingMemo) ...[
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.purpleLight),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: Column(
                children: [
                  TextField(
                    controller: _titleController,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                    decoration: const InputDecoration(
                      hintText: '标题',
                      border: InputBorder.none,
                    ),
                  ),
                  TextField(
                    controller: _contentController,
                    maxLines: 4,
                    style: const TextStyle(fontSize: 14),
                    decoration: const InputDecoration(
                      hintText: '写点什么 ...',
                      border: InputBorder.none,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => setState(() => _isAddingMemo = false),
                        child: const Text('取消'),
                      ),
                      TextButton(
                        onPressed: _saveMemo,
                        style: TextButton.styleFrom(
                          backgroundColor: AppColors.purpleDark,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('保存'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: widget.memos.isEmpty && !_isAddingMemo
              ? Padding(
                  padding: const EdgeInsets.symmetric(vertical: 32),
                  child: Center(
                    child: Text(
                      '暂无备忘录',
                      style: TextStyle(color: Colors.grey.shade400),
                    ),
                  ),
                )
              : GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.85,
                  ),
                  itemCount: widget.memos.length,
                  itemBuilder: (context, index) {
                    final memo = widget.memos[index];
                    return _MemoCard(
                      memo: memo,
                      onTap: () => widget.onMemoTap(memo),
                      onDelete: () => widget.onDeleteMemo(memo.id),
                    );
                  },
                ),
        ),
      ],
    ),
        Positioned(
          top: 8,
          right: 8,
          child: IconButton(
            onPressed: widget.onSettings,
            icon: const Icon(Icons.settings_outlined),
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}

class _MemoCard extends StatelessWidget {
  const _MemoCard({
    required this.memo,
    required this.onTap,
    required this.onDelete,
  });

  final MemoItem memo;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 6,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    memo.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: onDelete,
                  child: Icon(
                    Icons.delete_outline,
                    size: 16,
                    color: Colors.grey.shade300,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Expanded(
              child: Text(
                memo.content,
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                  height: 1.4,
                ),
              ),
            ),
            Text(
              memo.date,
              style: const TextStyle(
                fontSize: 10,
                color: AppColors.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
