import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:biyan/screens/auth/register_screen.dart';
import 'package:biyan/screens/profile/settings_text_screen.dart';
import 'package:biyan/services/storage_service.dart';
import 'package:biyan/theme/app_colors.dart';
import 'package:biyan/widgets/app_branding.dart';
import 'package:biyan/widgets/auth_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, required this.onLogin});

  final Future<void> Function() onLogin;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _accountController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _agreed = false;
  bool _obscurePassword = true;
  bool _submitting = false;
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

  Future<void> _openRegister() async {
    final registered = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (context) => RegisterScreen(onRegistered: widget.onLogin),
      ),
    );
    if (registered == true && mounted && Navigator.of(context).canPop()) {
      Navigator.of(context).pop(true);
    }
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
      await _submitLogin();
    }
  }

  Future<void> _submitLogin() async {
    if (_submitting) return;
    setState(() => _submitting = true);

    final error = await StorageService.validateLogin(
      _accountController.text,
      _passwordController.text,
    );

    if (!mounted) return;

    if (error != null) {
      setState(() => _submitting = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error)));
      return;
    }

    await widget.onLogin();

    if (mounted && Navigator.of(context).canPop()) {
      Navigator.of(context).pop(true);
    }
  }

  Future<void> _handleLogin() async {
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
      await _submitLogin();
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
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverFillRemaining(
                hasScrollBody: false,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Navigator.of(context).canPop()
                            ? IconButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(false),
                                icon: const Icon(Icons.close, size: 22),
                                color: AppColors.textPrimary,
                              )
                            : const SizedBox(height: 48),
                      ),
                      const Spacer(flex: 2),
                      const AppLogo(size: 108, showShadow: true),
                      const SizedBox(height: 28),
                      const AppNameText(fontSize: 38),
                      const SizedBox(height: 12),
                      const AppTaglineText(fontSize: 16),
                      const SizedBox(height: 36),
                      AuthTextField(
                        controller: _accountController,
                        hintText: '请输入手机号码',
                        keyboardType: TextInputType.phone,
                        maxLength: StorageService.phoneLength,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
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
                            setState(
                              () => _obscurePassword = !_obscurePassword,
                            );
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
                      const Spacer(flex: 2),
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          onPressed: _submitting ? null : _handleLogin,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.purple,
                            foregroundColor: Colors.white,
                            disabledBackgroundColor: AppColors.purple
                                .withValues(alpha: 0.5),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(26),
                            ),
                          ),
                          child: const Text(
                            '登录',
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
                              side: const BorderSide(
                                color: AppColors.textMuted,
                              ),
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
                      const Spacer(flex: 1),
                      TextButton(
                        onPressed: _openRegister,
                        child: const Text(
                          '我要注册',
                          style: TextStyle(
                            fontSize: 15,
                            color: AppColors.purple,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
