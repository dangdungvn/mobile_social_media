import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile/common/utils/app_colors.dart';

class AppTheme {
  static ThemeData lightTheme() {
    return ThemeData(
      brightness: Brightness.light,
      useMaterial3: true,
      primaryColor: AppColors.primaryLight,
      scaffoldBackgroundColor: AppColors.backgroundLight,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primaryLight,
        secondary: AppColors.secondaryLight,
        tertiary: AppColors.accentLight,
        surface: AppColors.cardLight,
        error: AppColors.errorLight,
      ),
      textTheme: TextTheme(
        displayLarge: GoogleFonts.poppins(
          color: AppColors.textDarkLight,
          fontWeight: FontWeight.bold,
          fontSize: 28.sp,
        ),
        displayMedium: GoogleFonts.poppins(
          color: AppColors.textDarkLight,
          fontWeight: FontWeight.w600,
          fontSize: 24.sp,
        ),
        displaySmall: GoogleFonts.poppins(
          color: AppColors.textDarkLight,
          fontWeight: FontWeight.w600,
          fontSize: 20.sp,
        ),
        bodyLarge: GoogleFonts.poppins(
          color: AppColors.textDarkLight,
          fontSize: 16.sp,
          fontWeight: FontWeight.normal,
        ),
        bodyMedium: GoogleFonts.poppins(
          color: AppColors.textMediumLight,
          fontSize: 14.sp,
          fontWeight: FontWeight.normal,
        ),
        bodySmall: GoogleFonts.poppins(
          color: AppColors.textLightLight,
          fontSize: 12.sp,
          fontWeight: FontWeight.normal,
        ),
      ),
      cardTheme: CardTheme(
        color: AppColors.cardLight,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryLight,
          foregroundColor: AppColors.white,
          elevation: 0,
          padding: EdgeInsets.symmetric(vertical: 14.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 16.sp,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.cardLight,
        contentPadding: EdgeInsets.all(16.w),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.dividerLight),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.dividerLight),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.primaryLight),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.errorLight),
        ),
        hintStyle: GoogleFonts.poppins(color: AppColors.textLightLight),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.dividerLight,
        thickness: 1,
      ),
      iconTheme: const IconThemeData(color: AppColors.textDarkLight),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.cardLight,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: AppColors.textDarkLight),
        titleTextStyle: GoogleFonts.poppins(
          color: AppColors.textDarkLight,
          fontSize: 18.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.cardLight,
        selectedItemColor: AppColors.primaryLight,
        unselectedItemColor: AppColors.textLightLight,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
    );
  }

  static ThemeData darkTheme() {
    return ThemeData(
      brightness: Brightness.dark,
      useMaterial3: true,
      primaryColor: AppColors.primaryDark,
      scaffoldBackgroundColor: AppColors.backgroundDark,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primaryDark,
        secondary: AppColors.secondaryDark,
        tertiary: AppColors.accentDark,
        surface: AppColors.cardDark,
        error: AppColors.errorDark,
      ),
      textTheme: TextTheme(
        displayLarge: GoogleFonts.poppins(
          color: AppColors.textDarkDark,
          fontWeight: FontWeight.bold,
          fontSize: 28.sp,
        ),
        displayMedium: GoogleFonts.poppins(
          color: AppColors.textDarkDark,
          fontWeight: FontWeight.w600,
          fontSize: 24.sp,
        ),
        displaySmall: GoogleFonts.poppins(
          color: AppColors.textDarkDark,
          fontWeight: FontWeight.w600,
          fontSize: 20.sp,
        ),
        bodyLarge: GoogleFonts.poppins(
          color: AppColors.textDarkDark,
          fontSize: 16.sp,
          fontWeight: FontWeight.normal,
        ),
        bodyMedium: GoogleFonts.poppins(
          color: AppColors.textMediumDark,
          fontSize: 14.sp,
          fontWeight: FontWeight.normal,
        ),
        bodySmall: GoogleFonts.poppins(
          color: AppColors.textLightDark,
          fontSize: 12.sp,
          fontWeight: FontWeight.normal,
        ),
      ),
      cardTheme: CardTheme(
        color: AppColors.cardDark,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryDark,
          foregroundColor: AppColors.white,
          elevation: 0,
          padding: EdgeInsets.symmetric(vertical: 14.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 16.sp,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.cardDark,
        contentPadding: EdgeInsets.all(16.w),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.dividerDark),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.dividerDark),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.primaryDark),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.errorDark),
        ),
        hintStyle: GoogleFonts.poppins(color: AppColors.textLightDark),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.dividerDark,
        thickness: 1,
      ),
      iconTheme: const IconThemeData(color: AppColors.textDarkDark),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.cardDark,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: AppColors.textDarkDark),
        titleTextStyle: GoogleFonts.poppins(
          color: AppColors.textDarkDark,
          fontSize: 18.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.cardDark,
        selectedItemColor: AppColors.primaryDark,
        unselectedItemColor: AppColors.textLightDark,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
    );
  }
}
