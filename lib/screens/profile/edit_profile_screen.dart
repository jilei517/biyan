import 'package:flutter/material.dart';
import 'package:biyan/data/image_urls.dart';
import 'package:biyan/models/user_profile.dart';
import 'package:biyan/services/image_storage_service.dart';
import 'package:biyan/theme/app_colors.dart';
import 'package:biyan/widgets/app_image.dart';
import 'package:biyan/widgets/screen_header.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({
    super.key,
    required this.profile,
    required this.onBack,
    required this.onSave,
  });

  final UserProfile profile;
  final VoidCallback onBack;
  final ValueChanged<UserProfile> onSave;

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late final TextEditingController _nicknameController;
  late final TextEditingController _signatureController;
  late String _avatar;
  late String _gender;
  late int? _age;
  bool _isPickingAvatar = false;

  static const _genderOptions = ['男', '女', '保密'];

  @override
  void initState() {
    super.initState();
    _avatar = widget.profile.avatar;
    _gender = widget.profile.gender;
    _age = widget.profile.age;
    _nicknameController = TextEditingController(text: widget.profile.nickname);
    _signatureController = TextEditingController(text: widget.profile.signature);
  }

  @override
  void dispose() {
    _nicknameController.dispose();
    _signatureController.dispose();
    super.dispose();
  }

  Future<void> _pickAvatar() async {
    if (_isPickingAvatar) return;

    setState(() => _isPickingAvatar = true);
    try {
      await Future<void>.delayed(const Duration(milliseconds: 100));
      if (!mounted) return;

      final path = await ImageStorageService.pickAvatarFromGallery();
      if (!mounted || path == null) return;
      setState(() => _avatar = path);
    } catch (_) {
      if (mounted) {
        _showSnackBar('更换头像失败，请重试');
      }
    } finally {
      if (mounted) {
        setState(() => _isPickingAvatar = false);
      }
    }
  }

  Future<void> _pickAge() async {
    var selectedAge = _age ?? 24;
    final controller = FixedExtentScrollController(initialItem: selectedAge - 16);

    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('取消'),
                        ),
                        const Text(
                          '选择年龄',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            setState(() => _age = selectedAge);
                            Navigator.pop(context);
                          },
                          child: const Text(
                            '确定',
                            style: TextStyle(color: AppColors.purple),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 180,
                      child: ListWheelScrollView.useDelegate(
                        controller: controller,
                        itemExtent: 40,
                        perspective: 0.005,
                        diameterRatio: 1.5,
                        onSelectedItemChanged: (index) {
                          setModalState(() => selectedAge = index + 16);
                        },
                        childDelegate: ListWheelChildBuilderDelegate(
                          childCount: 65,
                          builder: (context, index) {
                            final age = index + 16;
                            final isSelected = age == selectedAge;
                            return Center(
                              child: Text(
                                '$age 岁',
                                style: TextStyle(
                                  fontSize: isSelected ? 20 : 16,
                                  fontWeight: isSelected
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                  color: isSelected
                                      ? AppColors.purple
                                      : AppColors.textSecondary,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );

    controller.dispose();
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _handleSave() {
    final nickname = _nicknameController.text.trim();
    if (nickname.isEmpty) {
      _showSnackBar('请输入昵称');
      return;
    }

    widget.onSave(
      UserProfile(
        nickname: nickname,
        avatar: _avatar,
        gender: _gender,
        age: _age,
        signature: _signatureController.text.trim(),
      ),
    );
    widget.onBack();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundGray,
      body: Column(
        children: [
          ScreenHeader(
            title: '编辑资料',
            onBack: widget.onBack,
            rightWidget: GestureDetector(
              onTap: _handleSave,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.purpleLight,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  '保存',
                  style: TextStyle(
                    color: AppColors.purple,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                Center(
                  child: GestureDetector(
                    onTap: _isPickingAvatar ? null : _pickAvatar,
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          width: 96,
                          height: 96,
                          padding: const EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFFC084FC), Color(0xFFF472B6)],
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: ClipOval(
                            child: _isPickingAvatar
                                ? Container(
                                    color: Colors.grey.shade200,
                                    child: const Center(
                                      child: SizedBox(
                                        width: 24,
                                        height: 24,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                        ),
                                      ),
                                    ),
                                  )
                                : _avatar.isEmpty
                                    ? const ColoredBox(
                                        color: AppColors.purpleLight,
                                        child: Center(
                                          child: Icon(
                                            Icons.person_outline,
                                            size: 40,
                                            color: AppColors.purple,
                                          ),
                                        ),
                                      )
                                    : AppImage(
                                        url: _avatar,
                                        assetFallback:
                                            'assets/images/avatar.png',
                                      ),
                          ),
                        ),
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: Container(
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(
                              color: AppColors.purple,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                            child: const Icon(
                              Icons.camera_alt,
                              size: 14,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Center(
                  child: Text(
                    '点头像从相册选，或从下面挑一张',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                  ),
                ),
                const SizedBox(height: 16),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: ImageUrls.presetAvatars.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                  ),
                  itemBuilder: (context, index) {
                    final url = ImageUrls.presetAvatars[index];
                    final selected = _avatar == url;
                    return GestureDetector(
                      onTap: () => setState(() => _avatar = url),
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: selected
                                ? AppColors.purple
                                : Colors.transparent,
                            width: 2,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(2),
                          child: ClipOval(
                            child: AppImage(url: url),
                          ),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 24),
                _FieldSection(
                  label: '昵称',
                  child: TextField(
                    controller: _nicknameController,
                    maxLength: 20,
                    decoration: const InputDecoration(
                      hintText: '输入昵称',
                      border: InputBorder.none,
                      counterText: '',
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                _FieldSection(
                  label: '性别',
                  child: Row(
                    children: _genderOptions.map((option) {
                      final isSelected = _gender == option;
                      return Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(
                            right: option != _genderOptions.last ? 8 : 0,
                          ),
                          child: GestureDetector(
                            onTap: () => setState(() => _gender = option),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AppColors.purple
                                    : AppColors.background,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: isSelected
                                      ? AppColors.purple
                                      : AppColors.border,
                                ),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                option,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: isSelected
                                      ? Colors.white
                                      : AppColors.textPrimary,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 16),
                _FieldSection(
                  label: '年龄',
                  child: InkWell(
                    onTap: _pickAge,
                    borderRadius: BorderRadius.circular(8),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _age == null ? '未设置' : '$_age 岁',
                            style: TextStyle(
                              fontSize: 16,
                              color: _age == null
                                  ? AppColors.textMuted
                                  : AppColors.textPrimary,
                            ),
                          ),
                          Icon(
                            Icons.chevron_right,
                            color: Colors.grey.shade400,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                _FieldSection(
                  label: '个性签名',
                  child: TextField(
                    controller: _signatureController,
                    maxLines: 3,
                    maxLength: 60,
                    decoration: const InputDecoration(
                      hintText: '写一句个性签名吧...',
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FieldSection extends StatelessWidget {
  const _FieldSection({
    required this.label,
    required this.child,
  });

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 4),
          child,
        ],
      ),
    );
  }
}
