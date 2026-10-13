import 'package:get/get.dart';
import '../../../shared/controllers/auth_controller.dart';
import '../controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<AuthController>()) {
      Get.put(AuthController(), permanent: true);
    }
    Get.lazyPut<HomeController>(() => HomeController());
  }
}
