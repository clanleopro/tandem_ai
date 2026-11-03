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

class LoginPage extends StatefulWidget {
  final AuthController? authCtrl;

  const LoginPage({super.key, this.authCtrl});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _agreedToTerms = false;
  bool _obscurePassword = true;
  String? _errorMessage;

  AuthController get _authController =>
      widget.authCtrl ??
      (Get.isRegistered<AuthController>()
          ? Get.find<AuthController>()
          : Get.put(AuthController()));

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;
    if (!_agreedToTerms) {
      setState(
        () => _errorMessage = 'Please accept the Terms of Use to continue.',
      );
      return;
    }
    setState(() => _errorMessage = null);
    _authController.login(
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );
  }

  void _handleGoogleLogin() {
    _authController.login(
      email: 'demo.user@example.com',
      company: 'Tandem Demo',
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
                  AppStrings.loginOrSignup,
                  style: AppTypography.heading1().copyWith(fontSize: 24),
                ),
                const SizedBox(height: 5),
                Text(
                  AppStrings.loginSubtitle,
                  style: AppTypography.bodySmall(),
                ),
                const SizedBox(height: 26),
                OutlinedButton(
                  onPressed: _handleGoogleLogin,
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(46),
                    backgroundColor: AppColors.cardBackground,
                    foregroundColor: AppColors.textPrimary,
                    side: const BorderSide(color: AppColors.cardBorder),
                    shape: const StadiumBorder(),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'G',
                        style: AppTypography.bodyBold(
                          color: const Color(0xFF4285F4),
                        ).copyWith(fontSize: 19),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        AppStrings.continueWithGoogle,
                        style: AppTypography.bodyBold(),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                OutlinedButton(
                  onPressed: () => Get.toNamed(AppRoutes.companyAuth),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(46),
                    backgroundColor: AppColors.cardBackground,
                    foregroundColor: AppColors.textPrimary,
                    side: const BorderSide(color: AppColors.cardBorder),
                    shape: const StadiumBorder(),
                  ),
                  child: Text(
                    AppStrings.createCompanyAccount,
                    style: AppTypography.bodyBold(),
                  ),
                ),
                const SizedBox(height: 22),
                _buildDivider(),
                const SizedBox(height: 22),
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        AppStrings.userIdWorkEmail,
                        style: AppTypography.bodyBold(),
                      ),
                      const SizedBox(height: 7),
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        validator: (value) {
                          final email = value?.trim() ?? '';
                          if (email.isEmpty) {
                            return 'Enter your user ID or work email.';
                          }
                          if (email.contains('@') &&
                              !RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$')
                                  .hasMatch(email)) {
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
                      Text(
                        AppStrings.password,
                        style: AppTypography.bodyBold(),
                      ),
                      const SizedBox(height: 7),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        textInputAction: TextInputAction.done,
                        onFieldSubmitted: (_) => _handleLogin(),
                        validator: (value) => (value == null || value.isEmpty)
                            ? 'Enter your password.'
                            : null,
                        decoration: _inputDecoration(
                          hint: 'Enter your password',
                          icon: Icons.lock_outline,
                          suffix: IconButton(
                            tooltip: _obscurePassword
                                ? 'Show password'
                                : 'Hide password',
                            onPressed: () => setState(
                              () => _obscurePassword = !_obscurePassword,
                            ),
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
                      const SizedBox(height: 14),
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
                        label: AppStrings.continueLabel,
                        variant: AppButtonVariant.primaryRed,
                        height: 46,
                        borderRadius: 24,
                        onPressed: _handleLogin,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Row(
      children: [
        const Expanded(child: Divider(color: AppColors.cardBorder)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            AppStrings.orClientAccess,
            style: AppTypography.bodySmall(),
          ),
        ),
        const Expanded(child: Divider(color: AppColors.cardBorder)),
      ],
    );
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
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: _fieldBorder(),
      enabledBorder: _fieldBorder(),
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
        borderSide: BorderSide(color: AppColors.statusAlertText, width: 1.4),
      ),
    );
  }

  OutlineInputBorder _fieldBorder() => OutlineInputBorder(
    borderRadius: BorderRadius.circular(28),
    borderSide: const BorderSide(color: AppColors.cardBorder),
  );

  Widget _buildTermsRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 24,
          height: 24,
          child: Checkbox(
            value: _agreedToTerms,
            activeColor: AppColors.primaryRed,
            onChanged: (value) => setState(() {
              _agreedToTerms = value ?? false;
              _errorMessage = null;
            }),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Text(
              'I agree to Tandem Standards Verification Terms of Service and Safety Disclaimer.',
              style: AppTypography.bodySmall(),
            ),
          ),
        ),
      ],
    );
  }
}
