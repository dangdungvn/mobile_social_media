import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile/common/providers/theme_provider.dart';
import 'package:mobile/common/utils/app_colors_improved.dart';
import 'package:provider/provider.dart';

class CreatePostModalSheet extends StatelessWidget {
  final Function(String) onOptionSelected;

  const CreatePostModalSheet({super.key, required this.onOptionSelected});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;

    return Container(
      decoration: BoxDecoration(
        color: isDarkMode ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24.r),
          topRight: Radius.circular(24.r),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 0,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle indicator
          Container(
            width: 40.w,
            height: 5.h,
            decoration: BoxDecoration(
              color:
                  isDarkMode ? AppColors.dividerDark : AppColors.dividerLight,
              borderRadius: BorderRadius.circular(2.5.r),
            ),
          ),

          SizedBox(height: 28.h),

          // Title
          Text(
            "Create New Post",
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color:
                  isDarkMode ? AppColors.textDarkDark : AppColors.textDarkLight,
            ),
          ),

          SizedBox(height: 32.h),

          // Post options
          _buildPostOption(
            context,
            isDarkMode,
            Icons.text_fields_rounded,
            "Text Post",
            "Share your thoughts with others",
            () => onOptionSelected("text"),
            AppColors.primaryLight,
            AppColors.primaryDark,
          ),

          SizedBox(height: 16.h),

          _buildPostOption(
            context,
            isDarkMode,
            Icons.photo_library_outlined,
            "Photo Post",
            "Share images with your friends",
            () => onOptionSelected("photo"),
            AppColors.secondaryLight,
            AppColors.secondaryDark,
          ),

          SizedBox(height: 16.h),

          _buildPostOption(
            context,
            isDarkMode,
            Icons.videocam_outlined,
            "Video Post",
            "Share videos with your friends",
            () => onOptionSelected("video"),
            AppColors.accentLight,
            AppColors.accentDark,
          ),

          SizedBox(height: 32.h),

          // Cancel button
          _buildCancelButton(context, isDarkMode),

          SizedBox(height: 16.h),
        ],
      ),
    );
  }

  Widget _buildPostOption(
    BuildContext context,
    bool isDarkMode,
    IconData icon,
    String title,
    String subtitle,
    VoidCallback onTap,
    Color lightModeColor,
    Color darkModeColor,
  ) {
    Color iconColor = isDarkMode ? darkModeColor : lightModeColor;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color:
              isDarkMode ? AppColors.backgroundDark : AppColors.backgroundLight,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color:
                  isDarkMode
                      ? Colors.black.withOpacity(0.2)
                      : Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 50.w,
              height: 50.h,
              decoration: BoxDecoration(
                color:
                    isDarkMode
                        ? iconColor.withOpacity(0.15)
                        : iconColor.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(icon, size: 24.sp, color: iconColor),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color:
                          isDarkMode
                              ? AppColors.textDarkDark
                              : AppColors.textDarkLight,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color:
                          isDarkMode
                              ? AppColors.textMediumDark
                              : AppColors.textMediumLight,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16.sp,
              color:
                  isDarkMode
                      ? AppColors.textLightDark
                      : AppColors.textLightLight,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCancelButton(BuildContext context, bool isDarkMode) {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 16.h),
        decoration: BoxDecoration(
          color: isDarkMode ? Colors.transparent : Colors.transparent,
          border: Border.all(
            color: isDarkMode ? AppColors.dividerDark : AppColors.dividerLight,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(16.r),
        ),
        alignment: Alignment.center,
        child: Text(
          "Cancel",
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
            color:
                isDarkMode
                    ? AppColors.textMediumDark
                    : AppColors.textMediumLight,
          ),
        ),
      ),
    );
  }
}
