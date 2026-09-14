import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:biyan/screens/profile/settings_text_screen.dart';
import 'package:biyan/services/storage_service.dart';
import 'package:biyan/theme/app_colors.dart';
import 'package:biyan/widgets/app_branding.dart';
import 'package:biyan/widgets/auth_text_field.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({
    super.key,
    required this.onRegistered,
  });

  final Future<void> Function() onRegistered;

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _accountController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _submitting = false;
  bool _agreed = false;
  late final TapGestureRecognizer _privacyRecognizer;
  late final TapGestureRecognizer _userNoticeRecognizer;

  @override
  void initState() {
    super.initState();
    _privacyRecognizer = TapGestureRecognizer()
      ..onTap = () => _openDoc(SettingsDocType.privacy);
    _userNoticeRecognizer = TapGestureRecognizer()
      ..onTap = () => _openDoc(SettingsDocType.userNotice);
  }

  @override
  void dispose() {
    _accountController.dispose();
    _passwordController.dispose();
    _privacyRecognizer.dispose();
    _userNoticeRecognizer.dispose();
    super.dispose();
  }

  void _openDoc(SettingsDocType type) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => SettingsTextScreen(
          type: type,
          onBack: () => Navigator.of(context).pop(),
        ),
      ),
    );
  }

  Future<void> _showAgreementDialog() async {
    final agreed = await showDialog<bool>(
      context: context,
      barrierColor: Colors.black38,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 28, 24, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  '温馨提示',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  '请先阅读《用户须知》和《隐私协议》',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.black87,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: const Text(
                          '不同意',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: const Text(
                          '同意',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );

    if (agreed == true && mounted) {
      setState(() => _agreed = true);
      await _submitRegister();
    }
  }

  Future<void> _submitRegister() async {
    if (_submitting) return;
    setState(() => _submitting = true);

    final error = await StorageService.registerAccount(
      _accountController.text,
      _passwordController.text,
    );

    if (!mounted) return;
    setState(() => _submitting = false);

    if (error != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error)));
      return;
    }

    await widget.onRegistered();
    if (mounted) {
      Navigator.of(context).pop(true);
    }
  }

  Future<void> _handleConfirm() async {
    _dismissKeyboard();
    final phoneError = StorageService.validatePhone(_accountController.text);
    if (phoneError != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(phoneError)));
      return;
    }
    final passwordError = StorageService.validatePassword(
      _passwordController.text,
    );
    if (passwordError != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(passwordError)));
      return;
    }

    if (_agreed) {
      await _submitRegister();
    } else {
      await _showAgreementDialog();
    }
  }

  void _dismissKeyboard() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: _dismissKeyboard,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.arrow_back_ios_new, size: 20),
                    color: AppColors.textPrimary,
                  ),
                ),
                const Spacer(flex: 1),
                const AppLogo(size: 88, showShadow: true),
                const SizedBox(height: 24),
                const AppNameText(fontSize: 34),
                const SizedBox(height: 8),
                const Text(
                  '注册账号',
                  style: TextStyle(
                    fontSize: 15,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 36),
                AuthTextField(
                  controller: _accountController,
                  hintText: '请输入手机号码',
                  keyboardType: TextInputType.phone,
                  maxLength: StorageService.phoneLength,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: 14),
                AuthTextField(
                  controller: _passwordController,
                  hintText: '请输入密码（至少6位）',
                  obscureText: _obscurePassword,
                  textInputAction: TextInputAction.done,
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() => _obscurePassword = !_obscurePassword);
                    },
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      size: 20,
                      color: AppColors.textMuted,
                    ),
                  ),
                ),
                const SizedBox(height: 28),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _submitting ? null : _handleConfirm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.purple,
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: AppColors.purple.withValues(
                        alpha: 0.5,
                      ),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(26),
                      ),
                    ),
                    child: const Text(
                      '确定',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 24,
                      height: 24,
                      child: Checkbox(
                        value: _agreed,
                        activeColor: AppColors.purple,
                        side: const BorderSide(color: AppColors.textMuted),
                        onChanged: (value) {
                          setState(() => _agreed = value ?? false);
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text.rich(
                        TextSpan(
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppColors.textSecondary,
                            height: 1.4,
                          ),
                          children: [
                            const TextSpan(text: '登录/注册即表示同意'),
                            TextSpan(
                              text: '隐私协议',
                              style: const TextStyle(
                                color: AppColors.purple,
                                fontWeight: FontWeight.w500,
                              ),
                              recognizer: _privacyRecognizer,
                            ),
                            const TextSpan(text: '和'),
                            TextSpan(
                              text: '用户须知',
                              style: const TextStyle(
                                color: AppColors.purple,
                                fontWeight: FontWeight.w500,
                              ),
                              recognizer: _userNoticeRecognizer,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const Spacer(flex: 2),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
