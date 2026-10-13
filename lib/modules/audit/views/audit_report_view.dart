import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/sample_data.dart';
import '../../../models/rigging_models.dart';
import '../../../shared/widgets/app_header.dart';
import '../../../shared/widgets/engineering_footer.dart';
import '../controllers/audit_controller.dart';

class AuditReportView extends GetView<AuditController> {
  const AuditReportView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgDark,
      appBar: AppHeader(
        onStartNewAudit: controller.reAudit,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1200),
                  child: Obx(() {
                    final report = controller.activeReport.value ?? SampleData.createSampleReport();
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Top Action Bar
                        _buildTopBar(report),

                        const SizedBox(height: 24),

                        // Executive HUD
                        _buildExecutiveHUD(report),

                        const SizedBox(height: 24),

                        // Lift Engineering Telemetry Metric Cards
                        _buildTelemetryCards(report),

                        const SizedBox(height: 28),

                        // Findings Filter and Header
                        _buildFindingsHeader(report),

                        const SizedBox(height: 16),

                        // Findings List
                        ..._buildFindingsList(report),

                        const SizedBox(height: 36),

                        // AI Auditor Bottom Banner
                        _buildAuditorBottomBanner(),

                        const SizedBox(height: 40),
                      ],
                    );
                  }),
                ),
              ),
            ),
          ),
          const EngineeringFooter(),
        ],
      ),
    );
  }

  Widget _buildTopBar(AuditReport report) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isCompact = constraints.maxWidth < 750;
        return Row(
          children: [
            OutlinedButton.icon(
              onPressed: () => Get.offAllNamed(AppRoutes.home),
              icon: const Icon(Icons.arrow_back, size: 16),
              label: const Text('Back to Home'),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppTheme.cardBorder),
                foregroundColor: AppTheme.textSecondary,
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                ),
              ),
            ),
            const SizedBox(width: 14),
            if (!isCompact)
              Expanded(
                child: Text(
                  'Audit Report: ${report.projectName}',
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textPrimary,
                  ),
                ),
              ),
            const Spacer(),
            OutlinedButton.icon(
              onPressed: controller.reAudit,
              icon: const Icon(Icons.refresh, size: 16),
              label: Text(isCompact ? 'Re-Audit' : 'Re-Verify / New Audit'),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppTheme.cardBorder),
                foregroundColor: AppTheme.textSecondary,
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                ),
              ),
            ),
            const SizedBox(width: 10),
            ElevatedButton.icon(
              onPressed: () => controller.openAuditorConsole(null),
              icon: const Icon(Icons.terminal_outlined, size: 16, color: Colors.white),
              label: Text(isCompact ? 'AI Console' : 'Launch AI Auditor Console'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.accentRed,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildExecutiveHUD(AuditReport report) {
    final hasViolations = report.violationsCount > 0;
    final scoreColor = hasViolations ? AppTheme.accentRed : AppTheme.greenCompliant;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.surfaceDark,
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        border: Border.all(
          color: scoreColor.withValues(alpha: 0.4),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Circular Score Gauge
              _buildScoreGauge(report.overallComplianceScore, scoreColor),

              const SizedBox(width: 20),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: scoreColor.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(color: scoreColor.withValues(alpha: 0.3)),
                          ),
                          child: Text(
                            hasViolations ? 'REWORK REQUIRED' : 'COMPLIANT TO SPECIFICATION',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: scoreColor,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          report.standard.code,
                          style: AppTheme.monoStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      report.projectName,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Evaluated on ${report.auditedAt.year}-${report.auditedAt.month.toString().padLeft(2, '0')}-${report.auditedAt.day.toString().padLeft(2, '0')} • Standard: ${report.standard.title}',
                      style: const TextStyle(fontSize: 12, color: AppTheme.textMuted),
                    ),
                  ],
                ),
              ),
            ],
          ),
              const SizedBox(height: 20),
              const Divider(color: AppTheme.dividerColor),
              const SizedBox(height: 16),
              Wrap(
                spacing: 16,
                runSpacing: 12,
                children: [
                  _StatusCounter(
                    count: report.violationsCount,
                    label: 'Critical Violations',
                    color: AppTheme.accentRed,
                  ),
                  _StatusCounter(
                    count: report.warningsCount,
                    label: 'Warnings & Cautions',
                    color: AppTheme.amberWarning,
                  ),
                  _StatusCounter(
                    count: report.compliantCount,
                    label: 'Compliant Checks',
                    color: AppTheme.greenCompliant,
                  ),
                  _StatusCounter(
                    count: report.findings.length,
                    label: 'Total Clauses Tested',
                    color: AppTheme.textSecondary,
                  ),
                ],
              ),
            ],
          ),
    );
  }

  Widget _buildScoreGauge(int score, Color color) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppTheme.cardDark,
        border: Border.all(color: color, width: 3),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '$score%',
              style: AppTheme.monoStyle(
                fontSize: 20,
                fontWeight: FontWeight.w900,
                color: color,
              ),
            ),
            const Text(
              'SCORE',
              style: TextStyle(fontSize: 8.5, color: AppTheme.textMuted, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTelemetryCards(AuditReport report) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isCompact = constraints.maxWidth < 800;
        final cardCount = isCompact ? 2 : 4;

        return GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: cardCount,
          crossAxisSpacing: 14,
          mainAxisSpacing: 14,
          childAspectRatio: isCompact ? 1.8 : 2.2,
          children: const [
            _MetricCard(
              title: 'MIN SLING ANGLE',
              value: '41.5°',
              requirement: 'Req: ≥ 45° (Rec: 60°)',
              statusColor: AppTheme.accentRed,
              isFailed: true,
            ),
            _MetricCard(
              title: 'PEAK LEG TENSION',
              value: '53.6 MT',
              requirement: 'WLL: 50.0 MT Max',
              statusColor: AppTheme.accentRed,
              isFailed: true,
            ),
            _MetricCard(
              title: 'SHACKLE D/d RATIO',
              value: '0.95',
              requirement: 'Req: ≥ 1.0 Crosby Spec',
              statusColor: AppTheme.amberWarning,
              isFailed: true,
            ),
            _MetricCard(
              title: 'DYNAMIC AMPLIFICATION',
              value: '1.15 DAF',
              requirement: 'Factored Load: 163.9 MT',
              statusColor: AppTheme.greenCompliant,
              isFailed: false,
            ),
          ],
        );
      },
    );
  }

  Widget _buildFindingsHeader(AuditReport report) {
    return Row(
      children: [
        const Text(
          'Engineering Verification Findings',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimary,
          ),
        ),
        const Spacer(),
        Obx(() {
          final filter = controller.statusFilter.value;
          return Wrap(
            spacing: 6,
            children: [
              _FilterChip(
                label: 'All (${report.findings.length})',
                isSelected: filter == null,
                onTap: () => controller.setFilter(null),
              ),
              _FilterChip(
                label: 'Violations (${report.violationsCount})',
                isSelected: filter == FindingStatus.violation,
                color: AppTheme.accentRed,
                onTap: () => controller.setFilter(FindingStatus.violation),
              ),
              _FilterChip(
                label: 'Warnings (${report.warningsCount})',
                isSelected: filter == FindingStatus.warning,
                color: AppTheme.amberWarning,
                onTap: () => controller.setFilter(FindingStatus.warning),
              ),
              _FilterChip(
                label: 'Compliant (${report.compliantCount})',
                isSelected: filter == FindingStatus.compliant,
                color: AppTheme.greenCompliant,
                onTap: () => controller.setFilter(FindingStatus.compliant),
              ),
            ],
          );
        }),
      ],
    );
  }

  List<Widget> _buildFindingsList(AuditReport report) {
    final filter = controller.statusFilter.value;
    final list = report.findings.where((f) {
      if (filter == null) return true;
      return f.status == filter;
    }).toList();

    return list.map((f) => _buildFindingCard(f)).toList();
  }

  Widget _buildFindingCard(AuditFinding finding) {
    Color statusColor;
    String statusLabel;

    switch (finding.status) {
      case FindingStatus.violation:
        statusColor = AppTheme.accentRed;
        statusLabel = 'VIOLATION';
        break;
      case FindingStatus.warning:
        statusColor = AppTheme.amberWarning;
        statusLabel = 'WARNING';
        break;
      case FindingStatus.compliant:
        statusColor = AppTheme.greenCompliant;
        statusLabel = 'COMPLIANT';
        break;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.cardDark,
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        border: Border.all(
          color: finding.status == FindingStatus.violation
              ? AppTheme.accentRed.withValues(alpha: 0.35)
              : AppTheme.cardBorder,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: statusColor.withValues(alpha: 0.3)),
                ),
                child: Text(
                  statusLabel,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: statusColor,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceDark,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: AppTheme.cardBorder),
                ),
                child: Text(
                  finding.clauseRef,
                  style: AppTheme.monoStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textPrimary,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                finding.category,
                style: const TextStyle(fontSize: 11, color: AppTheme.textMuted),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            finding.clauseTitle,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Standard Requirement: ',
                  style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold, color: AppTheme.textSecondary)),
              Expanded(
                child: Text(
                  finding.standardRequirement,
                  style: const TextStyle(fontSize: 12.5, color: AppTheme.textSecondary),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Plan Finding: ',
                  style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold, color: statusColor)),
              Expanded(
                child: Text(
                  finding.projectFinding,
                  style: TextStyle(fontSize: 12.5, color: statusColor),
                ),
              ),
            ],
          ),
          if (finding.technicalExplanation.isNotEmpty) ...[
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.surfaceDark,
                borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                border: Border.all(color: AppTheme.cardBorder),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    finding.technicalExplanation,
                    style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary, height: 1.4),
                  ),
                  if (finding.engineeringCalculation != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      'FORMULA: ${finding.engineeringCalculation}',
                      style: AppTheme.monoStyle(fontSize: 11, color: AppTheme.accentRed),
                    ),
                  ],
                ],
              ),
            ),
          ],
          if (finding.requiredRemedy.isNotEmpty) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.build_outlined, size: 14, color: AppTheme.amberWarning),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    'Directive: ${finding.requiredRemedy}',
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppTheme.textPrimary),
                  ),
                ),
                TextButton.icon(
                  onPressed: () => controller.openAuditorConsole('Clarify clause ${finding.clauseRef}: ${finding.clauseTitle}'),
                  icon: const Icon(Icons.chat_bubble_outline, size: 14, color: AppTheme.accentRed),
                  label: const Text('Ask AI Auditor', style: TextStyle(color: AppTheme.accentRed, fontSize: 12)),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildAuditorBottomBanner() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.surfaceDark,
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        border: Border.all(color: AppTheme.cardBorder),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.accentRed.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(AppTheme.radiusSm),
            ),
            child: const Icon(Icons.psychology_outlined, color: AppTheme.accentRed, size: 28),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Interactive AI Rigging Auditor Studio',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Query statutory tolerances, Crosby hardware catalogs, formula recalculations, and generate PE-stamped rework notes.',
                  style: TextStyle(fontSize: 12.5, color: AppTheme.textSecondary),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          ElevatedButton.icon(
            onPressed: () => controller.openAuditorConsole(null),
            icon: const Icon(Icons.chat_rounded, size: 16, color: Colors.white),
            label: const Text('Open AI Auditor'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.accentRed,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppTheme.radiusMd),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusCounter extends StatelessWidget {
  final int count;
  final String label;
  final Color color;

  const _StatusCounter({required this.count, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(shape: BoxShape.circle, color: color),
        ),
        const SizedBox(width: 6),
        Text(
          '$count $label',
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: color),
        ),
      ],
    );
  }
}

class _MetricCard extends StatelessWidget {
  final String title;
  final String value;
  final String requirement;
  final Color statusColor;
  final bool isFailed;

  const _MetricCard({
    required this.title,
    required this.value,
    required this.requirement,
    required this.statusColor,
    required this.isFailed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.cardDark,
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        border: Border.all(color: isFailed ? statusColor.withValues(alpha: 0.3) : AppTheme.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: AppTheme.monoStyle(fontSize: 9.5, color: AppTheme.textMuted),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: AppTheme.monoStyle(
              fontSize: 17,
              fontWeight: FontWeight.w900,
              color: statusColor,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            requirement,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 10.5, color: AppTheme.textSecondary),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final Color? color;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final activeColor = color ?? AppTheme.textPrimary;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppTheme.radiusSm),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: isSelected ? activeColor.withValues(alpha: 0.15) : AppTheme.cardDark,
          borderRadius: BorderRadius.circular(AppTheme.radiusSm),
          border: Border.all(
            color: isSelected ? activeColor : AppTheme.cardBorder,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            color: isSelected ? activeColor : AppTheme.textSecondary,
          ),
        ),
      ),
    );
  }
}
