import 'package:flutter/material.dart';

/// Trialog Corporate Design Constants
class DesignConstants {
  DesignConstants._();

  // Corporate Colors
  static const Color primaryColor = Color(0xFF10274C);
  static const Color primaryColorRgba = Color.fromRGBO(16, 39, 76, 1.0);

  // Gradient Variants
  static const Color primaryLight = Color(0xFF1A3B6B);
  static const Color primaryDark = Color(0xFF0A1831);

  // Neutral Colors
  static const Color backgroundColor = Color(0xFFFFFFFF);
  static const Color surfaceColor = Color(0xFFF5F5F5);
  static const Color errorColor = Color(0xFFD32F2F);
  static const Color successColor = Color(0xFF388E3C);
  static const Color warningColor = Color(0xFFF57C00);
  static const Color infoColor = Color(0xFF1976D2);

  // Text Colors
  static const Color textPrimary = Color(0xFF10274C);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textDisabled = Color(0xFFBDBDBD);
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  // Typography - Bodoni 72
  static const String fontFamily = 'Bodoni72';
  static const String fallbackFontFamily = 'serif';

  // Font Sizes
  static const double fontSizeXs = 9.0;
  static const double fontSizeSm = 10.0;
  static const double fontSizeMd = 12.0;
  static const double fontSizeLg = 14.0;
  static const double fontSizeXl = 16.0;
  static const double fontSize2xl = 20.0;
  static const double fontSize3xl = 24.0;

  // Logo Typography
  static const double logoFontSize = 12.0;

  // Text Typography
  static const double textFontSize = 9.0;

  // Font Weights
  static const FontWeight fontWeightLight = FontWeight.w300;
  static const FontWeight fontWeightRegular = FontWeight.w400;
  static const FontWeight fontWeightMedium = FontWeight.w500;
  static const FontWeight fontWeightSemiBold = FontWeight.w600;
  static const FontWeight fontWeightBold = FontWeight.w700;

  // Spacing (8px grid system)
  static const double spacingXxs = 2.0;
  static const double spacingXs = 4.0;
  static const double spacingSm = 8.0;
  static const double spacingMd = 16.0;
  static const double spacingLg = 24.0;
  static const double spacingXl = 32.0;
  static const double spacingXxl = 40.0;
  static const double spacing3xl = 48.0;

  // Border Radius
  static const double borderRadiusSm = 4.0;
  static const double borderRadiusMd = 8.0;
  static const double borderRadiusLg = 12.0;
  static const double borderRadiusXl = 16.0;
  static const double borderRadiusRound = 999.0;

  // Shadows
  static const List<BoxShadow> shadowSm = [
    BoxShadow(
      color: Color(0x1F000000),
      offset: Offset(0, 1),
      blurRadius: 3,
    ),
  ];

  static const List<BoxShadow> shadowMd = [
    BoxShadow(
      color: Color(0x29000000),
      offset: Offset(0, 4),
      blurRadius: 6,
    ),
  ];

  static const List<BoxShadow> shadowLg = [
    BoxShadow(
      color: Color(0x30000000),
      offset: Offset(0, 10),
      blurRadius: 20,
    ),
  ];

  // Elevation
  static const double elevationNone = 0.0;
  static const double elevationSm = 2.0;
  static const double elevationMd = 4.0;
  static const double elevationLg = 8.0;
  static const double elevationXl = 16.0;

  // Animation Durations
  static const Duration animationFast = Duration(milliseconds: 150);
  static const Duration animationNormal = Duration(milliseconds: 300);
  static const Duration animationSlow = Duration(milliseconds: 500);

  // Breakpoints for Responsive Design
  static const double breakpointMobile = 600.0;
  static const double breakpointTablet = 900.0;
  static const double breakpointDesktop = 1200.0;
  static const double breakpointWide = 1600.0;

  // Icon Sizes
  static const double iconSizeXs = 12.0;
  static const double iconSizeSm = 16.0;
  static const double iconSizeMd = 24.0;
  static const double iconSizeLg = 32.0;
  static const double iconSizeXl = 48.0;

  // Button Sizes
  static const double buttonHeightSm = 32.0;
  static const double buttonHeightMd = 40.0;
  static const double buttonHeightLg = 48.0;

  // Input Sizes
  static const double inputHeightSm = 32.0;
  static const double inputHeightMd = 40.0;
  static const double inputHeightLg = 48.0;
}
