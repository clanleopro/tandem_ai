import 'package:flutter/material.dart';
import '../models/rigging_models.dart';
import '../theme/app_theme.dart';

class AuditReportView extends StatefulWidget {
  final AuditReport report;
  final Function(String? clausePrompt) onOpenAuditorChat;
  final VoidCallback onReAudit;

  const AuditReportView({
    super.key,
    required this.report,
    required this.onOpenAuditorChat,
    required this.onReAudit,
  });

  @override
  State<AuditReportView> createState() => _AuditReportViewState();
}

class _AuditReportViewState extends State<AuditReportView> {
  FindingStatus? _statusFilter; // null means All

  @override
  Widget build(BuildContext context) {
    final report = widget.report;
    final filteredFindings = report.findings.where((f) {
      if (_statusFilter == null) return true;
      return f.status == _statusFilter;
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Executive Summary HUD Card
        _buildExecutiveHUD(report),

        const SizedBox(height: 24),

        // Engineering Telemetry Metric Cards
        _buildLiftMetricsRow(report),

        const SizedBox(height: 24),

        // Filter Bar & Action Header
        _buildFindingsHeader(report),

        const SizedBox(height: 16),

        // Findings List
        ...filteredFindings.map((finding) => _buildFindingCard(finding)),

        const SizedBox(height: 32),

        // Bottom CTA Banner to Chat with AI Auditor
        _buildAuditorBottomBanner(),
      ],
    );
  }

  Widget _buildExecutiveHUD(AuditReport report) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: AppTheme.surfaceDark,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: report.violationsCount > 0 ? AppTheme.redViolation.withValues(alpha: 0.5) : AppTheme.greenCompliant,
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: (report.violationsCount > 0 ? AppTheme.redViolation : AppTheme.greenCompliant).withValues(alpha: 0.08),
            blurRadius: 30,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Circular Score Gauge
              _buildScoreGauge(report.overallComplianceScore),

