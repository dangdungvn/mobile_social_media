import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile/common/providers/theme_provider.dart';
import 'package:mobile/common/utils/app_colors.dart';
import 'package:mobile/common/utils/app_style.dart';
import 'package:mobile/common/widgets/custom_button.dart';
import 'package:mobile/features/auth/models/user_model.dart';
import 'package:provider/provider.dart';

class SearchResultUserItem extends StatefulWidget {
  final UserModel user;

  const SearchResultUserItem({super.key, required this.user});

  @override
  State<SearchResultUserItem> createState() => _SearchResultUserItemState();
}

class _SearchResultUserItemState extends State<SearchResultUserItem> {
  bool _isFollowing = false;

  void _toggleFollow() {
    // In a real app, this would call an API to follow/unfollow
    setState(() {
      _isFollowing = !_isFollowing;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: isDarkMode ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color:
                isDarkMode
                    ? Colors.black.withOpacity(0.1)
                    : Colors.grey.withOpacity(0.1),
            blurRadius: 5,
            spreadRadius: 0,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Profile image
          Container(
            width: 50.w,
            height: 50.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: NetworkImage(
                  widget.user.profilePictureUrl ?? 'https://i.pravatar.cc/150',
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),

          SizedBox(width: 12.w),

          // User info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      widget.user.fullName ?? widget.user.username,
                      style: AppStyle.textStyle(
                        14,
                        isDarkMode
                            ? AppColors.textDarkDark
                            : AppColors.textDarkLight,
                        FontWeight.w600,
                      ),
                    ),
                    SizedBox(width: 4.w),
                    if (widget.user.isVerified)
                      Icon(
                        Icons.verified,
                        color:
                            isDarkMode
                                ? AppColors.primaryDark
                                : AppColors.primaryLight,
                        size: 16.sp,
                      ),
                    if (widget.user.isOnline)
                      Padding(
                        padding: EdgeInsets.only(left: 4.w),
                        child: Container(
                          width: 8.w,
                          height: 8.w,
                          decoration: BoxDecoration(
                            color: AppColors.successLight,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                  ],
                ),
                SizedBox(height: 4.h),
                Text(
                  '@${widget.user.username}',
                  style: AppStyle.textStyle(
                    12,
                    isDarkMode
                        ? AppColors.textLightDark
                        : AppColors.textLightLight,
                    FontWeight.normal,
                  ),
                ),
                if (widget.user.bio != null)
                  Padding(
                    padding: EdgeInsets.only(top: 4.h),
                    child: Text(
                      widget.user.bio!,
                      style: AppStyle.textStyle(
                        12,
                        isDarkMode
                            ? AppColors.textMediumDark
                            : AppColors.textMediumLight,
                        FontWeight.normal,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
              ],
            ),
          ),

          SizedBox(width: 8.w),

          // Follow button
          CustomButton(
            text: _isFollowing ? "Following" : "Follow",
            onPressed: _toggleFollow,
            isLoading: false,
            isOutlined: _isFollowing,
            isFullWidth: false,
            height: 32.h,
            width: 90.w,
          ),
        ],
      ),
    );
  }
}
