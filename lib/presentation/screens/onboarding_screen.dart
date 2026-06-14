import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../providers/core_providers.dart';
import '../themes/colors.dart';
import '../themes/typography.dart';
import '../widgets/common/animated_gradient_border.dart';
import '../widgets/common/custom_text_field.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _controller = TextEditingController();
  bool _obscureText = true;
  bool _isTesting = false;
  String? _error;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _saveKey() async {
    final apiKey = _controller.text.trim();
    if (apiKey.isEmpty) {
      setState(() => _error = 'Please enter an API key.');
      return;
    }

    setState(() {
      _isTesting = true;
      _error = null;
    });

    final isValid = await ref.read(apiKeyProvider.notifier).validate(apiKey);
    if (!mounted) return;

    if (!isValid) {
      setState(() {
        _isTesting = false;
        _error = 'That key could not reach OpenRouter.';
      });
      return;
    }

    await ref.read(apiKeyProvider.notifier).setApiKey(apiKey);
    if (!mounted) return;
    setState(() => _isTesting = false);
    context.go('/');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 440),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: AnimatedGradientBorder(
              child: Padding(
                padding: const EdgeInsets.all(28),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [AppColors.primary, AppColors.accent],
                            ),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const Icon(
                            Icons.chat_bubble,
                            color: AppColors.background,
                            size: 28,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Text(
                          'OpenChat',
                          style: AppTypography.display.copyWith(fontSize: 26),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    Text(
                      'Local-first. Private. Your OpenRouter key.',
                      style: AppTypography.bodySmall,
                    ),
                    const SizedBox(height: 28),
                    Text(
                      'Enter your OpenRouter API key',
                      style: AppTypography.title.copyWith(fontSize: 16),
                    ),
                    const SizedBox(height: 12),
                    CustomTextField(
                      controller: _controller,
                      hintText: 'sk-or-v1-...',
                      obscureText: _obscureText,
                      autofocus: true,
                      suffix: Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: GestureDetector(
                          onTap: () => setState(() => _obscureText = !_obscureText),
                          child: Icon(
                            _obscureText
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: AppColors.textTertiary,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                    if (_error != null) ...[
                      const SizedBox(height: 10),
                      Text(
                        _error!,
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.error,
                        ),
                      ),
                    ],
                    const SizedBox(height: 20),
                    _PrimaryButton(
                      label: _isTesting ? 'Checking...' : 'Continue',
                      onTap: _isTesting ? null : _saveKey,
                    ),
                    const SizedBox(height: 16),
                    Center(
                      child: TextButton(
                        onPressed: () async {
                          final url = Uri.parse('https://openrouter.ai/keys');
                          if (await canLaunchUrl(url)) {
                            await launchUrl(
                              url,
                              mode: LaunchMode.externalApplication,
                            );
                          }
                        },
                        child: Text(
                          'Get an OpenRouter key',
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PrimaryButton extends StatefulWidget {
  const _PrimaryButton({required this.label, this.onTap});

  final String label;
  final VoidCallback? onTap;

  @override
  State<_PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<_PrimaryButton> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.primary, Color(0xFF6B42FF)],
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(
                  alpha: widget.onTap == null ? 0 : (_hovering ? 0.5 : 0.3),
                ),
                blurRadius: _hovering ? 24 : 12,
                spreadRadius: -2,
              ),
            ],
          ),
          alignment: Alignment.center,
          child: Text(
            widget.label,
            style: AppTypography.body.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
