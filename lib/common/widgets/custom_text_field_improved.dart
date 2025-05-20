import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile/common/utils/app_colors_improved.dart';
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
  final String? labelText;
  final bool readOnly;
  final VoidCallback? onTap;
  final List<TextInputFormatter>? inputFormatters;
  final bool showLabel;
  final bool enableShadow;
  final bool transparent;
  final EdgeInsetsGeometry? contentPadding;

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
    this.labelText,
    this.readOnly = false,
    this.onTap,
    this.inputFormatters,
    this.showLabel = false,
    this.enableShadow = true,
    this.transparent = false,
    this.contentPadding,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showLabel && labelText != null)
          Padding(
            padding: EdgeInsets.only(left: 4.w, bottom: 8.h),
            child: Text(
              labelText!,
              style: AppStyle.textStyle(
                14,
                isDarkMode
                    ? AppColors.textMediumDark
                    : AppColors.textMediumLight,
                FontWeight.w500,
              ),
            ),
          ),
        Container(
          decoration:
              enableShadow
                  ? BoxDecoration(
                    borderRadius: BorderRadius.circular(16.r),
                    boxShadow: [
                      BoxShadow(
                        color:
                            isDarkMode
                                ? Colors.black.withOpacity(0.15)
                                : AppColors.shadowColorLight,
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  )
                  : null,
          child: TextFormField(
            controller: controller,
            obscureText: isPassword,
            keyboardType: keyboardType,
            maxLines: maxLines,
            focusNode: focusNode,
            textInputAction: textInputAction,
            readOnly: readOnly,
            onTap: onTap,
            inputFormatters: inputFormatters,
            style: AppStyle.textStyle(
              15,
              isDarkMode ? AppColors.textDarkDark : AppColors.textDarkLight,
              FontWeight.normal,
            ),
            decoration: InputDecoration(
              hintText: hintText,
              labelText: showLabel ? null : labelText,
              prefixIcon:
                  prefixIcon != null
                      ? Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12.w),
                        child: prefixIcon,
                      )
                      : null,
              prefixIconConstraints: BoxConstraints(minWidth: 24.w),
              suffixIcon:
                  suffixIcon != null
                      ? Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12.w),
                        child: suffixIcon,
                      )
                      : null,
              suffixIconConstraints: BoxConstraints(minWidth: 24.w),
              hintStyle: AppStyle.textStyle(
                15,
                isDarkMode ? AppColors.textLightDark : AppColors.textLightLight,
                FontWeight.normal,
              ),
              labelStyle: AppStyle.textStyle(
                14,
                isDarkMode
                    ? AppColors.textMediumDark
                    : AppColors.textMediumLight,
                FontWeight.normal,
              ),
              contentPadding:
                  contentPadding ??
                  EdgeInsets.symmetric(vertical: 18.h, horizontal: 20.w),
              fillColor:
                  transparent
                      ? Colors.transparent
                      : isDarkMode
                      ? AppColors.cardDark
                      : Colors.white,
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16.r),
                borderSide:
                    transparent
                        ? BorderSide.none
                        : BorderSide(
                          color:
                              isDarkMode
                                  ? AppColors.dividerDark
                                  : AppColors.dividerLight,
                          width: 1,
                        ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16.r),
                borderSide:
                    transparent
                        ? BorderSide.none
                        : BorderSide(
                          color:
                              isDarkMode
                                  ? AppColors.dividerDark
                                  : AppColors.dividerLight,
                          width: 1,
                        ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16.r),
                borderSide:
                    transparent
                        ? BorderSide.none
                        : BorderSide(
                          color:
                              isDarkMode
                                  ? AppColors.primaryDark
                                  : AppColors.primaryLight,
                          width: 1.5,
                        ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16.r),
                borderSide: BorderSide(
                  color:
                      isDarkMode ? AppColors.errorDark : AppColors.errorLight,
                  width: 1,
                ),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16.r),
                borderSide: BorderSide(
                  color:
                      isDarkMode ? AppColors.errorDark : AppColors.errorLight,
                  width: 1.5,
                ),
              ),
              errorStyle: AppStyle.textStyle(
                12,
                isDarkMode ? AppColors.errorDark : AppColors.errorLight,
                FontWeight.normal,
              ),
            ),
            onChanged: onChanged,
            onFieldSubmitted: onSubmitted,
            validator: validator,
          ),
        ),
      ],
    );
  }
}
