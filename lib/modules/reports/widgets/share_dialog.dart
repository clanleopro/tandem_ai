import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/app_assets.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/widgets/app_button.dart';
import '../../../data/models/analysis_report.dart';
import '../../workspace/controllers/workspace_controller.dart';

class ShareDialog extends StatelessWidget {
  final AnalysisReport? report;

  const ShareDialog({super.key, this.report});

  void _showFeedback(BuildContext context, String message) {
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 3),
        backgroundColor: AppColors.darkAction,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      backgroundColor: Colors.white,
      child: Container(
        width: 440,
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header with Close 'X'
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppStrings.share,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.close,
                    size: 20,
                    color: AppColors.textPrimary,
                  ),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const SizedBox(height: 24),
            // "Share to assigned engineer" card
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFFF9FAFB),
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: AppColors.cardBorder, width: 1),
              ),
              child: Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFFD1D5DB),
                        width: 1,
                      ),
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        AppAssets.divyaAvatar,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(
                            Icons.person,
                            color: AppColors.textSecondary,
                            size: 20,
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      AppStrings.shareToAssignedEngineer,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  AppButton(
                    label: AppStrings.send,
                    variant: AppButtonVariant.primaryRed,
                    height: 36,
                    borderRadius: 18,
                    onPressed: () {
                      _showFeedback(
                        context,
                        'Verification report shared to Assigned Engineer Divya (Notification & PDF dispatch sent)',
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Large Dark "Download Report" Pill Button
            InkWell(
              onTap: () {
                final projName = Get.isRegistered<WorkspaceController>()
                    ? Get.find<WorkspaceController>()
                              .activeProject
                              .value
                              ?.name ??
                          'Project'
                    : 'Project';
                _showFeedback(
                  context,
                  'Downloading "Tandem_Verification_Report_${projName.replaceAll(' ', '_')}.pdf"...',
                );
              },
              borderRadius: BorderRadius.circular(25),
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.darkAction,
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.15),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    AppStrings.downloadReport,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 28),
            // Social Share Icons row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildSocialIcon(
                  context: context,
                  label: 'WhatsApp',
                  color: AppColors.whatsapp,
                  icon: Icons.chat_bubble_outline_rounded,
                ),
                _buildSocialIcon(
                  context: context,
                  label: 'Facebook',
                  color: AppColors.facebook,
                  icon: Icons.facebook,
                ),
                _buildSocialIcon(
                  context: context,
                  label: 'Twitter',
                  color: AppColors.twitter,
                  icon: Icons.flutter_dash,
                ),
                _buildSocialIcon(
                  context: context,
                  label: 'Email',
                  color: AppColors.email,
                  icon: Icons.mail_outline_rounded,
                ),
                _buildSocialIcon(
                  context: context,
                  label: 'Reddit',
                  color: AppColors.reddit,
                  icon: Icons.reddit,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSocialIcon({
    required BuildContext context,
    required String label,
    required Color color,
    required IconData icon,
  }) {
    return InkWell(
      onTap: () {
        _showFeedback(context, 'Shared report via $label');
      },
      borderRadius: BorderRadius.circular(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            child: Icon(icon, color: Colors.white, size: 22),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
