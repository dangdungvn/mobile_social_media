import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile/common/providers/theme_provider.dart';
import 'package:mobile/common/utils/app_colors.dart';
import 'package:mobile/common/utils/app_constants.dart';
import 'package:mobile/common/utils/app_style.dart';
import 'package:mobile/features/feed/models/post_model.dart';
import 'package:mobile/features/feed/widgets/post_card.dart';
import 'package:mobile/features/feed/widgets/story_list.dart';
import 'package:provider/provider.dart';

class NewsFeedScreen extends StatefulWidget {
  const NewsFeedScreen({super.key});

  @override
  State<NewsFeedScreen> createState() => _NewsFeedScreenState();
}

class _NewsFeedScreenState extends State<NewsFeedScreen>
    with SingleTickerProviderStateMixin {
  bool _isLoading = false;
  String _selectedFeedType = "For You"; // Default feed type
  final List<String> _feedTypes = ["For You", "Following", "Friends"];
  late AnimationController _refreshIconController;

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

  @override
  void initState() {
    super.initState();
    _refreshIconController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
  }

  @override
  void dispose() {
    _refreshIconController.dispose();
    super.dispose();
  }

  Future<void> _refreshFeed() async {
    setState(() {
      _isLoading = true;
    });

    // Animate refresh icon
    _refreshIconController.repeat();

    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _isLoading = false;
    });

    _refreshIconController.reset();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;

    return Scaffold(
      backgroundColor:
          isDarkMode ? AppColors.backgroundDark : AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: isDarkMode ? AppColors.cardDark : AppColors.cardLight,
        title: Row(
          children: [
            Text(
              AppConstants.appName,
              style: TextStyle(
                fontSize: 24.sp,
                color:
                    isDarkMode ? AppColors.primaryDark : AppColors.primaryLight,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
            SizedBox(width: 4.w),
            Icon(Icons.verified, color: AppColors.verified, size: 16.sp),
          ],
        ),
        actions: [
          // Search button
          Container(
            margin: EdgeInsets.only(right: 8.w),
            decoration: BoxDecoration(
              color:
                  isDarkMode
                      ? AppColors.backgroundDark
                      : AppColors.backgroundLight,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.search,
                color:
                    isDarkMode
                        ? AppColors.textDarkDark
                        : AppColors.textDarkLight,
                size: 24.sp,
              ),
            ),
          ),
          // Notification button with badge
          Container(
            margin: EdgeInsets.only(right: 8.w),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color:
                        isDarkMode
                            ? AppColors.backgroundDark
                            : AppColors.backgroundLight,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.notifications_outlined,
                      color:
                          isDarkMode
                              ? AppColors.textDarkDark
                              : AppColors.textDarkLight,
                      size: 24.sp,
                    ),
                  ),
                ),
                Positioned(
                  top: 10.h,
                  right: 10.w,
                  child: Container(
                    width: 16.w,
                    height: 16.w,
                    decoration: BoxDecoration(
                      color: AppColors.accentLight,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color:
                            isDarkMode
                                ? AppColors.cardDark
                                : AppColors.cardLight,
                        width: 2,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        "3",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Theme toggle button
          Container(
            margin: EdgeInsets.only(right: 8.w),
            decoration: BoxDecoration(
              color:
                  isDarkMode
                      ? AppColors.backgroundDark
                      : AppColors.backgroundLight,
              shape: BoxShape.circle,
            ),
            child: IconButton(
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
                    isDarkMode
                        ? AppColors.textDarkDark
                        : AppColors.textDarkLight,
                size: 22.sp,
              ),
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
            // Stories section with elevated container
            Container(
              margin: EdgeInsets.only(top: 8.h),
              decoration: BoxDecoration(
                color: isDarkMode ? AppColors.cardDark : AppColors.cardLight,
                borderRadius: BorderRadius.circular(16.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    spreadRadius: 0,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      left: 16.w,
                      top: 16.h,
                      bottom: 12.h,
                    ),
                    child: Text(
                      "Stories",
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w700,
                        color:
                            isDarkMode
                                ? AppColors.textDarkDark
                                : AppColors.textDarkLight,
                      ),
                    ),
                  ),
                  StoryList(),
                  SizedBox(height: 12.h),
                ],
              ),
            ),

            SizedBox(height: 16.h),

            // Feed type selector with improved appearance
            Container(
              decoration: BoxDecoration(
                color: isDarkMode ? AppColors.cardDark : AppColors.cardLight,
                borderRadius: BorderRadius.circular(16.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    spreadRadius: 0,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
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
                          child: AnimatedContainer(
                            duration: Duration(milliseconds: 200),
                            margin: EdgeInsets.only(right: 12.w),
                            padding: EdgeInsets.symmetric(
                              horizontal: 20.w,
                              vertical: 10.h,
                            ),
                            decoration: BoxDecoration(
                              color:
                                  isSelected
                                      ? isDarkMode
                                          ? AppColors.primaryDark
                                          : AppColors.primaryLight
                                      : isDarkMode
                                      ? AppColors.backgroundDark
                                      : AppColors.backgroundLight,
                              borderRadius: BorderRadius.circular(30.r),
                              boxShadow:
                                  isSelected
                                      ? [
                                        BoxShadow(
                                          color:
                                              isDarkMode
                                                  ? AppColors.primaryDark
                                                      .withOpacity(0.3)
                                                  : AppColors.primaryLight
                                                      .withOpacity(0.3),
                                          blurRadius: 8,
                                          spreadRadius: 0,
                                          offset: Offset(0, 2),
                                        ),
                                      ]
                                      : null,
                            ),
                            child: Text(
                              type,
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight:
                                    isSelected
                                        ? FontWeight.w700
                                        : FontWeight.w500,
                                color:
                                    isSelected
                                        ? Colors.white
                                        : isDarkMode
                                        ? AppColors.textMediumDark
                                        : AppColors.textMediumLight,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                ),
              ),
            ),

            SizedBox(height: 16.h),

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
                children:
                    _posts.map((post) {
                      return Container(
                        margin: EdgeInsets.only(bottom: 16.h),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16.r),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              spreadRadius: 0,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: PostCard(post: post),
                      );
                    }).toList(),
              ),

            SizedBox(height: 80.h), // Extra space at bottom for FAB
          ],
        ),
      ),
      // Floating action button for creating new post
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: Container(
          width: 56.w,
          height: 56.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                isDarkMode
                    ? AppColors.buttonGradientStartDark
                    : AppColors.buttonGradientStartLight,
                isDarkMode
                    ? AppColors.buttonGradientEndDark
                    : AppColors.buttonGradientEndLight,
              ],
            ),
            boxShadow: [
              BoxShadow(
                color:
                    isDarkMode
                        ? AppColors.primaryDark.withOpacity(0.3)
                        : AppColors.primaryLight.withOpacity(0.3),
                blurRadius: 10,
                spreadRadius: 0,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: Icon(Icons.add, color: Colors.white, size: 26.sp),
        ),
      ),
    );
  }
}
