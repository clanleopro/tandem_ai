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

class SignupPage extends StatefulWidget {
  final AuthController? authCtrl;

  const SignupPage({super.key, this.authCtrl});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  final _companyController = TextEditingController();
  final _emailController = TextEditingController();
  final _registrationIdController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _agreedToTerms = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  String? _errorMessage;

  AuthController get _authController =>
      widget.authCtrl ??
      (Get.isRegistered<AuthController>()
          ? Get.find<AuthController>()
          : Get.put(AuthController()));

  @override
  void dispose() {
    _companyController.dispose();
    _emailController.dispose();
    _registrationIdController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleSignup() {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;
    if (!_agreedToTerms) {
      setState(
        () => _errorMessage =
            'Please accept the verification terms and safety guidelines.',
      );
      return;
    }
    setState(() => _errorMessage = null);
    _authController.signup(
      company: _companyController.text.trim(),
      email: _emailController.text.trim(),
    );
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
                    child: _buildFormScrollView(compact: false),
                  ),
                ),
              ],
            );
          }
          return _buildFormScrollView(compact: true);
        },
      ),
    );
  }

  Widget _buildFormScrollView({required bool compact}) {
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
            child: Form(
              key: _formKey,
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
                    'Create a company account to manage your team\'s access.',
                    style: AppTypography.bodySmall(),
                  ),
                  const SizedBox(height: 26),
                  _buildField(
                    label: AppStrings.companyLegalName,
                    controller: _companyController,
                    icon: Icons.business_outlined,
                    hint: 'e.g. Apex Crane & Heavy Transport LLC',
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
                  ),
                  const SizedBox(height: 16),
                  _buildField(
                    label: AppStrings.password,
                    controller: _passwordController,
                    icon: Icons.lock_outline,
                    hint: 'Create a password',
                    obscureText: _obscurePassword,
                    suffix: IconButton(
                      tooltip: _obscurePassword
                          ? 'Show password'
                          : 'Hide password',
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
                    suffix: IconButton(
                      tooltip: _obscureConfirmPassword
                          ? 'Show password'
                          : 'Hide password',
                      onPressed: () => setState(
                        () =>
                            _obscureConfirmPassword = !_obscureConfirmPassword,
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
                      if (v == null || v.isEmpty) {
                        return 'Confirm your password.';
                      }
                      if (v != _passwordController.text) {
                        return 'Passwords do not match.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildTermsRow(),
                  if (_errorMessage != null) ...[
                    const SizedBox(height: 10),
                    Text(
                      _errorMessage!,
                      style: AppTypography.bodySmall(
                        color: AppColors.statusAlertText,
                      ),
                    ),
                  ],
                  const SizedBox(height: 22),
                  AppButton(
                    label: 'Create Account',
                    variant: AppButtonVariant.primaryRed,
                    height: 46,
                    borderRadius: 24,
                    onPressed: _handleSignup,
                  ),
                  const SizedBox(height: 14),
                  Center(
                    child: TextButton(
                      onPressed: () => Get.toNamed(AppRoutes.login),
                      child: Text(
                        AppStrings.alreadyHaveAccount,
                        style: AppTypography.bodyBold(
                          color: AppColors.primaryRed,
                        ).copyWith(fontSize: 13),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    required String hint,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
    bool obscureText = false,
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
            border: _fieldBorder(),
            enabledBorder: _fieldBorder(),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(28),
              borderSide: const BorderSide(
                color: AppColors.primaryRed,
                width: 1.4,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: const BorderSide(color: AppColors.statusAlertText),
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

  OutlineInputBorder _fieldBorder() => OutlineInputBorder(
    borderRadius: BorderRadius.circular(28),
    borderSide: const BorderSide(color: AppColors.cardBorder),
  );

  Widget _buildTermsRow() => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SizedBox(
        width: 24,
        height: 24,
        child: Checkbox(
          value: _agreedToTerms,
          activeColor: AppColors.primaryRed,
          onChanged: (v) => setState(() {
            _agreedToTerms = v ?? false;
            _errorMessage = null;
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
