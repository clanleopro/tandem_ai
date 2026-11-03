import 'package:get/get.dart';

import '../../auth/controllers/auth_controller.dart';
import '../../analysis/controllers/analysis_controller.dart';
import '../../reports/controllers/report_controller.dart';
import '../controllers/workspace_controller.dart';

class WorkspaceBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<AuthController>()) {
      Get.put<AuthController>(AuthController(), permanent: true);
    }
    if (!Get.isRegistered<WorkspaceController>()) {
      Get.put<WorkspaceController>(WorkspaceController(), permanent: true);
    }
    if (!Get.isRegistered<AnalysisController>()) {
      Get.put<AnalysisController>(AnalysisController(), permanent: true);
    }
    if (!Get.isRegistered<ReportController>()) {
      Get.put<ReportController>(ReportController(), permanent: true);
    }
  }
}

