import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/routes/app_routes.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/tandem_logo.dart';
import '../controllers/auth_controller.dart';
import '../widgets/auth_preview_panel.dart';

/// Company Authentication page containing two tabs:
///   0 — Account Login (default)
///   1 — Sign Up
///
/// Navigate here via [AppRoutes.companyAuth].
/// Pass `arguments: {'tab': 1}` to open directly on the Sign Up tab.
class CompanyAuthPage extends StatefulWidget {
  final AuthController? authCtrl;

  const CompanyAuthPage({super.key, this.authCtrl});

  @override
  State<CompanyAuthPage> createState() => _CompanyAuthPageState();
}

class _CompanyAuthPageState extends State<CompanyAuthPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  AuthController get _auth =>
      widget.authCtrl ??
      (Get.isRegistered<AuthController>()
          ? Get.find<AuthController>()
          : Get.put(AuthController()));

  @override
  void initState() {
    super.initState();
    // Allow the caller to open directly on the Sign Up tab.
    final args = Get.arguments;
    final initialIndex =
        (args is Map && args['tab'] == 1) ? 1 : 0;
    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: initialIndex,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  /// Switch to Account Login tab and optionally pre-fill the email field.
  void _switchToLoginTab({String? prefillEmail}) {
    _tabController.animateTo(0);
    if (prefillEmail != null) {
      // The login tab's form key is owned by _CompanyLoginForm; we pass the
      // email via a ValueNotifier so the child can listen without rebuilding
      // the entire parent.
      _loginPrefillEmail.value = prefillEmail;
    }
  }

  final ValueNotifier<String> _loginPrefillEmail = ValueNotifier('');

  @override
  void dispose2() {
    _loginPrefillEmail.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.workspaceBackground,
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth >= 1000) {
            return Row(
              children: [
                Expanded(
                  flex: 6,
                  child: AuthPreviewPanel(
                    onLogoTap: () => Get.toNamed(AppRoutes.landing),
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: Container(
                    color: AppColors.workspaceBackground,
                    child: _buildScrollView(compact: false),
                  ),
                ),
              ],
            );
          }
          return _buildScrollView(compact: true);
        },
      ),
    );
  }

  Widget _buildScrollView({required bool compact}) {
    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: compact ? 20 : 48,
          vertical: 28,
        ),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: Container(
            padding: EdgeInsets.all(compact ? 24 : 8),
            decoration: compact
                ? BoxDecoration(
                    color: AppColors.cardBackground,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.cardBorder),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 20,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  )
                : null,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (compact) ...[
                  Center(
                    child: TandemLogo(
                      isDarkBadge: false,
                      onTap: () => Get.toNamed(AppRoutes.landing),
                    ),
                  ),
                  const SizedBox(height: 22),
                ],
                Text(
                  AppStrings.createCompanyAccount,
                  style: AppTypography.heading1().copyWith(fontSize: 24),
                ),
                const SizedBox(height: 5),
                Text(
                  'Manage your team\'s access and document reviews.',
                  style: AppTypography.bodySmall(),
                ),
                const SizedBox(height: 24),
                _SegmentedTabBar(controller: _tabController),
                const SizedBox(height: 24),
                // Tab views are kept alive so form state survives tab switches.
                SizedBox(
                  height: _tabController.index == 0 ? null : null,
                  child: _TabContent(
                    tabController: _tabController,
                    auth: _auth,
                    loginPrefillEmail: _loginPrefillEmail,
                    onSignupSuccess: _switchToLoginTab,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Segmented Tab Bar ────────────────────────────────────────────────────────

class _SegmentedTabBar extends StatefulWidget {
  final TabController controller;

  const _SegmentedTabBar({required this.controller});

  @override
  State<_SegmentedTabBar> createState() => _SegmentedTabBarState();
}

class _SegmentedTabBarState extends State<_SegmentedTabBar> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onTabChanged);
  }

  void _onTabChanged() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTabChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 42,
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          _Tab(
            label: 'Account Login',
            isActive: widget.controller.index == 0,
            onTap: () => widget.controller.animateTo(0),
          ),
          _Tab(
            label: 'Sign Up',
            isActive: widget.controller.index == 1,
            onTap: () => widget.controller.animateTo(1),
          ),
        ],
      ),
    );
  }
}

