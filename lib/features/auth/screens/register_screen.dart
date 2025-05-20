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

  void _register() {
    if (_formKey.currentState!.validate()) {
      // Authenticate user and set login state
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      authProvider.login().then((_) {
        // Navigate to main screen after successful registration
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
                      // Back button
                      Align(
                        alignment: Alignment.topLeft,
                        child: IconButton(
                          onPressed: () => context.go(AppConstants.routeLogin),
                          icon: Icon(
                            Icons.arrow_back_ios_new,
                            color:
                                isDarkMode
                                    ? AppColors.textDarkDark
                                    : AppColors.textDarkLight,
                          ),
                        ),
                      ),

                      SizedBox(height: 16.h),

                      // App Logo
                      Container(
                        width: 80.w,
                        height: 80.h,
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
                            size: 50.sp,
                            color:
                                isDarkMode
                                    ? AppColors.primaryDark
                                    : AppColors.primaryLight,
                          ),
                        ),
                      ),

                      SizedBox(height: 16.h),

                      // Register Title
                      Text(
                        "Create Account",
                        style: AppStyle.textStyle(
                          24,
                          isDarkMode
                              ? AppColors.textDarkDark
                              : AppColors.textDarkLight,
                          FontWeight.bold,
                        ),
                      ),

                      SizedBox(height: 8.h),

                      // Subtitle
                      Text(
                        "Join our community today!",
                        style: AppStyle.textStyle(
                          14,
                          isDarkMode
                              ? AppColors.textMediumDark
                              : AppColors.textMediumLight,
                          FontWeight.w400,
                        ),
                      ),

                      SizedBox(height: 32.h),

                      // Full Name field
                      CustomTextField(
                        controller: _fullNameController,
                        hintText: "Full Name",
                        prefixIcon: Icon(Icons.person_outline),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter your full name";
                          }
                          return null;
                        },
                      ),

                      SizedBox(height: 16.h),

                      // Username field
                      CustomTextField(
                        controller: _usernameController,
                        hintText: "Username",
                        prefixIcon: Icon(Icons.alternate_email),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter a username";
                          }
                          if (value.length < 3) {
                            return "Username must be at least 3 characters";
                          }
                          return null;
                        },
                      ),

                      SizedBox(height: 16.h),

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

                      SizedBox(height: 16.h), // Confirm Password field
                      CustomTextField(
                        controller: _confirmPasswordController,
                        hintText: "Confirm Password",
                        prefixIcon: Icon(Icons.lock_outline),
                        isPassword: !_isConfirmPasswordVisible,
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

                      SizedBox(height: 32.h),

                      // Register button
                      CustomButton(
                        text: "Register",
                        onPressed: _register,
                        isFullWidth: true,
                      ),

                      SizedBox(height: 24.h),

                      // Terms and conditions
                      Text(
                        "By registering, you agree to our Terms of Service and Privacy Policy",
                        textAlign: TextAlign.center,
                        style: AppStyle.textStyle(
                          12,
                          isDarkMode
                              ? AppColors.textLightDark
                              : AppColors.textLightLight,
                          FontWeight.w400,
                        ),
                      ),

                      SizedBox(height: 24.h),

                      // Login link
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
        ),
      ),
    );
  }
}
