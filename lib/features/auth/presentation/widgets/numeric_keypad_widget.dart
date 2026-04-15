import 'package:flutter/material.dart';
import 'package:mozi_v2/core/theme/app_colors.dart';
import 'package:mozi_v2/core/theme/app_typography.dart';

/// Shared numeric keypad widget — 3×4 grid (1-9, -, 0, backspace)
class NumericKeypadWidget extends StatelessWidget {
  final void Function(String digit) onDigitTap;
  final VoidCallback onBackspace;

  const NumericKeypadWidget({
    super.key,
    required this.onDigitTap,
    required this.onBackspace,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 2.0,
      children: [
        _KeypadKey(label: '1', onTap: () => onDigitTap('1')),
        _KeypadKey(label: '2', onTap: () => onDigitTap('2')),
        _KeypadKey(label: '3', onTap: () => onDigitTap('3')),
        _KeypadKey(label: '4', onTap: () => onDigitTap('4')),
        _KeypadKey(label: '5', onTap: () => onDigitTap('5')),
        _KeypadKey(label: '6', onTap: () => onDigitTap('6')),
        _KeypadKey(label: '7', onTap: () => onDigitTap('7')),
        _KeypadKey(label: '8', onTap: () => onDigitTap('8')),
        _KeypadKey(label: '9', onTap: () => onDigitTap('9')),
        const SizedBox(), // empty bottom-left
        _KeypadKey(label: '0', onTap: () => onDigitTap('0')),
        _BackspaceKey(onTap: onBackspace),
      ],
    );
  }
}

class _KeypadKey extends StatefulWidget {
  final String label;
  final VoidCallback onTap;
  const _KeypadKey({required this.label, required this.onTap});

  @override
  State<_KeypadKey> createState() => _KeypadKeyState();
}

class _KeypadKeyState extends State<_KeypadKey> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 80),
        margin: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: _pressed ? AppColors.surfaceContainerHigh : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.center,
        child: Text(
          widget.label,
          style: AppTypography.headlineSmall.copyWith(
            color: AppColors.onSurface,
          ),
        ),
      ),
    );
  }
}

class _BackspaceKey extends StatefulWidget {
  final VoidCallback onTap;
  const _BackspaceKey({required this.onTap});

  @override
  State<_BackspaceKey> createState() => _BackspaceKeyState();
}

class _BackspaceKeyState extends State<_BackspaceKey> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 80),
        margin: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: _pressed ? AppColors.surfaceContainerHigh : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.center,
        child: const Icon(
          Icons.backspace_outlined,
          color: AppColors.onSurfaceVariant,
          size: 24,
        ),
      ),
    );
  }
}
