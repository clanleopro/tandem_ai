import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/sample_data.dart';
import '../../../models/rigging_models.dart';
import '../../home/controllers/home_controller.dart';
import 'package:file_picker/file_picker.dart' show PlatformFile, FilePicker, FileType;

class AuditController extends GetxController {
  static AuditController get to => Get.find<AuditController>();

  // Wizard state
  final standards = <RiggingStandard>[].obs;
  final selectedStandard = Rx<RiggingStandard?>(null);
  final projectFiles = <ProjectFile>[].obs;
  final selectedProjectFile = Rx<ProjectFile?>(null);
  final currentStep = 0.obs;

  final projectNameController = TextEditingController(
    text: 'Turbine Generator Module 4 - Tandem Placement',
  );
  final siteLocationController = TextEditingController(
    text: 'Ras Laffan Petrochem Phase II, Qatar',
  );
  final customProjectFileName = Rx<String?>(null);

  // Scanner state
  final isAnalyzing = false.obs;
  final scanProgress = 0.0.obs;
  final scanStatusText = 'Initializing Tandem AI Engine...'.obs;
  Timer? _scanTimer;

  // Report state
  final activeReport = Rx<AuditReport?>(null);
  final activeProject = Rx<AuditProject?>(null);
  final statusFilter = Rx<FindingStatus?>(null);

  final List<String> _scanStages = [
    'Parsing Standard Clauses & Regulatory Safety Factors...',
    'Extracting Lift Geometry, Sling Lengths & Horizontal Angles...',
    'Evaluating Leg Tension: T = W / (N * sin θ) against WLL...',
    'Cross-referencing Crosby Hardware D/d Curvature Limits...',
    'Verifying Dynamic Amplification & Outrigger Ground Pressures...',
    'Detecting Discrepancies & Formulating Engineering Rework Directives...',
  ];

  @override
  void onInit() {
    super.onInit();
    final stds = List<RiggingStandard>.from(SampleData.defaultStandards);
    standards.assignAll(stds);
    if (stds.isNotEmpty) selectedStandard.value = stds.first;

    final files = List<ProjectFile>.from(SampleData.sampleProjectFiles);
    projectFiles.assignAll(files);
    if (files.isNotEmpty) selectedProjectFile.value = files.first;

    // Check if arguments were passed
    final args = Get.arguments;
    if (args != null && args is Map) {
      if (args['report'] != null) {
        activeReport.value = args['report'] as AuditReport;
      }
      if (args['project'] != null) {
        activeProject.value = args['project'] as AuditProject;
      }
    }

    if (activeReport.value == null && Get.isRegistered<HomeController>()) {
      activeReport.value = HomeController.to.activeReport.value;
      activeProject.value = HomeController.to.currentProject.value;
    }
  }

  @override
  void onClose() {
    _scanTimer?.cancel();
    projectNameController.dispose();
    siteLocationController.dispose();
    super.onClose();
  }

