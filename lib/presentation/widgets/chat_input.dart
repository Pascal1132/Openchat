import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/openrouter_model.dart';
import '../themes/colors.dart';
import '../themes/typography.dart';
import 'common/icon_button_custom.dart';

class ChatInput extends ConsumerStatefulWidget {
  const ChatInput({
    required this.onSend,
    this.onStop,
    this.isLoading = false,
    this.hintText = 'Message OpenChat...',
    this.availableModels = const <OpenRouterModel>[],
    this.selectedModel,
    this.onModelChanged,
    super.key,
  });

  final ValueChanged<String> onSend;
  final VoidCallback? onStop;
  final bool isLoading;
  final String hintText;
  final List<OpenRouterModel> availableModels;
  final OpenRouterModel? selectedModel;
  final ValueChanged<OpenRouterModel?>? onModelChanged;

  @override
  ConsumerState<ChatInput> createState() => _ChatInputState();
}

class _ChatInputState extends ConsumerState<ChatInput> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _submit() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    widget.onSend(text);
    _controller.clear();
    _focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.transparent, AppColors.background],
        ),
      ),
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: AppColors.surfaceRaised,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: _focusNode.hasFocus ? AppColors.primary : AppColors.border,
            width: 1.5,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 14, top: 6, bottom: 4),
              child: _ModelSelector(
                models: widget.availableModels,
                selected: widget.selectedModel,
                onChanged: widget.onModelChanged,
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    focusNode: _focusNode,
                    maxLines: 6,
                    minLines: 1,
                    style: AppTypography.body,
                    textInputAction: TextInputAction.newline,
                    decoration: InputDecoration(
                      hintText: widget.hintText,
                      hintStyle: AppTypography.body.copyWith(
                        color: AppColors.textTertiary,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                    ),
                    onSubmitted: (_) => _submit(),
                  ),
                ),
                const SizedBox(width: 6),
                if (widget.isLoading)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8, right: 8),
                    child: IconButtonCustom(
                      icon: Icons.stop_rounded,
                      onTap: widget.onStop,
                      color: AppColors.error,
                      tooltip: 'Stop generating',
                    ),
                  )
                else
                  Padding(
                    padding: const EdgeInsets.only(bottom: 6, right: 6),
                    child: _SendButton(onSend: _submit),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ModelSelector extends StatelessWidget {
  const _ModelSelector({
    required this.models,
    this.selected,
    this.onChanged,
  });

  final List<OpenRouterModel> models;
  final OpenRouterModel? selected;
  final ValueChanged<OpenRouterModel?>? onChanged;

  @override
  Widget build(BuildContext context) {
    final display = selected?.displayName ?? 'Default model';

    return GestureDetector(
      onTap: () => _showModelMenu(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: AppColors.surfaceOverlay,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.auto_awesome,
              size: 12,
              color: selected != null ? AppColors.primary : AppColors.textTertiary,
            ),
            const SizedBox(width: 6),
            Text(
              display,
              style: AppTypography.label.copyWith(
                color: selected != null ? AppColors.primary : AppColors.textTertiary,
              ),
            ),
            const SizedBox(width: 4),
            const Icon(
              Icons.keyboard_arrow_down,
              size: 14,
              color: AppColors.textTertiary,
            ),
          ],
        ),
      ),
    );
  }

  void _showModelMenu(BuildContext context) {
    final renderBox = context.findRenderObject() as RenderBox?;
    final offset = renderBox?.localToGlobal(Offset.zero) ?? Offset.zero;
    final size = renderBox?.size ?? Size.zero;

    final menuItems = <PopupMenuEntry<OpenRouterModel?>>[
      const PopupMenuItem<OpenRouterModel?>(
        value: null,
        child: Text('Default model'),
      ),
      const PopupMenuDivider(),
      ...models.map(
        (model) => PopupMenuItem<OpenRouterModel?>(
          value: model,
          child: Text(model.displayName),
        ),
      ),
    ];

    showMenu<OpenRouterModel?>(
      context: context,
      position: RelativeRect.fromLTRB(
        offset.dx,
        offset.dy + size.height + 8,
        offset.dx + size.width,
        offset.dy + size.height,
      ),
      items: menuItems,
      color: AppColors.surfaceRaised,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
    ).then((value) {
      if (value != null || selected != null) {
        onChanged?.call(value);
      }
    });
  }
}

class _SendButton extends StatefulWidget {
  const _SendButton({required this.onSend});

  final VoidCallback onSend;

  @override
  State<_SendButton> createState() => _SendButtonState();
}

class _SendButtonState extends State<_SendButton> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: GestureDetector(
        onTap: widget.onSend,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(
                  alpha: _hovering ? 0.5 : 0.25,
                ),
                blurRadius: _hovering ? 20 : 12,
                spreadRadius: -2,
              ),
            ],
          ),
          child: const Icon(
            Icons.arrow_upward_rounded,
            color: Colors.white,
            size: 20,
          ),
        ),
      ),
    );
  }
}
