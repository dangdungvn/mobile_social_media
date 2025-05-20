import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile/common/providers/theme_provider.dart';
import 'package:mobile/common/utils/app_colors_improved.dart';
import 'package:mobile/common/utils/app_style.dart';
import 'package:provider/provider.dart';

class SocialSignInButton extends StatelessWidget {
  final String text;
  final String iconPath;
  final VoidCallback onTap;
  final Color? backgroundColor;
  final Color? textColor;

  const SocialSignInButton({
    super.key,
    required this.text,
    required this.iconPath,
    required this.onTap,
    this.backgroundColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;

    final bgColor =
        backgroundColor ??
        (isDarkMode ? AppColors.cardDark : AppColors.cardLight);

    final txtColor =
        textColor ??
        (isDarkMode ? AppColors.textDarkDark : AppColors.textDarkLight);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.r),
      child: Container(
        width: double.infinity,
        height: 56.h,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: isDarkMode ? AppColors.dividerDark : AppColors.dividerLight,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color:
                  isDarkMode
                      ? Colors.black.withOpacity(0.1)
                      : AppColors.shadowColorLight,
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(width: 24.w, height: 24.h, child: Image.asset(iconPath)),
            SizedBox(width: 12.w),
            Text(
              text,
              style: AppStyle.textStyle(16, txtColor, FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}
