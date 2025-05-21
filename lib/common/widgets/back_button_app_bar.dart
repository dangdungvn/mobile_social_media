import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile/common/utils/app_colors.dart';

extension BackButtonAppBar on AppBar {
  static AppBar withBackButton({
    required BuildContext context,
    required String title,
    required bool isDarkMode,
    List<Widget>? actions,
    double? elevation,
    PreferredSizeWidget? bottom,
    bool centerTitle = true,
    TextStyle? titleStyle,
    VoidCallback? onBackButtonPressed,
  }) {
    return AppBar(
      elevation: elevation ?? 0,
      backgroundColor: isDarkMode ? AppColors.cardDark : AppColors.cardLight,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back,
          color: isDarkMode ? AppColors.textDarkDark : AppColors.textDarkLight,
        ),
        onPressed: onBackButtonPressed ?? () => Navigator.of(context).pop(),
      ),
      title: Text(
        title,
        style:
            titleStyle ??
            TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color:
                  isDarkMode ? AppColors.textDarkDark : AppColors.textDarkLight,
            ),
      ),
      centerTitle: centerTitle,
      actions: actions,
      bottom: bottom,
    );
  }
}