              const SizedBox(width: 24),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: report.violationsCount > 0
                                ? AppTheme.redViolation.withValues(alpha: 0.15)
                                : AppTheme.greenCompliant.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: report.violationsCount > 0
                                  ? AppTheme.redViolation
                                  : AppTheme.greenCompliant,
                            ),
                          ),
                          child: Text(
                            report.violationsCount > 0
                                ? '● REWORK REQUIRED - NON-COMPLIANT'
                                : '● APPROVED FOR EXECUTION',
                            style: AppTheme.monoStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: report.violationsCount > 0
                                  ? AppTheme.redViolation
                                  : AppTheme.greenCompliant,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Audit Stamped: Today at 10:32 AM',
                          style: AppTheme.monoStyle(fontSize: 11, color: AppTheme.textMuted),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      report.projectName,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Standard Verified: ${report.standard.code} (${report.standard.title}) • File: ${report.projectFile.fileName}',
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      report.executiveSummary,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppTheme.textSecondary,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Tally Pills
          Wrap(
            spacing: 12,
            runSpacing: 8,
            children: [
              _buildTallyBadge(
                label: 'Critical Violations',
                count: report.violationsCount,
                color: AppTheme.redViolation,
                icon: Icons.dangerous_outlined,
              ),
              _buildTallyBadge(
                label: 'Warnings / Margins',
                count: report.warningsCount,
                color: AppTheme.amberWarning,
                icon: Icons.warning_amber_rounded,
              ),
              _buildTallyBadge(
                label: 'Compliant Clauses',
                count: report.compliantCount,
                color: AppTheme.greenCompliant,
                icon: Icons.verified_outlined,
              ),
              const Spacer(),
              ElevatedButton.icon(
                onPressed: () => widget.onOpenAuditorChat(null),
                icon: const Icon(Icons.psychology, color: Colors.black, size: 18),
                label: const Text(
                  'Solve Rework in AI Auditor',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.cyanAccent,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildScoreGauge(int score) {
    Color gaugeColor;
    if (score >= 85) {
      gaugeColor = AppTheme.greenCompliant;
    } else if (score >= 70) {
      gaugeColor = AppTheme.amberWarning;
    } else {
      gaugeColor = AppTheme.redViolation;
    }

    return Container(
      width: 110,
      height: 110,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppTheme.cardDark,
        border: Border.all(color: gaugeColor, width: 3),
        boxShadow: [
          BoxShadow(
            color: gaugeColor.withValues(alpha: 0.3),
            blurRadius: 16,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '$score%',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w900,
              color: gaugeColor,
            ),
          ),
          Text(
            'COMPLIANCE',
            style: AppTheme.monoStyle(
              fontSize: 9,
              fontWeight: FontWeight.bold,
              color: AppTheme.textMuted,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTallyBadge({
    required String label,
    required int count,
    required Color color,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 8),
          Text(
            '$count $label',
            style: AppTheme.monoStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLiftMetricsRow(AuditReport report) {
    final metrics = report.liftMetrics;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.cardDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.tune, size: 18, color: AppTheme.cyanAccent),
              const SizedBox(width: 8),
              const Text(
                'Rigging Physics & Telemetry Cross-Validation',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const Spacer(),
              Text(
                'Standard: ASME B30.9 Table 9-1.2',
                style: AppTheme.monoStyle(fontSize: 10, color: AppTheme.textMuted),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 16,
            runSpacing: 12,
            children: [
              _buildMetricPill('MIN SLING ANGLE', metrics['minSlingAngle'] ?? '41.5°', true),
              _buildMetricPill('MAX LEG TENSION', metrics['maxLegTension'] ?? '24.27 MT', true),
              _buildMetricPill('DESIGN SAFETY FACTOR', metrics['designSafetyFactor'] ?? '4.28 : 1', true),
              _buildMetricPill('CRANE 1 UTILIZATION', metrics['crane1Utilization'] ?? '71.2%', false),
              _buildMetricPill('CRANE 2 UTILIZATION', metrics['crane2Utilization'] ?? '73.8%', false),
              _buildMetricPill('WIND THRESHOLD', metrics['windLimit'] ?? '9.8 m/s', false),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricPill(String title, String val, bool isFailed) {
    return Container(
      width: 180,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.surfaceDark,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isFailed ? AppTheme.redViolation.withValues(alpha: 0.4) : AppTheme.cardBorder,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTheme.monoStyle(fontSize: 9, color: AppTheme.textMuted, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            val,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: isFailed ? AppTheme.redViolation : AppTheme.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFindingsHeader(AuditReport report) {
    return Row(
      children: [
        const Text(
          'Clause-by-Clause Compliance Findings',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const Spacer(),
        // Filter Buttons
        Wrap(
          spacing: 8,
          children: [
            _buildFilterChip('All (${report.findings.length})', null),
            _buildFilterChip('Violations (${report.violationsCount})', FindingStatus.violation),
            _buildFilterChip('Warnings (${report.warningsCount})', FindingStatus.warning),
            _buildFilterChip('Compliant (${report.compliantCount})', FindingStatus.compliant),
          ],
        ),
      ],
    );
  }

  Widget _buildFilterChip(String label, FindingStatus? status) {
    final isSelected = _statusFilter == status;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => setState(() => _statusFilter = status),
      selectedColor: AppTheme.cyanAccent.withValues(alpha: 0.2),
      labelStyle: TextStyle(
        fontSize: 11,
        color: isSelected ? AppTheme.cyanAccent : AppTheme.textSecondary,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
      ),
      side: BorderSide(
        color: isSelected ? AppTheme.cyanAccent : AppTheme.cardBorder,
      ),
    );
  }

  Widget _buildFindingCard(AuditFinding finding) {
    Color statusColor;
    String statusLabel;
    IconData statusIcon;

    switch (finding.status) {
      case FindingStatus.violation:
        statusColor = AppTheme.redViolation;
        statusLabel = 'CRITICAL VIOLATION';
        statusIcon = Icons.error_outline;
        break;
      case FindingStatus.warning:
        statusColor = AppTheme.amberWarning;
        statusLabel = 'MARGIN WARNING';
        statusIcon = Icons.warning_amber_rounded;
        break;
      case FindingStatus.compliant:
        statusColor = AppTheme.greenCompliant;
        statusLabel = 'COMPLIANT';
        statusIcon = Icons.check_circle_outline;
        break;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: AppTheme.cardDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: finding.status == FindingStatus.violation
              ? AppTheme.redViolation.withValues(alpha: 0.4)
              : AppTheme.cardBorder,
          width: finding.status == FindingStatus.violation ? 1.5 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Row
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: statusColor.withValues(alpha: 0.4)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(statusIcon, size: 14, color: statusColor),
                    const SizedBox(width: 6),
                    Text(
                      statusLabel,
                      style: AppTheme.monoStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: statusColor,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceDark,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  finding.clauseRef,
                  style: AppTheme.monoStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.cyanAccent,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                finding.category,
                style: const TextStyle(fontSize: 11, color: AppTheme.textMuted),
              ),
              const Spacer(),
              if (finding.status != FindingStatus.compliant)
                TextButton.icon(
                  onPressed: () => widget.onOpenAuditorChat('Solve finding: ${finding.clauseRef} - ${finding.clauseTitle}'),
                  icon: const Icon(Icons.chat_bubble_outline, size: 14, color: AppTheme.cyanAccent),
                  label: const Text(
                    'Ask Auditor To Solve',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppTheme.cyanAccent,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),

          const SizedBox(height: 12),

          // Title
          Text(
            finding.clauseTitle,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),

          const SizedBox(height: 14),

          // Comparison: Observed vs Standard Requirement
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Observed in Drawing
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceDark,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppTheme.cardBorder),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.description_outlined, size: 14, color: statusColor),
                          const SizedBox(width: 6),
                          const Text(
                            'OBSERVED IN LIFT PLAN / CAD',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.textSecondary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        finding.projectFinding,
                        style: const TextStyle(fontSize: 13, color: Colors.white, height: 1.4),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 14),
              // Mandated by Standard
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceDark,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppTheme.cardBorder),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.rule, size: 14, color: AppTheme.cyanAccent),
                          SizedBox(width: 6),
                          Text(
                            'STANDARD REGULATORY CLAUSE',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.textSecondary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        finding.standardRequirement,
                        style: const TextStyle(fontSize: 13, color: AppTheme.textSecondary, height: 1.4),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Technical Explanation
          Text(
            finding.technicalExplanation,
            style: const TextStyle(fontSize: 13, color: AppTheme.textSecondary, height: 1.5),
          ),

          // Engineering Calculation Snippet
          if (finding.engineeringCalculation != null) ...[
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppTheme.cardBorder),
              ),
              child: Row(
                children: [
                  const Icon(Icons.calculate_outlined, size: 16, color: AppTheme.cyanAccent),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      finding.engineeringCalculation!,
                      style: AppTheme.monoStyle(
                        fontSize: 11,
                        color: AppTheme.cyanAccent,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],

          // Required Remedy
          if (finding.status != FindingStatus.compliant) ...[
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.cyanAccent.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppTheme.cyanAccent.withValues(alpha: 0.3)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.lightbulb_outline, size: 18, color: AppTheme.cyanAccent),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'MANDATORY REWORK DIRECTIVE:',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.cyanAccent,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          finding.requiredRemedy,
                          style: const TextStyle(fontSize: 12, color: Colors.white, height: 1.4),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildAuditorBottomBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        gradient: AppTheme.primaryGradient,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppTheme.cyanAccent.withValues(alpha: 0.3),
            blurRadius: 24,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(Icons.psychology, size: 36, color: Colors.black),
          ),
          const SizedBox(width: 20),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Need Clarifications or Rework Engineering?',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Launch the interactive AI Auditor to recalculate bridle lengths, adjust sling angles, or verify revised Crosby hardware in real-time.',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          ElevatedButton.icon(
            onPressed: () => widget.onOpenAuditorChat(null),
            icon: const Icon(Icons.chat_outlined, color: Colors.white, size: 18),
            label: const Text(
              'Launch Auditor Studio',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
          ),
        ],
      ),
    );
  }
}
