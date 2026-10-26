import 'package:flutter/material.dart';
import 'package:biyan/data/app_data.dart';
import 'package:biyan/models/user_profile.dart';
import 'package:biyan/theme/app_colors.dart';
import 'package:biyan/widgets/tag_chip.dart';

class HobbiesTab extends StatefulWidget {
  const HobbiesTab({
    super.key,
    required this.profile,
    required this.selectedHobbies,
    required this.customTags,
    required this.onHobbiesChanged,
    required this.onCustomTagsChanged,
  });

  final UserProfile profile;
  final List<String> selectedHobbies;
  final List<String> customTags;
  final ValueChanged<List<String>> onHobbiesChanged;
  final ValueChanged<List<String>> onCustomTagsChanged;

  @override
  State<HobbiesTab> createState() => _HobbiesTabState();
}

class _HobbiesTabState extends State<HobbiesTab> {
  bool _isAddingCustom = false;
  final _customController = TextEditingController();

  @override
  void dispose() {
    _customController.dispose();
    super.dispose();
  }

  void _toggleHobby(String hobby) {
    final updated = List<String>.from(widget.selectedHobbies);
    if (updated.contains(hobby)) {
      updated.remove(hobby);
    } else {
      updated.add(hobby);
    }
    widget.onHobbiesChanged(updated);
  }

  void _resetHobbies() {
    widget.onHobbiesChanged([]);
  }

  void _addCustomTag() {
    final text = _customController.text.trim();
    if (text.isEmpty) {
      setState(() => _isAddingCustom = false);
      return;
    }

    final tags = List<String>.from(widget.customTags);
    if (!tags.contains(text)) {
      tags.add(text);
      widget.onCustomTagsChanged(tags);
    }

    final hobbies = List<String>.from(widget.selectedHobbies);
    if (!hobbies.contains(text)) {
      hobbies.add(text);
      widget.onHobbiesChanged(hobbies);
    }

    _customController.clear();
    setState(() => _isAddingCustom = false);
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            Text(
              '记录${widget.profile.nickname}的爱好',
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w900,
                fontStyle: FontStyle.italic,
                color: AppColors.textPrimary,
                letterSpacing: 1.2,
              ),
            ),
            Positioned(
              top: 4,
              right: 2,
              child: Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: AppColors.purpleDark.withValues(alpha: 0.8),
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFF5F3FF), Color(0xFFFDF2F8)],
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.purpleLight),
          ),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'TA 的爱好',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: widget.selectedHobbies.isEmpty
                        ? [
                            Text(
                              '还没有选择任何爱好呀 ~',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.purple.shade200,
                              ),
                            ),
                          ]
                        : widget.selectedHobbies
                            .map((tag) => DisplayTag(label: tag))
                            .toList(),
                  ),
                ],
              ),
              Positioned(
                top: 0,
                right: 0,
                child: GestureDetector(
                  onTap: _resetHobbies,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF59D),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.yellow.shade200,
                          blurRadius: 4,
                        ),
                      ],
                    ),
                    child: const Text(
                      '重置',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF854D0E),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                right: -16,
                bottom: -24,
                child: Icon(
                  Icons.favorite,
                  size: 100,
                  color: Colors.pink.shade200.withValues(alpha: 0.4),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),
        _SectionTitle(title: '自定义'),
        const SizedBox(height: 16),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            ...widget.customTags.map(
              (tag) => TagChip(
                label: tag,
                selected: widget.selectedHobbies.contains(tag),
                onTap: () => _toggleHobby(tag),
                small: true,
              ),
            ),
            if (_isAddingCustom)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 100,
                    child: TextField(
                      controller: _customController,
                      autofocus: true,
                      style: const TextStyle(fontSize: 13),
                      decoration: InputDecoration(
                        hintText: '输入爱好',
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(
                            color: Colors.purple.shade200,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: const BorderSide(
                            color: AppColors.purple,
                            width: 2,
                          ),
                        ),
                        isDense: true,
                      ),
                      onSubmitted: (_) => _addCustomTag(),
                    ),
                  ),
                  TextButton(
                    onPressed: _addCustomTag,
                    child: const Text(
                      '确定',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.purpleDark,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              )
            else
              GestureDetector(
                onTap: () => setState(() => _isAddingCustom = true),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.pink.shade100),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.add, size: 14, color: AppColors.purpleDark),
                      SizedBox(width: 4),
                      Text(
                        '添加',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.purpleDark,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
        ...AppData.hobbyCategories.map((category) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 32),
              _SectionTitle(title: category.title),
              const SizedBox(height: 16),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: category.tags.map((tag) {
                  return TagChip(
                    label: tag,
                    selected: widget.selectedHobbies.contains(tag),
                    onTap: () => _toggleHobby(tag),
                    small: true,
                  );
                }).toList(),
              ),
            ],
          );
        }),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 3,
          height: 14,
          decoration: BoxDecoration(
            color: AppColors.pinkAccent,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
