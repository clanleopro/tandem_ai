import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/app_colors.dart';
import '../controllers/analysis_controller.dart';

class AnalysisProgressView extends StatelessWidget {
  final AnalysisController? analysisCtrl;

  const AnalysisProgressView({super.key, this.analysisCtrl});

  AnalysisController get _controller =>
      analysisCtrl ?? Get.find<AnalysisController>();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 640),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
          padding: const EdgeInsets.all(36),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AppColors.cardBorder, width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 20,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Obx(() {
            final progress = _controller.analysisProgress.value;
            final statusMessage = _controller.analysisStatusMessage.value;

            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 90,
                      height: 90,
                      child: CircularProgressIndicator(
                        value: progress > 0 ? progress : null,
                        strokeWidth: 6,
                        backgroundColor: const Color(0xFFF3F4F6),
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          AppColors.primaryRed,
                        ),
                      ),
                    ),
                    Text(
                      '${(progress * 100).toInt()}%',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 28),
                Text(
                  'Cross-Verifying Lift Plan Against Standards',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  statusMessage,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 32),
                _buildStageItem(
                  title: 'ASME B30.5 & Appointed Person Guidelines',
                  subtitle:
                      'Cross-checking critical lift 85% capacity threshold',
                  isDone: progress >= 0.30,
                  isActive: progress < 0.30,
                ),
                const SizedBox(height: 12),
                _buildStageItem(
                  title: 'OSHA 1926 Rigging Tackle & Sling Geometry',
                  subtitle:
                      'Evaluating bridle angle and 0.707 derating calculation',
                  isDone: progress >= 0.60,
                  isActive: progress >= 0.30 && progress < 0.60,
                ),
                const SizedBox(height: 12),
                _buildStageItem(
                  title: 'Geotechnical Ground Bearing Assessment',
                  subtitle: 'Comparing timber pad loading against 220 kPa soil bearing limit',
                  isDone: progress >= 0.85,
                  isActive: progress >= 0.60 && progress < 0.85,
                ),
                const SizedBox(height: 12),
                _buildStageItem(
                  title: 'Personnel Competency & Environmental Limits',
                  subtitle: 'Checking Appointed Person signature & 9.8 m/s wind threshold',
                  isDone: progress >= 1.0,
                  isActive: progress >= 0.85 && progress < 1.0,
                ),
              ],
            );
          }),
        ),
      ),
    );
  }

  Widget _buildStageItem({
    required String title,
    required String subtitle,
    required bool isDone,
    required bool isActive,
  }) {
    Color iconBg;
    Widget iconWidget;

    if (isDone) {
      iconBg = const Color(0xFFECFDF5);
      iconWidget = const Icon(
        Icons.check,
        size: 16,
        color: AppColors.successGreen,
      );
    } else if (isActive) {
      iconBg = AppColors.primaryRedLight;
      iconWidget = const SizedBox(
        width: 14,
        height: 14,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: AppColors.primaryRed,
        ),
      );
    } else {
      iconBg = const Color(0xFFF3F4F6);
      iconWidget = Container(
        width: 8,
        height: 8,
        decoration: const BoxDecoration(
          color: Color(0xFFD1D5DB),
          shape: BoxShape.circle,
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFFFDF2F2) : const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isActive ? AppColors.primaryRedLight : AppColors.cardBorder,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
            child: Center(child: iconWidget),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
