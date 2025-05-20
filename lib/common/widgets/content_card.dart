import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile/common/providers/theme_provider.dart';
import 'package:mobile/common/utils/app_colors_improved.dart';
import 'package:provider/provider.dart';

class ContentCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? borderRadius;
  final bool showBorder;
  final bool showShadow;
  final double? width;
  final double? height;

  const ContentCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.borderRadius,
    this.showBorder = true,
    this.showShadow = true,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;

    return Container(
      width: width,
      height: height,
      padding: padding ?? EdgeInsets.all(16.w),
      margin: margin ?? EdgeInsets.symmetric(vertical: 8.h),
      decoration: BoxDecoration(
        color: isDarkMode ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(borderRadius ?? 16.r),
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
            showShadow
                ? [
                  BoxShadow(
                    color:
                        isDarkMode
                            ? Colors.black.withOpacity(0.12)
                            : AppColors.shadowColorLight,
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ]
                : null,
      ),
      child: child,
    );
  }
}
