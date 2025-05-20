import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/common/providers/theme_provider.dart';
import 'package:mobile/common/utils/app_colors.dart';
import 'package:mobile/common/utils/app_constants.dart';
import 'package:mobile/common/utils/app_style.dart';
import 'package:mobile/features/feed/models/post_model.dart';
import 'package:mobile/features/feed/screens/post_detail_screen.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

class PostCard extends StatelessWidget {
  final PostModel post;

  const PostCard({required this.post, super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;

    return Container(
      margin: EdgeInsets.only(bottom: 8.h),
      color: isDarkMode ? AppColors.cardDark : AppColors.cardLight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with user info
          _buildHeader(context, isDarkMode),

          // Post content
          _buildContent(context, isDarkMode),

          // Post media (images/videos)
          if (post.media != null && post.media!.isNotEmpty)
            _buildMediaContent(context, isDarkMode),

          // If this is a shared post
          if (post.type == PostType.shared)
            _buildSharedPost(context, isDarkMode),

          // Engagement stats
          _buildEngagementStats(context, isDarkMode),

          // Divider
          Divider(
            height: 1.h,
            thickness: 1.h,
            color: isDarkMode ? AppColors.dividerDark : AppColors.dividerLight,
          ),

          // Action buttons
          _buildActionButtons(context, isDarkMode),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isDarkMode) {
    return Padding(
      padding: EdgeInsets.all(12.w),
      child: Row(
        children: [
          // User avatar
          GestureDetector(
            onTap: () {
              // View profile
            },
            child: Container(
              width: 40.w,
              height: 40.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: NetworkImage(
                    post.userProfilePicture ?? "https://i.pravatar.cc/150",
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),

          SizedBox(width: 12.w),

          // User name and post time
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      post.username ?? "Unknown User",
                      style: AppStyle.textStyle(
                        14,
                        isDarkMode
                            ? AppColors.textDarkDark
                            : AppColors.textDarkLight,
                        FontWeight.w600,
                      ),
                    ),
                    if (post.type == PostType.shared)
                      Text(
                        " shared a post",
                        style: AppStyle.textStyle(
                          14,
                          isDarkMode
                              ? AppColors.textMediumDark
                              : AppColors.textMediumLight,
                          FontWeight.normal,
                        ),
                      ),
                  ],
                ),

                SizedBox(height: 2.h),

                Text(
                  timeago.format(post.createdAt),
                  style: AppStyle.textStyle(
                    12,
                    isDarkMode
                        ? AppColors.textLightDark
                        : AppColors.textLightLight,
                    FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),

          // More options button
          IconButton(
            onPressed: () {
              _showPostOptions(context, isDarkMode);
            },
            icon: Icon(
              Icons.more_horiz,
              color:
                  isDarkMode
                      ? AppColors.textMediumDark
                      : AppColors.textMediumLight,
              size: 20.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context, bool isDarkMode) {
    if (post.content.isEmpty) return SizedBox.shrink();

    return GestureDetector(
      onTap: () {
        context.go(
          '${AppConstants.routePostDetail.replaceFirst(":postId", "")}${post.id}',
        );
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
        child: Text(
          post.content,
          style: AppStyle.textStyle(
            15,
            isDarkMode ? AppColors.textDarkDark : AppColors.textDarkLight,
            FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildMediaContent(BuildContext context, bool isDarkMode) {
    if (post.media == null || post.media!.isEmpty) return SizedBox.shrink();

    final mediaCount = post.media!.length;

    return GestureDetector(
      onTap: () {
        context.go(
          '${AppConstants.routePostDetail.replaceFirst(":postId", "")}${post.id}',
        );
      },
      child: Container(
        margin: EdgeInsets.only(top: 8.h),
        constraints: BoxConstraints(maxHeight: mediaCount == 1 ? 300.h : 200.h),
        child:
            mediaCount == 1
                ? _buildSingleMedia(context, post.media![0])
                : _buildMediaGrid(context, post.media!),
      ),
    );
  }

  Widget _buildSingleMedia(BuildContext context, PostMedia media) {
    if (media.type == 'image') {
      return Image.network(
        media.url,
        width: double.infinity,
        height: 300.h,
        fit: BoxFit.cover,
      );
    } else if (media.type == 'video') {
      // In a real app, use a video player here
      return Stack(
        alignment: Alignment.center,
        children: [
          Image.network(
            media.thumbnailUrl ?? media.url,
            width: double.infinity,
            height: 300.h,
            fit: BoxFit.cover,
          ),
          Container(
            width: 60.w,
            height: 60.w,
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.7),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.play_arrow, color: Colors.white, size: 36.sp),
          ),
        ],
      );
    }

    return SizedBox.shrink();
  }

  Widget _buildMediaGrid(BuildContext context, List<PostMedia> media) {
    if (media.length == 2) {
      return Row(
        children: [
          Expanded(child: _buildGridMediaItem(context, media[0])),
          SizedBox(width: 2.w),
          Expanded(child: _buildGridMediaItem(context, media[1])),
        ],
      );
    } else if (media.length == 3) {
      return Row(
        children: [
          Expanded(
            flex: 1,
            child: _buildGridMediaItem(context, media[0], height: 200.h),
          ),
          SizedBox(width: 2.w),
          Expanded(
            flex: 1,
            child: Column(
              children: [
                _buildGridMediaItem(context, media[1], height: 99.h),
                SizedBox(height: 2.h),
                _buildGridMediaItem(context, media[2], height: 99.h),
              ],
            ),
          ),
        ],
      );
    } else {
      return GridView.builder(
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 2.w,
          mainAxisSpacing: 2.h,
        ),
        itemCount: media.length > 4 ? 4 : media.length,
        itemBuilder: (context, index) {
          if (index == 3 && media.length > 4) {
            // Show overlay with count of remaining images
            return Stack(
              fit: StackFit.expand,
              children: [
                _buildGridMediaItem(context, media[index]),
                Container(
                  color: Colors.black.withOpacity(0.6),
                  child: Center(
                    child: Text(
                      "+${media.length - 4}",
                      style: AppStyle.textStyle(
                        24,
                        Colors.white,
                        FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            );
          }
          return _buildGridMediaItem(context, media[index]);
        },
      );
    }
  }

  Widget _buildGridMediaItem(
    BuildContext context,
    PostMedia media, {
    double? height,
  }) {
    if (media.type == 'image') {
      return SizedBox(
        height: height,
        child: Image.network(
          media.url,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        ),
      );
    } else if (media.type == 'video') {
      return Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            height: height,
            child: Image.network(
              media.thumbnailUrl ?? media.url,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
          ),
          Icon(Icons.play_circle_fill, color: Colors.white, size: 24.sp),
        ],
      );
    }

    return SizedBox.shrink();
  }

  Widget _buildSharedPost(BuildContext context, bool isDarkMode) {
    // In a real app, you'd fetch the original post data
    return Container(
      margin: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        border: Border.all(
          color: isDarkMode ? AppColors.dividerDark : AppColors.dividerLight,
          width: 1.w,
        ),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(8.w),
            child: Row(
              children: [
                Container(
                  width: 32.w,
                  height: 32.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: NetworkImage("https://i.pravatar.cc/150?img=10"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                SizedBox(width: 8.w),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Original Author",
                      style: AppStyle.textStyle(
                        12,
                        isDarkMode
                            ? AppColors.textDarkDark
                            : AppColors.textDarkLight,
                        FontWeight.w600,
                      ),
                    ),
                    Text(
                      "Original post date",
                      style: AppStyle.textStyle(
                        10,
                        isDarkMode
                            ? AppColors.textLightDark
                            : AppColors.textLightLight,
                        FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
            child: Text(
              "This is the original post content that was shared. It could be a longer text with more details about the topic.",
              style: AppStyle.textStyle(
                13,
                isDarkMode
                    ? AppColors.textMediumDark
                    : AppColors.textMediumLight,
                FontWeight.normal,
              ),
            ),
          ),

          // Sample image in shared post
          Image.network(
            "https://images.unsplash.com/photo-1682686580003-22d3d65399a8?q=80&w=1171&auto=format&fit=crop",
            width: double.infinity,
            height: 150.h,
            fit: BoxFit.cover,
          ),
        ],
      ),
    );
  }

  Widget _buildEngagementStats(BuildContext context, bool isDarkMode) {
    if (post.likeCount == 0 && post.commentCount == 0 && post.shareCount == 0) {
      return SizedBox.shrink();
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      child: Row(
        children: [
          // Likes count
          if (post.likeCount > 0)
            Expanded(
              child: Row(
                children: [
                  Icon(
                    Icons.favorite,
                    color: AppColors.secondaryLight,
                    size: 16.sp,
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    post.likeCount.toString(),
                    style: AppStyle.textStyle(
                      12,
                      isDarkMode
                          ? AppColors.textMediumDark
                          : AppColors.textMediumLight,
                      FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),

          // Comments count
          if (post.commentCount > 0)
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.comment,
                    color:
                        isDarkMode
                            ? AppColors.textMediumDark
                            : AppColors.textMediumLight,
                    size: 16.sp,
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    post.commentCount.toString(),
                    style: AppStyle.textStyle(
                      12,
                      isDarkMode
                          ? AppColors.textMediumDark
                          : AppColors.textMediumLight,
                      FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),

          // Shares count
          if (post.shareCount > 0)
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(
                    Icons.share,
                    color:
                        isDarkMode
                            ? AppColors.textMediumDark
                            : AppColors.textMediumLight,
                    size: 16.sp,
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    post.shareCount.toString(),
                    style: AppStyle.textStyle(
                      12,
                      isDarkMode
                          ? AppColors.textMediumDark
                          : AppColors.textMediumLight,
                      FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, bool isDarkMode) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildActionButton(
            context,
            isDarkMode,
            post.isLiked ? Icons.favorite : Icons.favorite_border,
            "Like",
            post.isLiked ? AppColors.secondaryLight : null,
            () {
              // Like action
            },
          ),
          _buildActionButton(
            context,
            isDarkMode,
            Icons.chat_bubble_outline,
            "Comment",
            null,
            () {
              // Navigate to post detail for commenting
              context.go(
                '${AppConstants.routePostDetail.replaceFirst(":postId", "")}${post.id}',
              );
            },
          ),
          _buildActionButton(
            context,
            isDarkMode,
            Icons.share_outlined,
            "Share",
            null,
            () {
              // Share action
            },
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context,
    bool isDarkMode,
    IconData icon,
    String label,
    Color? iconColor,
    VoidCallback onTap,
  ) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 8.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 20.sp,
                color:
                    iconColor ??
                    (isDarkMode
                        ? AppColors.textMediumDark
                        : AppColors.textMediumLight),
              ),
              SizedBox(width: 8.w),
              Text(
                label,
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
      ),
    );
  }

  void _showPostOptions(BuildContext context, bool isDarkMode) {
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
                Icons.bookmark_border,
                "Save Post",
                () => Navigator.pop(context),
              ),

              _buildOptionItem(
                context,
                isDarkMode,
                Icons.person_add_outlined,
                "Follow ${post.username ?? 'User'}",
                () => Navigator.pop(context),
              ),

              _buildOptionItem(
                context,
                isDarkMode,
                Icons.report_outlined,
                "Report Post",
                () => Navigator.pop(context),
              ),

              _buildOptionItem(
                context,
                isDarkMode,
                Icons.visibility_off_outlined,
                "Hide Post",
                () => Navigator.pop(context),
              ),

              _buildOptionItem(
                context,
                isDarkMode,
                Icons.block_outlined,
                "Block ${post.username ?? 'User'}",
                () => Navigator.pop(context),
                isDestructive: true,
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
