import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile/common/providers/theme_provider.dart';
import 'package:mobile/common/utils/app_colors.dart';
import 'package:mobile/common/utils/app_constants.dart';
import 'package:mobile/common/utils/app_style.dart';
import 'package:mobile/features/feed/models/post_model.dart';
import 'package:mobile/features/feed/widgets/post_card.dart';
import 'package:mobile/features/feed/widgets/story_list.dart';
import 'package:mobile/features/feed/widgets/story_list_improved.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

class NewsFeedScreen extends StatefulWidget {
  const NewsFeedScreen({super.key});

  @override
  State<NewsFeedScreen> createState() => _NewsFeedScreenState();
}

class _NewsFeedScreenState extends State<NewsFeedScreen> {
  bool _isLoading = false;
  String _selectedFeedType = "For You"; // Default feed type
  final List<String> _feedTypes = ["For You", "Following", "Friends"];

  // Mock posts data
  final List<PostModel> _posts = [
    PostModel(
      id: '1',
      userId: 'user1',
      username: 'John Doe',
      userProfilePicture: 'https://i.pravatar.cc/150?img=1',
      content:
          'Just finished reading an amazing book on artificial intelligence. It\'s incredible how far we\'ve come in this field! #AI #Technology',
      type: PostType.text,
      createdAt: DateTime.now().subtract(Duration(hours: 2)),
      likeCount: 42,
      commentCount: 8,
      shareCount: 3,
    ),
    PostModel(
      id: '2',
      userId: 'user2',
      username: 'Jane Smith',
      userProfilePicture: 'https://i.pravatar.cc/150?img=5',
      content: 'Beautiful sunset at the beach today! 🌅 #Nature #Peace',
      media: [
        PostMedia(
          url:
              'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?q=80&w=2073&auto=format&fit=crop',
          type: 'image',
        ),
      ],
      type: PostType.image,
      createdAt: DateTime.now().subtract(Duration(hours: 5)),
      likeCount: 156,
      commentCount: 23,
      shareCount: 12,
      isLiked: true,
    ),
    PostModel(
      id: '3',
      userId: 'user3',
      username: 'Mike Johnson',
      userProfilePicture: 'https://i.pravatar.cc/150?img=8',
      content:
          'Just went hiking in the mountains and the views were breathtaking! Check out these photos:',
      media: [
        PostMedia(
          url:
              'https://images.unsplash.com/photo-1454496522488-7a8e488e8606?q=80&w=2076&auto=format&fit=crop',
          type: 'image',
        ),
        PostMedia(
          url:
              'https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?q=80&w=2070&auto=format&fit=crop',
          type: 'image',
        ),
        PostMedia(
          url:
              'https://images.unsplash.com/photo-1486870591958-9b9d0d1dda99?q=80&w=2070&auto=format&fit=crop',
          type: 'image',
        ),
      ],
      type: PostType.image,
      createdAt: DateTime.now().subtract(Duration(days: 1)),
      likeCount: 89,
      commentCount: 14,
      shareCount: 5,
    ),
    PostModel(
      id: '4',
      userId: 'user4',
      username: 'Sarah Williams',
      userProfilePicture: 'https://i.pravatar.cc/150?img=9',
      content:
          'Just shared a fascinating article on how social media affects mental health.',
      originalPostId: '1001',
      originalPostUserId: 'user10',
      type: PostType.shared,
      createdAt: DateTime.now().subtract(Duration(days: 2)),
      likeCount: 31,
      commentCount: 6,
      shareCount: 2,
    ),
  ];

  Future<void> _refreshFeed() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate API call
    await Future.delayed(Duration(seconds: 1));

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;

    return Scaffold(
      backgroundColor:
          isDarkMode ? AppColors.backgroundDark : AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: isDarkMode ? AppColors.cardDark : AppColors.cardLight,
        title: Text(
          AppConstants.appName,
          style: AppStyle.textStyle(
            24,
            isDarkMode ? AppColors.primaryDark : AppColors.primaryLight,
            FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.notifications_outlined,
              color:
                  isDarkMode ? AppColors.textDarkDark : AppColors.textDarkLight,
            ),
          ),
          IconButton(
            onPressed: () {
              final themeProvider = Provider.of<ThemeProvider>(
                context,
                listen: false,
              );
              themeProvider.toggleTheme();
            },
            icon: Icon(
              isDarkMode ? Icons.light_mode : Icons.dark_mode,
              color:
                  isDarkMode ? AppColors.textDarkDark : AppColors.textDarkLight,
            ),
          ),
        ],
        elevation: 0,
      ),
      body: RefreshIndicator(
        onRefresh: _refreshFeed,
        color: isDarkMode ? AppColors.primaryDark : AppColors.primaryLight,
        child: ListView(
          children: [
            // Stories section
            Container(
              color: isDarkMode ? AppColors.cardDark : AppColors.cardLight,
              padding: EdgeInsets.symmetric(vertical: 12.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 16.w, bottom: 8.h),
                    child: Text(
                      "Stories",
                      style: AppStyle.textStyle(
                        16,
                        isDarkMode
                            ? AppColors.textDarkDark
                            : AppColors.textDarkLight,
                        FontWeight.w600,
                      ),
                    ),
                  ),
                  StoryListImproved(),
                ],
              ),
            ),

            SizedBox(height: 8.h),

            // Feed type selector
            Container(
              color: isDarkMode ? AppColors.cardDark : AppColors.cardLight,
              padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children:
                      _feedTypes.map((type) {
                        final isSelected = type == _selectedFeedType;
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedFeedType = type;
                            });
                          },
                          child: Container(
                            margin: EdgeInsets.only(right: 12.w),
                            padding: EdgeInsets.symmetric(
                              horizontal: 16.w,
                              vertical: 8.h,
                            ),
                            decoration: BoxDecoration(
                              color:
                                  isSelected
                                      ? isDarkMode
                                          ? AppColors.primaryDark
                                          : AppColors.primaryLight
                                      : Colors.transparent,
                              borderRadius: BorderRadius.circular(20.r),
                              border: Border.all(
                                color:
                                    isSelected
                                        ? isDarkMode
                                            ? AppColors.primaryDark
                                            : AppColors.primaryLight
                                        : isDarkMode
                                        ? AppColors.dividerDark
                                        : AppColors.dividerLight,
                              ),
                            ),
                            child: Text(
                              type,
                              style: AppStyle.textStyle(
                                14,
                                isSelected
                                    ? Colors.white
                                    : isDarkMode
                                    ? AppColors.textMediumDark
                                    : AppColors.textMediumLight,
                                isSelected ? FontWeight.w600 : FontWeight.w500,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                ),
              ),
            ),

            SizedBox(height: 8.h),

            // Posts
            if (_isLoading)
              Center(
                child: Padding(
                  padding: EdgeInsets.all(24.h),
                  child: CircularProgressIndicator(
                    color:
                        isDarkMode
                            ? AppColors.primaryDark
                            : AppColors.primaryLight,
                  ),
                ),
              )
            else
              Column(
                children: _posts.map((post) => PostCard(post: post)).toList(),
              ),
          ],
        ),
      ),
    );
  }
}
