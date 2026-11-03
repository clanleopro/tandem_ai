import 'package:get/get.dart';

import '../controllers/report_controller.dart';

class ReportBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<ReportController>()) {
      Get.put<ReportController>(ReportController(), permanent: true);
    }
  }
}

