import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/routes/app_routes.dart';
import '../controllers/auth_controller.dart';


class AuthDialog extends StatefulWidget {
  const AuthDialog({super.key});

  @override
  State<AuthDialog> createState() => _AuthDialogState();
}

class _AuthDialogState extends State<AuthDialog> {
  static const Color _background = Color(0xFF111111);
  static const Color _surface = Color(0xFF191919);
  static const Color _border = Color(0xFF333333);
  static const Color _accent = Color(0xFFE3262E);
  static const Color _primaryText = Color(0xFFF5F5F5);
  static const Color _secondaryText = Color(0xFFA6A6A6);

  final TextEditingController _accessKeyController = TextEditingController();
  final AuthController _auth = Get.find<AuthController>();

  bool _obscureAccessKey = true;

  @override
  void dispose() {
    _accessKeyController.dispose();
    super.dispose();
  }

  Future<void> _handleGoogleDemoLogin() async {
    final success = await _auth.prepareGoogleDemoLogin();

    if (!mounted || !success) return;

    final name = _auth.pendingGoogleName.value;
    final email = _auth.pendingGoogleEmail.value;

    Navigator.of(context).pop();

    Get.to<void>(
      () => SubscriptionPlansPage(
        userName: name,
        userEmail: email,
        onCreateAccount: (plan, cycle) {
          _auth.completeGoogleDemoSignup(
            planName: plan.name,
            billingCycle: cycle == BillingCycle.monthly ? 'Monthly' : 'Yearly',
          );

          Get.offAllNamed(AppRoutes.home);
        },
      ),
    );
  }

