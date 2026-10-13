import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/app_header.dart';
import '../../../shared/widgets/engineering_footer.dart';
import '../controllers/audit_controller.dart';

class AuditWizardView extends GetView<AuditController> {
  const AuditWizardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgDark,
      appBar: AppHeader(
        onStartNewAudit: controller.resetWizard,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1100),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Breadcrumb and Navigation Bar
                      _buildTopNavigation(),

                      const SizedBox(height: 24),

                      // Stepper Navigation
                      Obx(() => _buildStepIndicator(controller.currentStep.value)),

                      const SizedBox(height: 28),

                      // Step Content
                      Obx(() {
                        switch (controller.currentStep.value) {
                          case 0:
                            return _buildStep1SelectStandard();
                          case 1:
                            return _buildStep2UploadLiftPlan();
                          case 2:
                          default:
                            return _buildStep3ScanningProgress();
                        }
                      }),

                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const EngineeringFooter(),
        ],
      ),
    );
  }

  Widget _buildTopNavigation() {
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
        const SizedBox(width: 16),
        const Text(
          'Compliance Verification Wizard',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppTheme.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildStepIndicator(int currentStep) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceDark,
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        border: Border.all(color: AppTheme.cardBorder),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isCompact = constraints.maxWidth < 650;
          return Row(
            children: [
              _buildStepItem(0, '1', 'Select Standard', currentStep, isCompact),
              Expanded(
                child: Container(
                  height: 1,
                  color: currentStep > 0 ? AppTheme.accentRed : AppTheme.cardBorder,
                  margin: const EdgeInsets.symmetric(horizontal: 12),
                ),
              ),
              _buildStepItem(1, '2', 'Lift Plan Specs', currentStep, isCompact),
              Expanded(
                child: Container(
                  height: 1,
                  color: currentStep > 1 ? AppTheme.accentRed : AppTheme.cardBorder,
                  margin: const EdgeInsets.symmetric(horizontal: 12),
                ),
              ),
              _buildStepItem(2, '3', 'AI Verification Scan', currentStep, isCompact),
            ],
          );
        },
      ),
    );
  }

  Widget _buildStepItem(int stepIndex, String number, String label, int currentStep, bool isCompact) {
    final isActive = currentStep == stepIndex;
    final isDone = currentStep > stepIndex;

    Color badgeColor = AppTheme.cardDark;
    Color textColor = AppTheme.textMuted;
    Color borderColor = AppTheme.cardBorder;

    if (isDone) {
      badgeColor = AppTheme.greenCompliant.withValues(alpha: 0.15);
      borderColor = AppTheme.greenCompliant;
      textColor = AppTheme.greenCompliant;
    } else if (isActive) {
      badgeColor = AppTheme.accentRed.withValues(alpha: 0.15);
      borderColor = AppTheme.accentRed;
      textColor = Colors.white;
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: badgeColor,
            border: Border.all(color: borderColor),
          ),
          child: Center(
            child: isDone
                ? const Icon(Icons.check, size: 14, color: AppTheme.greenCompliant)
                : Text(
                    number,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
          ),
        ),
        if (!isCompact) ...[
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
              color: isActive ? AppTheme.textPrimary : AppTheme.textSecondary,
            ),
          ),
        ],
      ],
    );
  }

  // ─── STEP 1: SELECT REGULATORY STANDARD ───────────────────────────────────
  Widget _buildStep1SelectStandard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Step 1 • Select Regulatory Rigging Standard',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
        ),
        const SizedBox(height: 6),
        const Text(
          'Choose the baseline standard or regulatory code to evaluate your lift plan against.',
          style: TextStyle(fontSize: 13, color: AppTheme.textSecondary),
        ),
        const SizedBox(height: 24),
        LayoutBuilder(
          builder: (context, constraints) {
            final isCompact = constraints.maxWidth < 700;
            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: isCompact ? 1 : 2,
                mainAxisExtent: 200,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: controller.standards.length,
              itemBuilder: (context, index) {
                final std = controller.standards[index];
                return Obx(() {
                  final isSelected = controller.selectedStandard.value?.id == std.id;
                  return InkWell(
                    onTap: () => controller.selectStandard(std),
                    borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppTheme.cardDark,
                        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                        border: Border.all(
                          color: isSelected ? AppTheme.accentRed : AppTheme.cardBorder,
                          width: isSelected ? 1.5 : 1,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? AppTheme.accentRed.withValues(alpha: 0.15)
                                      : AppTheme.surfaceDark,
                                  borderRadius: BorderRadius.circular(4),
                                  border: Border.all(
                                    color: isSelected ? AppTheme.accentRed : AppTheme.cardBorder,
                                  ),
                                ),
                                child: Text(
                                  std.code,
                                  style: AppTheme.monoStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    color: isSelected ? AppTheme.accentRed : AppTheme.textPrimary,
                                  ),
                                ),
                              ),
                              const Spacer(),
                              if (isSelected)
                                const Icon(Icons.check_circle, size: 20, color: AppTheme.accentRed)
                              else
                                const Icon(Icons.radio_button_off, size: 20, color: AppTheme.textMuted),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            std.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            std.organization,
                            style: const TextStyle(fontSize: 12, color: AppTheme.textMuted),
                          ),
                          const Spacer(),
                          Row(
                            children: [
                              Text(
                                '${std.clausesCount} verification clauses',
                                style: AppTheme.monoStyle(fontSize: 10, color: AppTheme.textSecondary),
                              ),
                              const Spacer(),
                              Text(
                                std.category,
                                style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                });
              },
            );
          },
        ),
        const SizedBox(height: 32),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ElevatedButton.icon(
              onPressed: controller.nextStep,
              icon: const Icon(Icons.arrow_forward, size: 16),
              label: const Text('Proceed to Lift Plan Staging'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.accentRed,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ─── STEP 2: UPLOAD LIFT PLAN SPECS ───────────────────────────────────────
  Widget _buildStep2UploadLiftPlan() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Step 2 • Staging Lift Plan & Rigging Geometry',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
        ),
        const SizedBox(height: 6),
        const Text(
          'Provide the project metadata and select the CAD drawing or sling calculation package.',
          style: TextStyle(fontSize: 13, color: AppTheme.textSecondary),
        ),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppTheme.surfaceDark,
            borderRadius: BorderRadius.circular(AppTheme.radiusMd),
            border: Border.all(color: AppTheme.cardBorder),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'PROJECT DETAILS',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.textSecondary),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: controller.projectNameController,
                decoration: const InputDecoration(
                  labelText: 'Project Name',
                  prefixIcon: Icon(Icons.assignment_outlined, size: 18),
                ),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: controller.siteLocationController,
                decoration: const InputDecoration(
                  labelText: 'Site Location & Facility',
                  prefixIcon: Icon(Icons.location_on_outlined, size: 18),
                ),
              ),
              const SizedBox(height: 28),
              const Text(
                'RIGGING PLAN PACKAGE (SELECT SAMPLE OR UPLOAD CUSTOM)',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.textSecondary),
              ),
              const SizedBox(height: 12),
              ...controller.projectFiles.map((file) {
                return Obx(() {
                  final isSelected = controller.selectedProjectFile.value?.id == file.id &&
                      controller.customProjectFileName.value == null;
                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      color: AppTheme.cardDark,
                      borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                      border: Border.all(
                        color: isSelected ? AppTheme.accentRed : AppTheme.cardBorder,
                      ),
                    ),
                    child: ListTile(
                      onTap: () => controller.selectProjectFile(file),
                      leading: Icon(
                        Icons.picture_as_pdf,
                        color: isSelected ? AppTheme.accentRed : AppTheme.textMuted,
                      ),
                      title: Text(
                        file.fileName,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: isSelected ? AppTheme.textPrimary : AppTheme.textSecondary,
                        ),
                      ),
                      subtitle: Text(
                        '${file.liftDescription} • ${file.totalLoadWeightTons} MT • ${file.craneModel}',
                        style: const TextStyle(fontSize: 11, color: AppTheme.textMuted),
                      ),
                      trailing: isSelected
                          ? const Icon(Icons.check_circle, color: AppTheme.accentRed, size: 18)
                          : null,
                    ),
                  );
                });
              }),
              const SizedBox(height: 14),
              Obx(() {
                final customName = controller.customProjectFileName.value;
                return InkWell(
                  onTap: controller.simulateCustomFileUpload,
                  borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppTheme.cardDark,
                      borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                      border: Border.all(
                        color: customName != null ? AppTheme.accentRed : AppTheme.cardBorder,
                        style: BorderStyle.solid,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          customName != null ? Icons.check_circle : Icons.upload_file,
                          color: customName != null ? AppTheme.greenCompliant : AppTheme.accentRed,
                          size: 22,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          customName ?? 'Upload Custom Rigging Drawing / Calc Sheet (PDF/DWG)',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: customName != null ? AppTheme.textPrimary : AppTheme.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
        const SizedBox(height: 32),
        Row(
          children: [
            OutlinedButton(
              onPressed: controller.previousStep,
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppTheme.cardBorder),
                foregroundColor: AppTheme.textSecondary,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              ),
              child: const Text('← Back'),
            ),
            const Spacer(),
            ElevatedButton.icon(
              onPressed: controller.nextStep,
              icon: const Icon(Icons.play_arrow, size: 18),
              label: const Text('Run Compliance Verification Scan'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.accentRed,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ─── STEP 3: SCANNING TELEMETRY ───────────────────────────────────────────
  Widget _buildStep3ScanningProgress() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: AppTheme.surfaceDark,
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        border: Border.all(color: AppTheme.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppTheme.accentRed.withValues(alpha: 0.1),
              border: Border.all(color: AppTheme.accentRed),
            ),
            child: const Center(
              child: SizedBox(
                width: 38,
                height: 38,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  valueColor: AlwaysStoppedAnimation<Color>(AppTheme.accentRed),
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Tandem AI Verification Engine Active',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Obx(() => Text(
                controller.scanStatusText.value,
                textAlign: TextAlign.center,
                style: AppTheme.monoStyle(
                  fontSize: 13,
                  color: AppTheme.textSecondary,
                ),
              )),
          const SizedBox(height: 28),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: Obx(() => LinearProgressIndicator(
                  value: controller.scanProgress.value,
                  backgroundColor: AppTheme.cardDark,
                  valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.accentRed),
                  minHeight: 8,
                )),
          ),
          const SizedBox(height: 12),
          Obx(() => Text(
                '${(controller.scanProgress.value * 100).toInt()}% Verified',
                style: AppTheme.monoStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.accentRed,
                ),
              )),
          const SizedBox(height: 32),
          const Divider(color: AppTheme.dividerColor),
          const SizedBox(height: 20),
          Wrap(
            spacing: 24,
            runSpacing: 16,
            alignment: WrapAlignment.center,
            children: const [
              _TelemetryTicker(label: 'CALC ENGINE', value: 'Bridle Sling Tension (N=4)'),
              _TelemetryTicker(label: 'HARDWARE SPEC', value: 'Crosby G-2130 D/d Limit'),
              _TelemetryTicker(label: 'AMPLIFICATION', value: 'DAF = 1.15 Factored Load'),
              _TelemetryTicker(label: 'STANDARD', value: 'ASME B30.9-2021 Clause 9-2'),
            ],
          ),
        ],
      ),
    );
  }
}

class _TelemetryTicker extends StatelessWidget {
  final String label;
  final String value;

  const _TelemetryTicker({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTheme.monoStyle(fontSize: 10, color: AppTheme.textMuted),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: AppTheme.monoStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppTheme.textPrimary),
        ),
      ],
    );
  }
}