class _Tab extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _Tab({
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: isActive ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(9),
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : [],
          ),
          child: Center(
            child: Text(
              label,
              style: AppTypography.bodyBold().copyWith(
                fontSize: 13,
                color: isActive
                    ? AppColors.textPrimary
                    : AppColors.textMuted,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Tab Content (keeps both forms alive) ────────────────────────────────────

class _TabContent extends StatefulWidget {
  final TabController tabController;
  final AuthController auth;
  final ValueNotifier<String> loginPrefillEmail;
  final void Function({String? prefillEmail}) onSignupSuccess;

  const _TabContent({
    required this.tabController,
    required this.auth,
    required this.loginPrefillEmail,
    required this.onSignupSuccess,
  });

  @override
  State<_TabContent> createState() => _TabContentState();
}

class _TabContentState extends State<_TabContent> {
  @override
  void initState() {
    super.initState();
    widget.tabController.addListener(_rebuild);
  }

  void _rebuild() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    widget.tabController.removeListener(_rebuild);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Use IndexedStack so both forms stay mounted (form state preserved).
    return IndexedStack(
      index: widget.tabController.index,
      children: [
        _CompanyLoginForm(
          auth: widget.auth,
          prefillEmail: widget.loginPrefillEmail,
        ),
        _CompanySignupForm(
          auth: widget.auth,
          onRegistered: widget.onSignupSuccess,
        ),
      ],
    );
  }
}

// ─── Account Login Form ───────────────────────────────────────────────────────

class _CompanyLoginForm extends StatefulWidget {
  final AuthController auth;
  final ValueNotifier<String> prefillEmail;

  const _CompanyLoginForm({
    required this.auth,
    required this.prefillEmail,
  });

  @override
  State<_CompanyLoginForm> createState() => _CompanyLoginFormState();
}

class _CompanyLoginFormState extends State<_CompanyLoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    widget.prefillEmail.addListener(_onPrefill);
    // Apply any already-set prefill value.
    if (widget.prefillEmail.value.isNotEmpty) {
      _emailController.text = widget.prefillEmail.value;
    }
  }

  void _onPrefill() {
    final email = widget.prefillEmail.value;
    if (email.isNotEmpty && mounted) {
      _emailController.text = email;
    }
  }

  @override
  void dispose() {
    widget.prefillEmail.removeListener(_onPrefill);
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;
    if (widget.auth.isLoading.value) return;

    await widget.auth.login(
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isLoading = widget.auth.isLoading.value;
      final errorMsg = widget.auth.errorMessage.value;

      return Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(AppStrings.userIdWorkEmail, style: AppTypography.bodyBold()),
            const SizedBox(height: 7),
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              enabled: !isLoading,
              validator: (v) {
                final e = v?.trim() ?? '';
                if (e.isEmpty) return 'Enter your work email.';
                if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(e)) {
                  return 'Enter a valid email address.';
                }
                return null;
              },
              decoration: _inputDecoration(
                hint: 'name@company.com',
                icon: Icons.mail_outline,
              ),
            ),
            const SizedBox(height: 18),
            Text(AppStrings.password, style: AppTypography.bodyBold()),
            const SizedBox(height: 7),
            TextFormField(
              controller: _passwordController,
              obscureText: _obscurePassword,
              textInputAction: TextInputAction.done,
              enabled: !isLoading,
              onFieldSubmitted: (_) => _handleLogin(),
              validator: (v) =>
                  (v == null || v.isEmpty) ? 'Enter your password.' : null,
              decoration: _inputDecoration(
                hint: 'Enter your password',
                icon: Icons.lock_outline,
                suffix: IconButton(
                  tooltip: _obscurePassword ? 'Show password' : 'Hide password',
                  onPressed: () =>
                      setState(() => _obscurePassword = !_obscurePassword),
                  icon: Icon(
                    _obscurePassword
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    size: 19,
                    color: AppColors.textMuted,
                  ),
                ),
              ),
            ),
            if (errorMsg.isNotEmpty) ...[
              const SizedBox(height: 10),
              Text(
                errorMsg,
                style: AppTypography.bodySmall(
                  color: AppColors.statusAlertText,
                ),
              ),
            ],
            const SizedBox(height: 22),
            AppButton(
              label: isLoading ? 'Signing in…' : 'Sign In',
              variant: AppButtonVariant.primaryRed,
              height: 46,
              borderRadius: 24,
              onPressed: isLoading ? null : _handleLogin,
            ),
            const SizedBox(height: 10),
            Center(
              child: TextButton(
                onPressed: () => Get.offAllNamed(AppRoutes.login),
                child: Text(
                  'Back to main login',
                  style: AppTypography.bodySmall(color: AppColors.textMuted)
                      .copyWith(fontSize: 12),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  InputDecoration _inputDecoration({
    required String hint,
    required IconData icon,
    Widget? suffix,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: AppTypography.bodySmall(color: AppColors.textSubtle),
      prefixIcon: Icon(icon, size: 19, color: AppColors.textMuted),
      suffixIcon: suffix,
      filled: true,
      fillColor: AppColors.cardBackground,
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: _border(),
      enabledBorder: _border(),
      focusedBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(28)),
        borderSide: BorderSide(color: AppColors.primaryRed, width: 1.4),
      ),
      errorBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(18)),
        borderSide: BorderSide(color: AppColors.statusAlertText),
      ),
      focusedErrorBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(18)),
        borderSide:
            BorderSide(color: AppColors.statusAlertText, width: 1.4),
      ),
    );
  }

  OutlineInputBorder _border() => OutlineInputBorder(
        borderRadius: BorderRadius.circular(28),
        borderSide: const BorderSide(color: AppColors.cardBorder),
      );
}