  Future<void> _handleClientKeyLogin() async {
    final success = await _auth.loginWithDemoClientKey(
      _accessKeyController.text,
    );

    if (!mounted || !success) return;

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: _background,
      insetPadding: const EdgeInsets.all(20),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: const BorderSide(color: _border),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 460, maxHeight: 720),
        child: Obx(() {
          final loggedIn = _auth.isLoggedIn.value;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: loggedIn ? _buildProfile() : _buildSignIn(),
          );
        }),
      ),
    );
  }

  Widget _buildSignIn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildDialogHeader(),
        const SizedBox(height: 26),
        const Text(
          'Welcome to Tandem AI',
          style: TextStyle(
            color: _primaryText,
            fontSize: 23,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Sign in to continue to your rigging workspace.',
          style: TextStyle(
            color: _secondaryText,
            fontSize: 13,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 22),
        _buildGoogleButton(),
        const SizedBox(height: 20),
        Row(
          children: const [
            Expanded(child: Divider(color: _border)),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                'OR CLIENT ACCESS',
                style: TextStyle(
                  color: _secondaryText,
                  fontSize: 10,
                  letterSpacing: 1,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Expanded(child: Divider(color: _border)),
          ],
        ),
        const SizedBox(height: 18),
        const Text(
          'Access key',
          style: TextStyle(
            color: _primaryText,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _accessKeyController,
          obscureText: _obscureAccessKey,
          style: const TextStyle(color: _primaryText, fontSize: 14),
          decoration: InputDecoration(
            hintText: 'Enter your client access key',
            hintStyle: const TextStyle(color: _secondaryText, fontSize: 13),
            filled: true,
            fillColor: _surface,
            prefixIcon: const Icon(
              Icons.key_outlined,
              color: _secondaryText,
              size: 19,
            ),
            suffixIcon: IconButton(
              tooltip: _obscureAccessKey ? 'Show key' : 'Hide key',
              onPressed: () {
                setState(() => _obscureAccessKey = !_obscureAccessKey);
              },
              icon: Icon(
                _obscureAccessKey
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                color: _secondaryText,
                size: 19,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: _border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: _accent),
            ),
          ),
          onSubmitted: (_) => _handleClientKeyLogin(),
        ),
        const SizedBox(height: 8),
        const Text(
          'Demo key: TANDEM-DEMO-2026',
          style: TextStyle(color: _secondaryText, fontSize: 11),
        ),
        Obx(() {
          final error = _auth.authError.value;
          if (error.isEmpty) return const SizedBox.shrink();

          return Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Text(
              error,
              style: const TextStyle(color: Color(0xFFFF777C), fontSize: 12),
            ),
          );
        }),
        const SizedBox(height: 18),
        Obx(() {
          final loading = _auth.isLoading.value;

          return SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: loading ? null : _handleClientKeyLogin,
              style: ElevatedButton.styleFrom(
                backgroundColor: _accent,
                disabledBackgroundColor: _border,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 0,
              ),
              child: loading
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Text(
                      'Continue with access key',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
            ),
          );
        }),
        const SizedBox(height: 14),
        const Text(
          'Demo mode: Google sign-in and access-key validation are simulated.',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: _secondaryText,
            fontSize: 10,
            height: 1.4,
          ),
        ),
      ],
    );
  }

  Widget _buildGoogleButton() {
    return Obx(() {
      final loading = _auth.isLoading.value;

      return SizedBox(
        width: double.infinity,
        child: OutlinedButton(
          onPressed: loading ? null : _handleGoogleDemoLogin,
          style: OutlinedButton.styleFrom(
            foregroundColor: _primaryText,
            side: const BorderSide(color: _border),
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: loading
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: _primaryText,
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 22,
                      height: 22,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: const Text(
                        'G',
                        style: TextStyle(
                          color: Color(0xFF4285F4),
                          fontWeight: FontWeight.w800,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      'Continue with Google',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
        ),
      );
    });
  }

  Widget _buildProfile() {
    final name = _auth.engineerName.value;
    final email = _auth.engineerEmail.value;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildDialogHeader(),
        const SizedBox(height: 24),
        CircleAvatar(
          radius: 32,
          backgroundColor: _accent.withValues(alpha: 0.15),
          child: const Icon(Icons.person_outline, color: _accent, size: 32),
        ),
        const SizedBox(height: 14),
        Text(
          name.isEmpty ? 'Signed in' : name,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: _primaryText,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          email,
          textAlign: TextAlign.center,
          style: const TextStyle(color: _secondaryText, fontSize: 13),
        ),
        if (_auth.selectedPlanName.value.isNotEmpty) ...[
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
            decoration: BoxDecoration(
              color: _surface,
              borderRadius: BorderRadius.circular(9),
              border: const Border.fromBorderSide(BorderSide(color: _border)),
            ),
            child: Text(
              'Demo plan: ${_auth.selectedPlanName.value} · '
              '${_auth.selectedBillingCycle.value}',
              style: const TextStyle(color: _primaryText, fontSize: 12),
            ),
          ),
        ],
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: Get.back,
            style: ElevatedButton.styleFrom(
              backgroundColor: _accent,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 0,
            ),
            child: const Text('Continue', style: TextStyle(fontWeight: FontWeight.w700)),
          ),
        ),
        const SizedBox(height: 10),
        TextButton(
          onPressed: () {
            _auth.logout();
          },
          child: const Text(
            'Sign out',
            style: TextStyle(color: _secondaryText),
          ),
        ),
      ],
    );
  }

  Widget _buildDialogHeader() {
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: _accent,
            borderRadius: BorderRadius.circular(9),
          ),
          child: const Icon(
            Icons.architecture,
            color: Colors.white,
            size: 20,
          ),
        ),
        const SizedBox(width: 10),
        const Text(
          'TANDEM AI',
          style: TextStyle(
            color: _primaryText,
            fontSize: 13,
            fontWeight: FontWeight.w800,
            letterSpacing: 1,
          ),
        ),
        const Spacer(),
        IconButton(
          tooltip: 'Close',
          onPressed: Get.back,
          icon: const Icon(Icons.close, color: _secondaryText, size: 20),
        ),
      ],
    );
  }
}


enum BillingCycle { monthly, yearly }

class SubscriptionPlan {
  const SubscriptionPlan({
    required this.name,
    required this.description,
    required this.monthlyPrice,
    required this.yearlyPrice,
    required this.features,
    this.isPopular = false,
  });

  final String name;
  final String description;
  final int monthlyPrice;
  final int yearlyPrice;
  final List<String> features;
  final bool isPopular;

