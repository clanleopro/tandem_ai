import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../widgets/auth_dialog.dart';

class AuthController extends GetxController {
  static AuthController get to => Get.find<AuthController>();

  static const String demoClientAccessKey = 'TANDEM-DEMO-2026';

  final isLoggedIn = false.obs;
  final isLoading = false.obs;
  final authError = ''.obs;

  final engineerName = ''.obs;
  final engineerEmail = ''.obs;
  final licenseId = ''.obs;

  final selectedPlanName = ''.obs;
  final selectedBillingCycle = ''.obs;

  // Temporary demo user details held between Google demo login and plan selection.
  final pendingGoogleName = ''.obs;
  final pendingGoogleEmail = ''.obs;

  void login({
    required String email,
    required String name,
    required String license,
  }) {
    isLoggedIn.value = true;
    engineerEmail.value = email;
    engineerName.value = name;
    licenseId.value = license;
    authError.value = '';
  }

  /// UI-only simulation of Google sign-in.
  /// This stages a new user; the user is logged in after selecting a plan.
  Future<bool> prepareGoogleDemoLogin() async {
    isLoading.value = true;
    authError.value = '';

    try {
      await Future<void>.delayed(const Duration(milliseconds: 700));

      pendingGoogleName.value = 'Alex Morgan';
      pendingGoogleEmail.value = 'alex@example.com';

      return true;
    } catch (_) {
      authError.value = 'Demo sign-in failed. Please try again.';
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  /// UI-only client access-key sign-in.
  Future<bool> loginWithDemoClientKey(String accessKey) async {
    isLoading.value = true;
    authError.value = '';

    try {
      await Future<void>.delayed(const Duration(milliseconds: 500));

      if (accessKey.trim() != demoClientAccessKey) {
        authError.value = 'That access key is not valid. Check it and try again.';
        return false;
      }

      login(
        email: 'client.demo@tandem-rigging.ai',
        name: 'Demo Client',
        license: 'Client Access',
      );

      return true;
    } finally {
      isLoading.value = false;
    }
  }

  /// Completes the demo Google-user signup after plan selection.
  void completeGoogleDemoSignup({
    required String planName,
    required String billingCycle,
  }) {
    selectedPlanName.value = planName;
    selectedBillingCycle.value = billingCycle;

    login(
      email: pendingGoogleEmail.value,
      name: pendingGoogleName.value,
      license: 'Demo account',
    );
  }

  /// Retained for any existing demo button elsewhere in the app.
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
    selectedPlanName.value = '';
    selectedBillingCycle.value = '';
    authError.value = '';
  }

  void showLoginModal(BuildContext context) {
    showDialog<void>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.75),
      builder: (_) => const AuthDialog(),
    );
  }
}