 Future<StandardUploadDraft?> openStandardsVault() async {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();

  PlatformFile? selectedFile;
  String? fileError;
  bool isPickingFile = false;

  final result = await Get.dialog<StandardUploadDraft>(
    Dialog(
      backgroundColor: AppTheme.surfaceDark,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        side: const BorderSide(color: AppTheme.cardBorder),
      ),
      child: SizedBox(
        width: 560,
        child: StatefulBuilder(
          builder: (context, setDialogState) {
            Future<void> pickDocument() async {
              setDialogState(() {
                isPickingFile = true;
                fileError = null;
              });

              try {
                final file = await FilePicker.pickFile(
                  type: FileType.custom,
                  allowedExtensions: const [
                    'pdf',
                    'doc',
                    'docx',
                    'xls',
                    'xlsx',
                  ],
                  dialogTitle: 'Select a standard document',
                );

                if (file == null) return;

                final extension = file.extension?.toLowerCase();
                const allowedExtensions = {
                  'pdf',
                  'doc',
                  'docx',
                  'xls',
                  'xlsx',
                };

                if (extension == null ||
                    !allowedExtensions.contains(extension)) {
                  setDialogState(() {
                    selectedFile = null;
                    fileError = 'Choose a PDF, Word, or Excel document.';
                  });
                  return;
                }

                const maxFileSizeBytes = 25 * 1024 * 1024;
                final fileSizeBytes = await file.length();

                if (fileSizeBytes! > maxFileSizeBytes) {
                  setDialogState(() {
                    selectedFile = null;
                    fileError = 'The file must be 25 MB or smaller.';
                  });
                  return;
                }

                setDialogState(() {
                  selectedFile = file;
                  fileError = null;
                });
              } catch (error) {
                setDialogState(() {
                  fileError = 'Could not open the file. Please try again.';
                });
              } finally {
                setDialogState(() {
                  isPickingFile = false;
                });
              }
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: AppTheme.accentRed.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: AppTheme.accentRed.withValues(alpha: 0.3),
                            ),
                          ),
                          child: const Icon(
                            Icons.upload_file_outlined,
                            color: AppTheme.accentRed,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Upload a Standard',
                                style: TextStyle(
                                  fontSize: 19,
                                  fontWeight: FontWeight.w700,
                                  color: AppTheme.textPrimary,
                                ),
                              ),
                              SizedBox(height: 3),
                              Text(
                                'Add a document to your standards library.',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppTheme.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          tooltip: 'Close',
                          onPressed: () => Get.back<StandardUploadDraft>(),
                          icon: const Icon(
                            Icons.close,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    const Text(
                      'STANDARD NAME',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.8,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: nameController,
                      textCapitalization: TextCapitalization.words,
                      style: const TextStyle(color: AppTheme.textPrimary),
                      decoration: InputDecoration(
                        hintText: 'e.g. ASME B30.9-2021',
                        hintStyle: const TextStyle(
                          color: AppTheme.textMuted,
                        ),
                        prefixIcon: const Icon(
                          Icons.menu_book_outlined,
                          color: AppTheme.textMuted,
                          size: 19,
                        ),
                        filled: true,
                        fillColor: AppTheme.cardDark,
                        border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(AppTheme.radiusSm),
                          borderSide:
                              const BorderSide(color: AppTheme.cardBorder),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(AppTheme.radiusSm),
                          borderSide:
                              const BorderSide(color: AppTheme.cardBorder),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(AppTheme.radiusSm),
                          borderSide: const BorderSide(
                            color: AppTheme.accentRed,
                            width: 1.4,
                          ),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(AppTheme.radiusSm),
                          borderSide: const BorderSide(color: Colors.redAccent),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Enter a name for this standard.';
                        }
                        if (value.trim().length < 3) {
                          return 'The name must be at least 3 characters.';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 20),

                    const Text(
                      'STANDARD DOCUMENT',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.8,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 8),

                    InkWell(
                      onTap: isPickingFile ? null : pickDocument,
                      borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 22,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.cardDark,
                          borderRadius:
                              BorderRadius.circular(AppTheme.radiusMd),
                          border: Border.all(
                            color: fileError != null
                                ? Colors.redAccent
                                : selectedFile != null
                                    ? AppTheme.accentRed
                                    : AppTheme.cardBorder,
                            width: selectedFile != null ? 1.4 : 1,
                          ),
                        ),
                        child: selectedFile == null
                            ? Column(
                                children: [
                                  Icon(
                                    isPickingFile
                                        ? Icons.hourglass_top_rounded
                                        : Icons.cloud_upload_outlined,
                                    size: 30,
                                    color: AppTheme.accentRed,
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    isPickingFile
                                        ? 'Opening file picker…'
                                        : 'Choose a document to upload',
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: AppTheme.textPrimary,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  const Text(
                                    'PDF, DOC, DOCX, XLS, or XLSX • Maximum 25 MB',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: AppTheme.textMuted,
                                    ),
                                  ),
                                  const SizedBox(height: 14),
                                  OutlinedButton(
                                    onPressed:
                                        isPickingFile ? null : pickDocument,
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor: AppTheme.textPrimary,
                                      side: const BorderSide(
                                        color: AppTheme.cardBorder,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                          AppTheme.radiusSm,
                                        ),
                                      ),
                                    ),
                                    child: const Text('Browse files'),
                                  ),
                                ],
                              )
                            : Row(
                                children: [
                                  const Icon(
                                    Icons.description_outlined,
                                    color: AppTheme.accentRed,
                                    size: 28,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          selectedFile!.name,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                            color: AppTheme.textPrimary,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          '${selectedFile!.extension?.toUpperCase() ?? 'DOCUMENT'} selected',
                                          style: const TextStyle(
                                            fontSize: 11,
                                            color: AppTheme.textSecondary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  IconButton(
                                    tooltip: 'Remove file',
                                    onPressed: () {
                                      setDialogState(() {
                                        selectedFile = null;
                                        fileError = null;
                                      });
                                    },
                                    icon: const Icon(
                                      Icons.close,
                                      color: AppTheme.textMuted,
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ),

                    if (fileError != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        fileError!,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.redAccent,
                        ),
                      ),
                    ],

                    const SizedBox(height: 24),
                    const Divider(color: AppTheme.cardBorder),
                    const SizedBox(height: 16),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        OutlinedButton(
                          onPressed: () => Get.back<StandardUploadDraft>(),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppTheme.textSecondary,
                            side: const BorderSide(
                              color: AppTheme.cardBorder,
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 18,
                              vertical: 14,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(AppTheme.radiusMd),
                            ),
                          ),
                          child: const Text('Cancel'),
                        ),
                        const SizedBox(width: 12),
                        ElevatedButton.icon(
                          onPressed: () {
                            final isFormValid =
                                formKey.currentState?.validate() ?? false;

                            if (!isFormValid) return;

                            if (selectedFile == null) {
                              setDialogState(() {
                                fileError = 'Choose a document to continue.';
                              });
                              return;
                            }

                            Get.back<StandardUploadDraft>(
                              result: StandardUploadDraft(
                                name: nameController.text.trim(),
                                file: selectedFile!,
                              ),
                            );
                          },
                          icon: const Icon(Icons.upload, size: 17),
                          label: const Text('Continue'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.accentRed,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 14,
                            ),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(AppTheme.radiusMd),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    ),
    barrierDismissible: false,
  );

  nameController.dispose();
  return result;
}
  void selectStandard(RiggingStandard standard) {
    selectedStandard.value = standard;
  }

  void selectProjectFile(ProjectFile file) {
    selectedProjectFile.value = file;
    customProjectFileName.value = null;
  }

  void simulateCustomFileUpload() {
    customProjectFileName.value = 'Heavy_Turbine_Rigging_LiftPlan_Verified.pdf';
  }

  void nextStep() {
    if (currentStep.value < 2) {
      currentStep.value++;
      if (currentStep.value == 2) {
        startScan();
      }
    }
  }

  void previousStep() {
    if (currentStep.value > 0) {
      currentStep.value--;
    }
  }

  void resetWizard() {
    _scanTimer?.cancel();
    isAnalyzing.value = false;
    scanProgress.value = 0.0;
    currentStep.value = 0;
  }

  void startScan() {
    _scanTimer?.cancel();
    isAnalyzing.value = true;
    scanProgress.value = 0.05;
    scanStatusText.value = _scanStages[0];

    int stageIndex = 0;
    _scanTimer = Timer.periodic(const Duration(milliseconds: 600), (timer) {
      scanProgress.value += 0.16;
      if (stageIndex < _scanStages.length) {
        scanStatusText.value = _scanStages[stageIndex];
        stageIndex++;
      }

      if (scanProgress.value >= 1.0) {
        scanProgress.value = 1.0;
        isAnalyzing.value = false;
        timer.cancel();

        final generatedReport = SampleData.createSampleReport();
        activeReport.value = generatedReport;

        if (Get.isRegistered<HomeController>()) {
          HomeController.to.activeReport.value = generatedReport;
        }

        Get.offNamed(
          AppRoutes.auditReport,
          arguments: {'report': generatedReport},
        );
      }
    });
  }

  void reAudit() {
    resetWizard();
    Get.toNamed(AppRoutes.auditWizard);
  }

  void openAuditorConsole(String? prompt) {
    Get.toNamed(
      AppRoutes.auditorConsole,
      arguments: {'prompt': prompt, 'report': activeReport.value},
    );
  }

  void setFilter(FindingStatus? filter) {
    statusFilter.value = filter;
  }
}
class StandardUploadDraft {
  const StandardUploadDraft({
    required this.name,
    required this.file,
  });

  final String name;
  final PlatformFile file;
}