import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TandemLogo extends StatelessWidget {
  final double height;
  final bool isDarkBadge;
  final VoidCallback? onTap;

  const TandemLogo({
    super.key,
    this.height = 36,
    this.isDarkBadge = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final logoWidget = Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: isDarkBadge ? const Color(0xFF1E1F25) : Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isDarkBadge
              ? const Color(0xFF33353F)
              : const Color(0xFFE5E7EB),
          width: 1.2,
        ),
        boxShadow: isDarkBadge
            ? null
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 4,
                  offset: const Offset(0, 1),
                ),
              ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Styled geometric glyph accent
          Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: Color(0xFFFF3838),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            'Tandem',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 19,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.6,
              color: isDarkBadge ? Colors.white : const Color(0xFF111827),
            ),
          ),
        ],
      ),
    );

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: logoWidget,
      );
    }

    return logoWidget;
  }
}
