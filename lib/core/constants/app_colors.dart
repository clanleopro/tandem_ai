import 'package:flutter/material.dart';

/// Centralized color palette for the Tandem application.
/// All existing hex values are strictly preserved.
class AppColors {
  AppColors._();

  // Primary brand colors
  static const Color primaryRed = Color(0xFFFF3838);
  static const Color primaryRedHover = Color(0xFFE52E2E);
  static const Color primaryRedLight = Color(0xFFFFECEB);

  // Sidebar / Dark surfaces
  static const Color sidebarBackground = Color(0xFF131418);
  static const Color sidebarCard = Color(0xFF1B1C22);
  static const Color sidebarHover = Color(0xFF22242B);
  static const Color sidebarBorder = Color(0xFF2D2F37);
  static const Color sidebarTextMuted = Color(0xFF9CA3AF);
  static const Color sidebarTextActive = Color(0xFFFFFFFF);

  // Workspace / Main area
  static const Color workspaceBackground = Color(0xFFF4F5F7);
  static const Color cardBackground = Color(0xFFFFFFFF);
  static const Color cardBorder = Color(0xFFE5E7EB);
  static const Color cardBorderLight = Color(0xFFEEF0F3);

  // Stepper & Neutral pills
  static const Color stepperBackground = Color(0xFFEBECEF);
  static const Color stepperPillActive = Color(0xFFFFFFFF);
  static const Color stepperTextInactive = Color(0xFF6B7280);

  // Document upload & state cards
  static const Color docCardSelectedBg = Color(0xFFF3FAF5);
  static const Color docCardSelectedBorder = Color(0xFF86EFAC);
  static const Color docCardUnselectedBg = Color(0xFFFFFFFF);
  static const Color docCardUnselectedBorder = Color(0xFFD1D5DB);

  // Functional badges & states
  static const Color successGreen = Color(0xFF10B981);
  static const Color successGreenDark = Color(0xFF047857);
  static const Color replaceBlueBg = Color(0xFFEFF6FF);
  static const Color replaceBlueBorder = Color(0xFFBFDBFE);
  static const Color replaceBlueText = Color(0xFF2563EB);

  static const Color darkAction = Color(0xFF1F2024);
  static const Color darkActionHover = Color(0xFF2B2D33);

  // Text colors
  static const Color textPrimary = Color(0xFF111827);
  static const Color textSecondary = Color(0xFF4B5563);
  static const Color textMuted = Color(0xFF6B7280);
  static const Color textSubtle = Color(0xFF9CA3AF);

  // Status pills
  static const Color statusMatchBg = Color(0xFFECFDF5);
  static const Color statusMatchText = Color(0xFF065F46);
  static const Color statusDiffBg = Color(0xFFFFFBEB);
  static const Color statusDiffText = Color(0xFFB45309);
  static const Color statusAlertBg = Color(0xFFFEF2F2);
  static const Color statusAlertText = Color(0xFFB91C1C);

  // Social share brand colors
  static const Color whatsapp = Color(0xFF25D366);
  static const Color facebook = Color(0xFF3B5998);
  static const Color twitter = Color(0xFF1DA1F2);
  static const Color email = Color(0xFF6B7280);
  static const Color reddit = Color(0xFFFF4500);
}

