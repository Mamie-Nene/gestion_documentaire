import 'package:flutter/material.dart';

class AppColors {
  // Base
  static const background = Color(0xFFF2F5F9);
  static const foreground = Color(0xFF333333);

  // Card & Popover
  static const card = Color(0xFFFFFFFF);
  static const cardForeground = Color(0xFF333333);

  static const popover = Color(0xFFFFFFFF);
  static const popoverForeground = Color(0xFF333333);

  // Primary (214 52% 41%)
  static const primary = Color(0xFF2F5DA1);
  static const primaryForeground = Color(0xFFFFFFFF);

  // Secondary (93 42% 46%)
  static const secondary = Color(0xFF6FA63F);
  static const secondaryForeground = Color(0xFFFFFFFF);

  // Muted
  static const muted = Color(0xFFE9EEF5);
  static const mutedForeground = Color(0xFF4A5568);

  // Accent
  static const accent = Color(0xFF6FA63F);
  static const accentForeground = Color(0xFFFFFFFF);

  // Destructive
  static const destructive = Color(0xFFD63636);
  static const destructiveForeground = Color(0xFFFAFAFA);

  // Border / Input
  static const border = Color(0xFFDEE3EA);
  static const input = Color(0xFFF2F5F9);
  static const ring = Color(0xFF2F5DA1);

  // Charts
  static const chart1 = Color(0xFF2F5DA1);
  static const chart2 = Color(0xFF6FA63F);
  static const chart3 = Color(0xFFD63636);
  static const chart4 = Color(0xFF8A94A6);
  static const chart5 = Color(0xFFF5A623);

  // Sidebar
  static const sidebarBackground = Color(0xFF1F3F6E);
  static const sidebarForeground = Color(0xFFF2F2F2);
  static const sidebarPrimary = Color(0xFF6FA63F);
  static const sidebarPrimaryForeground = Color(0xFFFFFFFF);
  static const sidebarAccent = Color(0xFF2A4E80);
  static const sidebarAccentForeground = Color(0xFFF2F2F2);
  static const sidebarBorder = Color(0xFF315985);
  static const sidebarRing = Color(0xFF6FA63F);

  // Status
  static const success = Color(0xFF6FA63F);
  static const successForeground = Color(0xFFFFFFFF);

  static const warning = Color(0xFFF5A623);
  static const warningForeground = Color(0xFF333333);

  // Radius
  static const double radius = 8.0; // 0.5rem ≈ 8px
}


class ColorSchemes {
  static final lightCodeColorScheme = ColorScheme.light();
}

class LightCodeColors {
  // App Colors
  Color get gray_900 => Color(0xFF1C160C);
  Color get white_A700 => Color(0xFFFFFFFF);
  Color get gray_600 => Color(0xFF727272);
  Color get deep_orange_50 => Color(0xFFF5F0E5);
  Color get gray_200 => Color(0xFFE5E8EA);
  Color get green_600 => Color(0xFF30A05E);
  Color get bleu_600 => Color(0xFF0056D6);
  Color get yellow_800 => Color(0xFFEF9920);
  Color get gray_900_01 => Color(0xFF0C1C11);
  Color get green_600_01 => Color(0xFF4C9368);
  Color get deep_orange_50_01 => Color(0xFFF4EFE5);
  Color get black_900 => Color(0xFF000000);
  Color get gray_300 => Color(0xFFE8DDCE);
  Color get gray_700 => Color(0xFF585858);
  Color get gray_500 => Color(0xFFADADAD);
  Color get gray_400 => Color(0xFFBFC0C0);
  Color get orange_50 => Color(0xFFFEF4E4);
  Color get amber_100 => Color(0xFFFEE6C5);
  Color get orange_300 => Color(0xFFF3B965);
  Color get orange_50_01 => Color(0xFFFEF5E4);
  Color get orange_300_01 => Color(0xFFF3BA67);
  Color get orange_50_02 => Color(0xFFFEF4E2);
  Color get orange_300_02 => Color(0xFFF4BB68);
  Color get yellow_100 => Color(0xFFFEE7C6);
  Color get orange_50_03 => Color(0xFFFEF5E5);
  Color get green_300 => Color(0xFF7AC097);
  Color get gray_400_01 => Color(0xFFAEAEAE);
  Color get gray_400_02 => Color(0xFFAFAFAF);
  Color get gray_700_01 => Color(0xFF5E5E5E);
  Color get gray_400_03 => Color(0xFFBFBFBF);
  Color get gray_500_01 => Color(0xFF929292);
  Color get gray_500_02 => Color(0xFF979797);
  Color get gray_700_02 => Color(0xFF5A5A59);
  Color get gray_400_04 => Color(0xFFB6B6B6);
  Color get gray_400_05 => Color(0xFFC4C4C4);
  Color get orange_300_03 => Color(0xFFF3BB68);
  Color get orange_50_04 => Color(0xFFFEF4E3);
  Color get orange_50_05 => Color(0xFFFEF5E6);
  Color get orange_200 => Color(0xFFF4BC6A);
  Color get gray_400_06 => Color(0xFFB8B8B8);
  Color get gray_500_03 => Color(0xFFACACAC);
  Color get gray_500_04 => Color(0xFFA9A9A9);
  Color get gray_400_07 => Color(0xFFC5C5C6);
  Color get gray_500_05 => Color(0xFF999999);

  // Additional Colors
  Color get transparentCustom => Colors.transparent;
  Color get greyCustom => Colors.grey;
  Color get redCustom => Colors.red;

  // Color Shades - Each shade has its own dedicated constant
  Color get grey200 => Colors.grey.shade200;
  Color get grey100 => Colors.grey.shade100;
}


