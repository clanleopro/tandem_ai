import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_theme.dart';

class EngineeringFooter extends StatelessWidget {
  const EngineeringFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isCompact = constraints.maxWidth < 950;

        return Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(
            horizontal: isCompact ? 16 : 32,
            vertical: 14,
          ),
          decoration: const BoxDecoration(
            color: AppTheme.surfaceDark,
            border: Border(
              top: BorderSide(color: AppTheme.cardBorder, width: 1),
            ),
          ),
          child: Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            runSpacing: 8,
            children: [
              _buildEngineStatus(),
              const Text(
                AppConstants.engineTagline,
                style: TextStyle(fontSize: 11, color: AppTheme.textMuted),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEngineStatus() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 7,
          height: 7,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: AppTheme.greenCompliant,
          ),
        ),
        const SizedBox(width: 8),
        Flexible(
          child: Text(
            AppConstants.engineVersion,
            overflow: TextOverflow.ellipsis,
            style: AppTheme.monoStyle(
              fontSize: 11,
              color: AppTheme.textMuted,
            ),
          ),
        ),
      ],
    );
  }
}
