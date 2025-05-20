import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile/common/providers/theme_provider.dart';
import 'package:mobile/common/utils/app_colors_improved.dart';
import 'package:mobile/common/utils/app_style.dart';
import 'package:provider/provider.dart';

class ProfileStatCard extends StatelessWidget {
  final String value;
  final String label;
  final IconData? icon;
  final bool showBorder;
  final VoidCallback? onTap;

  const ProfileStatCard({
    super.key,
    required this.value,
    required this.label,
    this.icon,
    this.showBorder = true,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.r),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
        decoration: BoxDecoration(
          color: isDarkMode ? AppColors.cardDark : AppColors.cardLight,
          borderRadius: BorderRadius.circular(16.r),
          border:
              showBorder
                  ? Border.all(
                    color:
                        isDarkMode
                            ? AppColors.dividerDark
                            : AppColors.dividerLight,
                    width: 1,
                  )
                  : null,
          boxShadow:
              showBorder
                  ? [
                    BoxShadow(
                      color:
                          isDarkMode
                              ? Colors.black.withOpacity(0.12)
                              : AppColors.shadowColorLight,
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                  : null,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 20.sp,
                color:
                    isDarkMode ? AppColors.primaryDark : AppColors.primaryLight,
              ),
              SizedBox(height: 8.h),
            ],
            Text(
              value,
              style: AppStyle.textStyle(
                18,
                isDarkMode ? AppColors.textDarkDark : AppColors.textDarkLight,
                FontWeight.bold,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              label,
              style: AppStyle.textStyle(
                12,
                isDarkMode
                    ? AppColors.textMediumDark
                    : AppColors.textMediumLight,
                FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
