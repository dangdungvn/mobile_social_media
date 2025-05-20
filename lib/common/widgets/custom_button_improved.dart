import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile/common/utils/app_colors_improved.dart';
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
  final bool isGradient;

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
    this.isGradient = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;

    return SizedBox(
      width: isFullWidth ? double.infinity : width,
      height: height ?? 56.h,
      child:
          isGradient
              ? _buildGradientButton(context, isDarkMode)
              : _buildSolidButton(context, isDarkMode),
    );
  }

  Widget _buildSolidButton(BuildContext context, bool isDarkMode) {
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.resolveWith<Color>((states) {
          if (isOutlined) return Colors.transparent;

          if (states.contains(WidgetState.disabled)) {
            return isDarkMode
                ? AppColors.primaryDark.withOpacity(0.5)
                : AppColors.primaryLight.withOpacity(0.5);
          }

          if (states.contains(WidgetState.pressed)) {
            return isDarkMode
                ? AppColors.primaryDark.withOpacity(0.7)
                : AppColors.primaryLight.withOpacity(0.7);
          }

          return isDarkMode ? AppColors.primaryDark : AppColors.primaryLight;
        }),
        foregroundColor: WidgetStateProperty.resolveWith<Color>((states) {
          if (isOutlined) {
            return isDarkMode ? AppColors.primaryDark : AppColors.primaryLight;
          }
          return Colors.white;
        }),
        elevation: WidgetStateProperty.resolveWith<double>((states) {
          if (isOutlined) return 0;

          if (states.contains(WidgetState.pressed)) {
            return 1.0;
          }

          return 4.0;
        }),
        shadowColor: WidgetStateProperty.resolveWith<Color>((states) {
          if (isOutlined) return Colors.transparent;

          return isDarkMode
              ? AppColors.primaryDark.withOpacity(0.3)
              : AppColors.primaryLight.withOpacity(0.3);
        }),
        padding: WidgetStateProperty.all(EdgeInsets.symmetric(vertical: 12.h)),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
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
        ),
        overlayColor: WidgetStateProperty.resolveWith<Color>((states) {
          if (isOutlined) {
            return isDarkMode
                ? AppColors.primaryDark.withOpacity(0.1)
                : AppColors.primaryLight.withOpacity(0.1);
          }
          return Colors.white.withOpacity(0.1);
        }),
      ),
      child: _buildButtonContent(isDarkMode),
    );
  }

  Widget _buildGradientButton(BuildContext context, bool isDarkMode) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors:
              isDarkMode
                  ? AppColors.primaryGradientDark
                  : AppColors.primaryGradientLight,
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color:
                isDarkMode
                    ? AppColors.primaryDark.withOpacity(0.3)
                    : AppColors.primaryLight.withOpacity(0.3),
            offset: const Offset(0, 4),
            blurRadius: 10,
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
          shadowColor: Colors.transparent,
          padding: EdgeInsets.symmetric(vertical: 12.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
        ),
        child: _buildButtonContent(isDarkMode),
      ),
    );
  }

  Widget _buildButtonContent(bool isDarkMode) {
    if (isLoading) {
      return SizedBox(
        width: 24.w,
        height: 24.h,
        child: CircularProgressIndicator(
          strokeWidth: 2.5,
          valueColor: AlwaysStoppedAnimation<Color>(
            isOutlined
                ? isDarkMode
                    ? AppColors.primaryDark
                    : AppColors.primaryLight
                : Colors.white,
          ),
        ),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (prefixIcon != null) ...[prefixIcon!, SizedBox(width: 12.w)],
        Flexible(
          child: Text(
            text,
            style: AppStyle.textStyle(
              16,
              isOutlined || isGradient
                  ? isDarkMode
                      ? AppColors.primaryDark
                      : Colors.white
                  : isOutlined
                  ? isDarkMode
                      ? AppColors.primaryDark
                      : AppColors.primaryLight
                  : Colors.white,
              FontWeight.w600,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (suffixIcon != null) ...[SizedBox(width: 12.w), suffixIcon!],
      ],
    );
  }
}
