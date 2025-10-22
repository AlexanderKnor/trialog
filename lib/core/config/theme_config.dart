import 'package:flutter/material.dart';
import 'package:trialog/core/constants/design_constants.dart';

/// Trialog application theme configuration
class ThemeConfig {
  ThemeConfig._();

  /// Light theme
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,

      // Color Scheme
      colorScheme: const ColorScheme.light(
        primary: DesignConstants.primaryColor,
        onPrimary: DesignConstants.textOnPrimary,
        secondary: DesignConstants.primaryLight,
        onSecondary: DesignConstants.textOnPrimary,
        error: DesignConstants.errorColor,
        onError: Colors.white,
        surface: DesignConstants.surfaceColor,
        onSurface: DesignConstants.textPrimary,
      ),

      // Scaffold
      scaffoldBackgroundColor: DesignConstants.backgroundColor,

      // AppBar Theme
      appBarTheme: const AppBarTheme(
        elevation: DesignConstants.elevationSm,
        centerTitle: true,
        backgroundColor: DesignConstants.primaryColor,
        foregroundColor: DesignConstants.textOnPrimary,
        iconTheme: IconThemeData(
          color: DesignConstants.textOnPrimary,
        ),
        titleTextStyle: TextStyle(
          fontFamily: DesignConstants.fontFamily,
          fontSize: DesignConstants.fontSizeLg,
          fontWeight: DesignConstants.fontWeightSemiBold,
          color: DesignConstants.textOnPrimary,
        ),
      ),

