import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  static const List<FontFeature> headingFeatures = [
    FontFeature.enable('ss01'),
    FontFeature.enable('ss02'),
  ];

  static TextStyle get heroDisplay {
    return GoogleFonts.montserrat(
      fontSize: 64,
      fontWeight: FontWeight.w500,
      height: 1.16,
      color: AppColors.inkDeep,
      fontFeatures: headingFeatures,
    );
  }

  static TextStyle get displayLg {
    return GoogleFonts.montserrat(
      fontSize: 48,
      fontWeight: FontWeight.w500,
      height: 1.17,
      color: AppColors.inkDeep,
      fontFeatures: headingFeatures,
    );
  }

  static TextStyle get headingLg {
    return GoogleFonts.montserrat(
      fontSize: 36,
      fontWeight: FontWeight.w500,
      height: 1.28,
      color: AppColors.inkDeep,
      fontFeatures: headingFeatures,
    );
  }

  static TextStyle get headingMd {
    return GoogleFonts.montserrat(
      fontSize: 28,
      fontWeight: FontWeight.w300,
      height: 1.21,
      color: AppColors.inkDeep,
      fontFeatures: headingFeatures,
    );
  }

  static TextStyle get headingSm {
    return GoogleFonts.montserrat(
      fontSize: 24,
      fontWeight: FontWeight.w500,
      height: 1.25,
      color: AppColors.inkDeep,
      fontFeatures: headingFeatures,
    );
  }

  static TextStyle get subtitleLg {
    return GoogleFonts.montserrat(
      fontSize: 18,
      fontWeight: FontWeight.w700,
      height: 1.44,
      color: AppColors.ink,
    );
  }

  static TextStyle get subtitleMd {
    return GoogleFonts.montserrat(
      fontSize: 18,
      fontWeight: FontWeight.w400,
      height: 1.44,
      color: AppColors.ink,
    );
  }

  static TextStyle get bodyMdBold {
    return GoogleFonts.montserrat(
      fontSize: 16,
      fontWeight: FontWeight.w700,
      height: 1.50,
      letterSpacing: -0.16,
      color: AppColors.ink,
    );
  }

  static TextStyle get bodyMd {
    return GoogleFonts.montserrat(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      height: 1.50,
      letterSpacing: -0.16,
      color: AppColors.ink,
    );
  }

  static TextStyle get bodySmBold {
    return GoogleFonts.montserrat(
      fontSize: 14,
      fontWeight: FontWeight.w700,
      height: 1.43,
      letterSpacing: -0.14,
      color: AppColors.ink,
    );
  }

  static TextStyle get bodySm {
    return GoogleFonts.montserrat(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      height: 1.43,
      letterSpacing: -0.14,
      color: AppColors.slate,
    );
  }

  static TextStyle get captionBold {
    return GoogleFonts.montserrat(
      fontSize: 12,
      fontWeight: FontWeight.w700,
      height: 1.33,
      color: AppColors.ink,
    );
  }

  static TextStyle get caption {
    return GoogleFonts.montserrat(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      height: 1.33,
      color: AppColors.stone,
    );
  }

  static TextStyle get buttonMd {
    return GoogleFonts.montserrat(
      fontSize: 14,
      fontWeight: FontWeight.w700,
      height: 1.43,
      letterSpacing: -0.14,
    );
  }

  static TextStyle get linkMd {
    return GoogleFonts.montserrat(
      fontSize: 16,
      fontWeight: FontWeight.w700,
      height: 1.50,
      letterSpacing: -0.16,
      color: AppColors.metaLink,
    );
  }
}
