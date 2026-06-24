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
      scaffoldBackgroundColor: AppColors.canvasSoft,
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
      navigationBarTheme: _navigationBarTheme,
      cardTheme: _cardTheme,
      bottomSheetTheme: _bottomSheetTheme,
      dialogTheme: _dialogTheme,
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
      backgroundColor: Colors.transparent,
      foregroundColor: AppColors.inkDeep,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
      titleTextStyle: AppTextStyles.subtitleLg,
      surfaceTintColor: Colors.transparent,
      iconTheme: const IconThemeData(color: AppColors.ink, size: 24),
    );
  }

  static InputDecorationTheme get _inputDecorationTheme {
    final borderRadius = AppRadius.all(AppRadius.xl);

    return InputDecorationTheme(
      filled: true,
      fillColor: AppColors.canvas.withValues(alpha: 0.96),
      constraints: const BoxConstraints(minHeight: 52),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.base,
        vertical: AppSpacing.base,
      ),
      labelStyle: AppTextStyles.bodySm.copyWith(color: AppColors.slate),
      hintStyle: AppTextStyles.bodySm.copyWith(color: AppColors.steel),
      errorStyle: AppTextStyles.bodySm.copyWith(
        color: AppColors.criticalStrong,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: borderRadius,
        borderSide: const BorderSide(color: AppColors.hairlineSoft),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: borderRadius,
        borderSide: const BorderSide(color: AppColors.fbBlue, width: 1.6),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: borderRadius,
        borderSide: const BorderSide(color: AppColors.criticalStrong),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: borderRadius,
        borderSide: const BorderSide(color: AppColors.criticalStrong, width: 1.6),
      ),
      prefixIconColor: AppColors.steel,
      suffixIconColor: AppColors.steel,
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
        minimumSize: const Size.fromHeight(50),
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 14),
        textStyle: AppTextStyles.buttonMd,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.all(18),
        ),
      ),
    );
  }

  static OutlinedButtonThemeData get _outlinedButtonTheme {
    return OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.inkDeep,
        minimumSize: const Size.fromHeight(50),
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
        textStyle: AppTextStyles.buttonMd,
        side: const BorderSide(color: AppColors.hairline, width: 1.3),
        backgroundColor: AppColors.canvas.withValues(alpha: 0.9),
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.all(18),
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

  static NavigationBarThemeData get _navigationBarTheme {
    return NavigationBarThemeData(
      backgroundColor: AppColors.canvas.withValues(alpha: 0.97),
      indicatorColor: AppColors.primary.withValues(alpha: 0.12),
      iconTheme: WidgetStateProperty.resolveWith((states) {
        final selected = states.contains(WidgetState.selected);
        return IconThemeData(
          color: selected ? AppColors.primary : AppColors.stone,
          size: 22,
        );
      }),
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        final selected = states.contains(WidgetState.selected);
        return AppTextStyles.caption.copyWith(
          color: selected ? AppColors.primary : AppColors.stone,
          fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
        );
      }),
      elevation: 0,
      height: 72,
      surfaceTintColor: Colors.transparent,
    );
  }

  static CardThemeData get _cardTheme {
    return CardThemeData(
      color: AppColors.canvas,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.all(AppRadius.xl),
        side: const BorderSide(color: AppColors.hairlineSoft),
      ),
      margin: EdgeInsets.zero,
    );
  }

  static BottomSheetThemeData get _bottomSheetTheme {
    return BottomSheetThemeData(
      backgroundColor: AppColors.canvas,
      modalBackgroundColor: AppColors.canvas,
      surfaceTintColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppRadius.xxxl),
        ),
      ),
    );
  }

  static DialogThemeData get _dialogTheme {
    return DialogThemeData(
      backgroundColor: AppColors.canvas,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.all(AppRadius.xxl),
      ),
    );
  }
}
