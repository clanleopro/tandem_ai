import 'dart:math' as math;

import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_theme.dart';

class HeroSection extends StatelessWidget {
  final VoidCallback onStartAudit;

  const HeroSection({super.key, required this.onStartAudit});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= 900;
    final isMobile = screenWidth < 600;
    final isCompact = screenWidth < 850;

    return CustomPaint(
      painter: LiftPlanBackgroundPainter(
        accent: AppTheme.accentRed,
        grid: AppTheme.textMuted,
        compact: isCompact,
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: isMobile ? 32 : (isDesktop ? 60 : 44),
          horizontal: isMobile ? 12 : 24,
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 980),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Small label and status
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
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
                              color: AppTheme.accentRed.withValues(alpha: 0.5),
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

                // Main heading
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 920),
                  child: Text(
                    isMobile
                        ? AppConstants.heroHeadingMobile
                        : AppConstants.heroHeading,
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

                // Description
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

                // Primary action
                ElevatedButton.icon(
                  onPressed: onStartAudit,
                  icon: const Icon(
                    Icons.add_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                  label: Text(
                    AppConstants.ctaStartAudit,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: isMobile ? 14 : 15,
                      letterSpacing: 0.3,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.accentRed,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: EdgeInsets.symmetric(
                      horizontal: isMobile ? 20 : 32,
                      vertical: isMobile ? 15 : 18,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                    ),
                    shadowColor: Colors.transparent,
                  ),
                ),

                const SizedBox(height: 36),

                // Standards coverage
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 10,
                  runSpacing: 8,
                  children: const [
                    _StandardBadge(
                      label: 'ASME B30.9',
                      scope: 'Slings & Hardware',
                    ),
                    _StandardBadge(
                      label: 'OSHA 1926.1400',
                      scope: 'Cranes & Derricks',
                    ),
                    _StandardBadge(
                      label: 'LOLER 1998',
                      scope: 'Lifting Operations',
                    ),
                    _StandardBadge(
                      label: 'EN 13414-1',
                      scope: 'Steel Wire Slings',
                    ),
                    _StandardBadge(
                      label: 'CROSBY G-2130',
                      scope: 'D/d Curvature Limits',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
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

class LiftPlanBackgroundPainter extends CustomPainter {
  const LiftPlanBackgroundPainter({
    required this.accent,
    required this.grid,
    required this.compact,
  });

  final Color accent;
  final Color grid;
  final bool compact;

  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty) return;

    // Fine grid, kept low contrast so the content remains easy to read.
    final gridPaint = Paint()
      ..color = grid.withValues(alpha: compact ? 0.08 : 0.14)
      ..strokeWidth = 0.6;

    for (double x = 0; x <= size.width; x += 48) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }

    for (double y = 0; y <= size.height; y += 48) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    // Scale the lift illustration to fit the available hero area.
    final widthScale = size.width * 0.42 / 360;
    final heightScale = size.height * 0.86 / 400;
    final scale = math
        .min(widthScale, heightScale)
        .clamp(0.28, 1.30)
        .toDouble();

    final drawingWidth = 360 * scale;
    final drawingHeight = 400 * scale;

    canvas.save();
    canvas.translate(
      size.width - drawingWidth - (compact ? -8 : 20),
      (size.height - drawingHeight) / 2,
    );
    canvas.scale(scale);

    final structurePaint = Paint()
      ..color = const Color.fromARGB(255, 166, 43, 34)
      ..strokeWidth = 1.2
      ..style = PaintingStyle.stroke;

    final accentPaint = Paint()
      ..color = accent.withValues(alpha: compact ? 0.035 : 0.10)
      ..strokeWidth = 1.4
      ..style = PaintingStyle.stroke;

    final guidePaint = Paint()
      ..color = accent.withValues(alpha: compact ? 0.02 : 0.055)
      ..strokeWidth = 0.8
      ..style = PaintingStyle.stroke;

    // Crane base and supports.
    canvas.drawLine(
      const Offset(54, 340),
      const Offset(252, 340),
      structurePaint,
    );
    canvas.drawLine(
      const Offset(76, 354),
      const Offset(230, 354),
      structurePaint,
    );
    canvas.drawLine(
      const Offset(154, 244),
      const Offset(154, 340),
      structurePaint,
    );
    canvas.drawLine(
      const Offset(112, 340),
      const Offset(154, 300),
      structurePaint,
    );
    canvas.drawLine(
      const Offset(196, 340),
      const Offset(154, 300),
      structurePaint,
    );

    // Crane boom and suspended cable.
    canvas.drawLine(const Offset(144, 252), const Offset(340, 62), accentPaint);
    canvas.drawLine(
      const Offset(153, 260),
      const Offset(349, 70),
      structurePaint,
    );
    canvas.drawLine(const Offset(340, 62), const Offset(340, 262), guidePaint);

    // Hook and load block.
    canvas.drawCircle(const Offset(340, 264), 3, accentPaint);
    canvas.drawLine(
      const Offset(340, 267),
      const Offset(340, 282),
      accentPaint,
    );
    canvas.drawArc(
      const Rect.fromLTWH(332, 278, 16, 16),
      0,
      3.14,
      false,
      accentPaint,
    );
    canvas.drawRect(const Rect.fromLTWH(329, 300, 22, 20), structurePaint);

    // Boom tip marker.
    canvas.drawCircle(const Offset(340, 62), 3, accentPaint);

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant LiftPlanBackgroundPainter oldDelegate) {
    return oldDelegate.accent != accent ||
        oldDelegate.grid != grid ||
        oldDelegate.compact != compact;
  }
}
