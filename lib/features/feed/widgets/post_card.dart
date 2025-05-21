import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile/common/providers/theme_provider.dart';
import 'package:mobile/common/utils/app_colors.dart';
import 'package:mobile/features/feed/models/post_model.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

class PostCard extends StatefulWidget {
  final PostModel post;

  const PostCard({required this.post, super.key});

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard>
    with SingleTickerProviderStateMixin {
  bool _isLiked = false;
  late AnimationController _likeAnimationController;
  late Animation<double> _likeAnimation;

  @override
  void initState() {
    super.initState();
    _isLiked = widget.post.isLiked;

    // Initialize animation controller for like button
    _likeAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _likeAnimation = Tween<double>(begin: 1.0, end: 1.5).animate(
      CurvedAnimation(
        parent: _likeAnimationController,
        curve: Curves.elasticOut,
      ),
    );

    _likeAnimationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _likeAnimationController.reverse();
      }
    });
  }

  @override
  void dispose() {
    _likeAnimationController.dispose();
    super.dispose();
  }

  void _toggleLike() {
    setState(() {
      _isLiked = !_isLiked;
    });

    if (_isLiked) {
      _likeAnimationController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;

    return Container(
      decoration: BoxDecoration(
        color: isDarkMode ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with user info
          _buildHeader(context, isDarkMode),

          // Post content
          _buildContent(context, isDarkMode),

          // Post media (images/videos)
          if (widget.post.media != null && widget.post.media!.isNotEmpty)
            _buildMediaContent(context, isDarkMode),

          // If this is a shared post
          if (widget.post.type == PostType.shared)
            _buildSharedPost(context, isDarkMode),

          // Engagement stats
          _buildEngagementStats(context, isDarkMode),

          // Divider
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: Divider(
              height: 1.h,
              thickness: 1.h,
              color:
                  isDarkMode
                      ? AppColors.dividerDark
                      : AppColors.dividerLight.withOpacity(0.5),
            ),
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
          // User avatar with border
          GestureDetector(
            onTap: () {
              // View profile
            },
            child: Container(
              width: 44.w,
              height: 44.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color:
                      isDarkMode
                          ? AppColors.dividerDark
                          : AppColors.dividerLight,
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(22.r),
                child: Image.network(
                  widget.post.userProfilePicture ?? "https://i.pravatar.cc/150",
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        color:
                            isDarkMode
                                ? AppColors.primaryDark
                                : AppColors.primaryLight,
                        strokeWidth: 2,
                      ),
                    );
                  },
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
                      widget.post.username ?? "Unknown User",
                      style: TextStyle(
                        fontSize: 15.sp,
                        color:
                            isDarkMode
                                ? AppColors.textDarkDark
                                : AppColors.textDarkLight,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(width: 4.w),
                    if (widget.post.isVerified)
                      Icon(
                        Icons.verified,
                        color: AppColors.verified,
                        size: 14.sp,
                      ),
                  ],
                ),
                SizedBox(height: 2.h),
                Text(
                  timeago.format(widget.post.createdAt),
                  style: TextStyle(
                    fontSize: 12.sp,
                    color:
                        isDarkMode
                            ? AppColors.textLightDark
                            : AppColors.textLightLight,
                  ),
                ),
              ],
            ),
          ),

          // More options button
          IconButton(
            onPressed: () {
              // Show post options
              _showPostOptions(context, isDarkMode);
            },
            icon: Icon(
              Icons.more_horiz,
              color:
                  isDarkMode
                      ? AppColors.textMediumDark
                      : AppColors.textMediumLight,
              size: 22.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context, bool isDarkMode) {
    if (widget.post.content.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
      child: Text(
        widget.post.content,
        style: TextStyle(
          fontSize: 15.sp,
          color: isDarkMode ? AppColors.textDarkDark : AppColors.textDarkLight,
          height: 1.4,
        ),
      ),
    );
  }

  Widget _buildMediaContent(BuildContext context, bool isDarkMode) {
    if (widget.post.media == null || widget.post.media!.isEmpty) {
      return const SizedBox.shrink();
    }

    // Single image post
    if (widget.post.media!.length == 1) {
      return GestureDetector(
        onTap: () {
          // View full image
        },
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
          height: 280.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                spreadRadius: 0,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16.r),
            child: Image.network(
              widget.post.media!.first.url,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Center(
                  child: CircularProgressIndicator(
                    color:
                        isDarkMode
                            ? AppColors.primaryDark
                            : AppColors.primaryLight,
                  ),
                );
              },
            ),
          ),
        ),
      );
    }

    // Multiple images post (grid or carousel)
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      height: 240.h,
      child: GridView.count(
        physics: NeverScrollableScrollPhysics(),
        crossAxisCount: widget.post.media!.length > 2 ? 3 : 2,
        mainAxisSpacing: 8.w,
        crossAxisSpacing: 8.w,
        children:
            widget.post.media!.take(6).map((media) {
              final isLastWithMore =
                  widget.post.media!.length > 6 &&
                  widget.post.media!.indexOf(media) == 5;

              return GestureDetector(
                onTap: () {
                  // View all images
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12.r),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.network(media.url, fit: BoxFit.cover),
                      if (isLastWithMore)
                        Container(
                          color: Colors.black.withOpacity(0.6),
                          child: Center(
                            child: Text(
                              "+${widget.post.media!.length - 5}",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            }).toList(),
      ),
    );
  }

  Widget _buildSharedPost(BuildContext context, bool isDarkMode) {
    // This would show a preview of the original post
    return Container(
      margin: EdgeInsets.all(12.w),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color:
            isDarkMode ? AppColors.backgroundDark : AppColors.backgroundLight,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: isDarkMode ? AppColors.dividerDark : AppColors.dividerLight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Original author info
          Row(
            children: [
              CircleAvatar(
                radius: 16.r,
                backgroundImage: const NetworkImage(
                  "https://i.pravatar.cc/150?img=10", // Placeholder
                ),
              ),
              SizedBox(width: 8.w),
              Text(
                "Original Author",
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color:
                      isDarkMode
                          ? AppColors.textDarkDark
                          : AppColors.textDarkLight,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          // Original post content preview
          Text(
            "This is a preview of the original post content...",
            style: TextStyle(
              fontSize: 14.sp,
              color:
                  isDarkMode
                      ? AppColors.textMediumDark
                      : AppColors.textMediumLight,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEngagementStats(BuildContext context, bool isDarkMode) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Likes count with icon
          Row(
            children: [
              Icon(
                Icons.favorite,
                color: isDarkMode ? AppColors.likeDark : AppColors.likeLight,
                size: 18.sp,
              ),
              SizedBox(width: 6.w),
              Text(
                "${widget.post.likeCount}",
                style: TextStyle(
                  fontSize: 14.sp,
                  color:
                      isDarkMode
                          ? AppColors.textMediumDark
                          : AppColors.textMediumLight,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),

          // Comments and shares
          Row(
            children: [
              Text(
                "${widget.post.commentCount} comments",
                style: TextStyle(
                  fontSize: 14.sp,
                  color:
                      isDarkMode
                          ? AppColors.textMediumDark
                          : AppColors.textMediumLight,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(width: 10.w),
              Text(
                "${widget.post.shareCount} shares",
                style: TextStyle(
                  fontSize: 14.sp,
                  color:
                      isDarkMode
                          ? AppColors.textMediumDark
                          : AppColors.textMediumLight,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, bool isDarkMode) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Like button
          _buildActionButton(
            context,
            icon: _isLiked ? Icons.favorite : Icons.favorite_border,
            label: "Like",
            iconColor:
                _isLiked
                    ? (isDarkMode ? AppColors.likeDark : AppColors.likeLight)
                    : (isDarkMode
                        ? AppColors.textMediumDark
                        : AppColors.textMediumLight),
            onTap: _toggleLike,
            isDarkMode: isDarkMode,
            showAnimation: _isLiked,
          ),

          // Comment button
          _buildActionButton(
            context,
            icon: Icons.chat_bubble_outline,
            label: "Comment",
            iconColor:
                isDarkMode
                    ? AppColors.textMediumDark
                    : AppColors.textMediumLight,
            onTap: () {
              // Navigate to comments
            },
            isDarkMode: isDarkMode,
          ),

          // Share button
          _buildActionButton(
            context,
            icon: Icons.share_outlined,
            label: "Share",
            iconColor:
                isDarkMode
                    ? AppColors.textMediumDark
                    : AppColors.textMediumLight,
            onTap: () {
              // Show share options
            },
            isDarkMode: isDarkMode,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color iconColor,
    required VoidCallback onTap,
    required bool isDarkMode,
    bool showAnimation = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        child: Row(
          children: [
            AnimatedBuilder(
              animation: _likeAnimationController,
              builder: (context, child) {
                return Transform.scale(
                  scale: showAnimation ? _likeAnimation.value : 1.0,
                  child: Icon(icon, color: iconColor, size: 20.sp),
                );
              },
            ),
            SizedBox(width: 6.w),
            Text(
              label,
              style: TextStyle(
                fontSize: 14.sp,
                color:
                    isDarkMode
                        ? AppColors.textMediumDark
                        : AppColors.textMediumLight,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showPostOptions(BuildContext context, bool isDarkMode) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder:
          (context) => Container(
            decoration: BoxDecoration(
              color: isDarkMode ? AppColors.cardDark : AppColors.cardLight,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.r),
                topRight: Radius.circular(20.r),
              ),
            ),
            padding: EdgeInsets.symmetric(vertical: 16.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Handle bar
                Container(
                  width: 40.w,
                  height: 4.h,
                  margin: EdgeInsets.only(bottom: 16.h),
                  decoration: BoxDecoration(
                    color:
                        isDarkMode
                            ? AppColors.dividerDark
                            : AppColors.dividerLight,
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),

                _buildOptionItem(
                  context,
                  icon: Icons.bookmark_border,
                  label: "Save Post",
                  isDarkMode: isDarkMode,
                ),
                _buildOptionItem(
                  context,
                  icon: Icons.person_remove_outlined,
                  label: "Unfollow User",
                  isDarkMode: isDarkMode,
                ),
                _buildOptionItem(
                  context,
                  icon: Icons.block,
                  label: "Report Post",
                  isDarkMode: isDarkMode,
                  isDestructive: true,
                ),
              ],
            ),
          ),
    );
  }

  Widget _buildOptionItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required bool isDarkMode,
    bool isDestructive = false,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color:
            isDestructive
                ? (isDarkMode ? AppColors.errorDark : AppColors.errorLight)
                : (isDarkMode
                    ? AppColors.textMediumDark
                    : AppColors.textMediumLight),
      ),
      title: Text(
        label,
        style: TextStyle(
          color:
              isDestructive
                  ? (isDarkMode ? AppColors.errorDark : AppColors.errorLight)
                  : (isDarkMode
                      ? AppColors.textDarkDark
                      : AppColors.textDarkLight),
        ),
      ),
      onTap: () {
        Navigator.pop(context);
        // Handle the option
      },
    );
  }
}
