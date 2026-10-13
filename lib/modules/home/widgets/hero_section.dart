import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_theme.dart';

class HeroSection extends StatelessWidget {
  final VoidCallback onStartAudit;

  const HeroSection({
    super.key,
    required this.onStartAudit,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= 900;
    final isMobile = screenWidth < 600;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        vertical: isMobile ? 32 : (isDesktop ? 60 : 44),
        horizontal: isMobile ? 12 : 24,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // ─── 1. SMALL LABEL / MONO TAG ─────────────────────────────────────
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: AppTheme.tagDecoration(AppTheme.accentRed),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppTheme.accentRed,
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.accentRed.withValues(alpha: 0.6),
                        blurRadius: 6,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  AppConstants.heroTag,
                  style: AppTheme.monoStyle(
                    fontSize: isMobile ? 9.5 : 11,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.accentRed,
                    letterSpacing: 1.0,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // ─── 2. MAIN HEADING ───────────────────────────────────────────────
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 920),
            child: Text(
              isMobile ? AppConstants.heroHeadingMobile : AppConstants.heroHeading,
              textAlign: TextAlign.center,
              style: AppTheme.displayStyle(
                fontSize: isMobile ? 26 : (isDesktop ? 44 : 34),
                fontWeight: FontWeight.w800,
                color: AppTheme.textPrimary,
                letterSpacing: -0.6,
              ),
            ),
          ),

          const SizedBox(height: 18),

          // ─── 3. EXACT DESCRIPTION ──────────────────────────────────────────
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 780),
            child: Text(
              AppConstants.heroDescription,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: isMobile ? 14 : 16,
                fontWeight: FontWeight.w400,
                color: AppTheme.textSecondary,
                height: 1.6,
              ),
            ),
          ),

          const SizedBox(height: 32),

          // ─── 4. SINGLE PROMINENT PRIMARY CTA ──────────────────────────────
          ElevatedButton.icon(
            onPressed: onStartAudit,
            icon: const Icon(
              Icons.add_rounded,
              color: Colors.white,
              size: 20,
            ),
            label: const Text(
              AppConstants.ctaStartAudit,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 15,
                letterSpacing: 0.3,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.accentRed,
              foregroundColor: Colors.white,
              elevation: 0,
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 24 : 32,
                vertical: isMobile ? 16 : 18,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppTheme.radiusMd),
              ),
              shadowColor: Colors.transparent,
            ),
          ),

          const SizedBox(height: 36),

          // ─── 5. STANDARDS COVERAGE CHIPS ──────────────────────────────────
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 10,
            runSpacing: 8,
            children: const [
              _StandardBadge(label: 'ASME B30.9', scope: 'Slings & Hardware'),
              _StandardBadge(label: 'OSHA 1926.1400', scope: 'Cranes & Derricks'),
              _StandardBadge(label: 'LOLER 1998', scope: 'Lifting Operations'),
              _StandardBadge(label: 'EN 13414-1', scope: 'Steel Wire Slings'),
              _StandardBadge(label: 'CROSBY G-2130', scope: 'D/d Curvature Limits'),
            ],
          ),
        ],
      ),
    );
  }
}

class _StandardBadge extends StatelessWidget {
  final String label;
  final String scope;

  const _StandardBadge({required this.label, required this.scope});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: AppTheme.cardDark,
        borderRadius: BorderRadius.circular(AppTheme.radiusSm),
        border: Border.all(color: AppTheme.cardBorder),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: AppTheme.monoStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            scope,
            style: const TextStyle(fontSize: 10, color: AppTheme.textMuted),
          ),
        ],
      ),
    );
  }
}
