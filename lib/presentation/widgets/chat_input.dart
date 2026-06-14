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
      behavior: HitTestBehavior.opaque,
      onTap: () => _showModelSheet(context),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.auto_awesome,
            size: 11,
            color: selected != null ? AppColors.primary : AppColors.textTertiary,
          ),
          const SizedBox(width: 5),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 200),
            child: Text(
              display,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.label.copyWith(
                color: selected != null
                    ? AppColors.primary
                    : AppColors.textTertiary,
              ),
            ),
          ),
          const Icon(
            Icons.unfold_more,
            size: 13,
            color: AppColors.textTertiary,
          ),
        ],
      ),
    );
  }

  Future<void> _showModelSheet(BuildContext context) async {
    final result = await showModalBottomSheet<_ModelChoice>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => _ModelPickerSheet(
        models: models,
        selectedId: selected?.id,
      ),
    );
    if (result != null) {
      onChanged?.call(result.model);
    }
  }
}

/// Wrapper so a "default model" (null) selection can be distinguished from
/// the sheet being dismissed (which returns null from showModalBottomSheet).
class _ModelChoice {
  const _ModelChoice(this.model);
  final OpenRouterModel? model;
}

class _ModelPickerSheet extends StatefulWidget {
  const _ModelPickerSheet({required this.models, this.selectedId});

  final List<OpenRouterModel> models;
  final String? selectedId;

  @override
  State<_ModelPickerSheet> createState() => _ModelPickerSheetState();
}

class _ModelPickerSheetState extends State<_ModelPickerSheet> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final filtered = widget.models.where((m) {
      if (_query.isEmpty) return true;
      final q = _query.toLowerCase();
      return m.displayName.toLowerCase().contains(q) ||
          m.id.toLowerCase().contains(q);
    }).toList();

    return Padding(
      padding: EdgeInsets.only(bottom: media.viewInsets.bottom),
      child: Container(
        constraints: BoxConstraints(maxHeight: media.size.height * 0.75),
        decoration: const BoxDecoration(
          color: AppColors.surfaceRaised,
          borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
          border: Border(top: BorderSide(color: AppColors.border)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 10),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(14),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.search,
                        size: 18, color: AppColors.textTertiary),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        autofocus: true,
                        style: AppTypography.body,
                        decoration: InputDecoration(
                          hintText: 'Search models',
                          hintStyle: AppTypography.body
                              .copyWith(color: AppColors.textTertiary),
                          border: InputBorder.none,
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 14),
                        ),
                        onChanged: (v) => setState(() => _query = v),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Flexible(
              child: ListView(
                shrinkWrap: true,
                padding: const EdgeInsets.fromLTRB(8, 0, 8, 16),
                children: [
                  _tile(
                    context,
                    label: 'Default model',
                    sublabel: 'Use the app default',
                    isSelected: widget.selectedId == null,
                    onTap: () =>
                        Navigator.of(context).pop(const _ModelChoice(null)),
                  ),
                  ...filtered.map(
                    (m) => _tile(
                      context,
                      label: m.displayName,
                      sublabel: m.id,
                      isSelected: m.id == widget.selectedId,
                      isFavorite: m.isFavorite,
                      onTap: () =>
                          Navigator.of(context).pop(_ModelChoice(m)),
                    ),
                  ),
                  if (filtered.isEmpty)
                    Padding(
                      padding: const EdgeInsets.all(24),
                      child: Center(
                        child: Text(
                          'No models match "$_query"',
                          style: AppTypography.bodySmall
                              .copyWith(color: AppColors.textTertiary),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _tile(
    BuildContext context, {
    required String label,
    required String sublabel,
    required bool isSelected,
    required VoidCallback onTap,
    bool isFavorite = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 3, horizontal: 6),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.surfaceOverlay : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.transparent,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      if (isFavorite) ...[
                        const Icon(Icons.star,
                            size: 13, color: AppColors.accent),
                        const SizedBox(width: 5),
                      ],
                      Flexible(
                        child: Text(
                          label,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTypography.body,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    sublabel,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.label
                        .copyWith(color: AppColors.textTertiary),
                  ),
                ],
              ),
            ),
            if (isSelected)
              const Icon(Icons.check_circle,
                  size: 18, color: AppColors.primary),
          ],
        ),
      ),
    );
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
