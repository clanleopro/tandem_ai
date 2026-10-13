import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/constants/app_constants.dart';
import '../../core/routes/app_routes.dart';
import '../../core/theme/app_theme.dart';
import '../controllers/auth_controller.dart';

class AppHeader extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback? onStartNewAudit;

  const AppHeader({
    super.key,
    this.onStartNewAudit,
  });

  @override
  Size get preferredSize => const Size.fromHeight(72);

  void _handleStartNewAudit() {
    if (onStartNewAudit != null) {
      onStartNewAudit!();
    } else {
      Get.toNamed(AppRoutes.auditWizard);
    }
  }

  void _handleBrandClick() {
    if (Get.currentRoute != AppRoutes.home) {
      Get.offAllNamed(AppRoutes.home);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isCompact = screenWidth < 700;
    final isMobile = screenWidth < 500;

    return Container(
      height: 72,
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 14 : (isCompact ? 20 : 32),
      ),
      decoration: const BoxDecoration(
        color: AppTheme.surfaceDark,
        border: Border(
          bottom: BorderSide(color: AppTheme.cardBorder, width: 1),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // ─── LEFT: BRAND LOGO & TITLE ──────────────────────────────────────
          Flexible(
            child: InkWell(
              onTap: _handleBrandClick,
              borderRadius: BorderRadius.circular(AppTheme.radiusMd),
              hoverColor: Colors.transparent,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      gradient: AppTheme.logoGradient,
                      borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.accentRed.withValues(alpha: 0.35),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.architecture,
                        color: Colors.white,
                        size: 22,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Flexible(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              AppConstants.appName,
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 1.2,
                                color: AppTheme.textPrimary,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 5,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: AppTheme.accentRed,
                                borderRadius: BorderRadius.circular(3),
                              ),
                              child: const Text(
                                'AI',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white,
                                  letterSpacing: 0.8,
                                ),
                              ),
                            ),
                          ],
                        ),
                        if (!isMobile) ...[
                          const SizedBox(height: 2),
                          Text(
                            AppConstants.appSubtitle,
                            overflow: TextOverflow.ellipsis,
                            style: AppTheme.monoStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.textSecondary,
                              letterSpacing: 0.6,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(width: 12),

          // ─── RIGHT: ONLY 2 ACTIONS (START NEW AUDIT & LOGIN) ───────────────
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 1. LOGIN (Secondary Button)
              _buildLoginButton(context, isMobile),

              const SizedBox(width: 10),

              // 2. START NEW AUDIT (Primary Red Action)
              _buildStartAuditButton(isMobile),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLoginButton(BuildContext context, bool isMobile) {
    final auth = Get.find<AuthController>();

    return Obx(() {
      final isLoggedIn = auth.isLoggedIn.value;

      if (isLoggedIn) {
        return OutlinedButton.icon(
          onPressed: () => auth.showLoginModal(context),
          icon: const Icon(
            Icons.verified,
            size: 15,
            color: AppTheme.greenCompliant,
          ),
          label: Text(
            isMobile ? 'PE' : (auth.engineerName.value.isNotEmpty ? auth.engineerName.value.split(' ').first : 'Eng.'),
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
            ),
          ),
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: AppTheme.greenCompliant),
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 10 : 14,
              vertical: 12,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppTheme.radiusMd),
            ),
          ),
        );
      }

      if (isMobile) {
        return OutlinedButton(
          onPressed: () => auth.showLoginModal(context),
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: AppTheme.cardBorder),
            foregroundColor: AppTheme.textPrimary,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppTheme.radiusMd),
            ),
          ),
          child: const Text('Login', style: TextStyle(fontSize: 12)),
        );
      }

      return OutlinedButton.icon(
        onPressed: () => auth.showLoginModal(context),
        icon: const Icon(
          Icons.person_outline,
          size: 16,
          color: AppTheme.textSecondary,
        ),
        label: const Text(
          AppConstants.ctaLogin,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppTheme.textPrimary,
          ),
        ),
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: AppTheme.cardBorder),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTheme.radiusMd),
          ),
        ),
      );
    });
  }

  Widget _buildStartAuditButton(bool isMobile) {
    return ElevatedButton.icon(
      onPressed: _handleStartNewAudit,
      icon: const Icon(Icons.add_rounded, size: 17, color: Colors.white),
      label: Text(
        isMobile ? 'New Audit' : AppConstants.ctaStartAudit,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: Colors.white,
          letterSpacing: 0.3,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppTheme.accentRed,
        foregroundColor: Colors.white,
        elevation: 0,
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 12 : 18,
          vertical: 12,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        ),
      ),
    );
  }
}
