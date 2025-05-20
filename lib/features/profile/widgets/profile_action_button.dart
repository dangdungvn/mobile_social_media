import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile/common/providers/theme_provider.dart';
import 'package:mobile/common/utils/app_colors_improved.dart';
import 'package:mobile/common/utils/app_style.dart';
import 'package:provider/provider.dart';

class ProfileActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isPrimary;
  final bool isLoading;

  const ProfileActionButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.isPrimary = false,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;

    return InkWell(
      onTap: isLoading ? null : onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 16.w),
        decoration: BoxDecoration(
          gradient:
              isPrimary
                  ? LinearGradient(
                    colors:
                        isDarkMode
                            ? AppColors.primaryGradientDark
                            : AppColors.primaryGradientLight,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                  : null,
          color:
              !isPrimary
                  ? (isDarkMode ? AppColors.cardDark : AppColors.cardLight)
                  : null,
          borderRadius: BorderRadius.circular(12.r),
          border:
              !isPrimary
                  ? Border.all(
                    color:
                        isDarkMode
                            ? AppColors.dividerDark
                            : AppColors.dividerLight,
                    width: 1,
                  )
                  : null,
          boxShadow: [
            BoxShadow(
              color:
                  isPrimary
                      ? (isDarkMode
                          ? AppColors.primaryDark.withOpacity(0.3)
                          : AppColors.primaryLight.withOpacity(0.3))
                      : (isDarkMode
                          ? Colors.black.withOpacity(0.1)
                          : AppColors.shadowColorLight),
              blurRadius: isPrimary ? 8 : 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child:
            isLoading
                ? Center(
                  child: SizedBox(
                    width: 20.w,
                    height: 20.h,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.w,
                      color:
                          isPrimary
                              ? Colors.white
                              : (isDarkMode
                                  ? AppColors.primaryDark
                                  : AppColors.primaryLight),
                    ),
                  ),
                )
                : Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      icon,
                      color:
                          isPrimary
                              ? Colors.white
                              : (isDarkMode
                                  ? AppColors.primaryDark
                                  : AppColors.primaryLight),
                      size: 18.sp,
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      label,
                      style: AppStyle.textStyle(
                        14,
                        isPrimary
                            ? Colors.white
                            : (isDarkMode
                                ? AppColors.textDarkDark
                                : AppColors.textDarkLight),
                        FontWeight.w600,
                      ),
                    ),
                  ],
                ),
      ),
    );
  }
}
