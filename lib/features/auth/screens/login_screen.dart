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

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() async {
    if (_formKey.currentState!.validate()) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      // Show progress indicator during login
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Logging in...'),
          duration: Duration(seconds: 1),
        ),
      );

      try {
        final success = await authProvider.login(
          _emailController.text.trim(),
          _passwordController.text.trim(),
        );

        if (success) {
          // Navigate to main screen after successful login
          context.go(AppConstants.routeMain);
        } else {
          // Show error message
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(authProvider.error ?? 'Login failed'),
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
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
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
                  // App Logo
                  Image.asset(
                    'assets/images/logo.png',
                    // Thay thế bằng đường dẫn thực tế đến logo của bạn
                    // Hoặc nếu không có logo, sử dụng widget dưới đây
                    errorBuilder:
                        (context, error, stackTrace) => Container(
                          width: 130.w,
                          height: 130.h,
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
                              size: 80.sp,
                              color:
                                  isDarkMode
                                      ? AppColors.primaryDark
                                      : AppColors.primaryLight,
                            ),
                          ),
                        ),
                    height: 130.h,
                  ),

                  SizedBox(height: 24.h), // App name
                  Text(
                    AppConstants.appName.toUpperCase(),
                    style: TextStyle(
                      fontSize: 28.sp,
                      fontWeight: FontWeight.w900,
                      fontFamily: 'Ubuntu-Regular',
                      color:
                          isDarkMode
                              ? AppColors.textDarkDark
                              : AppColors.textDarkLight,
                    ),
                  ),

                  SizedBox(height: 12.h),

                  Text(
                    "Welcome back!",
                    style: TextStyle(
                      fontSize: 16.sp,
                      color:
                          isDarkMode
                              ? AppColors.textMediumDark
                              : AppColors.textMediumLight,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  SizedBox(height: 40.h),

                  // Email field
                  Container(
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

                  SizedBox(height: 16.h),

                  // Password field
                  Container(
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
                  SizedBox(height: 10.h),

                  // Forgot password
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        // Handle forgot password
                      },
                      child: Text(
                        "Forgot Password?",
                        style: TextStyle(
                          fontSize: 14.sp,
                          color:
                              isDarkMode
                                  ? AppColors.secondaryDark
                                  : AppColors.primaryLight,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 30.h),

                  // Login button
                  GestureDetector(
                    onTap: _login,
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
                          "LOGIN",
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 30.h),

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

                  SizedBox(height: 24.h),

                  // Social login buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _socialLoginButton(
                        isDarkMode,
                        Icons.facebook,
                        AppColors.accentDark,
                      ),
                      SizedBox(width: 20.w),
                      _socialLoginButton(
                        isDarkMode,
                        Icons.g_mobiledata_rounded,
                        AppColors.errorLight,
                      ),
                      SizedBox(width: 20.w),
                      _socialLoginButton(
                        isDarkMode,
                        Icons.apple,
                        isDarkMode ? Colors.white : Colors.black,
                      ),
                    ],
                  ),

                  SizedBox(height: 32.h),

                  // Register link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account? ",
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
                          context.go(AppConstants.routeRegister);
                        },
                        child: Text(
                          "Register",
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

  Widget _socialLoginButton(bool isDarkMode, IconData icon, Color iconColor) {
    return InkWell(
      onTap: () {
        // Handle social login
      },
      borderRadius: BorderRadius.circular(50),
      child: Container(
        width: 50.w,
        height: 50.w, // Using w for both to keep it square
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isDarkMode ? AppColors.cardDark : AppColors.cardLight,
          boxShadow: [
            BoxShadow(
              color: isDarkMode ? Colors.black26 : Colors.grey.withOpacity(0.3),
              blurRadius: 10,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Center(child: Icon(icon, color: iconColor, size: 30.sp)),
      ),
    );
  }
}
