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
      height: 110.h,
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

  const StoryItemWidget({required this.story, super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 6.w),
      child: Column(
        children: [
          Container(
            width: 75.w,
            height: 75.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border:
                  story.isCurrentUser
                      ? Border.all(
                        color:
                            isDarkMode
                                ? AppColors.cardDark
                                : AppColors.cardLight,
                        width: 2.5,
                      )
                      : Border.all(
                        color:
                            story.isViewed
                                ? isDarkMode
                                    ? AppColors.dividerDark.withOpacity(0.7)
                                    : AppColors.dividerLight
                                : isDarkMode
                                ? Colors.transparent
                                : Colors.transparent,
                        width: 2.5,
                      ),
              gradient:
                  story.isViewed
                      ? null
                      : story.isCurrentUser
                      ? null
                      : LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                        colors: [
                          isDarkMode ? AppColors.accentDark : Colors.purple,
                          isDarkMode
                              ? AppColors.primaryDark
                              : AppColors.primaryLight,
                        ],
                      ),
            ),
            padding: EdgeInsets.all(3.5),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isDarkMode ? AppColors.cardDark : AppColors.cardLight,
                  width: 2.5,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(50.r),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    // Profile image
                    Image.network(
                      story.userProfilePicture,
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
                      errorBuilder:
                          (context, error, stackTrace) => Center(
                            child: Icon(
                              Icons.person,
                              color:
                                  isDarkMode
                                      ? AppColors.textMediumDark
                                      : AppColors.textMediumLight,
                              size: 30.sp,
                            ),
                          ),
                    ),

                    // Add story icon for current user
                    if (story.isCurrentUser)
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          width: 22.w,
                          height: 22.w,
                          decoration: BoxDecoration(
                            color:
                                isDarkMode
                                    ? AppColors.primaryDark
                                    : AppColors.primaryLight,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color:
                                  isDarkMode
                                      ? AppColors.cardDark
                                      : Colors.white,
                              width: 2,
                            ),
                          ),
                          child: Center(
                            child: Icon(
                              Icons.add,
                              size: 14.sp,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 6.h),
          // Username
          SizedBox(
            width: 72.w,
            child: Text(
              story.username.split(' ')[0], // Just first name
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12.sp,
                color:
                    isDarkMode
                        ? (story.isCurrentUser
                            ? AppColors.primaryDark
                            : AppColors.textMediumDark)
                        : (story.isCurrentUser
                            ? AppColors.primaryLight
                            : AppColors.textMediumLight),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
