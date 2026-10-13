import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class HeroBanner extends StatelessWidget {
  final VoidCallback onStartProject;
  final VoidCallback onBrowseStandards;

  const HeroBanner({
    super.key,
    required this.onStartProject,
    required this.onBrowseStandards,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHight = MediaQuery.of(context).size.height;
    final isCompact = screenWidth < 850;

    return SizedBox(
      width: screenWidth,
      height: screenHight - 160,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Tag & Status Row
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: AppTheme.tagDecoration(AppTheme.accentRed),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppTheme.accentRed,
                  ),
                ),
                const SizedBox(width: 7),
                Text(
                  'AI RIGGING STANDARDS VERIFIER',
                  style: AppTheme.monoStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.accentRed,
                    letterSpacing: 0.7,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // Main Headline
          Text(
            'Industrial Rigging & Lift Plan\nStandards Verification Engine',
            style: AppTheme.displayStyle(
              fontSize: isCompact ? 28 : 42,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              letterSpacing: -0.5,
            ),
          ),

          const SizedBox(height: 16),

          // Description
          Text(
            'Upload company or regulatory rigging standards, verify heavy lift drawings & sling calculation sheets against strict regulatory clauses, and resolve critical geometric or WLL discrepancies with an interactive AI Rigging Auditor.',
            style: TextStyle(
              fontSize: isCompact ? 14 : 16,
              fontWeight: FontWeight.w400,
              color: AppTheme.textSecondary,
              height: 1.6,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
          ),

          const SizedBox(height: 24),

          // Action Buttons
          Wrap(
            spacing: 16,
            runSpacing: 12,
            children: [
              // Start Project Primary Button
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(
                  Icons.play_arrow_rounded,
                  color: Colors.white,
                  size: 20,
                ),
                label: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 2),
                  child: Text(
                    'Start Your Project / New Audit',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.accentRed,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shadowColor: Colors.transparent,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppTheme.radiusLg),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 40),

          // Engineering Proof Metrics
        ],
      ),
    );
  }
}
