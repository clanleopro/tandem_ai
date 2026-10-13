import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/routes/app_routes.dart';
import '../../../data/sample_data.dart';
import '../../../models/rigging_models.dart';
import '../../home/controllers/home_controller.dart';

class AuditController extends GetxController {
  static AuditController get to => Get.find<AuditController>();

  // Wizard state
  final standards = <RiggingStandard>[].obs;
  final selectedStandard = Rx<RiggingStandard?>(null);
  final projectFiles = <ProjectFile>[].obs;
  final selectedProjectFile = Rx<ProjectFile?>(null);
  final currentStep = 0.obs;

  final projectNameController = TextEditingController(text: 'Turbine Generator Module 4 - Tandem Placement');
  final siteLocationController = TextEditingController(text: 'Ras Laffan Petrochem Phase II, Qatar');
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

        Get.offNamed(AppRoutes.auditReport, arguments: {'report': generatedReport});
      }
    });
  }

  void reAudit() {
    resetWizard();
    Get.toNamed(AppRoutes.auditWizard);
  }

  void openAuditorConsole(String? prompt) {
    Get.toNamed(AppRoutes.auditorConsole, arguments: {
      'prompt': prompt,
      'report': activeReport.value,
    });
  }

  void setFilter(FindingStatus? filter) {
    statusFilter.value = filter;
  }
}