// ─── Sign Up Form ─────────────────────────────────────────────────────────────

class _CompanySignupForm extends StatefulWidget {
  final AuthController auth;

  /// Called after successful registration. The caller may switch to the Login
  /// tab and prefill the registered email (for backends that require manual
  /// login after sign-up).
  final void Function({String? prefillEmail}) onRegistered;

  const _CompanySignupForm({
    required this.auth,
    required this.onRegistered,
  });

  @override
  State<_CompanySignupForm> createState() => _CompanySignupFormState();
}

class _CompanySignupFormState extends State<_CompanySignupForm> {
  final _formKey = GlobalKey<FormState>();
  final _companyController = TextEditingController();
  final _emailController = TextEditingController();
  final _registrationIdController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _agreedToTerms = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  String? _localError;

  @override
  void dispose() {
    _companyController.dispose();
    _emailController.dispose();
    _registrationIdController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleSignup() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;
    if (!_agreedToTerms) {
      setState(() => _localError =
          'Please accept the verification terms and safety guidelines.');
      return;
    }
    if (widget.auth.isLoading.value) return;
    setState(() => _localError = null);

    await widget.auth.signup(
      company: _companyController.text.trim(),
      email: _emailController.text.trim(),
      password: _passwordController.text,
      registrationId: _registrationIdController.text.trim(),
    );

    // If the backend requires email verification instead of auto-login,
    // AuthController.signup() would NOT call Get.offAllNamed and would instead
    // set a flag. Check that flag here and call onRegistered to switch tabs:
    //
    // if (!widget.auth.isLoggedIn.value && mounted) {
    //   widget.onRegistered(prefillEmail: _emailController.text.trim());
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isLoading = widget.auth.isLoading.value;
      final backendError = widget.auth.errorMessage.value;
      final displayError = _localError ?? (backendError.isNotEmpty ? backendError : null);

      return Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildField(
              label: AppStrings.companyLegalName,
              controller: _companyController,
              icon: Icons.business_outlined,
              hint: 'e.g. Apex Crane & Heavy Transport LLC',
              enabled: !isLoading,
              validator: (v) => (v == null || v.trim().isEmpty)
                  ? 'Enter your company legal name.'
                  : null,
            ),
            const SizedBox(height: 16),
            _buildField(
              label: AppStrings.userIdWorkEmail,
              controller: _emailController,
              icon: Icons.mail_outline,
              hint: 'engineer@company.com',
              keyboardType: TextInputType.emailAddress,
              enabled: !isLoading,
              validator: (v) {
                final e = v?.trim() ?? '';
                if (e.isEmpty) return 'Enter your work email.';
                if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(e)) {
                  return 'Enter a valid email address.';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            _buildField(
              label: AppStrings.companyRegistrationOptional,
              controller: _registrationIdController,
              icon: Icons.badge_outlined,
              hint: 'e.g. SC&RA / OSHA / NCCCO Member ID',
              enabled: !isLoading,
            ),
            const SizedBox(height: 16),
            _buildField(
              label: AppStrings.password,
              controller: _passwordController,
              icon: Icons.lock_outline,
              hint: 'Create a password',
              obscureText: _obscurePassword,
              enabled: !isLoading,
              suffix: IconButton(
                tooltip:
                    _obscurePassword ? 'Show password' : 'Hide password',
                onPressed: () =>
                    setState(() => _obscurePassword = !_obscurePassword),
                icon: Icon(
                  _obscurePassword
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  size: 19,
                  color: AppColors.textMuted,
                ),
              ),
              validator: (v) {
                if (v == null || v.isEmpty) return 'Create a password.';
                if (v.length < 8) return 'Use at least 8 characters.';
                return null;
              },
            ),
            const SizedBox(height: 16),
            _buildField(
              label: AppStrings.confirmPassword,
              controller: _confirmPasswordController,
              icon: Icons.lock_reset_outlined,
              hint: 'Enter your password again',
              obscureText: _obscureConfirmPassword,
              enabled: !isLoading,
              suffix: IconButton(
                tooltip: _obscureConfirmPassword
                    ? 'Show password'
                    : 'Hide password',
                onPressed: () => setState(
                  () => _obscureConfirmPassword = !_obscureConfirmPassword,
                ),
                icon: Icon(
                  _obscureConfirmPassword
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  size: 19,
                  color: AppColors.textMuted,
                ),
              ),
              validator: (v) {
                if (v == null || v.isEmpty) return 'Confirm your password.';
                if (v != _passwordController.text) {
                  return 'Passwords do not match.';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            _buildTermsRow(isLoading),
            if (displayError != null) ...[
              const SizedBox(height: 10),
              Text(
                displayError,
                style: AppTypography.bodySmall(
                  color: AppColors.statusAlertText,
                ),
              ),
            ],
            const SizedBox(height: 22),
            AppButton(
              label: isLoading ? 'Creating account…' : 'Create Account',
              variant: AppButtonVariant.primaryRed,
              height: 46,
              borderRadius: 24,
              onPressed: isLoading ? null : _handleSignup,
            ),
          ],
        ),
      );
    });
  }

