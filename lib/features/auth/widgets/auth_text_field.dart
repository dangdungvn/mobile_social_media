import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile/common/providers/theme_provider.dart';
import 'package:mobile/common/utils/app_colors_improved.dart';
import 'package:mobile/common/utils/app_style.dart';
import 'package:provider/provider.dart';

class AuthTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final String? labelText;
  final bool isPassword;
  final bool isError;
  final String? errorText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final Function(String)? onSubmitted;
  final Function(String)? onChanged;
  final String? Function(String?)? validator;
  final List<TextInputFormatter>? inputFormatters;
  final bool autofocus;
  final FocusNode? focusNode;
  final int? maxLines;
  final int? maxLength;

  const AuthTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.labelText,
    this.isPassword = false,
    this.isError = false,
    this.errorText,
    this.prefixIcon,
    this.suffixIcon,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.onSubmitted,
    this.onChanged,
    this.validator,
    this.inputFormatters,
    this.autofocus = false,
    this.focusNode,
    this.maxLines = 1,
    this.maxLength,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (labelText != null)
          Padding(
            padding: EdgeInsets.only(left: 4.w, bottom: 8.h),
            child: Text(
              labelText!,
              style: AppStyle.textStyle(
                14,
                isDarkMode ? AppColors.textDarkDark : AppColors.textDarkLight,
                FontWeight.w600,
              ),
            ),
          ),
        Container(
          decoration: BoxDecoration(
            color:
                isDarkMode
                    ? AppColors.backgroundDark.withOpacity(0.5)
                    : AppColors.backgroundLight.withOpacity(0.7),
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color:
                  isError
                      ? AppColors.errorLight
                      : isDarkMode
                      ? AppColors.dividerDark
                      : AppColors.dividerLight,
              width: isError ? 1.5 : 1,
            ),
            boxShadow:
                !isError
                    ? [
                      BoxShadow(
                        color:
                            isDarkMode
                                ? Colors.black.withOpacity(0.1)
                                : AppColors.shadowColorLight,
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ]
                    : null,
          ),
          child: TextFormField(
            controller: controller,
            obscureText: isPassword,
            keyboardType: keyboardType,
            textInputAction: textInputAction,
            onFieldSubmitted: onSubmitted,
            onChanged: onChanged,
            validator: validator,
            inputFormatters: inputFormatters,
            autofocus: autofocus,
            focusNode: focusNode,
            maxLines: maxLines,
            maxLength: maxLength,
            style: AppStyle.textStyle(
              16,
              isDarkMode ? AppColors.textDarkDark : AppColors.textDarkLight,
              FontWeight.normal,
            ),
            cursorColor:
                isDarkMode ? AppColors.primaryDark : AppColors.primaryLight,
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: AppStyle.textStyle(
                16,
                isDarkMode ? AppColors.textLightDark : AppColors.textLightLight,
                FontWeight.normal,
              ),
              prefixIcon: prefixIcon,
              suffixIcon: suffixIcon,
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16.w,
                vertical: 16.h,
              ),
              counterText: "",
            ),
          ),
        ),
        if (isError && errorText != null)
          Padding(
            padding: EdgeInsets.only(left: 16.w, top: 8.h),
            child: Row(
              children: [
                Icon(
                  Icons.error_outline,
                  color: AppColors.errorLight,
                  size: 14.sp,
                ),
                SizedBox(width: 8.w),
                Text(
                  errorText!,
                  style: AppStyle.textStyle(
                    12,
                    AppColors.errorLight,
                    FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
