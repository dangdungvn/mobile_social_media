import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile/common/providers/theme_provider.dart';
import 'package:mobile/common/utils/app_colors.dart';
import 'package:mobile/common/utils/app_style.dart';
import 'package:mobile/features/feed/models/comment_model.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

typedef VoteCallback = void Function(String commentId, VoteType voteType);
typedef ReplyCallback = void Function(String commentId);

class CommentItem extends StatelessWidget {
  final CommentModel comment;
  final VoteCallback onVote;
  final ReplyCallback onReply;

  const CommentItem({
    super.key,
    required this.comment,
    required this.onVote,
    required this.onReply,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;

    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.h),
      decoration: BoxDecoration(
        color:
            isDarkMode ? AppColors.backgroundDark : AppColors.backgroundLight,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(12.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Comment header with user info
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // User avatar
                Container(
                  width: 36.w,
                  height: 36.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: NetworkImage(
                        comment.userProfilePicture ??
                            'https://i.pravatar.cc/150',
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                SizedBox(width: 8.w),

                // Username and comment content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Username and time
                      Row(
                        children: [
                          Text(
                            comment.username ?? "Unknown User",
                            style: AppStyle.textStyle(
                              14,
                              isDarkMode
                                  ? AppColors.textDarkDark
                                  : AppColors.textDarkLight,
                              FontWeight.w600,
                            ),
                          ),

                          SizedBox(width: 6.w),

                          Text(
                            timeago.format(comment.createdAt),
                            style: AppStyle.textStyle(
                              12,
                              isDarkMode
                                  ? AppColors.textLightDark
                                  : AppColors.textLightLight,
                              FontWeight.normal,
                            ),
                          ),

                          SizedBox(width: 6.w),

                          // Show verification mark if comment is verified
                          if (comment.verification ==
                              CommentVerification.correct)
                            Icon(
                              Icons.check_circle,
                              color: AppColors.successLight,
                              size: 14.sp,
                            )
                          else if (comment.verification ==
                              CommentVerification.incorrect)
                            Icon(
                              Icons.cancel,
                              color: AppColors.errorLight,
                              size: 14.sp,
                            ),
                        ],
                      ),

                      SizedBox(height: 4.h),

                      // Comment content
                      Text(
                        comment.content,
                        style: AppStyle.textStyle(
                          14,
                          isDarkMode
                              ? AppColors.textDarkDark
                              : AppColors.textDarkLight,
                          FontWeight.normal,
                        ),
                      ),

                      SizedBox(height: 8.h),

                      // Comment actions (vote, reply)
                      Row(
                        children: [
                          // Upvote button
                          _buildVoteButton(
                            context,
                            isDarkMode,
                            Icons.arrow_upward,
                            comment.upvotes.toString(),
                            comment.userVote == VoteType.upvote,
                            () => onVote(comment.id, VoteType.upvote),
                          ),

                          SizedBox(width: 4.w),

                          // Score
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8.w,
                              vertical: 2.h,
                            ),
                            decoration: BoxDecoration(
                              color: _getScoreColor(comment.score, isDarkMode),
                              borderRadius: BorderRadius.circular(4.r),
                            ),
                            child: Text(
                              comment.score.toString(),
                              style: AppStyle.textStyle(
                                12,
                                Colors.white,
                                FontWeight.bold,
                              ),
                            ),
                          ),

                          SizedBox(width: 4.w),

                          // Downvote button
                          _buildVoteButton(
                            context,
                            isDarkMode,
                            Icons.arrow_downward,
                            comment.downvotes.toString(),
                            comment.userVote == VoteType.downvote,
                            () => onVote(comment.id, VoteType.downvote),
                          ),

                          SizedBox(width: 20.w),

                          // Reply button
                          GestureDetector(
                            onTap: () => onReply(comment.id),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.reply,
                                  size: 16.sp,
                                  color:
                                      isDarkMode
                                          ? AppColors.textMediumDark
                                          : AppColors.textMediumLight,
                                ),
                                SizedBox(width: 4.w),
                                Text(
                                  "Reply",
                                  style: AppStyle.textStyle(
                                    12,
                                    isDarkMode
                                        ? AppColors.textMediumDark
                                        : AppColors.textMediumLight,
                                    FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          Spacer(),

                          // More options button
                          GestureDetector(
                            onTap: () {
                              _showCommentOptions(context, isDarkMode);
                            },
                            child: Icon(
                              Icons.more_horiz,
                              size: 18.sp,
                              color:
                                  isDarkMode
                                      ? AppColors.textMediumDark
                                      : AppColors.textMediumLight,
                            ),
                          ),
                        ],
                      ),

                      // Verification text
                      if (comment.verification == CommentVerification.correct)
                        Padding(
                          padding: EdgeInsets.only(top: 8.h),
                          child: Row(
                            children: [
                              Icon(
                                Icons.verified_user,
                                size: 12.sp,
                                color: AppColors.successLight,
                              ),
                              SizedBox(width: 4.w),
                              Text(
                                "Verified as correct by admin",
                                style: AppStyle.textStyle(
                                  12,
                                  AppColors.successLight,
                                  FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        )
                      else if (comment.verification ==
                          CommentVerification.incorrect)
                        Padding(
                          padding: EdgeInsets.only(top: 8.h),
                          child: Row(
                            children: [
                              Icon(
                                Icons.dangerous,
                                size: 12.sp,
                                color: AppColors.errorLight,
                              ),
                              SizedBox(width: 4.w),
                              Text(
                                "Marked as incorrect by admin",
                                style: AppStyle.textStyle(
                                  12,
                                  AppColors.errorLight,
                                  FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVoteButton(
    BuildContext context,
    bool isDarkMode,
    IconData icon,
    String count,
    bool isActive,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
        decoration: BoxDecoration(
          color:
              isActive
                  ? (isDarkMode ? AppColors.cardDark : AppColors.cardLight)
                  : Colors.transparent,
          borderRadius: BorderRadius.circular(4.r),
          border: Border.all(
            color: isDarkMode ? AppColors.dividerDark : AppColors.dividerLight,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 14.sp,
              color:
                  isActive
                      ? (icon == Icons.arrow_upward
                          ? AppColors.successLight
                          : AppColors.errorLight)
                      : (isDarkMode
                          ? AppColors.textMediumDark
                          : AppColors.textMediumLight),
            ),
            if (int.parse(count) > 0)
              Padding(
                padding: EdgeInsets.only(left: 4.w),
                child: Text(
                  count,
                  style: AppStyle.textStyle(
                    12,
                    isActive
                        ? (icon == Icons.arrow_upward
                            ? AppColors.successLight
                            : AppColors.errorLight)
                        : (isDarkMode
                            ? AppColors.textMediumDark
                            : AppColors.textMediumLight),
                    FontWeight.w500,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Color _getScoreColor(int score, bool isDarkMode) {
    if (score > 0) {
      return AppColors.successLight;
    } else if (score < 0) {
      return AppColors.errorLight;
    } else {
      return isDarkMode ? AppColors.textLightDark : AppColors.textLightLight;
    }
  }

  void _showCommentOptions(BuildContext context, bool isDarkMode) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            color: isDarkMode ? AppColors.cardDark : AppColors.cardLight,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16.r),
              topRight: Radius.circular(16.r),
            ),
          ),
          padding: EdgeInsets.symmetric(vertical: 16.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color:
                      isDarkMode
                          ? AppColors.dividerDark
                          : AppColors.dividerLight,
                  borderRadius: BorderRadius.circular(2.r),
                ),
                margin: EdgeInsets.only(bottom: 16.h),
              ),

              _buildOptionItem(
                context,
                isDarkMode,
                Icons.flag_outlined,
                "Report Comment",
                () => Navigator.pop(context),
              ),

              _buildOptionItem(
                context,
                isDarkMode,
                Icons.content_copy,
                "Copy Text",
                () => Navigator.pop(context),
              ),

              // Admin only options would be conditionally rendered based on user role
              _buildOptionItem(
                context,
                isDarkMode,
                Icons.verified_user_outlined,
                comment.verification == CommentVerification.correct
                    ? "Remove Verification"
                    : "Mark as Correct",
                () => Navigator.pop(context),
              ),

              _buildOptionItem(
                context,
                isDarkMode,
                Icons.dangerous_outlined,
                comment.verification == CommentVerification.incorrect
                    ? "Remove Incorrect Mark"
                    : "Mark as Incorrect",
                () => Navigator.pop(context),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildOptionItem(
    BuildContext context,
    bool isDarkMode,
    IconData icon,
    String label,
    VoidCallback onTap, {
    bool isDestructive = false,
  }) {
    final textColor =
        isDestructive
            ? AppColors.errorLight
            : (isDarkMode ? AppColors.textDarkDark : AppColors.textDarkLight);

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 24.w),
        child: Row(
          children: [
            Icon(icon, color: textColor, size: 22.sp),
            SizedBox(width: 16.w),
            Text(
              label,
              style: AppStyle.textStyle(16, textColor, FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}
