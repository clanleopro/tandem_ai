import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

enum AppButtonVariant { primaryRed, dark, secondary, outline, replaceBlue }

class AppButton extends StatefulWidget {
  final String label;
  final VoidCallback? onPressed;
  final Widget? icon;
  final AppButtonVariant variant;
  final double? width;
  final double height;
  final double borderRadius;
  final bool isLoading;

  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.variant = AppButtonVariant.primaryRed,
    this.width,
    this.height = 42,
    this.borderRadius = 22,
    this.isLoading = false,
  });

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color fg;
    Border? border;
    List<BoxShadow>? shadows;

    final isEnabled = widget.onPressed != null && !widget.isLoading;

    switch (widget.variant) {
      case AppButtonVariant.primaryRed:
        bg = isEnabled
            ? (_isHovered ? AppColors.primaryRedHover : AppColors.primaryRed)
            : AppColors.primaryRed.withValues(alpha: 0.5);
        fg = Colors.white;
        shadows = isEnabled
            ? [
                BoxShadow(
                  color: AppColors.primaryRed.withValues(
                    alpha: _isHovered ? 0.4 : 0.25,
                  ),
                  blurRadius: _isHovered ? 12 : 8,
                  offset: const Offset(0, 3),
                ),
              ]
            : null;
        break;

      case AppButtonVariant.dark:
        bg = isEnabled
            ? (_isHovered ? AppColors.darkActionHover : AppColors.darkAction)
            : AppColors.darkAction.withValues(alpha: 0.5);
        fg = Colors.white;
        shadows = isEnabled
            ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ]
            : null;
        break;

      case AppButtonVariant.replaceBlue:
        bg = _isHovered ? const Color(0xFFE0E7FF) : AppColors.replaceBlueBg;
        fg = AppColors.replaceBlueText;
        border = Border.all(color: AppColors.replaceBlueBorder, width: 1);
        break;

      case AppButtonVariant.secondary:
        bg = _isHovered ? const Color(0xFFF3F4F6) : Colors.white;
        fg = AppColors.textPrimary;
        border = Border.all(color: AppColors.cardBorder, width: 1);
        break;

      case AppButtonVariant.outline:
        bg = _isHovered
            ? Colors.white.withValues(alpha: 0.05)
            : Colors.transparent;
        fg = Colors.white;
        border = Border.all(color: AppColors.sidebarBorder, width: 1);
        break;
    }

    return MouseRegion(
      cursor: isEnabled ? SystemMouseCursors.click : SystemMouseCursors.basic,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(widget.borderRadius),
          border: border,
          boxShadow: shadows,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: isEnabled ? widget.onPressed : null,
            borderRadius: BorderRadius.circular(widget.borderRadius),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Center(
                child: widget.isLoading
                    ? SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(fg),
                        ),
                      )
                    : Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (widget.icon != null) ...[
                            widget.icon!,
                            const SizedBox(width: 6),
                          ],
                          Flexible(
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                widget.label,
                                style: AppTypography.button(color: fg),
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
