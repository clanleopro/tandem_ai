import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';

class ReadyBanner extends StatelessWidget {
  final bool ready;
  final bool isSubmitting;
  final VoidCallback? onAnalyze;

  const ReadyBanner({
    super.key,
    required this.ready,
    required this.isSubmitting,
    required this.onAnalyze,
  });

  @override
  Widget build(BuildContext context) {
    final button = SizedBox(
      height: 44,
      width: 140,
      child: ElevatedButton(
        onPressed: ready ? onAnalyze : null,
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: AppColors.primaryRed,
          foregroundColor: Colors.white,
          disabledBackgroundColor: const Color(0xFFEBECEF),
          disabledForegroundColor: const Color(0xFF9CA3AF),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
          textStyle: GoogleFonts.plusJakartaSans(
            fontSize: 13,
            fontWeight: FontWeight.w700,
          ),
        ),
        child: isSubmitting
            ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.primaryRed,
                ),
              )
            : const Text(AppStrings.analyze),
      ),
    );

    final description = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          isSubmitting
              ? AppStrings.generatingYourAuditReport
              : ready
              ? AppStrings.yourDocumentsAreReady
              : AppStrings.selectYourDocuments,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          isSubmitting
              ? AppStrings.analyzingBothPdfs
              : ready
              ? AppStrings.checkRequirementsAndReview
              : AppStrings.browseAndSelectBothPdfs,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 13,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.cardBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 480) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [description, const SizedBox(height: 20), button],
            );
          }

          return Row(
            children: [
              Expanded(child: description),
              const SizedBox(width: 20),
              button,
            ],
          );
        },
      ),
    );
  }
}
