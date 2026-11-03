import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../data/models/project_model.dart';
import '../../workspace/controllers/workspace_controller.dart';
import '../../workspace/widgets/new_project_dialog.dart';
import '../controllers/analysis_controller.dart';
import '../widgets/document_card.dart';
import '../widgets/document_dropdown.dart';
import '../widgets/ready_banner.dart';
import '../widgets/stepper_bar.dart';

class AnalysisWizardView extends StatefulWidget {
  final WorkspaceController? workspaceCtrl;
  final AnalysisController? analysisCtrl;

  const AnalysisWizardView({super.key, this.workspaceCtrl, this.analysisCtrl});

  @override
  State<AnalysisWizardView> createState() => _AnalysisWizardViewState();
}

class _AnalysisWizardViewState extends State<AnalysisWizardView> {
  WorkspaceController get _workspace =>
      widget.workspaceCtrl ?? Get.find<WorkspaceController>();
  AnalysisController get _analysis =>
      widget.analysisCtrl ?? Get.find<AnalysisController>();

  Future<void> _pickDocument({required bool isStandard}) async {
    final error = await _analysis.pickDocument(isStandard: isStandard);
    if (!mounted) return;

    if (error != null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(error)));
    }
  }

  Future<void> _analyzeDocuments() async {
    // Guard: must have both documents with bytes
    if (!_analysis.canAnalyze) return;

    // Guard: prevent double-tap
    if (_analysis.isSubmitting.value) return;

    // ── Scenario 1 / 3: No active project for THIS review ───────────────────
    // isNewDocumentSelected == true means the wizard was opened fresh (via
    // "+ New Document") and has not been associated with a project yet.
    if (_workspace.isNewDocumentSelected.value) {
      final ProjectModel? project = await showDialog<ProjectModel>(
        context: context,
        barrierDismissible: false,
        builder: (_) => NewProjectDialog(workspaceCtrl: _workspace),
      );

      // User canceled the dialog → preserve documents, stay on wizard
      if (!mounted) return;
      if (project == null) return;

      // Project created successfully → fall through to analysis
    }

    // ── Scenario 2: activeProject guaranteed to be set at this point ─────────
    final active = _workspace.activeProject.value;
    if (active == null) return; // safety net (should not happen)

    final success = await _analysis.analyze(
      projectId: active.id,
      projectName: active.name,
    );

    if (!mounted) return;
    if (!success && _analysis.errorMessage.isNotEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(_analysis.errorMessage.value)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isPicking = _analysis.isPickingDocument.value;
      final isSubmitting = _analysis.isSubmitting.value;
      final currentSourceDoc = _analysis.selectedSourceDoc.value;
      final currentLiftPlanDoc = _analysis.selectedLiftPlanDoc.value;
      final standardDocs = _workspace.standardDocs.toList();
      final liftPlanDocs = _workspace.liftPlanDocs.toList();
      final wizardStep = _workspace.wizardStep.value;

      return SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 960),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                StepperBar(currentStep: wizardStep),
                const SizedBox(height: 38),
                AbsorbPointer(
                  absorbing: isPicking || isSubmitting,
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final sourceSection = Column(
                        children: [
                          DocumentCard(
                            document: currentSourceDoc,
                            onBrowse: () => _pickDocument(isStandard: true),
                            onRemove: _analysis.removeSourceDocument,
                          ),
                          const SizedBox(height: 14),
                          DocumentDropdown(
                            hint: AppStrings.selectSourceDocument,
                            documents: standardDocs,
                            selectedDocument: currentSourceDoc,
                            onSelected: (document) {
                              if (document != null) {
                                _analysis.selectSourceDocument(document);
                              }
                            },
                          ),
                        ],
                      );

                      final liftPlanSection = Column(
                        children: [
                          DocumentCard(
                            document: currentLiftPlanDoc,
                            onBrowse: () => _pickDocument(isStandard: false),
                            onRemove: _analysis.removeLiftPlanDocument,
                          ),
                          const SizedBox(height: 14),
                          DocumentDropdown(
                            hint: AppStrings.selectLiftPlan,
                            documents: liftPlanDocs,
                            selectedDocument: currentLiftPlanDoc,
                            onSelected: (document) {
                              if (document != null) {
                                _analysis.selectLiftPlanDocument(document);
                              }
                            },
                          ),
                        ],
                      );

                      if (constraints.maxWidth < 640) {
                        return Column(
                          children: [
                            sourceSection,
                            const SizedBox(height: 24),
                            liftPlanSection,
                          ],
                        );
                      }

                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(child: sourceSection),
                          const SizedBox(width: 28),
                          Expanded(child: liftPlanSection),
                        ],
                      );
                    },
                  ),
                ),
                if (isPicking) ...[
                  const SizedBox(height: 20),
                  const LinearProgressIndicator(
                    color: AppColors.primaryRed,
                    backgroundColor: AppColors.primaryRedLight,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    AppStrings.readingPdf,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
                const SizedBox(height: 36),
                ReadyBanner(
                  ready: _analysis.canAnalyze && !isPicking && !isSubmitting,
                  isSubmitting: isSubmitting,
                  onAnalyze: _analyzeDocuments,
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
