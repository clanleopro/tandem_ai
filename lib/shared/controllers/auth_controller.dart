import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../widgets/auth_dialog.dart';

class AuthController extends GetxController {
  static AuthController get to => Get.find<AuthController>();

  final isLoggedIn = false.obs;
  final engineerName = ''.obs;
  final engineerEmail = ''.obs;
  final licenseId = ''.obs;

  void login({required String email, required String name, required String license}) {
    isLoggedIn.value = true;
    engineerEmail.value = email;
    engineerName.value = name;
    licenseId.value = license;
  }

  void demoLogin() {
    login(
      email: 'chief.vance@tandem-rigging.ai',
      name: 'Eng. Christopher Vance, PE',
      license: 'ASME-PE #84912',
    );
  }

  void logout() {
    isLoggedIn.value = false;
    engineerName.value = '';
    engineerEmail.value = '';
    licenseId.value = '';
  }

  void showLoginModal(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.75),
      builder: (context) => const AuthDialog(),
    );
  }
}
