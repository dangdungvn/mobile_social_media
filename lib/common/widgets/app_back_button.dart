import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile/common/utils/app_colors.dart';
import 'package:mobile/common/providers/theme_provider.dart';
import 'package:provider/provider.dart';

class AppBackButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Color? iconColor;
  final double? iconSize;
  final EdgeInsets? padding;

  const AppBackButton({
    super.key,
    this.onPressed,
    this.iconColor,
    this.iconSize,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;

    return IconButton(
      icon: Icon(
        Icons.arrow_back,
        color:
            iconColor ??
            (isDarkMode ? AppColors.textDarkDark : AppColors.textDarkLight),
        size: iconSize ?? 24.sp,
      ),
      padding: padding ?? EdgeInsets.zero,
      onPressed: onPressed ?? () => Navigator.of(context).pop(),
    );
  }
}

// Helper mixin để thêm nút quay lại vào AppBar
mixin AppBarBackButtonMixin<T extends StatefulWidget> on State<T> {
  // Tạo AppBar với nút quay lại
  PreferredSizeWidget createAppBarWithBackButton({
    required BuildContext context,
    required String title,
    bool isDarkMode = false,
    List<Widget>? actions,
    double? elevation,
    PreferredSizeWidget? bottom,
    bool centerTitle = true,
    TextStyle? titleStyle,
    Widget? leadingWidget,
    VoidCallback? onBackButtonPressed,
  }) {
    return AppBar(
      elevation: elevation ?? 0,
      backgroundColor: isDarkMode ? AppColors.cardDark : AppColors.cardLight,
      leading: leadingWidget ?? AppBackButton(onPressed: onBackButtonPressed),
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
