import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile/common/providers/theme_provider.dart';
import 'package:mobile/common/utils/app_colors_improved.dart';
import 'package:mobile/common/utils/app_constants.dart';
import 'package:provider/provider.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTabSelected;
  final VoidCallback onCreatePostTap;

  const CustomBottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onTabSelected,
    required this.onCreatePostTap,
  });
  @override
  Widget build(BuildContext context) {
    final isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;

    return Container(
      height: 78.h, // Increased height to match the nav item height changes
      decoration: BoxDecoration(
        color: isDarkMode ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.r),
          topRight: Radius.circular(20.r),
        ),
        boxShadow: [
          BoxShadow(
            color:
                isDarkMode
                    ? Colors.black.withOpacity(0.2)
                    : Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(AppConstants.navItems.length, (index) {
          final item = AppConstants.navItems[index];
          final bool isSelected = selectedIndex == index;

          // Create post button has special styling
          if (index == 2) {
            return _buildCreatePostButton(context, isDarkMode);
          }

          return _buildNavItem(context, isDarkMode, item, index, isSelected);
        }),
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context,
    bool isDarkMode,
    Map<String, dynamic> item,
    int index,
    bool isSelected,
  ) {
    return InkWell(
      onTap: () => onTabSelected(index),
      child: Container(
        width: 70.w,
        height: 60.h, // Increased height to accommodate content
        padding: EdgeInsets.symmetric(
          vertical: 6.h,
        ), // Reduced vertical padding
        decoration:
            isSelected
                ? BoxDecoration(
                  borderRadius: BorderRadius.circular(15.r),
                  color:
                      isDarkMode
                          ? AppColors.primaryDark.withOpacity(0.15)
                          : AppColors.primaryLight.withOpacity(0.15),
                )
                : null,
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center, // Center content vertically
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? item['activeIcon'] : item['icon'],
              size: 22.h, // Slightly reduced icon size
              color:
                  isSelected
                      ? isDarkMode
                          ? AppColors.primaryDark
                          : AppColors.primaryLight
                      : isDarkMode
                      ? AppColors.textLightDark
                      : AppColors.textLightLight,
            ),
            SizedBox(height: 3.h), // Slightly reduced spacing
            Text(
              item['label'],
              style: TextStyle(
                fontSize: 10.sp,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                color:
                    isSelected
                        ? isDarkMode
                            ? AppColors.primaryDark
                            : AppColors.primaryLight
                        : isDarkMode
                        ? AppColors.textLightDark
                        : AppColors.textLightLight,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCreatePostButton(BuildContext context, bool isDarkMode) {
    return InkWell(
      onTap: onCreatePostTap,
      child: Container(
        width: 56.w,
        height: 56.h,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors:
                isDarkMode
                    ? AppColors.primaryGradientDark
                    : AppColors.primaryGradientLight,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color:
                  isDarkMode
                      ? AppColors.primaryDark.withOpacity(0.3)
                      : AppColors.primaryLight.withOpacity(0.4),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Icon(Icons.add, color: Colors.white, size: 28.h),
      ),
    );
  }
}
