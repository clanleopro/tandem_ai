import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../models/rigging_models.dart';

class ActiveAuditBanner extends StatelessWidget {
  final AuditReport report;
  final VoidCallback onInspectReport;
  final VoidCallback onOpenAuditor;

  const ActiveAuditBanner({
    super.key,
    required this.report,
    required this.onInspectReport,
    required this.onOpenAuditor,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isCompact = constraints.maxWidth < 850;

        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppTheme.surfaceDark,
            borderRadius: BorderRadius.circular(AppTheme.radiusMd),
            border: Border.all(
              color: report.violationsCount > 0
                  ? AppTheme.accentRed.withValues(alpha: 0.4)
                  : AppTheme.greenCompliant.withValues(alpha: 0.4),
            ),
          ),
          child: isCompact
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(report),
                    const SizedBox(height: 10),
                    _buildDescription(report),
                    const SizedBox(height: 16),
                    _buildActionButtons(),
                  ],
                )
              : Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppTheme.accentRed.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                      ),
                      child: const Icon(
                        Icons.warning_amber_rounded,
                        color: AppTheme.accentRed,
                        size: 26,
                      ),
                    ),
                    const SizedBox(width: 18),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildHeader(report),
                          const SizedBox(height: 4),
                          _buildDescription(report),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    _buildActionButtons(),
                  ],
                ),
        );
      },
    );
  }

  Widget _buildHeader(AuditReport report) {
    return Wrap(
      spacing: 10,
      runSpacing: 6,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        const Text(
          'ACTIVE AUDIT ALERT • REWORK REQUIRED',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: AppTheme.accentRed,
            letterSpacing: 0.5,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: AppTheme.cardDark,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            '${report.overallComplianceScore}% Compliance',
            style: AppTheme.monoStyle(
              fontSize: 11,
              color: AppTheme.amberWarning,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDescription(AuditReport report) {
    return Text(
      '${report.projectName} (${report.standard.code}) has ${report.violationsCount} critical geometric violations: horizontal sling angle at 41.5° & deficient shackle D/d curvature.',
      style: const TextStyle(fontSize: 13, color: AppTheme.textSecondary),
    );
  }

  Widget _buildActionButtons() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        ElevatedButton(
          onPressed: onInspectReport,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.accentRed,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppTheme.radiusMd),
            ),
          ),
          child: const Text('Inspect Report', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
        ),
        OutlinedButton(
          onPressed: onOpenAuditor,
          style: OutlinedButton.styleFrom(
            foregroundColor: AppTheme.textSecondary,
            side: const BorderSide(color: AppTheme.cardBorder),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppTheme.radiusMd),
            ),
          ),
          child: const Text('Open AI Auditor', style: TextStyle(fontSize: 12)),
        ),
      ],
    );
  }
}
