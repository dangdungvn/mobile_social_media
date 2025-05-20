import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile/common/providers/theme_provider.dart';
import 'package:mobile/common/utils/app_colors_improved.dart';
import 'package:mobile/common/utils/app_style.dart';
import 'package:mobile/features/auth/models/user_model.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

class SearchResultUserItem extends StatelessWidget {
  final UserModel user;
  final VoidCallback? onTap;
  final bool alreadyFollowing;

  const SearchResultUserItem({
    super.key,
    required this.user,
    this.onTap,
    this.alreadyFollowing = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        margin: EdgeInsets.only(bottom: 8.h),
        decoration: BoxDecoration(
          color: isDarkMode ? AppColors.cardDark : AppColors.cardLight,
          borderRadius: BorderRadius.circular(14.r),
          boxShadow: [
            BoxShadow(
              color:
                  isDarkMode
                      ? Colors.black.withOpacity(0.12)
                      : AppColors.shadowColorLight,
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
          border: Border.all(
            color: isDarkMode ? AppColors.dividerDark : AppColors.dividerLight,
            width: 0.5,
          ),
        ),
        child: Row(
          children: [
            // User Avatar with gradient border
            Container(
              width: 50.w,
              height: 50.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors:
                      isDarkMode
                          ? AppColors.secondaryGradientDark
                          : AppColors.secondaryGradientLight,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color:
                        isDarkMode
                            ? Colors.black.withOpacity(0.15)
                            : AppColors.shadowColorLight,
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              padding: EdgeInsets.all(2.w),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(25.r),
                child: CachedNetworkImage(
                  imageUrl:
                      user.profilePictureUrl ?? 'https://i.pravatar.cc/150',
                  fit: BoxFit.cover,
                  placeholder:
                      (context, url) => Container(
                        color:
                            isDarkMode
                                ? AppColors.backgroundDark
                                : AppColors.backgroundLight,
                        child: Center(
                          child: SizedBox(
                            width: 20.w,
                            height: 20.w,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.w,
                              color:
                                  isDarkMode
                                      ? AppColors.accentDark
                                      : AppColors.accentLight,
                            ),
                          ),
                        ),
                      ),
                  errorWidget:
                      (context, url, error) => Container(
                        color:
                            isDarkMode
                                ? AppColors.backgroundDark
                                : AppColors.backgroundLight,
                        child: Icon(
                          Icons.person,
                          color:
                              isDarkMode
                                  ? AppColors.textLightDark
                                  : AppColors.textLightLight,
                        ),
                      ),
                ),
              ),
            ),

            SizedBox(width: 16.w),

            // User info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Username and verification badge
                  Row(
                    children: [
                      Text(
                        user.fullName ?? user.username ?? "Unknown User",
                        style: AppStyle.textStyle(
                          16,
                          isDarkMode
                              ? AppColors.textDarkDark
                              : AppColors.textDarkLight,
                          FontWeight.w600,
                        ),
                      ),
                      if (user.isVerified) ...[
                        SizedBox(width: 4.w),
                        Icon(
                          Icons.verified,
                          size: 16.sp,
                          color:
                              isDarkMode
                                  ? AppColors.primaryDark
                                  : AppColors.primaryLight,
                        ),
                      ],
                    ],
                  ),

                  if (user.fullName != null) ...[
                    SizedBox(height: 4.h),
                    Text(
                      "@${user.username}",
                      style: AppStyle.textStyle(
                        14,
                        isDarkMode
                            ? AppColors.textMediumDark
                            : AppColors.textMediumLight,
                        FontWeight.w500,
                      ),
                    ),
                  ],

                  if (user.bio != null && user.bio!.isNotEmpty) ...[
                    SizedBox(height: 4.h),
                    Text(
                      user.bio!,
                      style: AppStyle.textStyle(
                        13,
                        isDarkMode
                            ? AppColors.textLightDark
                            : AppColors.textLightLight,
                        FontWeight.normal,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),

            // Follow/Following button
            Container(
              width: 90.w,
              height: 34.h,
              decoration: BoxDecoration(
                color:
                    alreadyFollowing
                        ? Colors.transparent
                        : isDarkMode
                        ? AppColors.primaryDark
                        : AppColors.primaryLight,
                borderRadius: BorderRadius.circular(20.r),
                border:
                    alreadyFollowing
                        ? Border.all(
                          color:
                              isDarkMode
                                  ? AppColors.dividerDark
                                  : AppColors.dividerLight,
                          width: 1.5,
                        )
                        : null,
              ),
              child: Center(
                child: Text(
                  alreadyFollowing ? "Following" : "Follow",
                  style: AppStyle.textStyle(
                    14,
                    alreadyFollowing
                        ? (isDarkMode
                            ? AppColors.textMediumDark
                            : AppColors.textMediumLight)
                        : Colors.white,
                    FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
