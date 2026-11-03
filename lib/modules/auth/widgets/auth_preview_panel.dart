import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/tandem_logo.dart';
import '../../../core/widgets/workspace_preview_card.dart';

/// Preview panel displayed on wider screens for login and signup pages.
class AuthPreviewPanel extends StatelessWidget {
  final VoidCallback onLogoTap;

  const AuthPreviewPanel({super.key, required this.onLogoTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.cardBackground,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(48, 32, 36, 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TandemLogo(isDarkBadge: false, onTap: onLogoTap),
                SizedBox(height: constraints.maxHeight * 0.12),
                Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 820),
                    child: const AspectRatio(
                      aspectRatio: 1.48,
                      child: WorkspacePreviewCard(),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

