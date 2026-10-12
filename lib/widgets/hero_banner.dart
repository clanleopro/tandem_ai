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
    final isCompact = screenWidth < 850;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: isCompact ? 20 : 44,
        vertical: isCompact ? 32 : 48,
      ),
      decoration: BoxDecoration(
        gradient: AppTheme.heroGradient,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppTheme.cardBorderGlow, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: AppTheme.cyanAccent.withValues(alpha: 0.08),
            blurRadius: 36,
            spreadRadius: 2,
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.6),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Tag & Status Row
          Wrap(
            spacing: 12,
            runSpacing: 8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppTheme.cyanAccent.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: AppTheme.cyanAccent.withValues(alpha: 0.4),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppTheme.cyanAccent,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'AI RIGGING STANDARDS VERIFIER',
                      style: AppTheme.monoStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.cyanAccent,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceDark,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppTheme.cardBorder),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.shield_outlined,
                      size: 14,
                      color: AppTheme.amberWarning,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'ASME B30.9 • OSHA 1926 • LOLER • DNV',
                      style: AppTheme.monoStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Main Headline
          Text(
            'Industrial Rigging & Lift Plan\nStandards Verification Engine',
            style: TextStyle(
              fontSize: isCompact ? 28 : 42,
              fontWeight: FontWeight.w900,
              height: 1.15,
              color: Colors.white,
              letterSpacing: -0.5,
            ),
          ),

          const SizedBox(height: 16),

          // Description
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 820),
            child: Text(
              'Upload company or regulatory rigging standards, verify heavy lift drawings & sling calculation sheets against strict regulatory clauses, and resolve critical geometric or WLL discrepancies with an interactive AI Rigging Auditor.',
              style: TextStyle(
                fontSize: isCompact ? 14 : 16,
                color: AppTheme.textSecondary,
                height: 1.6,
              ),
            ),
          ),

          const SizedBox(height: 32),

          // Action Buttons
          Wrap(
            spacing: 16,
            runSpacing: 12,
            children: [
              // Start Project Primary Button
              ElevatedButton.icon(
                onPressed: onStartProject,
                icon: const Icon(
                  Icons.play_arrow_rounded,
                  color: Colors.black,
                  size: 24,
                ),
                label: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 4),
                  child: Text(
                    'Start Your Project / New Audit',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w900,
                      fontSize: 15,
                      letterSpacing: 0.3,
                    ),
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.cyanAccent,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 28,
                    vertical: 18,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 6,
                  shadowColor: AppTheme.cyanAccent.withValues(alpha: 0.6),
                ),
              ),

              // Browse Standards Vault
              OutlinedButton.icon(
                onPressed: onBrowseStandards,
                icon: const Icon(
                  Icons.folder_special_outlined,
                  color: Colors.white,
                  size: 20,
                ),
                label: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 4),
                  child: Text(
                    'Standards Library (5 Active)',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppTheme.cardBorderGlow, width: 1.5),
                  backgroundColor: AppTheme.surfaceDark.withValues(alpha: 0.6),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 18,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 40),

          // Engineering Proof Metrics
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppTheme.surfaceDark.withValues(alpha: 0.7),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppTheme.cardBorder),
            ),
            child: Wrap(
              spacing: isCompact ? 24 : 48,
              runSpacing: 16,
              children: [
                _buildMetric(
                  label: 'STANDARDS REPOSITORY',
                  value: '14+ Norms',
                  detail: 'ASME, OSHA, LOLER, DNV',
                  color: AppTheme.cyanAccent,
                ),
                _buildMetric(
                  label: 'CRITICAL AUDIT CHECKS',
                  value: '148 Clauses',
                  detail: 'Sling angles, WLL, D/d pin, DAF',
                  color: AppTheme.amberWarning,
                ),
                _buildMetric(
                  label: 'MANDATORY SAFETY FACTOR',
                  value: '5 : 1 Minimum',
                  detail: 'Live bridle tension validation',
                  color: AppTheme.greenCompliant,
                ),
                _buildMetric(
                  label: 'AI COPILOT RESOLUTION',
                  value: '< 3.2s Rework',
                  detail: 'Interactive engineering advice',
                  color: AppTheme.purpleAi,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetric({
    required String label,
    required String value,
    required String detail,
    required Color color,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: AppTheme.monoStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: AppTheme.textMuted,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w900,
            color: color,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          detail,
          style: const TextStyle(
            fontSize: 12,
            color: AppTheme.textSecondary,
          ),
        ),
      ],
    );
  }
}
