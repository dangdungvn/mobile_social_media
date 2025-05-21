import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile/common/providers/theme_provider.dart';
import 'package:mobile/common/utils/app_colors.dart';
import 'package:mobile/common/utils/app_constants.dart';
import 'package:mobile/features/feed/screens/create_post_screen.dart';
import 'package:mobile/features/feed/screens/news_feed_screen.dart';
import 'package:mobile/features/search/screens/search_screen.dart';
import 'package:mobile/features/chat/screens/chat_list_screen.dart';
import 'package:mobile/features/profile/screens/profile_screen.dart';
import 'package:provider/provider.dart';
import 'package:animations/animations.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  final List<Widget> _screens = [
    const NewsFeedScreen(),
    const SearchScreen(),
    const CreatePostScreen(),
    const ChatListScreen(),
    const ProfileScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    final isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;

    return Scaffold(
      body: PageTransitionSwitcher(
        transitionBuilder: (child, animation, secondaryAnimation) {
          return FadeThroughTransition(
            animation: animation,
            secondaryAnimation: secondaryAnimation,
            child: child,
          );
        },
        child: _screens[_selectedIndex],
      ),
      floatingActionButton:
          _selectedIndex != 2
              ? null
              : FloatingActionButton(
                backgroundColor:
                    isDarkMode ? AppColors.cardDark : AppColors.cardLight,
                onPressed: _showCreatePostOptions,
                child: Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
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
                  ),
                  child: Icon(Icons.add, color: Colors.white),
                ),
              ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: isDarkMode ? AppColors.cardDark : AppColors.cardLight,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              spreadRadius: 0,
            ),
          ],
        ),
        child: BottomAppBar(
          shape: CircularNotchedRectangle(),
          notchMargin: 8.0,
          color: isDarkMode ? AppColors.cardDark : AppColors.cardLight,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children:
                AppConstants.navItems.asMap().entries.map((entry) {
                  int index = entry.key;
                  Map<String, dynamic> item = entry.value;

                  // Skip center item which is handled by FloatingActionButton
                  if (index == 2) return Spacer();

                  return Expanded(
                    child: InkWell(
                      onTap: () => setState(() => _selectedIndex = index),
                      child: SizedBox(
                        height: 60.h,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              _selectedIndex == index
                                  ? item['activeIcon']
                                  : item['icon'],
                              color:
                                  _selectedIndex == index
                                      ? isDarkMode
                                          ? AppColors.primaryDark
                                          : AppColors.primaryLight
                                      : isDarkMode
                                      ? AppColors.textLightDark
                                      : AppColors.textLightLight,
                              size: 26.sp,
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              item['label'],
                              style: TextStyle(
                                fontSize: 11.sp,
                                color:
                                    _selectedIndex == index
                                        ? isDarkMode
                                            ? AppColors.primaryDark
                                            : AppColors.primaryLight
                                        : isDarkMode
                                        ? AppColors.textLightDark
                                        : AppColors.textLightLight,
                                fontWeight:
                                    _selectedIndex == index
                                        ? FontWeight.w600
                                        : FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
          ),
        ),
      ),
    );
  }

  void _showCreatePostOptions() {
    final isDarkMode =
        Provider.of<ThemeProvider>(context, listen: false).isDarkMode;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            color:
                isDarkMode
                    ? AppColors.backgroundDark
                    : AppColors.backgroundLight,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.r),
              topRight: Radius.circular(20.r),
            ),
          ),
          padding: EdgeInsets.all(24.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle indicator
              Container(
                width: 40.w,
                height: 5.h,
                decoration: BoxDecoration(
                  color:
                      isDarkMode
                          ? AppColors.dividerDark
                          : AppColors.dividerLight,
                  borderRadius: BorderRadius.circular(2.5.r),
                ),
              ),

              SizedBox(height: 24.h),

              // Title
              Text(
                "Create New Post",
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color:
                      isDarkMode
                          ? AppColors.textDarkDark
                          : AppColors.textDarkLight,
                ),
              ),

              SizedBox(height: 24.h),

              // Post options
              _buildPostOption(
                context,
                isDarkMode,
                Icons.text_fields_rounded,
                "Text Post",
                "Share your thoughts with others",
                () {
                  Navigator.pop(context);
                  setState(() {
                    _selectedIndex = 2; // Switch to create post screen
                  });
                },
              ),

              SizedBox(height: 16.h),

              _buildPostOption(
                context,
                isDarkMode,
                Icons.photo_library_outlined,
                "Photo Post",
                "Share images with your friends",
                () {
                  Navigator.pop(context);
                  setState(() {
                    _selectedIndex = 2; // Switch to create post screen
                  });
                  // For a real app, we'd pass data to the create post screen
                  // to indicate it should open the image picker
                },
              ),

              SizedBox(height: 16.h),

              _buildPostOption(
                context,
                isDarkMode,
                Icons.videocam_outlined,
                "Video Post",
                "Share videos with your friends",
                () {
                  Navigator.pop(context);
                  setState(() {
                    _selectedIndex = 2; // Switch to create post screen
                  });
                  // For a real app, we'd pass data to the create post screen
                  // to indicate it should open the video picker
                },
              ),

              SizedBox(height: 32.h),

              // Cancel button
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  decoration: BoxDecoration(
                    color:
                        isDarkMode ? AppColors.cardDark : AppColors.cardLight,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Center(
                    child: Text(
                      "Cancel",
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                        color:
                            isDarkMode
                                ? AppColors.textMediumDark
                                : AppColors.textMediumLight,
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 16.h),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPostOption(
    BuildContext context,
    bool isDarkMode,
    IconData icon,
    String title,
    String description,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: isDarkMode ? AppColors.cardDark : AppColors.cardLight,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              spreadRadius: 0,
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 50.w,
              height: 50.w,
              decoration: BoxDecoration(
                color:
                    isDarkMode
                        ? AppColors.primaryDark.withOpacity(0.1)
                        : AppColors.primaryLight.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color:
                    isDarkMode ? AppColors.primaryDark : AppColors.primaryLight,
                size: 24.sp,
              ),
            ),

            SizedBox(width: 16.w),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color:
                          isDarkMode
                              ? AppColors.textDarkDark
                              : AppColors.textDarkLight,
                    ),
                  ),

                  SizedBox(height: 4.h),

                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color:
                          isDarkMode
                              ? AppColors.textLightDark
                              : AppColors.textLightLight,
                    ),
                  ),
                ],
              ),
            ),

            Icon(
              Icons.chevron_right,
              color:
                  isDarkMode
                      ? AppColors.textMediumDark
                      : AppColors.textMediumLight,
            ),
          ],
        ),
      ),
    );
  }
}
