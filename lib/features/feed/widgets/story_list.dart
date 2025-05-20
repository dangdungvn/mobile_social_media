import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile/common/providers/theme_provider.dart';
import 'package:mobile/common/utils/app_colors.dart';
import 'package:mobile/common/utils/app_style.dart';
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

class StoryList extends StatelessWidget {
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
          'https://images.unsplash.com/photo-1469474968028-56623f02e42e?q=80&w=2074&auto=format&fit=crop',
      isViewed: true,
    ),
    StoryItem(
      id: 'story3',
      userId: 'user3',
      username: 'Mike Johnson',
      userProfilePicture: 'https://i.pravatar.cc/150?img=8',
      storyImage:
          'https://images.unsplash.com/photo-1433086966358-54859d0ed716?q=80&w=1974&auto=format&fit=crop',
    ),
    StoryItem(
      id: 'story4',
      userId: 'user4',
      username: 'Sarah Williams',
      userProfilePicture: 'https://i.pravatar.cc/150?img=9',
      storyImage:
          'https://images.unsplash.com/photo-1501854140801-50d01698950b?q=80&w=1950&auto=format&fit=crop',
    ),
    StoryItem(
      id: 'story5',
      userId: 'user5',
      username: 'David Brown',
      userProfilePicture: 'https://i.pravatar.cc/150?img=12',
      storyImage:
          'https://images.unsplash.com/photo-1470071459604-3b5ec3a7fe05?q=80&w=1974&auto=format&fit=crop',
    ),
    StoryItem(
      id: 'story6',
      userId: 'user6',
      username: 'Emily Davis',
      userProfilePicture: 'https://i.pravatar.cc/150?img=25',
      storyImage:
          'https://images.unsplash.com/photo-1497449493050-aad1e7cad165?q=80&w=1965&auto=format&fit=crop',
    ),
  ];

  StoryList({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100.h,
      child: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        scrollDirection: Axis.horizontal,
        itemCount: stories.length,
        itemBuilder: (context, index) {
          return StoryItemWidget(story: stories[index]);
        },
      ),
    );
  }
}

class StoryItemWidget extends StatelessWidget {
  final StoryItem story;

  const StoryItemWidget({super.key, required this.story});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;

    return Container(
      width: 80.w,
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      child: Column(
        children: [
          // Avatar with story ring
          Stack(
            alignment: Alignment.center,
            children: [
              // Colored ring around avatar
              Container(
                width: 64.w,
                height: 64.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient:
                      story.isViewed
                          ? null // No gradient for viewed stories
                          : LinearGradient(
                            colors: [
                              AppColors.secondaryLight,
                              AppColors.accentLight,
                              AppColors.primaryLight,
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                  color:
                      story.isViewed
                          ? isDarkMode
                              ? AppColors.dividerDark
                              : AppColors.dividerLight
                          : null,
                ),
              ),

              // White padding between ring and avatar
              Container(
                width: 60.w,
                height: 60.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isDarkMode ? AppColors.cardDark : AppColors.cardLight,
                ),
              ),

              // User avatar
              Container(
                width: 56.w,
                height: 56.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: NetworkImage(story.userProfilePicture),
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              // Plus icon for current user's "Add story"
              if (story.isCurrentUser)
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 20.w,
                    height: 20.w,
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color:
                            isDarkMode
                                ? AppColors.cardDark
                                : AppColors.cardLight,
                        width: 2.w,
                      ),
                    ),
                    child: Center(
                      child: Icon(Icons.add, color: Colors.white, size: 12.sp),
                    ),
                  ),
                ),
            ],
          ),

          SizedBox(height: 4.h),

          // Username text
          Text(
            story.isCurrentUser
                ? "Your Story"
                : _truncateUsername(story.username),
            style: AppStyle.textStyle(
              12,
              isDarkMode ? AppColors.textMediumDark : AppColors.textMediumLight,
              story.isViewed ? FontWeight.normal : FontWeight.w500,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  String _truncateUsername(String username) {
    if (username.length <= 9) return username;
    return '${username.substring(0, 8)}...';
  }
}