      // Text Theme
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontFamily: DesignConstants.fontFamily,
          fontSize: DesignConstants.fontSize3xl,
          fontWeight: DesignConstants.fontWeightBold,
          color: DesignConstants.textPrimary,
        ),
        displayMedium: TextStyle(
          fontFamily: DesignConstants.fontFamily,
          fontSize: DesignConstants.fontSize2xl,
          fontWeight: DesignConstants.fontWeightBold,
          color: DesignConstants.textPrimary,
        ),
        displaySmall: TextStyle(
          fontFamily: DesignConstants.fontFamily,
          fontSize: DesignConstants.fontSizeXl,
          fontWeight: DesignConstants.fontWeightBold,
          color: DesignConstants.textPrimary,
        ),
        headlineLarge: TextStyle(
          fontFamily: DesignConstants.fontFamily,
          fontSize: DesignConstants.fontSizeXl,
          fontWeight: DesignConstants.fontWeightSemiBold,
          color: DesignConstants.textPrimary,
        ),
        headlineMedium: TextStyle(
          fontFamily: DesignConstants.fontFamily,
          fontSize: DesignConstants.fontSizeLg,
          fontWeight: DesignConstants.fontWeightSemiBold,
          color: DesignConstants.textPrimary,
        ),
        headlineSmall: TextStyle(
          fontFamily: DesignConstants.fontFamily,
          fontSize: DesignConstants.fontSizeMd,
          fontWeight: DesignConstants.fontWeightSemiBold,
          color: DesignConstants.textPrimary,
        ),
        titleLarge: TextStyle(
          fontFamily: DesignConstants.fontFamily,
          fontSize: DesignConstants.fontSizeLg,
          fontWeight: DesignConstants.fontWeightMedium,
          color: DesignConstants.textPrimary,
        ),
        titleMedium: TextStyle(
          fontFamily: DesignConstants.fontFamily,
          fontSize: DesignConstants.fontSizeMd,
          fontWeight: DesignConstants.fontWeightMedium,
          color: DesignConstants.textPrimary,
        ),
        titleSmall: TextStyle(
          fontFamily: DesignConstants.fontFamily,
          fontSize: DesignConstants.fontSizeSm,
          fontWeight: DesignConstants.fontWeightMedium,
          color: DesignConstants.textPrimary,
        ),
        bodyLarge: TextStyle(
          fontFamily: DesignConstants.fontFamily,
          fontSize: DesignConstants.fontSizeMd,
          fontWeight: DesignConstants.fontWeightRegular,
          color: DesignConstants.textPrimary,
        ),
        bodyMedium: TextStyle(
          fontFamily: DesignConstants.fontFamily,
          fontSize: DesignConstants.textFontSize,
          fontWeight: DesignConstants.fontWeightRegular,
          color: DesignConstants.textPrimary,
        ),
        bodySmall: TextStyle(
          fontFamily: DesignConstants.fontFamily,
          fontSize: DesignConstants.fontSizeXs,
          fontWeight: DesignConstants.fontWeightRegular,
          color: DesignConstants.textSecondary,
        ),
        labelLarge: TextStyle(
          fontFamily: DesignConstants.fontFamily,
          fontSize: DesignConstants.fontSizeMd,
          fontWeight: DesignConstants.fontWeightMedium,
          color: DesignConstants.textPrimary,
        ),
        labelMedium: TextStyle(
          fontFamily: DesignConstants.fontFamily,
          fontSize: DesignConstants.fontSizeSm,
          fontWeight: DesignConstants.fontWeightMedium,
          color: DesignConstants.textPrimary,
        ),
        labelSmall: TextStyle(
          fontFamily: DesignConstants.fontFamily,
          fontSize: DesignConstants.fontSizeXs,
          fontWeight: DesignConstants.fontWeightMedium,
          color: DesignConstants.textSecondary,
        ),
      ),

      // Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: DesignConstants.elevationSm,
          backgroundColor: DesignConstants.primaryColor,
          foregroundColor: DesignConstants.textOnPrimary,
          minimumSize: const Size(0, DesignConstants.buttonHeightMd),
          padding: const EdgeInsets.symmetric(
            horizontal: DesignConstants.spacingMd,
            vertical: DesignConstants.spacingSm,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(DesignConstants.borderRadiusMd),
          ),
          textStyle: const TextStyle(
            fontFamily: DesignConstants.fontFamily,
            fontSize: DesignConstants.fontSizeMd,
            fontWeight: DesignConstants.fontWeightSemiBold,
          ),
        ),
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: DesignConstants.surfaceColor,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: DesignConstants.spacingMd,
          vertical: DesignConstants.spacingSm,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(DesignConstants.borderRadiusMd),
          borderSide: const BorderSide(
            color: DesignConstants.textDisabled,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(DesignConstants.borderRadiusMd),
          borderSide: const BorderSide(
            color: DesignConstants.textDisabled,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(DesignConstants.borderRadiusMd),
          borderSide: const BorderSide(
            color: DesignConstants.primaryColor,
            width: 2.0,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(DesignConstants.borderRadiusMd),
          borderSide: const BorderSide(
            color: DesignConstants.errorColor,
          ),
        ),
        labelStyle: const TextStyle(
          fontFamily: DesignConstants.fontFamily,
          fontSize: DesignConstants.fontSizeMd,
          color: DesignConstants.textSecondary,
        ),
        hintStyle: const TextStyle(
          fontFamily: DesignConstants.fontFamily,
          fontSize: DesignConstants.fontSizeMd,
          color: DesignConstants.textDisabled,
        ),
      ),

      // Card Theme
      cardTheme: CardThemeData(
        elevation: DesignConstants.elevationSm,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(DesignConstants.borderRadiusLg),
        ),
        color: Colors.white,
      ),

      // Divider Theme
      dividerTheme: const DividerThemeData(
        color: DesignConstants.textDisabled,
        thickness: 1.0,
        space: DesignConstants.spacingMd,
      ),

      // Icon Theme
      iconTheme: const IconThemeData(
        color: DesignConstants.primaryColor,
        size: DesignConstants.iconSizeMd,
      ),
    );
  }

  /// Dark theme
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,

      // Color Scheme
      colorScheme: const ColorScheme.dark(
        primary: DesignConstants.primaryLight,
        onPrimary: DesignConstants.textOnPrimary,
        secondary: DesignConstants.primaryColor,
        onSecondary: DesignConstants.textOnPrimary,
        error: DesignConstants.errorColor,
        onError: Colors.white,
        surface: Color(0xFF1E1E1E),
        onSurface: Colors.white,
      ),

      // Scaffold
      scaffoldBackgroundColor: const Color(0xFF121212),

      // AppBar Theme
      appBarTheme: const AppBarTheme(
        elevation: DesignConstants.elevationSm,
        centerTitle: true,
        backgroundColor: DesignConstants.primaryDark,
        foregroundColor: DesignConstants.textOnPrimary,
        iconTheme: IconThemeData(
          color: DesignConstants.textOnPrimary,
        ),
        titleTextStyle: TextStyle(
          fontFamily: DesignConstants.fontFamily,
          fontSize: DesignConstants.fontSizeLg,
          fontWeight: DesignConstants.fontWeightSemiBold,
          color: DesignConstants.textOnPrimary,
        ),
      ),

      // Rest of the dark theme would follow similar pattern
      // Simplified for brevity
    );
  }
}
