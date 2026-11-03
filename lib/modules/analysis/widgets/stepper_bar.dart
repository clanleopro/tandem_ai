import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';

class StepperBar extends StatelessWidget {
  final int currentStep;

  const StepperBar({super.key, required this.currentStep});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.stepperBackground,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        alignment: WrapAlignment.center,
        spacing: 12,
        runSpacing: 8,
        children: [
          _buildStepPill(
            title: AppStrings.selectSourceDocument,
            isActive: currentStep == 1,
          ),
          Container(width: 40, height: 1.5, color: const Color(0xFFCBCDD5)),
          _buildStepPill(
            title: AppStrings.selectDocument,
            isActive: currentStep == 2,
          ),
          Container(width: 40, height: 1.5, color: const Color(0xFFCBCDD5)),
          _buildStepPill(
            title: AppStrings.analyzeDocument,
            isActive: currentStep == 3,
          ),
        ],
      ),
    );
  }

  Widget _buildStepPill({required String title, required bool isActive}) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isActive ? 24 : 8,
        vertical: isActive ? 10 : 6,
      ),
      decoration: BoxDecoration(
        color: isActive ? Colors.white : Colors.transparent,
        borderRadius: BorderRadius.circular(24),
        boxShadow: isActive
            ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: Text(
        title,
        style: GoogleFonts.plusJakartaSans(
          fontSize: 13,
          fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
          color: isActive
              ? AppColors.textPrimary
              : AppColors.stepperTextInactive,
        ),
      ),
    );
  }
}
