import 'package:get/get.dart';
import '../../../shared/controllers/auth_controller.dart';
import '../controllers/console_controller.dart';

class ConsoleBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<AuthController>()) {
      Get.put(AuthController(), permanent: true);
    }
    Get.lazyPut<ConsoleController>(() => ConsoleController());
  }
}
