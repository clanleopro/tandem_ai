import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class NavHeader extends StatelessWidget {
  final int activeIndex;
  final Function(int) onTabSelected;
  final VoidCallback onStartNewAudit;
  final VoidCallback onOpenStandardsVault;

  const NavHeader({
    super.key,
    required this.activeIndex,
    required this.onTabSelected,
    required this.onStartNewAudit,
    required this.onOpenStandardsVault,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 900;

    return Container(
      height: 72,
      padding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 32),
      decoration: BoxDecoration(
        color: AppTheme.surfaceDark.withValues(alpha: 0.95),
        border: const Border(
          bottom: BorderSide(color: AppTheme.cardBorder, width: 1),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.4),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Brand Logo
          InkWell(
            onTap: () => onTabSelected(0),
            borderRadius: BorderRadius.circular(8),
            child: Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    gradient: AppTheme.primaryGradient,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.cyanAccent.withValues(alpha: 0.3),
                        blurRadius: 12,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.architecture,
                      color: Colors.black,
                      size: 24,
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text(
                          'TANDEM',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.5,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            gradient: AppTheme.aiBadgeGradient,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            'AI',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      'RIGGING STANDARDS COMPLIANCE VERIFIER',
                      style: AppTheme.monoStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.cyanAccent,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(width: 32),

          // Desktop Navigation Tabs
          if (!isMobile) ...[
            _buildNavItem(
              index: 0,
              label: 'Overview & Projects',
              icon: Icons.dashboard_outlined,
            ),
            _buildNavItem(
              index: 1,
              label: 'Audit & Verify',
              icon: Icons.rule,
            ),
            _buildNavItem(
              index: 2,
              label: 'AI Auditor Console',
              icon: Icons.psychology_outlined,
            ),
            const Spacer(),

            // Standards Vault Action Button
            OutlinedButton.icon(
              onPressed: onOpenStandardsVault,
              icon: const Icon(Icons.menu_book_outlined, size: 16),
              label: const Text('Standards Vault'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppTheme.textSecondary,
                side: const BorderSide(color: AppTheme.cardBorder),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(width: 12),

            // Start New Project CTA
            ElevatedButton.icon(
              onPressed: onStartNewAudit,
              icon: const Icon(Icons.add, size: 18, color: Colors.black),
              label: const Text(
                'Start New Audit',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.cyanAccent,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 4,
                shadowColor: AppTheme.cyanAccent.withValues(alpha: 0.5),
              ),
            ),
          ] else ...[
            const Spacer(),
            IconButton(
              icon: const Icon(Icons.menu_book, color: AppTheme.textSecondary),
              tooltip: 'Standards Vault',
              onPressed: onOpenStandardsVault,
            ),
            IconButton(
              icon: const Icon(Icons.add_circle, color: AppTheme.cyanAccent),
              tooltip: 'Start Audit',
              onPressed: onStartNewAudit,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required String label,
    required IconData icon,
  }) {
    final isSelected = activeIndex == index;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: TextButton.icon(
        onPressed: () => onTabSelected(index),
        icon: Icon(
          icon,
          size: 17,
          color: isSelected ? AppTheme.cyanAccent : AppTheme.textSecondary,
        ),
        label: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : AppTheme.textSecondary,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            fontSize: 13,
          ),
        ),
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          backgroundColor: isSelected
              ? AppTheme.cyanAccent.withValues(alpha: 0.1)
              : Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(
              color: isSelected
                  ? AppTheme.cyanAccent.withValues(alpha: 0.3)
                  : Colors.transparent,
            ),
          ),
        ),
      ),
    );
  }
}
