import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class NhCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final double borderRadius;
  final bool useGlass;
  final VoidCallback? onTap;
  final Color? backgroundColor;

  const NhCard({
    super.key,
    required this.child,
    this.padding,
    this.borderRadius = 16,
    this.useGlass = false,
    this.onTap,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = backgroundColor ??
        (useGlass
            ? (isDark
                ? Colors.white.withOpacity(0.05)
                : Colors.white.withOpacity(0.7))
            : Theme.of(context).colorScheme.surface);

    final border = useGlass
        ? Border.all(
            color: isDark
                ? Colors.white.withOpacity(0.1)
                : AppColors.primary.withOpacity(0.15),
          )
        : Border.all(color: Theme.of(context).colorScheme.outline);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(borderRadius),
          border: border,
          boxShadow: useGlass
              ? null
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(isDark ? 0.2 : 0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(borderRadius),
          child: Padding(
            padding: padding ?? const EdgeInsets.all(16),
            child: child,
          ),
        ),
      ),
    );
  }
}
