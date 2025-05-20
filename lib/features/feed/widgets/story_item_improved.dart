import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile/common/providers/theme_provider.dart';
import 'package:mobile/common/utils/app_colors_improved.dart';
import 'package:provider/provider.dart';

class StoryItemImproved extends StatelessWidget {
  final String username;
  final String imageUrl;
  final bool isViewed;
  final bool isAddStory;
  final VoidCallback onTap;

  const StoryItemImproved({
    super.key,
    required this.username,
    required this.imageUrl,
    this.isViewed = false,
    this.isAddStory = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 80.w,
        margin: EdgeInsets.only(right: 12.w),
        child: Column(
          children: [
            // Story avatar with border
            Container(
              padding: EdgeInsets.all(isAddStory ? 0 : 2.w),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient:
                    !isViewed && !isAddStory
                        ? LinearGradient(
                          colors:
                              isDarkMode
                                  ? [
                                    AppColors.secondaryDark,
                                    AppColors.primaryDark,
                                  ]
                                  : [
                                    AppColors.secondaryLight,
                                    AppColors.primaryLight,
                                  ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        )
                        : null,
                color:
                    isViewed && !isAddStory
                        ? (isDarkMode
                            ? AppColors.dividerDark
                            : AppColors.dividerLight)
                        : null,
                border:
                    isAddStory
                        ? Border.all(
                          color:
                              isDarkMode
                                  ? AppColors.dividerDark
                                  : AppColors.dividerLight,
                          width: 1.w,
                        )
                        : null,
              ),
              child: Container(
                width: 70.w,
                height: 70.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color:
                        isDarkMode ? AppColors.cardDark : AppColors.cardLight,
                    width: 2.w,
                  ),
                  color:
                      isAddStory
                          ? (isDarkMode
                              ? AppColors.backgroundDark
                              : AppColors.backgroundLight)
                          : null,
                ),
                child:
                    isAddStory
                        ? Center(
                          child: Icon(
                            Icons.add,
                            color:
                                isDarkMode
                                    ? AppColors.primaryDark
                                    : AppColors.primaryLight,
                            size: 28.sp,
                          ),
                        )
                        : ClipRRect(
                          borderRadius: BorderRadius.circular(35.r),
                          child: Image.network(
                            imageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Center(
                                child: Icon(
                                  Icons.person,
                                  color:
                                      isDarkMode
                                          ? AppColors.textLightDark
                                          : AppColors.textLightLight,
                                  size: 28.sp,
                                ),
                              );
                            },
                          ),
                        ),
              ),
            ),

            SizedBox(height: 6.h),

            // Username
            Text(
              isAddStory ? "Add Story" : username,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: isAddStory ? FontWeight.w600 : FontWeight.normal,
                color:
                    isDarkMode
                        ? AppColors.textMediumDark
                        : AppColors.textMediumLight,
                overflow: TextOverflow.ellipsis,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
            ),
          ],
        ),
      ),
    );
  }
}
