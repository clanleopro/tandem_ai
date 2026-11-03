import 'package:get/get.dart';

import '../../../app/routes/app_routes.dart';

/// GetxController responsible for user authentication and session management.
///
/// NOTE — Backend integration status:
/// The current implementation uses mock/local state only. No HTTP calls are
/// made. To connect real email+password authentication:
///   1. Inject an AuthRepository that wraps your HTTP client.
///   2. In [login], call `await _repo.login(email, password)` and handle the
///      returned session token / error.
///   3. In [signup], call `await _repo.signup(company, email, password)` and
///      handle verification / auto-login per backend contract.
///   4. Store the returned access token via a StorageService (never plaintext).
///   5. Remove the hardcoded defaults and the direct field assignments below.
class AuthController extends GetxController {
  // ─── Reactive Auth State ──────────────────────────────────────────────────
  final RxBool isLoggedIn = true.obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  final RxString currentUserName = 'Divya'.obs;
  final RxString currentUserRole =
      'Senior Crane & Rigging Specialist'.obs;
  final RxString currentUserEmail = 'divya.rigging@titanheavy.com'.obs;
  final RxString companyName = 'Titan Rigging & Heavy Lift Corp'.obs;

  // ─── Auth Actions ────────────────────────────────────────────────────────

  /// Authenticates a user with [email] and optionally [password].
  ///
  /// [password] is accepted but currently unused by the mock implementation.
  /// Wire it to your backend once an email+password endpoint is available.
  Future<void> login({
    String? email,
    String? company,
    String? password, // reserved for real backend integration
  }) async {
    if (isLoading.value) return;
    isLoading.value = true;
    errorMessage.value = '';

    try {
      // ── TODO: replace block below with real HTTP call ─────────────────────
      // final session = await _repo.login(email: email!, password: password!);
      // currentUserEmail.value = session.email;
      // companyName.value     = session.company;
      // ─────────────────────────────────────────────────────────────────────
      await Future.delayed(const Duration(milliseconds: 600)); // mock latency
      if (email != null && email.isNotEmpty) currentUserEmail.value = email;
      if (company != null && company.isNotEmpty) companyName.value = company;
      isLoggedIn.value = true;
      Get.offAllNamed(AppRoutes.workspace);
    } catch (e) {
      errorMessage.value =
          e.toString().replaceFirst('Exception: ', '');
    } finally {
      isLoading.value = false;
    }
  }

  /// Registers a new company account.
  ///
  /// [password] is accepted but currently unused by the mock implementation.
  /// After real backend integration, follow the backend's post-signup behavior:
  ///   - If the backend auto-logs-in: navigate to workspace directly.
  ///   - If the backend requires email verification: return the registered
  ///     email so the caller can switch to the Login tab and prompt the user.
  Future<void> signup({
    required String company,
    required String email,
    String? password, // reserved for real backend integration
    String? registrationId, // optional company reg ID
  }) async {
    if (isLoading.value) return;
    isLoading.value = true;
    errorMessage.value = '';

    try {
      // ── TODO: replace block below with real HTTP call ─────────────────────
      // final result = await _repo.signup(
      //   company: company, email: email, password: password!,
      //   registrationId: registrationId,
      // );
      // if (result.requiresVerification) return; // caller handles redirect
      // ─────────────────────────────────────────────────────────────────────
      await Future.delayed(const Duration(milliseconds: 600)); // mock latency
      companyName.value = company;
      currentUserEmail.value = email;
      isLoggedIn.value = true;
      Get.offAllNamed(AppRoutes.workspace);
    } catch (e) {
      errorMessage.value =
          e.toString().replaceFirst('Exception: ', '');
    } finally {
      isLoading.value = false;
    }
  }

  void logout() {
    isLoggedIn.value = false;
    isLoading.value = false;
    errorMessage.value = '';
    Get.offAllNamed(AppRoutes.login);
  }
}

