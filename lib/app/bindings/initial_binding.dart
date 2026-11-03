import 'package:get/get.dart';

import '../../core/services/app_controller.dart';
import '../../modules/analysis/controllers/analysis_controller.dart';
import '../../modules/auth/controllers/auth_controller.dart';
import '../../modules/reports/controllers/report_controller.dart';
import '../../modules/workspace/controllers/workspace_controller.dart';

/// Global initial binding that registers core application controllers.
class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<AuthController>(AuthController(), permanent: true);
    Get.put<WorkspaceController>(WorkspaceController(), permanent: true);
    Get.put<AnalysisController>(AnalysisController(), permanent: true);
    Get.put<ReportController>(ReportController(), permanent: true);

    // Register AppController backward compatibility bridge
    if (!Get.isRegistered<AppController>()) {
      Get.put<AppController>(AppController(), permanent: true);
    }
  }
}

