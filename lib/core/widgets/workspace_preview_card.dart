import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../theme/app_typography.dart';

/// Reusable workspace mini preview card used on auth screens (login and signup).
class WorkspacePreviewCard extends StatelessWidget {
  const WorkspacePreviewCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.stepperBackground,
        borderRadius: BorderRadius.circular(20),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Row(
          children: [
            Container(
              width: 112,
              color: AppColors.sidebarBackground,
              padding: const EdgeInsets.fromLTRB(12, 14, 10, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Tandem',
                    style: AppTypography.bodyBold(
                      color: AppColors.sidebarTextActive,
                    ).copyWith(fontSize: 16),
                  ),
                  const SizedBox(height: 28),
                  const _PreviewSidebarItem(
                    icon: Icons.add,
                    label: 'New Document',
                  ),
                  const SizedBox(height: 22),
                  Text(
                    'Projects',
                    style: AppTypography.bodySmall(
                      color: AppColors.sidebarTextMuted,
                    ).copyWith(fontSize: 10),
                  ),
                  const SizedBox(height: 12),
                  const _PreviewSidebarItem(
                    icon: Icons.description_outlined,
                    label: 'Titan Rigging',
                  ),
                  const _PreviewSidebarItem(
                    icon: Icons.description_outlined,
                    label: 'Heavy Move',
                  ),
                  const _PreviewSidebarItem(
                    icon: Icons.description_outlined,
                    label: 'Lift Force',
                  ),
                  const _PreviewSidebarItem(
                    icon: Icons.description_outlined,
                    label: 'Steel Bridge',
                  ),
                  const Spacer(),
                  const _PreviewSidebarItem(
                    icon: Icons.logout,
                    label: 'Log out',
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                color: AppColors.cardBackground,
                padding: const EdgeInsets.all(18),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        CircleAvatar(
                          radius: 12,
                          backgroundColor: AppColors.cardBorderLight,
                          child: const Icon(
                            Icons.person,
                            size: 15,
                            color: AppColors.textMuted,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text('Divya', style: AppTypography.bodySmall()),
                      ],
                    ),
                    const SizedBox(height: 28),
                    _buildMiniStepper(),
                    const SizedBox(height: 22),
                    const Expanded(
                      child: Row(
                        children: [
                          Expanded(child: _PreviewUploadCard()),
                          SizedBox(width: 14),
                          Expanded(child: _PreviewUploadCard()),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),
                    _buildAnalyzeBar(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMiniStepper() {
    return Container(
      height: 34,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: AppColors.stepperBackground,
        borderRadius: BorderRadius.circular(24),
      ),
      child: const Row(
        children: [
          _PreviewStepPill(label: 'Select Source Document', active: true),
          _PreviewStepPill(label: 'Select Document'),
          _PreviewStepPill(label: 'Analyze Document'),
        ],
      ),
    );
  }

  Widget _buildAnalyzeBar() {
    return Container(
      height: 54,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.cardBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Your documents are ready',
                  style: AppTypography.bodyBold(color: AppColors.textPrimary)
                      .copyWith(fontSize: 10),
                ),
                const SizedBox(height: 3),
                Text(
                  'Check requirements and review findings.',
                  style: AppTypography.bodySmall(color: AppColors.textMuted)
                      .copyWith(fontSize: 8),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.primaryRed,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'Analyze',
              style: AppTypography.button().copyWith(fontSize: 9),
            ),
          ),
        ],
      ),
    );
  }
}

class _PreviewSidebarItem extends StatelessWidget {
  final IconData icon;
  final String label;

  const _PreviewSidebarItem({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Icon(icon, size: 12, color: AppColors.sidebarTextMuted),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.bodySmall(color: AppColors.sidebarTextMuted)
                  .copyWith(fontSize: 8),
            ),
          ),
        ],
      ),
    );
  }
}

class _PreviewStepPill extends StatelessWidget {
  final String label;
  final bool active;

  const _PreviewStepPill({required this.label, this.active = false});

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 7),
        decoration: BoxDecoration(
          color: active ? AppColors.stepperPillActive : Colors.transparent,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: AppTypography.bodySmall(
            color: active
                ? AppColors.textPrimary
                : AppColors.stepperTextInactive,
          ).copyWith(fontSize: 7),
        ),
      ),
    );
  }
}

class _PreviewUploadCard extends StatelessWidget {
  const _PreviewUploadCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.cardBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.workspaceBackground,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.description_outlined,
                    size: 24,
                    color: AppColors.textMuted,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Drop document here',
                    style: AppTypography.bodySmall(color: AppColors.textPrimary)
                        .copyWith(fontSize: 9),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    'doc, docx, pdf, pptx, etc.',
                    style: AppTypography.bodySmall(color: AppColors.textMuted)
                        .copyWith(fontSize: 7),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Browse',
                    style: AppTypography.bodySmall(
                      color: AppColors.replaceBlueText,
                    ).copyWith(fontSize: 8),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
            child: Container(
              height: 30,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: AppColors.cardBackground,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.cardBorder),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Select source document',
                      style: AppTypography.bodySmall(
                        color: AppColors.textPrimary,
                      ).copyWith(fontSize: 8),
                    ),
                  ),
                  const Icon(
                    Icons.keyboard_arrow_down,
                    size: 14,
                    color: AppColors.textMuted,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
