import 'package:get/get.dart';
import '../../../core/routes/app_routes.dart';
import '../../../data/sample_data.dart';
import '../../../models/rigging_models.dart';

class HomeController extends GetxController {
  static HomeController get to => Get.find<HomeController>();

  final projects = <AuditProject>[].obs;
  final currentProject = Rx<AuditProject?>(null);
  final activeReport = Rx<AuditReport?>(null);

  @override
  void onInit() {
    super.onInit();
    final sampleProjects = SampleData.getSampleProjects();
    projects.assignAll(sampleProjects);
    if (sampleProjects.isNotEmpty) {
      currentProject.value = sampleProjects.first;
      activeReport.value = sampleProjects.first.report;
    }
  }

  void startNewAudit() {
    Get.toNamed(AppRoutes.auditWizard);
  }

  void selectProject(AuditProject project) {
    currentProject.value = project;
    activeReport.value = project.report ?? SampleData.createSampleReport();
    Get.toNamed(AppRoutes.auditReport, arguments: {'project': project, 'report': activeReport.value});
  }

  void inspectActiveReport() {
    if (activeReport.value != null) {
      Get.toNamed(AppRoutes.auditReport, arguments: {'report': activeReport.value, 'project': currentProject.value});
    } else {
      startNewAudit();
    }
  }

  void openAiConsole({String? prompt}) {
    Get.toNamed(AppRoutes.auditorConsole, arguments: {
      'prompt': prompt,
      'report': activeReport.value,
    });
  }
}
