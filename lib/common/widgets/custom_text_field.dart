import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile/common/utils/app_colors.dart';
import 'package:mobile/common/utils/app_style.dart';
import 'package:mobile/common/providers/theme_provider.dart';
import 'package:provider/provider.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final bool isPassword;
  final TextInputType keyboardType;
  final int? maxLines;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final TextInputAction textInputAction;
  final FocusNode? focusNode;
  final Function(String)? onChanged;
  final Function(String)? onSubmitted;
  final String? Function(String?)? validator;
  final double? borderRadius;
  final EdgeInsetsGeometry? contentPadding;
  final bool filled;
  final Color? fillColor;
  final InputBorder? border;
  final InputBorder? enabledBorder;
  final InputBorder? focusedBorder;

  const CustomTextField({
    super.key,
    required this.hintText,
    required this.controller,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
    this.maxLines = 1,
    this.prefixIcon,
    this.suffixIcon,
    this.textInputAction = TextInputAction.next,
    this.focusNode,
    this.onChanged,
    this.onSubmitted,
    this.validator,
    this.borderRadius,
    this.contentPadding,
    this.filled = false,
    this.fillColor,
    this.border,
    this.enabledBorder,
    this.focusedBorder,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;

    return TextFormField(
      controller: controller,
      obscureText: isPassword,
      keyboardType: keyboardType,
      maxLines: maxLines,
      focusNode: focusNode,
      textInputAction: textInputAction,
      onChanged: onChanged,
      onFieldSubmitted: onSubmitted,
      validator: validator,
      style: AppStyle.textStyle(
        14,
        isDarkMode ? AppColors.textDarkDark : AppColors.textDarkLight,
        FontWeight.normal,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        hintStyle: AppStyle.textStyle(
          14,
          isDarkMode ? AppColors.textLightDark : AppColors.textLightLight,
          FontWeight.normal,
        ),
        contentPadding:
            contentPadding ??
            EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
        fillColor:
            fillColor ?? (isDarkMode ? AppColors.cardDark : AppColors.white),
        filled: filled || true,
        border:
            border ??
            OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius ?? 12),
              borderSide: BorderSide(
                color:
                    isDarkMode ? AppColors.dividerDark : AppColors.dividerLight,
                width: 1,
              ),
            ),
        enabledBorder:
            enabledBorder ??
            OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius ?? 12),
              borderSide: BorderSide(
                color:
                    isDarkMode ? AppColors.dividerDark : AppColors.dividerLight,
                width: 1,
              ),
            ),
        focusedBorder:
            focusedBorder ??
            OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius ?? 12),
              borderSide: BorderSide(
                color:
                    isDarkMode ? AppColors.primaryDark : AppColors.primaryLight,
                width: 1.5,
              ),
            ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius ?? 12),
          borderSide: BorderSide(
            color: isDarkMode ? AppColors.errorDark : AppColors.errorLight,
            width: 1,
          ),
        ),
      ),
    );
  }
}
