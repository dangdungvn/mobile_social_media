import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile/common/providers/theme_provider.dart';
import 'package:mobile/common/utils/app_colors_improved.dart';
import 'package:mobile/features/feed/widgets/story_item_improved.dart';
import 'package:provider/provider.dart';

class StoryItem {
  final String id;
  final String userId;
  final String username;
  final String userProfilePicture;
  final String? storyImage;
  final bool isViewed;
  final bool isCurrentUser;

  StoryItem({
    required this.id,
    required this.userId,
    required this.username,
    required this.userProfilePicture,
    this.storyImage,
    this.isViewed = false,
    this.isCurrentUser = false,
  });
}

class StoryListImproved extends StatelessWidget {
  final List<StoryItem> stories = [
    // Current user (Add story)
    StoryItem(
      id: 'my-story',
      userId: 'current-user',
      username: 'Your Story',
      userProfilePicture: 'https://i.pravatar.cc/150?img=65',
      isCurrentUser: true,
    ),
    // Other users stories
    StoryItem(
      id: 'story1',
      userId: 'user1',
      username: 'John Doe',
      userProfilePicture: 'https://i.pravatar.cc/150?img=1',
      storyImage:
          'https://images.unsplash.com/photo-1526512340740-9217d0159da9?q=80&w=1000&auto=format&fit=crop',
    ),
    StoryItem(
      id: 'story2',
      userId: 'user2',
      username: 'Jane Smith',
      userProfilePicture: 'https://i.pravatar.cc/150?img=5',
      storyImage:
          'https://images.unsplash.com/photo-1618641986557-1ecd230959aa?q=80&w=1000&auto=format&fit=crop',
      isViewed: true,
    ),
    StoryItem(
      id: 'story3',
      userId: 'user3',
      username: 'Sarah Connor',
      userProfilePicture: 'https://i.pravatar.cc/150?img=9',
      storyImage:
          'https://images.unsplash.com/photo-1533929736458-ca588d08c8be?q=80&w=1000&auto=format&fit=crop',
    ),
    StoryItem(
      id: 'story4',
      userId: 'user4',
      username: 'Mark Taylor',
      userProfilePicture: 'https://i.pravatar.cc/150?img=12',
      storyImage:
          'https://images.unsplash.com/photo-1626544827763-d516dce335e2?q=80&w=1000&auto=format&fit=crop',
      isViewed: true,
    ),
    StoryItem(
      id: 'story5',
      userId: 'user5',
      username: 'Emma Wilson',
      userProfilePicture: 'https://i.pravatar.cc/150?img=23',
      storyImage:
          'https://images.unsplash.com/photo-1604537466158-719b1972feb8?q=80&w=1000&auto=format&fit=crop',
    ),
  ];

  StoryListImproved({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;

    return Container(
      margin: EdgeInsets.only(top: 16.h, bottom: 8.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Stories',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color:
                        isDarkMode
                            ? AppColors.textDarkDark
                            : AppColors.textDarkLight,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // View all stories
                  },
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 8.w),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                    'View All',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color:
                          isDarkMode
                              ? AppColors.primaryDark
                              : AppColors.primaryLight,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16.h),
          Container(
            height: 110.h,
            margin: EdgeInsets.only(left: 16.w),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: stories.length,
              itemBuilder: (context, index) {
                final story = stories[index];
                return StoryItemImproved(
                  username: story.username,
                  imageUrl: story.userProfilePicture,
                  isViewed: story.isViewed,
                  isAddStory: story.isCurrentUser,
                  onTap: () {
                    // View story logic
                    _handleStoryTap(context, story);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _handleStoryTap(BuildContext context, StoryItem story) {
    if (story.isCurrentUser) {
      // Show UI to create new story
      _showCreateStoryOptions(context);
    } else {
      // View the story
      _navigateToStoryView(context, story);
    }
  }

  void _showCreateStoryOptions(BuildContext context) {
    // Show options to create a story
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        final isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;

        return Container(
          decoration: BoxDecoration(
            color: isDarkMode ? AppColors.cardDark : AppColors.cardLight,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24.r),
              topRight: Radius.circular(24.r),
            ),
          ),
          padding: EdgeInsets.all(24.r),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
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
              Text(
                "Create Story",
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
              _buildStoryOption(
                context,
                isDarkMode,
                Icons.photo_camera,
                "Camera",
                () => Navigator.pop(context),
              ),
              SizedBox(height: 16.h),
              _buildStoryOption(
                context,
                isDarkMode,
                Icons.photo_library,
                "Gallery",
                () => Navigator.pop(context),
              ),
              SizedBox(height: 16.h),
              _buildStoryOption(
                context,
                isDarkMode,
                Icons.text_fields,
                "Text",
                () => Navigator.pop(context),
              ),
              SizedBox(height: 24.h),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStoryOption(
    BuildContext context,
    bool isDarkMode,
    IconData icon,
    String label,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
        decoration: BoxDecoration(
          color:
              isDarkMode ? AppColors.backgroundDark : AppColors.backgroundLight,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(12.r),
              decoration: BoxDecoration(
                color:
                    isDarkMode
                        ? AppColors.primaryDark.withOpacity(0.1)
                        : AppColors.primaryLight.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 24.sp,
                color:
                    isDarkMode ? AppColors.primaryDark : AppColors.primaryLight,
              ),
            ),
            SizedBox(width: 16.w),
            Text(
              label,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                color:
                    isDarkMode
                        ? AppColors.textDarkDark
                        : AppColors.textDarkLight,
              ),
            ),
            Spacer(),
            Icon(
              Icons.arrow_forward_ios,
              size: 16.sp,
              color:
                  isDarkMode
                      ? AppColors.textLightDark
                      : AppColors.textLightLight,
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToStoryView(BuildContext context, StoryItem story) {
    // TODO: Implement story view navigation
    // For now, just show a snackbar
    final snackBar = SnackBar(
      content: Text('Viewing ${story.username}\'s story'),
      duration: const Duration(seconds: 1),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