  Widget _buildField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    required String hint,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
    bool obscureText = false,
    bool enabled = true,
    Widget? suffix,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTypography.bodyBold().copyWith(fontSize: 13)),
        const SizedBox(height: 7),
        TextFormField(
          controller: controller,
          validator: validator,
          keyboardType: keyboardType,
          obscureText: obscureText,
          enabled: enabled,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: AppTypography.bodySmall(color: AppColors.textSubtle),
            prefixIcon: Icon(icon, size: 19, color: AppColors.textMuted),
            suffixIcon: suffix,
            filled: true,
            fillColor: AppColors.cardBackground,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            border: _border(),
            enabledBorder: _border(),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(28),
              borderSide: const BorderSide(
                color: AppColors.primaryRed,
                width: 1.4,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide:
                  const BorderSide(color: AppColors.statusAlertText),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: const BorderSide(
                color: AppColors.statusAlertText,
                width: 1.4,
              ),
            ),
          ),
        ),
      ],
    );
  }

  OutlineInputBorder _border() => OutlineInputBorder(
        borderRadius: BorderRadius.circular(28),
        borderSide: const BorderSide(color: AppColors.cardBorder),
      );

  Widget _buildTermsRow(bool isLoading) => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 24,
            height: 24,
            child: Checkbox(
              value: _agreedToTerms,
              activeColor: AppColors.primaryRed,
              onChanged: isLoading
                  ? null
                  : (v) => setState(() {
                        _agreedToTerms = v ?? false;
                        _localError = null;
                      }),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Text(
                'I agree to Tandem Standards Verification Terms of Service, Rigging Review Guidelines, and Safety Protocols.',
                style: AppTypography.bodySmall(),
              ),
            ),
          ),
        ],
      );
}

