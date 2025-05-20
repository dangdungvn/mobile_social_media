import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:mobile/common/providers/theme_provider.dart';
import 'package:mobile/common/utils/app_colors.dart';
import 'package:mobile/common/utils/app_constants.dart';
import 'package:mobile/common/utils/app_style.dart';
import 'package:mobile/features/auth/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeInAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    _fadeInAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.2, 0.8, curve: Curves.easeIn),
      ),
    );
    _controller.forward();

    // Navigate after animation completes based on authentication status
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        // Check if user is logged in
        Future.delayed(Duration(milliseconds: 500), () {
          final authProvider = Provider.of<AuthProvider>(
            context,
            listen: false,
          );
          if (authProvider.isAuthenticated) {
            // User is authenticated, go to main screen
            context.go(AppConstants.routeMain);
          } else {
            // User is not authenticated, go to login screen
            context.go(AppConstants.routeLogin);
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;

    return Scaffold(
      body: Container(
        decoration: AppStyle.gradientBoxDecoration(context, isDarkMode),
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // App icon/logo
                FadeTransition(
                  opacity: _fadeInAnimation,
                  child: Container(
                    width: 120.w,
                    height: 120.h,
                    decoration: BoxDecoration(
                      color:
                          isDarkMode ? AppColors.cardDark : AppColors.cardLight,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color:
                              isDarkMode
                                  ? AppColors.primaryDark.withOpacity(0.5)
                                  : AppColors.primaryLight.withOpacity(0.3),
                          blurRadius: 20,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: Center(
                      child: Icon(
                        Icons.connect_without_contact,
                        size: 70.sp,
                        color:
                            isDarkMode
                                ? AppColors.primaryDark
                                : AppColors.primaryLight,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 32.h),

                // App name
                FadeTransition(
                  opacity: _fadeInAnimation,
                  child: Text(
                    AppConstants.appName,
                    style: AppStyle.textStyle(
                      32,
                      isDarkMode
                          ? AppColors.textDarkDark
                          : AppColors.textDarkLight,
                      FontWeight.bold,
                    ),
                  ),
                ),

                SizedBox(height: 16.h),

                // App slogan
                FadeTransition(
                  opacity: _fadeInAnimation,
                  child: Text(
                    "Connect, Share, Discover",
                    style: AppStyle.textStyle(
                      16,
                      isDarkMode
                          ? AppColors.textMediumDark
                          : AppColors.textMediumLight,
                      FontWeight.w500,
                    ),
                  ),
                ),

                SizedBox(height: 64.h),

                // Loading animation
                SizedBox(
                  height: 60.h,
                  width: 60.w,
                  child: CircularProgressIndicator(
                    color:
                        isDarkMode
                            ? AppColors.secondaryDark
                            : AppColors.secondaryLight,
                    strokeWidth: 6.w,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
