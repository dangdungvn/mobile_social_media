import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile/common/utils/app_colors.dart';

class AppStyle {
  static TextStyle textStyle(double size, Color color, FontWeight fw) {
    return GoogleFonts.poppins(fontSize: size.sp, color: color, fontWeight: fw);
  }

  static BoxDecoration gradientBoxDecoration(
    BuildContext context,
    bool isDarkMode,
  ) {
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors:
            isDarkMode
                ? [
                  AppColors.backgroundDark,
                  AppColors.backgroundDark.withOpacity(0.9),
                  AppColors.cardDark.withOpacity(0.7),
                ]
                : [
                  AppColors.backgroundLight,
                  AppColors.white,
                  AppColors.secondaryLight.withOpacity(0.1),
                ],
      ),
    );
  }

  static BoxDecoration cardBoxDecoration(
    BuildContext context,
    bool isDarkMode,
  ) {
    return BoxDecoration(
      color: isDarkMode ? AppColors.cardDark : AppColors.cardLight,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color:
              isDarkMode
                  ? AppColors.black.withOpacity(0.15)
                  : AppColors.black.withOpacity(0.05),
          offset: const Offset(0, 2),
          blurRadius: 10,
          spreadRadius: 1,
        ),
      ],
    );
  }

  static BoxDecoration highlightBoxDecoration(
    BuildContext context,
    bool isDarkMode,
  ) {
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors:
            isDarkMode
                ? [AppColors.primaryDark, AppColors.accentDark]
                : [AppColors.primaryLight, AppColors.accentLight],
      ),
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color:
              isDarkMode
                  ? AppColors.primaryDark.withOpacity(0.25)
                  : AppColors.primaryLight.withOpacity(0.25),
          offset: const Offset(0, 4),
          blurRadius: 12,
          spreadRadius: 0,
        ),
      ],
    );
  }

  static BoxDecoration circularBoxDecoration(Color color, double radius) {
    return BoxDecoration(shape: BoxShape.circle, color: color);
  }
}
