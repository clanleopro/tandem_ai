import 'package:get/get.dart';
import '../../../shared/controllers/auth_controller.dart';
import '../controllers/audit_controller.dart';

class AuditBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<AuthController>()) {
      Get.put(AuthController(), permanent: true);
    }
    Get.lazyPut<AuditController>(() => AuditController());
  }
}
