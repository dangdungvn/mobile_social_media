import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile/common/providers/theme_provider.dart';
import 'package:mobile/common/utils/app_colors_improved.dart';
import 'package:mobile/common/utils/app_style.dart';
import 'package:mobile/features/feed/models/comment_model.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:cached_network_image/cached_network_image.dart';

typedef VoteCallback = void Function(String commentId, VoteType voteType);
typedef ReplyCallback = void Function(String commentId);

class CommentItemImproved extends StatelessWidget {
  final CommentModel comment;
  final VoteCallback onVote;
  final ReplyCallback onReply;
  final bool showReplyButton;
  final bool isReply;

  const CommentItemImproved({
    super.key,
    required this.comment,
    required this.onVote,
    required this.onReply,
    this.showReplyButton = true,
    this.isReply = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;

    return Container(
      margin: EdgeInsets.only(top: 8.h, left: isReply ? 36.w : 0, bottom: 8.h),
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
      ),
      child: Padding(
        padding: EdgeInsets.all(14.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Comment header with user info
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // User avatar with gradient border
                _buildAvatar(isDarkMode),

                SizedBox(width: 10.w),

                // Username, verification badge and comment content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Username and verification badge
                      _buildUserInfo(isDarkMode),

                      SizedBox(height: 4.h),

                      // Comment content
                      _buildCommentContent(isDarkMode),

                      SizedBox(height: 12.h),

                      // Comment actions (vote, reply)
                      _buildActions(context, isDarkMode),
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

  Widget _buildAvatar(bool isDarkMode) {
    return Container(
      width: 42.w,
      height: 42.w,
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
        borderRadius: BorderRadius.circular(20.r),
        child: CachedNetworkImage(
          imageUrl: comment.userProfilePicture ?? 'https://i.pravatar.cc/150',
          fit: BoxFit.cover,
          placeholder:
              (context, url) => Container(
                color:
                    isDarkMode
                        ? AppColors.backgroundDark
                        : AppColors.backgroundLight,
                child: Center(
                  child: SizedBox(
                    width: 16.w,
                    height: 16.w,
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
    );
  }

  Widget _buildUserInfo(bool isDarkMode) {
    return Row(
      children: [
        Text(
          comment.username ?? "Unknown User",
          style: AppStyle.textStyle(
            14,
            isDarkMode ? AppColors.textDarkDark : AppColors.textDarkLight,
            FontWeight.w600,
          ),
        ),

        SizedBox(width: 6.w),

        Container(
          padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
          decoration: BoxDecoration(
            color:
                isDarkMode
                    ? AppColors.primaryDark.withOpacity(0.2)
                    : AppColors.primaryLight.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Text(
            timeago.format(comment.createdAt),
            style: AppStyle.textStyle(
              10,
              isDarkMode ? AppColors.textLightDark : AppColors.textLightLight,
              FontWeight.w500,
            ),
          ),
        ),

        SizedBox(width: 6.w),

        // Show verification mark if comment is verified
        if (comment.verification == CommentVerification.correct)
          Container(
            padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
            decoration: BoxDecoration(
              color: AppColors.successLight.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.check_circle,
                  color: AppColors.successLight,
                  size: 12.sp,
                ),
                SizedBox(width: 2.w),
                Text(
                  "Verified",
                  style: AppStyle.textStyle(
                    10,
                    AppColors.successLight,
                    FontWeight.w500,
                  ),
                ),
              ],
            ),
          )
        else if (comment.verification == CommentVerification.incorrect)
          Container(
            padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
            decoration: BoxDecoration(
              color: AppColors.errorLight.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.cancel, color: AppColors.errorLight, size: 12.sp),
                SizedBox(width: 2.w),
                Text(
                  "Incorrect",
                  style: AppStyle.textStyle(
                    10,
                    AppColors.errorLight,
                    FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildCommentContent(bool isDarkMode) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        color:
            isDarkMode
                ? AppColors.backgroundDark.withOpacity(0.5)
                : AppColors.backgroundLight.withOpacity(0.7),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: isDarkMode ? AppColors.dividerDark : AppColors.dividerLight,
          width: 0.5,
        ),
      ),
      child: Text(
        comment.content,
        style: AppStyle.textStyle(
          14,
          isDarkMode ? AppColors.textDarkDark : AppColors.textDarkLight,
          FontWeight.normal,
        ),
      ),
    );
  }

  Widget _buildActions(BuildContext context, bool isDarkMode) {
    return Row(
      children: [
        // Upvote button - với hiệu ứng đẹp mắt
        _buildVoteButton(
          context,
          isDarkMode,
          Icons.thumb_up_outlined,
          comment.upvotes.toString(),
          comment.userVote == VoteType.upvote,
          () => onVote(comment.id, VoteType.upvote),
          isDarkMode ? AppColors.primaryDark : AppColors.primaryLight,
        ),

        SizedBox(width: 6.w),

        // Score - hiển thị với style tròn và đẹp
        Container(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
          decoration: BoxDecoration(
            color: _getScoreBackgroundColor(comment.score, isDarkMode),
            borderRadius: BorderRadius.circular(12.r),
            boxShadow: [
              BoxShadow(
                color: _getScoreColor(
                  comment.score,
                  isDarkMode,
                ).withOpacity(0.2),
                blurRadius: 4,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Text(
            comment.score.toString(),
            style: AppStyle.textStyle(
              12,
              _getScoreTextColor(comment.score, isDarkMode),
              FontWeight.bold,
            ),
          ),
        ),

        SizedBox(width: 6.w),

        // Downvote button - với hiệu ứng đẹp mắt
        _buildVoteButton(
          context,
          isDarkMode,
          Icons.thumb_down_outlined,
          comment.downvotes.toString(),
          comment.userVote == VoteType.downvote,
          () => onVote(comment.id, VoteType.downvote),
          isDarkMode ? AppColors.errorDark : AppColors.errorLight,
        ),

        if (showReplyButton) ...[
          SizedBox(width: 16.w),

          // Reply button - với hiệu ứng đẹp mắt
          _buildActionButton(
            isDarkMode,
            Icons.reply_rounded,
            "Reply",
            () => onReply(comment.id),
            isDarkMode ? AppColors.secondaryDark : AppColors.secondaryLight,
          ),
        ],

        const Spacer(),

        // More options button - thiết kế đẹp mắt
        InkWell(
          onTap: () => _showCommentOptions(context, isDarkMode),
          borderRadius: BorderRadius.circular(20.r),
          child: Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color:
                  isDarkMode
                      ? AppColors.backgroundDark.withOpacity(0.5)
                      : AppColors.backgroundLight.withOpacity(0.7),
              border: Border.all(
                color:
                    isDarkMode ? AppColors.dividerDark : AppColors.dividerLight,
                width: 1,
              ),
            ),
            child: Icon(
              Icons.more_horiz,
              size: 18.sp,
              color:
                  isDarkMode
                      ? AppColors.textMediumDark
                      : AppColors.textMediumLight,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildVoteButton(
    BuildContext context,
    bool isDarkMode,
    IconData icon,
    String count,
    bool isActive,
    VoidCallback onTap,
    Color accentColor,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
        decoration: BoxDecoration(
          color:
              isActive
                  ? accentColor.withOpacity(0.1)
                  : isDarkMode
                  ? AppColors.backgroundDark.withOpacity(0.3)
                  : AppColors.backgroundLight.withOpacity(0.3),
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(
            color:
                isActive
                    ? accentColor.withOpacity(0.5)
                    : isDarkMode
                    ? AppColors.dividerDark
                    : AppColors.dividerLight,
            width: isActive ? 1 : 0.5,
          ),
          boxShadow:
              isActive
                  ? [
                    BoxShadow(
                      color: accentColor.withOpacity(0.2),
                      blurRadius: 3,
                      offset: const Offset(0, 1),
                    ),
                  ]
                  : null,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 14.sp,
              color:
                  isActive
                      ? accentColor
                      : (isDarkMode
                          ? AppColors.textMediumDark
                          : AppColors.textMediumLight),
            ),
            if (int.parse(count) > 0) ...[
              SizedBox(width: 4.w),
              Text(
                count,
                style: AppStyle.textStyle(
                  12,
                  isActive
                      ? accentColor
                      : (isDarkMode
                          ? AppColors.textMediumDark
                          : AppColors.textMediumLight),
                  FontWeight.w500,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(
    bool isDarkMode,
    IconData icon,
    String label,
    VoidCallback onTap,
    Color accentColor,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
        decoration: BoxDecoration(
          color:
              isDarkMode
                  ? AppColors.backgroundDark.withOpacity(0.3)
                  : AppColors.backgroundLight.withOpacity(0.3),
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(
            color: isDarkMode ? AppColors.dividerDark : AppColors.dividerLight,
            width: 0.5,
          ),
        ),
        child: Row(
          children: [
            Icon(icon, size: 14.sp, color: accentColor),
            SizedBox(width: 4.w),
            Text(
              label,
              style: AppStyle.textStyle(12, accentColor, FontWeight.w500),
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

  Color _getScoreBackgroundColor(int score, bool isDarkMode) {
    if (score > 0) {
      return AppColors.successLight.withOpacity(0.1);
    } else if (score < 0) {
      return AppColors.errorLight.withOpacity(0.1);
    } else {
      return isDarkMode
          ? AppColors.backgroundDark.withOpacity(0.3)
          : AppColors.backgroundLight.withOpacity(0.3);
    }
  }

  Color _getScoreTextColor(int score, bool isDarkMode) {
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
      elevation: 0,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            color: isDarkMode ? AppColors.cardDark : AppColors.cardLight,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.r),
              topRight: Radius.circular(20.r),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 10,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          padding: EdgeInsets.symmetric(vertical: 20.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle indicator
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
                margin: EdgeInsets.only(bottom: 24.h),
              ),

              // Action items with beautiful design
              _buildOptionItem(
                context,
                isDarkMode,
                Icons.copy_rounded,
                "Copy Text",
                () {
                  Clipboard.setData(ClipboardData(text: comment.content));
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        "Comment copied to clipboard",
                        style: AppStyle.textStyle(
                          14,
                          Colors.white,
                          FontWeight.w500,
                        ),
                      ),
                      backgroundColor: AppColors.accentLight,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      margin: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 8.h,
                      ),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
              ),

              _buildOptionItem(
                context,
                isDarkMode,
                Icons.flag_outlined,
                "Report Comment",
                () {
                  Navigator.pop(context);
                  _showReportDialog(context, isDarkMode);
                },
              ),

              const Divider(),

              // Admin only options would be conditionally rendered based on user role
              _buildOptionItem(
                context,
                isDarkMode,
                comment.verification == CommentVerification.correct
                    ? Icons.unpublished_outlined
                    : Icons.check_circle_outline,
                comment.verification == CommentVerification.correct
                    ? "Remove Verification"
                    : "Mark as Correct",
                () => Navigator.pop(context),
                iconColor: AppColors.successLight,
              ),

              _buildOptionItem(
                context,
                isDarkMode,
                comment.verification == CommentVerification.incorrect
                    ? Icons.remove_circle_outline
                    : Icons.dangerous_outlined,
                comment.verification == CommentVerification.incorrect
                    ? "Remove Incorrect Mark"
                    : "Mark as Incorrect",
                () => Navigator.pop(context),
                iconColor: AppColors.errorLight,
              ),

              const Divider(),

              // Delete option - destructive action
              _buildOptionItem(
                context,
                isDarkMode,
                Icons.delete_outline,
                "Delete Comment",
                () => Navigator.pop(context),
                isDestructive: true,
              ),
            ],
          ),
        );
      },
    );
  }

  void _showReportDialog(BuildContext context, bool isDarkMode) {
    final reportReasons = [
      'Inappropriate content',
      'Spam',
      'Harassment',
      'False information',
      'Hate speech',
      'Violence',
      'Other',
    ];

    String selectedReason = reportReasons[0];

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor:
                  isDarkMode ? AppColors.cardDark : AppColors.cardLight,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.r),
              ),
              title: Text(
                'Report Comment',
                style: AppStyle.textStyle(
                  18,
                  isDarkMode ? AppColors.textDarkDark : AppColors.textDarkLight,
                  FontWeight.bold,
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Tell us why you want to report this comment:',
                    style: AppStyle.textStyle(
                      14,
                      isDarkMode
                          ? AppColors.textMediumDark
                          : AppColors.textMediumLight,
                      FontWeight.normal,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Container(
                    decoration: BoxDecoration(
                      color:
                          isDarkMode
                              ? AppColors.backgroundDark.withOpacity(0.5)
                              : AppColors.backgroundLight,
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(
                        color:
                            isDarkMode
                                ? AppColors.dividerDark
                                : AppColors.dividerLight,
                      ),
                    ),
                    height: 200.h,
                    width: double.infinity,
                    child: ListView.builder(
                      itemCount: reportReasons.length,
                      itemBuilder: (context, index) {
                        final reason = reportReasons[index];
                        final isSelected = reason == selectedReason;

                        return InkWell(
                          onTap: () {
                            setState(() {
                              selectedReason = reason;
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 16.w,
                              vertical: 12.h,
                            ),
                            decoration: BoxDecoration(
                              color:
                                  isSelected
                                      ? (isDarkMode
                                          ? AppColors.primaryDark.withOpacity(
                                            0.1,
                                          )
                                          : AppColors.primaryLight.withOpacity(
                                            0.1,
                                          ))
                                      : Colors.transparent,
                              border: Border(
                                bottom: BorderSide(
                                  color:
                                      isDarkMode
                                          ? AppColors.dividerDark
                                          : AppColors.dividerLight,
                                  width: 0.5,
                                ),
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  isSelected
                                      ? Icons.radio_button_checked
                                      : Icons.radio_button_off,
                                  color:
                                      isSelected
                                          ? (isDarkMode
                                              ? AppColors.primaryDark
                                              : AppColors.primaryLight)
                                          : (isDarkMode
                                              ? AppColors.textMediumDark
                                              : AppColors.textMediumLight),
                                  size: 18.sp,
                                ),
                                SizedBox(width: 12.w),
                                Text(
                                  reason,
                                  style: AppStyle.textStyle(
                                    14,
                                    isDarkMode
                                        ? AppColors.textDarkDark
                                        : AppColors.textDarkLight,
                                    FontWeight.normal,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'Cancel',
                    style: AppStyle.textStyle(
                      14,
                      isDarkMode
                          ? AppColors.textMediumDark
                          : AppColors.textMediumLight,
                      FontWeight.w500,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Comment reported successfully',
                          style: AppStyle.textStyle(
                            14,
                            Colors.white,
                            FontWeight.w500,
                          ),
                        ),
                        backgroundColor: AppColors.primaryLight,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        margin: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 8.h,
                        ),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        isDarkMode
                            ? AppColors.primaryDark
                            : AppColors.primaryLight,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                  child: Text(
                    'Submit Report',
                    style: AppStyle.textStyle(
                      14,
                      Colors.white,
                      FontWeight.w500,
                    ),
                  ),
                ),
              ],
            );
          },
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
    Color? iconColor,
  }) {
    final textColor =
        isDestructive
            ? AppColors.errorLight
            : (isDarkMode ? AppColors.textDarkDark : AppColors.textDarkLight);

    final finalIconColor =
        isDestructive
            ? AppColors.errorLight
            : (iconColor ??
                (isDarkMode
                    ? AppColors.textDarkDark
                    : AppColors.textDarkLight));

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 24.w),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: finalIconColor.withOpacity(0.1),
              ),
              child: Icon(icon, color: finalIconColor, size: 20.sp),
            ),
            SizedBox(width: 16.w),
            Text(
              label,
              style: AppStyle.textStyle(15, textColor, FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}
