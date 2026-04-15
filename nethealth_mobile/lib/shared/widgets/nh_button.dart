import 'package:flutter/material.dart';

enum NhButtonVariant { filled, outlined, ghost }

class NhButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final NhButtonVariant variant;
  final bool isLoading;
  final Widget? leadingIcon;
  final double? width;

  const NhButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = NhButtonVariant.filled,
    this.isLoading = false,
    this.leadingIcon,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    final child = isLoading
        ? const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: Colors.white,
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (leadingIcon != null) ...[
                leadingIcon!,
                const SizedBox(width: 8),
              ],
              Text(label),
            ],
          );

    Widget button = switch (variant) {
      NhButtonVariant.filled => ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          child: child,
        ),
      NhButtonVariant.outlined => OutlinedButton(
          onPressed: isLoading ? null : onPressed,
          child: child,
        ),
      NhButtonVariant.ghost => TextButton(
          onPressed: isLoading ? null : onPressed,
          child: child,
        ),
    };

    if (width != null) {
      return SizedBox(width: width, child: button);
    }
    return button;
  }
}
