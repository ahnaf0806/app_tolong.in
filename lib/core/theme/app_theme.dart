import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';
import 'app_radius.dart';
import 'app_spacing.dart';
import 'app_text_styles.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.canvas,
      fontFamily: GoogleFonts.montserrat().fontFamily,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        primary: AppColors.primary,
        secondary: AppColors.oculusPurple,
        surface: AppColors.canvas,
        error: AppColors.critical,
        onPrimary: AppColors.onPrimary,
        onSurface: AppColors.ink,
      ),
      textTheme: _textTheme,
      appBarTheme: _appBarTheme,
      inputDecorationTheme: _inputDecorationTheme,
      elevatedButtonTheme: _elevatedButtonTheme,
      outlinedButtonTheme: _outlinedButtonTheme,
      textButtonTheme: _textButtonTheme,
      snackBarTheme: _snackBarTheme,
      dividerTheme: _dividerTheme,
    );
  }

  static TextTheme get _textTheme {
    return TextTheme(
      displayLarge: AppTextStyles.heroDisplay,
      displayMedium: AppTextStyles.displayLg,
      headlineLarge: AppTextStyles.headingLg,
      headlineMedium: AppTextStyles.headingMd,
      headlineSmall: AppTextStyles.headingSm,
      titleLarge: AppTextStyles.subtitleLg,
      titleMedium: AppTextStyles.subtitleMd,
      bodyLarge: AppTextStyles.bodyMd,
      bodyMedium: AppTextStyles.bodyMd,
      bodySmall: AppTextStyles.bodySm,
      labelLarge: AppTextStyles.buttonMd,
      labelMedium: AppTextStyles.bodySmBold,
      labelSmall: AppTextStyles.caption,
    );
  }

  static AppBarTheme get _appBarTheme {
    return AppBarTheme(
      backgroundColor: AppColors.canvas,
      foregroundColor: AppColors.inkDeep,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: AppTextStyles.subtitleLg,
      surfaceTintColor: Colors.transparent,
      iconTheme: const IconThemeData(color: AppColors.ink, size: 24),
    );
  }

  static InputDecorationTheme get _inputDecorationTheme {
    final borderRadius = AppRadius.all(AppRadius.lg);

    return InputDecorationTheme(
      filled: true,
      fillColor: AppColors.canvas,
      constraints: const BoxConstraints(minHeight: 44),
      contentPadding: const EdgeInsets.all(AppSpacing.md),
      labelStyle: AppTextStyles.bodySm,
      hintStyle: AppTextStyles.bodySm.copyWith(color: AppColors.steel),
      errorStyle: AppTextStyles.bodySm.copyWith(
        color: AppColors.criticalStrong,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: borderRadius,
        borderSide: const BorderSide(color: AppColors.hairline),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: borderRadius,
        borderSide: const BorderSide(color: AppColors.fbBlue, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: borderRadius,
        borderSide: const BorderSide(color: AppColors.criticalStrong),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: borderRadius,
        borderSide: const BorderSide(color: AppColors.criticalStrong, width: 2),
      ),
    );
  }

  static ElevatedButtonThemeData get _elevatedButtonTheme {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.inkButton,
        foregroundColor: AppColors.onInkButton,
        disabledBackgroundColor: AppColors.disabledText,
        disabledForegroundColor: AppColors.canvas,
        elevation: 0,
        minimumSize: const Size.fromHeight(44),
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 14),
        textStyle: AppTextStyles.buttonMd,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.all(AppRadius.full),
        ),
      ),
    );
  }

  static OutlinedButtonThemeData get _outlinedButtonTheme {
    return OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.inkDeep,
        minimumSize: const Size.fromHeight(44),
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
        textStyle: AppTextStyles.buttonMd,
        side: const BorderSide(color: AppColors.inkDeep, width: 2),
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.all(AppRadius.full),
        ),
      ),
    );
  }

  static TextButtonThemeData get _textButtonTheme {
    return TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.metaLink,
        textStyle: AppTextStyles.linkMd,
      ),
    );
  }

  static SnackBarThemeData get _snackBarTheme {
    return SnackBarThemeData(
      backgroundColor: AppColors.inkDeep,
      contentTextStyle: AppTextStyles.bodySm.copyWith(color: AppColors.canvas),
      shape: RoundedRectangleBorder(borderRadius: AppRadius.all(AppRadius.xl)),
      behavior: SnackBarBehavior.floating,
    );
  }

  static DividerThemeData get _dividerTheme {
    return const DividerThemeData(
      color: AppColors.hairlineSoft,
      thickness: 1,
      space: 1,
    );
  }
}
