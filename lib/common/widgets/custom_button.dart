import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile/common/utils/app_colors.dart';
import 'package:mobile/common/utils/app_style.dart';
import 'package:mobile/common/providers/theme_provider.dart';
import 'package:provider/provider.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isOutlined;
  final bool isFullWidth;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final double? width;
  final double? height;
  final bool isLoading;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isOutlined = false,
    this.isFullWidth = true,
    this.prefixIcon,
    this.suffixIcon,
    this.width,
    this.height,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;

    return SizedBox(
      width: isFullWidth ? double.infinity : width,
      height: height ?? 50.h,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor:
              isOutlined
                  ? Colors.transparent
                  : isDarkMode
                  ? AppColors.primaryDark
                  : AppColors.primaryLight,
          foregroundColor:
              isOutlined
                  ? isDarkMode
                      ? AppColors.primaryDark
                      : AppColors.primaryLight
                  : AppColors.white,
          elevation: isOutlined ? 0 : 2,
          padding: EdgeInsets.symmetric(vertical: 12.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side:
                isOutlined
                    ? BorderSide(
                      color:
                          isDarkMode
                              ? AppColors.primaryDark
                              : AppColors.primaryLight,
                      width: 1.5,
                    )
                    : BorderSide.none,
          ),
          shadowColor:
              isOutlined
                  ? Colors.transparent
                  : isDarkMode
                  ? AppColors.primaryDark.withOpacity(0.3)
                  : AppColors.primaryLight.withOpacity(0.3),
        ),
        child:
            isLoading
                ? SizedBox(
                  width: 20.w,
                  height: 20.h,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      isOutlined
                          ? isDarkMode
                              ? AppColors.primaryDark
                              : AppColors.primaryLight
                          : AppColors.white,
                    ),
                  ),
                )
                : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (prefixIcon != null) ...[
                      prefixIcon!,
                      SizedBox(width: 8.w),
                    ],
                    Flexible(
                      child: Text(
                        text,
                        style: AppStyle.textStyle(
                          16,
                          isOutlined
                              ? isDarkMode
                                  ? AppColors.primaryDark
                                  : AppColors.primaryLight
                              : AppColors.white,
                          FontWeight.w600,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (suffixIcon != null) ...[
                      SizedBox(width: 8.w),
                      suffixIcon!,
                    ],
                  ],
                ),
      ),
    );
  }
}