  int priceFor(BillingCycle cycle) {
    return cycle == BillingCycle.monthly ? monthlyPrice : yearlyPrice;
  }
}

class SubscriptionPlansPage extends StatefulWidget {
  const SubscriptionPlansPage({
    super.key,
    required this.onCreateAccount,
    this.userName = 'Alex Morgan',
    this.userEmail = 'alex@example.com',
  });

  final FutureOr<void> Function(
    SubscriptionPlan plan,
    BillingCycle cycle,
  ) onCreateAccount;

  final String userName;
  final String userEmail;

  @override
  State<SubscriptionPlansPage> createState() => _SubscriptionPlansPageState();
}

class _SubscriptionPlansPageState extends State<SubscriptionPlansPage> {
  static const Color _background = Color(0xFF090909);
  static const Color _surface = Color(0xFF141414);
  static const Color _raisedSurface = Color(0xFF1D1D1D);
  static const Color _border = Color(0xFF303030);
  static const Color _accent = Color(0xFFE3262E);
  static const Color _primaryText = Color(0xFFF5F5F5);
  static const Color _secondaryText = Color(0xFFA6A6A6);

  static const List<SubscriptionPlan> _plans = [
    SubscriptionPlan(
      name: 'Essential',
      description: 'For independent rigging professionals.',
      monthlyPrice: 29,
      yearlyPrice: 290,
      features: [
        '5 audits per month',
        'Core rigging standards',
        'PDF audit reports',
        'Project history',
      ],
    ),
    SubscriptionPlan(
      name: 'Professional',
      description: 'For teams managing active lift projects.',
      monthlyPrice: 79,
      yearlyPrice: 790,
      isPopular: true,
      features: [
        'Unlimited audits',
        'Full standards library',
        'AI auditor console',
        'Team project workspace',
        'Priority support',
      ],
    ),
    SubscriptionPlan(
      name: 'Enterprise',
      description: 'For organizations with multiple teams.',
      monthlyPrice: 199,
      yearlyPrice: 1990,
      features: [
        'Everything in Professional',
        'Multiple team workspaces',
        'Organization controls',
        'Advanced reporting',
        'Dedicated support',
      ],
    ),
  ];

  BillingCycle _cycle = BillingCycle.monthly;
  int? _selectedPlanIndex;
  bool _isCreatingAccount = false;

