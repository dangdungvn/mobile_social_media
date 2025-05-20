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

  void _login() {
    if (_formKey.currentState!.validate()) {
      // Authenticate user and set login state
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      authProvider.login().then((_) {
        // Navigate to main screen after successful login
        context.go(AppConstants.routeMain);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;

    return Scaffold(
      body: Container(
        decoration: AppStyle.gradientBoxDecoration(context, isDarkMode),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // App Logo
                      Container(
                        width: 100.w,
                        height: 100.h,
                        decoration: BoxDecoration(
                          color:
                              isDarkMode
                                  ? AppColors.cardDark
                                  : AppColors.cardLight,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color:
                                  isDarkMode
                                      ? AppColors.primaryDark.withOpacity(0.5)
                                      : AppColors.primaryLight.withOpacity(0.3),
                              blurRadius: 15,
                              spreadRadius: 3,
                            ),
                          ],
                        ),
                        child: Center(
                          child: Icon(
                            Icons.connect_without_contact,
                            size: 60.sp,
                            color:
                                isDarkMode
                                    ? AppColors.primaryDark
                                    : AppColors.primaryLight,
                          ),
                        ),
                      ),

                      SizedBox(height: 24.h),

                      // App name
                      Text(
                        AppConstants.appName,
                        style: AppStyle.textStyle(
                          28,
                          isDarkMode
                              ? AppColors.textDarkDark
                              : AppColors.textDarkLight,
                          FontWeight.bold,
                        ),
                      ),

                      SizedBox(height: 48.h),

                      // Email field
                      CustomTextField(
                        controller: _emailController,
                        hintText: "Email",
                        prefixIcon: Icon(Icons.email_outlined),
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

                      SizedBox(height: 16.h), // Password field
                      CustomTextField(
                        controller: _passwordController,
                        hintText: "Password",
                        prefixIcon: Icon(Icons.lock_outline),
                        isPassword: !_isPasswordVisible,
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

                      SizedBox(height: 8.h),

                      // Forgot password
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            // Handle forgot password
                          },
                          child: Text(
                            "Forgot Password?",
                            style: AppStyle.textStyle(
                              14,
                              isDarkMode
                                  ? AppColors.secondaryDark
                                  : AppColors.secondaryLight,
                              FontWeight.w500,
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 24.h),

                      // Login button
                      CustomButton(
                        text: "Login",
                        onPressed: _login,
                        isFullWidth: true,
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
