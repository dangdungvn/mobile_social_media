import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/common/providers/theme_provider.dart';
import 'package:mobile/common/utils/app_colors.dart';
import 'package:mobile/common/utils/app_constants.dart';
import 'package:mobile/common/utils/app_style.dart';
import 'package:mobile/common/widgets/custom_button.dart';
import 'package:mobile/common/widgets/custom_text_field.dart';
import 'package:mobile/features/auth/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  @override
  void dispose() {
    _fullNameController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _register() async {
    if (_formKey.currentState!.validate()) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      // Show progress indicator during registration
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Creating your account...'),
          duration: Duration(seconds: 1),
        ),
      );

      try {
        final success = await authProvider.register(
          username: _usernameController.text.trim(),
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
          fullName: _fullNameController.text.trim(),
        );

        if (success) {
          // Navigate to main screen after successful registration
          context.go(AppConstants.routeMain);
        } else {
          // Show error message
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(authProvider.error ?? 'Registration failed'),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Back button
                  Align(
                    alignment: Alignment.topLeft,
                    child: Container(
                      margin: EdgeInsets.only(top: 8.h),
                      decoration: BoxDecoration(
                        color:
                            isDarkMode
                                ? AppColors.cardDark.withOpacity(0.7)
                                : AppColors.backgroundLight,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 8,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: Icon(
                          Icons.arrow_back_ios_new,
                          size: 18.sp,
                          color:
                              isDarkMode
                                  ? AppColors.textDarkDark
                                  : AppColors.textDarkLight,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 16.h),

                  // App Logo
                  Image.asset(
                    'assets/images/logo.png',
                    errorBuilder:
                        (context, error, stackTrace) => Container(
                          width: 100.w,
                          height: 100.h,
                          decoration: BoxDecoration(
                            color: AppColors.backgroundLight,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color:
                                    isDarkMode
                                        ? AppColors.primaryDark.withOpacity(0.3)
                                        : AppColors.primaryLight.withOpacity(
                                          0.2,
                                        ),
                                blurRadius: 12,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: Center(
                            child: Icon(
                              Icons.people_alt_rounded,
                              size: 60.sp,
                              color:
                                  isDarkMode
                                      ? AppColors.primaryDark
                                      : AppColors.primaryLight,
                            ),
                          ),
                        ),
                    height: 100.h,
                  ),

                  SizedBox(height: 20.h),

                  // App name
                  Text(
                    "CREATE ACCOUNT",
                    style: TextStyle(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w900,
                      fontFamily: 'Ubuntu-Regular',
                      color:
                          isDarkMode
                              ? AppColors.textDarkDark
                              : AppColors.textDarkLight,
                    ),
                  ),

                  SizedBox(height: 8.h),

                  Text(
                    "Join our social community",
                    style: TextStyle(
                      fontSize: 16.sp,
                      color:
                          isDarkMode
                              ? AppColors.textMediumDark
                              : AppColors.textMediumLight,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  SizedBox(height: 30.h),

                  // Full Name field
                  Container(
                    margin: EdgeInsets.only(bottom: 16.h),
                    decoration: BoxDecoration(
                      color: isDarkMode ? AppColors.cardDark : Colors.white,
                      borderRadius: BorderRadius.circular(30.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          blurRadius: 10,
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                    child: CustomTextField(
                      controller: _fullNameController,
                      hintText: "Full Name",
                      prefixIcon: Icon(
                        Icons.person_outline,
                        size: 20.sp,
                        color:
                            isDarkMode
                                ? AppColors.textMediumDark
                                : AppColors.textMediumLight,
                      ),
                      borderRadius: 30.r,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 20.w,
                        vertical: 16.h,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter your full name";
                        }
                        return null;
                      },
                    ),
                  ),

                  // Username field
                  Container(
                    margin: EdgeInsets.only(bottom: 16.h),
                    decoration: BoxDecoration(
                      color: isDarkMode ? AppColors.cardDark : Colors.white,
                      borderRadius: BorderRadius.circular(30.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          blurRadius: 10,
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                    child: CustomTextField(
                      controller: _usernameController,
                      hintText: "Username",
                      prefixIcon: Icon(
                        Icons.alternate_email,
                        size: 20.sp,
                        color:
                            isDarkMode
                                ? AppColors.textMediumDark
                                : AppColors.textMediumLight,
                      ),
                      borderRadius: 30.r,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 20.w,
                        vertical: 16.h,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter a username";
                        }
                        if (value.contains(' ')) {
                          return "Username cannot contain spaces";
                        }
                        return null;
                      },
                    ),
                  ),

                  // Email field
                  Container(
                    margin: EdgeInsets.only(bottom: 16.h),
                    decoration: BoxDecoration(
                      color: isDarkMode ? AppColors.cardDark : Colors.white,
                      borderRadius: BorderRadius.circular(30.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          blurRadius: 10,
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                    child: CustomTextField(
                      controller: _emailController,
                      hintText: "Email",
                      prefixIcon: Icon(
                        Icons.email_outlined,
                        size: 20.sp,
                        color:
                            isDarkMode
                                ? AppColors.textMediumDark
                                : AppColors.textMediumLight,
                      ),
                      borderRadius: 30.r,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 20.w,
                        vertical: 16.h,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter your email";
                        }
                        if (!RegExp(
                          r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                        ).hasMatch(value)) {
                          return "Please enter a valid email";
                        }
                        return null;
                      },
                    ),
                  ),

                  // Password field
                  Container(
                    margin: EdgeInsets.only(bottom: 16.h),
                    decoration: BoxDecoration(
                      color: isDarkMode ? AppColors.cardDark : Colors.white,
                      borderRadius: BorderRadius.circular(30.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          blurRadius: 10,
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                    child: CustomTextField(
                      controller: _passwordController,
                      hintText: "Password",
                      prefixIcon: Icon(
                        Icons.lock_outline,
                        size: 20.sp,
                        color:
                            isDarkMode
                                ? AppColors.textMediumDark
                                : AppColors.textMediumLight,
                      ),
                      isPassword: !_isPasswordVisible,
                      borderRadius: 30.r,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 20.w,
                        vertical: 16.h,
                      ),
                      suffixIcon: GestureDetector(
                        onTap: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                        child: Icon(
                          _isPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          size: 20.sp,
                          color:
                              isDarkMode
                                  ? AppColors.textMediumDark
                                  : AppColors.textMediumLight,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter your password";
                        }
                        if (value.length < 6) {
                          return "Password must be at least 6 characters";
                        }
                        return null;
                      },
                    ),
                  ),

                  // Confirm Password field
                  Container(
                    margin: EdgeInsets.only(bottom: 16.h),
                    decoration: BoxDecoration(
                      color: isDarkMode ? AppColors.cardDark : Colors.white,
                      borderRadius: BorderRadius.circular(30.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          blurRadius: 10,
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                    child: CustomTextField(
                      controller: _confirmPasswordController,
                      hintText: "Confirm Password",
                      prefixIcon: Icon(
                        Icons.lock_outline,
                        size: 20.sp,
                        color:
                            isDarkMode
                                ? AppColors.textMediumDark
                                : AppColors.textMediumLight,
                      ),
                      isPassword: !_isConfirmPasswordVisible,
                      borderRadius: 30.r,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 20.w,
                        vertical: 16.h,
                      ),
                      suffixIcon: GestureDetector(
                        onTap: () {
                          setState(() {
                            _isConfirmPasswordVisible =
                                !_isConfirmPasswordVisible;
                          });
                        },
                        child: Icon(
                          _isConfirmPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          size: 20.sp,
                          color:
                              isDarkMode
                                  ? AppColors.textMediumDark
                                  : AppColors.textMediumLight,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please confirm your password";
                        }
                        if (value != _passwordController.text) {
                          return "Passwords do not match";
                        }
                        return null;
                      },
                    ),
                  ),

                  SizedBox(height: 20.h),

                  // Register button
                  GestureDetector(
                    onTap: _register,
                    child: Container(
                      height: 50.h,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30.r),
                        gradient: LinearGradient(
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft,
                          colors: [
                            isDarkMode
                                ? AppColors.buttonGradientStartDark
                                : AppColors.buttonGradientStartLight,
                            isDarkMode
                                ? AppColors.buttonGradientEndDark
                                : AppColors.buttonGradientEndLight,
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color:
                                isDarkMode
                                    ? AppColors.primaryDark.withOpacity(0.3)
                                    : AppColors.primaryLight.withOpacity(0.3),
                            blurRadius: 10,
                            spreadRadius: 0,
                            offset: Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          "CREATE ACCOUNT",
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 24.h),

                  // OR divider
                  Row(
                    children: [
                      Expanded(
                        child: Divider(
                          color:
                              isDarkMode
                                  ? AppColors.dividerDark
                                  : AppColors.dividerLight,
                          thickness: 1,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: Text(
                          "OR",
                          style: AppStyle.textStyle(
                            14,
                            isDarkMode
                                ? AppColors.textLightDark
                                : AppColors.textLightLight,
                            FontWeight.w500,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          color:
                              isDarkMode
                                  ? AppColors.dividerDark
                                  : AppColors.dividerLight,
                          thickness: 1,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 20.h),

                  // Register link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already have an account? ",
                        style: AppStyle.textStyle(
                          14,
                          isDarkMode
                              ? AppColors.textMediumDark
                              : AppColors.textMediumLight,
                          FontWeight.w400,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          context.go(AppConstants.routeLogin);
                        },
                        child: Text(
                          "Login",
                          style: AppStyle.textStyle(
                            14,
                            isDarkMode
                                ? AppColors.secondaryDark
                                : AppColors.secondaryLight,
                            FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),

                  // Theme toggle button
                  TextButton.icon(
                    onPressed: () {
                      final themeProvider = Provider.of<ThemeProvider>(
                        context,
                        listen: false,
                      );
                      themeProvider.toggleTheme();
                    },
                    icon: Icon(
                      isDarkMode ? Icons.light_mode : Icons.dark_mode,
                      color:
                          isDarkMode
                              ? AppColors.accentDark
                              : AppColors.accentLight,
                    ),
                    label: Text(
                      isDarkMode ? "Light Mode" : "Dark Mode",
                      style: AppStyle.textStyle(
                        14,
                        isDarkMode
                            ? AppColors.accentDark
                            : AppColors.accentLight,
                        FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