  Future<void> _createAccount() async {
    final index = _selectedPlanIndex;
    if (index == null || _isCreatingAccount) return;

    setState(() => _isCreatingAccount = true);

    try {
      await widget.onCreateAccount(_plans[index], _cycle);
    } finally {
      if (mounted) setState(() => _isCreatingAccount = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isNarrow = MediaQuery.sizeOf(context).width < 760;

    return Scaffold(
      backgroundColor: _background,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1180),
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(
                isNarrow ? 18 : 32,
                24,
                isNarrow ? 18 : 32,
                32,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTopBar(),
                  const SizedBox(height: 42),
                  Center(
                    child: Column(
                      children: [
                        _buildEyebrow(),
                        const SizedBox(height: 18),
                        Text(
                          'Choose a plan for your work',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: _primaryText,
                            fontSize: isNarrow ? 30 : 42,
                            height: 1.1,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -1,
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Select a demo plan to finish setting up your account.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: _secondaryText,
                            fontSize: 15,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 24),
                        _buildBillingToggle(),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      if (constraints.maxWidth < 760) {
                        return Column(
                          children: List.generate(
                            _plans.length,
                            (index) => Padding(
                              padding: const EdgeInsets.only(bottom: 14),
                              child: _buildPlanCard(index),
                            ),
                          ),
                        );
                      }

                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: List.generate(
                          _plans.length,
                          (index) => Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(
                                right: index == _plans.length - 1 ? 0 : 14,
                              ),
                              child: _buildPlanCard(index),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                  _buildCreateAccountButton(),
                  const SizedBox(height: 14),
                  const Center(
                    child: Text(
                      'Demo only · No payment will be collected',
                      style: TextStyle(color: _secondaryText, fontSize: 12),
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

  Widget _buildTopBar() {
    return Row(
      children: [
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: _accent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(Icons.architecture, color: Colors.white, size: 21),
        ),
        const SizedBox(width: 11),
        const Text(
          'TANDEM AI',
          style: TextStyle(
            color: _primaryText,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.1,
          ),
        ),
        const Spacer(),
        if (MediaQuery.sizeOf(context).width > 480)
          Flexible(
            child: Text(
              'Account for ${widget.userEmail}',
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.right,
              style: const TextStyle(color: _secondaryText, fontSize: 12),
            ),
          ),
      ],
    );
  }

  Widget _buildEyebrow() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
      decoration: BoxDecoration(
        color: _accent.withValues(alpha: 0.10),
        border: Border.all(color: _accent.withValues(alpha: 0.35)),
        borderRadius: BorderRadius.circular(30),
      ),
      child: const Text(
        'PLANS FOR RIGGING PROFESSIONALS',
        style: TextStyle(
          color: Color(0xFFFF777C),
          fontSize: 10,
          fontWeight: FontWeight.w700,
          letterSpacing: 1,
        ),
      ),
    );
  }

  Widget _buildBillingToggle() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: _surface,
        border: Border.all(color: _border),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _billingOption('Monthly', BillingCycle.monthly),
          _billingOption('Yearly · Save 17%', BillingCycle.yearly),
        ],
      ),
    );
  }

  Widget _billingOption(String label, BillingCycle cycle) {
    final selected = _cycle == cycle;

    return InkWell(
      borderRadius: BorderRadius.circular(9),
      onTap: () => setState(() => _cycle = cycle),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? _raisedSurface : Colors.transparent,
          borderRadius: BorderRadius.circular(9),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? _primaryText : _secondaryText,
            fontSize: 12,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildPlanCard(int index) {
    final plan = _plans[index];
    final selected = _selectedPlanIndex == index;

    return InkWell(
      onTap: () => setState(() => _selectedPlanIndex = index),
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFF1A1112) : _surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected || plan.isPopular ? _accent : _border,
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    plan.name,
                    style: const TextStyle(
                      color: _primaryText,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                if (plan.isPopular)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: _accent,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'POPULAR',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.5,
                      ),
                    ),
                  )
                else
                  Icon(
                    selected
                        ? Icons.check_circle
                        : Icons.radio_button_unchecked,
                    color: selected ? _accent : _secondaryText,
                    size: 20,
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              plan.description,
              style: const TextStyle(
                color: _secondaryText,
                fontSize: 12,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 22),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '\$${plan.priceFor(_cycle)}',
                  style: const TextStyle(
                    color: _primaryText,
                    fontSize: 34,
                    height: 1,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -1,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 5, bottom: 3),
                  child: Text(
                    _cycle == BillingCycle.monthly ? '/ month' : '/ year',
                    style: const TextStyle(
                      color: _secondaryText,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            if (_cycle == BillingCycle.yearly) ...[
              const SizedBox(height: 7),
              Text(
                'Equivalent to \$${(plan.yearlyPrice / 12).round()} / month',
                style: const TextStyle(color: _secondaryText, fontSize: 11),
              ),
            ],
            const SizedBox(height: 20),
            const Divider(color: _border, height: 1),
            const SizedBox(height: 16),
            ...plan.features.map(
              (feature) => Padding(
                padding: const EdgeInsets.only(bottom: 11),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.check_rounded,
                      color: Color(0xFFFF777C),
                      size: 17,
                    ),
                    const SizedBox(width: 9),
                    Expanded(
                      child: Text(
                        feature,
                        style: const TextStyle(
                          color: _primaryText,
                          fontSize: 12,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCreateAccountButton() {
    final index = _selectedPlanIndex;
    final canContinue = index != null && !_isCreatingAccount;

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: canContinue ? _createAccount : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: _accent,
          disabledBackgroundColor: _raisedSurface,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 17),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(11),
          ),
          elevation: 0,
        ),
        child: _isCreatingAccount
            ? const SizedBox(
                width: 19,
                height: 19,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : Text(
                index == null
                    ? 'Select a plan to continue'
                    : 'Create account with ${_plans[index].name}',
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
      ),
    );
  }
}