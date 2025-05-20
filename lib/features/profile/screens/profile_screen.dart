import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/common/providers/theme_provider.dart';
import 'package:mobile/common/utils/app_colors.dart';
import 'package:mobile/common/utils/app_constants.dart';
import 'package:mobile/common/utils/app_style.dart';
import 'package:mobile/common/widgets/custom_button.dart';
import 'package:mobile/features/auth/models/user_model.dart';
import 'package:mobile/features/auth/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  final bool _isLoading = false;

  // Mock user data
  final UserModel _user = UserModel(
    id: 'current_user',
    username: 'james_wilson',
    email: 'james@example.com',
    fullName: 'James Wilson',
    profilePictureUrl: 'https://i.pravatar.cc/300?img=11',
    bio:
        'Software developer and tech enthusiast. Love photography and hiking in my free time.',
    isVerified: true,
    followers: ['user1', 'user2', 'user3', 'user4', 'user5', 'user6', 'user7'],
    following: ['user1', 'user2', 'user3'],
    friendIds: ['user1', 'user2'],
  );

  // Mock posts for the user
  final List<Map<String, dynamic>> _userPosts = [
    {
      'id': 'post1',
      'content':
          'Just hiked to the summit today! The views were incredible 🏔️ #hiking #nature #adventure',
      'imageUrl': 'https://images.unsplash.com/photo-1551632436-cbf8dd35adfa',
      'likesCount': 124,
      'commentsCount': 18,
      'timeAgo': '2h',
      'type': 'image',
    },
    {
      'id': 'post2',
      'content':
          'Working on a new Flutter project. Excited to share it with you all soon!',
      'imageUrl': null,
      'likesCount': 57,
      'commentsCount': 8,
      'timeAgo': '1d',
      'type': 'text',
    },
    {
      'id': 'post3',
      'content': 'Sunset at the beach 🌅',
      'imageUrl':
          'https://images.unsplash.com/photo-1507525428034-b723cf961d3e',
      'likesCount': 243,
      'commentsCount': 32,
      'timeAgo': '3d',
      'type': 'image',
    },
    {
      'id': 'post4',
      'content': 'My weekend photography collection 📸',
      'imageUrls': [
        'https://images.unsplash.com/photo-1469474968028-56623f02e42e',
        'https://images.unsplash.com/photo-1433086966358-54859d0ed716',
        'https://images.unsplash.com/photo-1447752875215-b2761acb3c5d',
      ],
      'likesCount': 189,
      'commentsCount': 24,
      'timeAgo': '5d',
      'type': 'gallery',
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;

    return Scaffold(
      backgroundColor:
          isDarkMode ? AppColors.backgroundDark : AppColors.backgroundLight,
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              backgroundColor:
                  isDarkMode
                      ? AppColors.backgroundDark
                      : AppColors.backgroundLight,
              expandedHeight: 300.h,
              pinned: true,
              actions: [
                PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'logout') {
                      _showLogoutConfirmation(context, isDarkMode);
                    }
                  },
                  icon: Icon(
                    Icons.menu,
                    color:
                        isDarkMode
                            ? AppColors.textDarkDark
                            : AppColors.textDarkLight,
                  ),
                  itemBuilder:
                      (context) => [
                        PopupMenuItem(
                          value: 'settings',
                          child: Row(
                            children: [
                              Icon(
                                Icons.settings,
                                color:
                                    isDarkMode
                                        ? AppColors.textDarkDark
                                        : AppColors.textDarkLight,
                              ),
                              SizedBox(width: 10.w),
                              Text('Settings'),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          value: 'logout',
                          child: Row(
                            children: [
                              Icon(
                                Icons.logout,
                                color:
                                    isDarkMode
                                        ? AppColors.errorDark
                                        : AppColors.errorLight,
                              ),
                              SizedBox(width: 10.w),
                              Text('Đăng xuất'),
                            ],
                          ),
                        ),
                      ],
                ),
              ],
              flexibleSpace: FlexibleSpaceBar(
                background: _buildProfileHeader(isDarkMode),
              ),
              bottom: TabBar(
                controller: _tabController,
                indicatorColor:
                    isDarkMode ? AppColors.primaryDark : AppColors.primaryLight,
                labelColor:
                    isDarkMode
                        ? AppColors.textDarkDark
                        : AppColors.textDarkLight,
                unselectedLabelColor:
                    isDarkMode
                        ? AppColors.textLightDark
                        : AppColors.textLightLight,
                tabs: [
                  Tab(text: 'Posts'),
                  Tab(text: 'Media'),
                  Tab(text: 'Liked'),
                ],
              ),
            ),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: [
            // Posts tab
            _buildPostsTab(isDarkMode),

            // Media tab
            _buildMediaTab(isDarkMode),

            // Liked tab
            _buildLikedTab(isDarkMode),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(bool isDarkMode) {
    return Container(
      padding: EdgeInsets.only(top: 100.h, left: 16.w, right: 16.w),
      decoration: BoxDecoration(
        color: isDarkMode ? AppColors.cardDark : AppColors.cardLight,
      ),
      child: Column(
        children: [
          // Profile picture
          Container(
            width: 100.w,
            height: 100.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color:
                    isDarkMode ? AppColors.primaryDark : AppColors.primaryLight,
                width: 3.w,
              ),
              image: DecorationImage(
                image: NetworkImage(
                  _user.profilePictureUrl ?? 'https://i.pravatar.cc/300',
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),

          SizedBox(height: 16.h),

          // Name and verification
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _user.fullName ?? _user.username,
                style: AppStyle.textStyle(
                  22,
                  isDarkMode ? AppColors.textDarkDark : AppColors.textDarkLight,
                  FontWeight.w600,
                ),
              ),
              if (_user.isVerified)
                Padding(
                  padding: EdgeInsets.only(left: 4.w),
                  child: Icon(
                    Icons.verified,
                    color:
                        isDarkMode
                            ? AppColors.primaryDark
                            : AppColors.primaryLight,
                    size: 20.sp,
                  ),
                ),
            ],
          ),

          SizedBox(height: 4.h),

          // Username
          Text(
            '@${_user.username}',
            style: AppStyle.textStyle(
              14,
              isDarkMode ? AppColors.textLightDark : AppColors.textLightLight,
              FontWeight.normal,
            ),
          ),

          SizedBox(height: 12.h),

          // Bio
          if (_user.bio != null)
            Text(
              _user.bio!,
              style: AppStyle.textStyle(
                14,
                isDarkMode
                    ? AppColors.textMediumDark
                    : AppColors.textMediumLight,
                FontWeight.normal,
              ),
              textAlign: TextAlign.center,
            ),

          SizedBox(height: 16.h),

          // Stats (followers, following, etc)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildStatColumn('Posts', '42', isDarkMode),
              _buildStatColumn(
                'Followers',
                _user.followers?.length.toString() ?? '0',
                isDarkMode,
              ),
              _buildStatColumn(
                'Following',
                _user.following?.length.toString() ?? '0',
                isDarkMode,
              ),
            ],
          ),

          SizedBox(height: 16.h),

          // Edit profile button
          CustomButton(
            text: 'Edit Profile',
            onPressed: () {
              // Navigate to edit profile
            },
            isLoading: false,
            isOutlined: true,
            isFullWidth: false,
            width: 150.w,
            height: 36.h,
          ),
        ],
      ),
    );
  }

  Widget _buildStatColumn(String label, String value, bool isDarkMode) {
    return Column(
      children: [
        Text(
          value,
          style: AppStyle.textStyle(
            18,
            isDarkMode ? AppColors.textDarkDark : AppColors.textDarkLight,
            FontWeight.w600,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          label,
          style: AppStyle.textStyle(
            14,
            isDarkMode ? AppColors.textLightDark : AppColors.textLightLight,
            FontWeight.normal,
          ),
        ),
      ],
    );
  }

  Widget _buildPostsTab(bool isDarkMode) {
    return _isLoading
        ? Center(
          child: CircularProgressIndicator(
            color: isDarkMode ? AppColors.primaryDark : AppColors.primaryLight,
          ),
        )
        : _userPosts.isEmpty
        ? _buildEmptyState('No posts yet', 'Share your first post', isDarkMode)
        : ListView.builder(
          padding: EdgeInsets.symmetric(vertical: 8.h),
          itemCount: _userPosts.length,
          itemBuilder: (context, index) {
            return _buildPostItem(_userPosts[index], isDarkMode);
          },
        );
  }

  Widget _buildMediaTab(bool isDarkMode) {
    // Filter posts with images
    List<Map<String, dynamic>> mediaPosts =
        _userPosts
            .where(
              (post) => post['type'] == 'image' || post['type'] == 'gallery',
            )
            .toList();

    return mediaPosts.isEmpty
        ? _buildEmptyState(
          'No media yet',
          'Share photos and videos',
          isDarkMode,
        )
        : GridView.builder(
          padding: EdgeInsets.all(4.w),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 4.w,
            mainAxisSpacing: 4.h,
          ),
          itemCount: mediaPosts.length,
          itemBuilder: (context, index) {
            final post = mediaPosts[index];

            if (post['type'] == 'gallery') {
              // For gallery posts, show the first image with an overlay indicating multiple
              return Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(post['imageUrls'][0]),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 8.h,
                    right: 8.w,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 6.w,
                        vertical: 2.h,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.collections,
                            color: Colors.white,
                            size: 12.sp,
                          ),
                          SizedBox(width: 2.w),
                          Text(
                            post['imageUrls'].length.toString(),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            } else {
              // Single image posts
              return Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(post['imageUrl']),
                    fit: BoxFit.cover,
                  ),
                ),
              );
            }
          },
        );
  }

  Widget _buildLikedTab(bool isDarkMode) {
    // For demonstration, we'll show an empty state
    return _buildEmptyState(
      'No liked posts yet',
      'Posts you like will appear here',
      isDarkMode,
    );
  }

  Widget _buildEmptyState(String title, String message, bool isDarkMode) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.sentiment_dissatisfied,
            size: 60.sp,
            color:
                isDarkMode ? AppColors.textLightDark : AppColors.textLightLight,
          ),
          SizedBox(height: 16.h),
          Text(
            title,
            style: AppStyle.textStyle(
              18,
              isDarkMode ? AppColors.textDarkDark : AppColors.textDarkLight,
              FontWeight.w600,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            message,
            style: AppStyle.textStyle(
              14,
              isDarkMode ? AppColors.textLightDark : AppColors.textLightLight,
              FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPostItem(Map<String, dynamic> post, bool isDarkMode) {
    return Container(
      margin: EdgeInsets.only(bottom: 8.h),
      color: isDarkMode ? AppColors.cardDark : AppColors.cardLight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Post header
          Padding(
            padding: EdgeInsets.all(12.w),
            child: Row(
              children: [
                Container(
                  width: 40.w,
                  height: 40.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: NetworkImage(
                        _user.profilePictureUrl ?? 'https://i.pravatar.cc/300',
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            _user.fullName ?? _user.username,
                            style: AppStyle.textStyle(
                              14,
                              isDarkMode
                                  ? AppColors.textDarkDark
                                  : AppColors.textDarkLight,
                              FontWeight.w600,
                            ),
                          ),
                          if (_user.isVerified)
                            Padding(
                              padding: EdgeInsets.only(left: 4.w),
                              child: Icon(
                                Icons.verified,
                                color:
                                    isDarkMode
                                        ? AppColors.primaryDark
                                        : AppColors.primaryLight,
                                size: 14.sp,
                              ),
                            ),
                        ],
                      ),
                      Text(
                        post['timeAgo'],
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
                IconButton(
                  onPressed: () {
                    // Show post options
                  },
                  icon: Icon(
                    Icons.more_vert,
                    color:
                        isDarkMode
                            ? AppColors.textMediumDark
                            : AppColors.textMediumLight,
                  ),
                ),
              ],
            ),
          ),

          // Post content
          if (post['content'] != null)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              child: Text(
                post['content'],
                style: AppStyle.textStyle(
                  14,
                  isDarkMode ? AppColors.textDarkDark : AppColors.textDarkLight,
                  FontWeight.normal,
                ),
              ),
            ),

          SizedBox(height: 8.h),

          // Post media
          if (post['type'] == 'image' && post['imageUrl'] != null)
            Image.network(
              post['imageUrl'],
              width: double.infinity,
              height: 300.h,
              fit: BoxFit.cover,
            )
          else if (post['type'] == 'gallery' && post['imageUrls'] != null)
            SizedBox(
              height: 300.h,
              child: PageView.builder(
                itemCount: post['imageUrls'].length,
                itemBuilder: (context, index) {
                  return Image.network(
                    post['imageUrls'][index],
                    width: double.infinity,
                    height: 300.h,
                    fit: BoxFit.cover,
                  );
                },
              ),
            ),

          // Post actions
          Padding(
            padding: EdgeInsets.all(12.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.favorite_outline,
                      color:
                          isDarkMode
                              ? AppColors.textMediumDark
                              : AppColors.textMediumLight,
                      size: 24.sp,
                    ),
                    SizedBox(width: 16.w),
                    Icon(
                      Icons.comment_outlined,
                      color:
                          isDarkMode
                              ? AppColors.textMediumDark
                              : AppColors.textMediumLight,
                      size: 24.sp,
                    ),
                    SizedBox(width: 16.w),
                    Icon(
                      Icons.share_outlined,
                      color:
                          isDarkMode
                              ? AppColors.textMediumDark
                              : AppColors.textMediumLight,
                      size: 24.sp,
                    ),
                  ],
                ),
                Icon(
                  Icons.bookmark_outline,
                  color:
                      isDarkMode
                          ? AppColors.textMediumDark
                          : AppColors.textMediumLight,
                  size: 24.sp,
                ),
              ],
            ),
          ),

          // Likes count
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: Text(
              '${post['likesCount']} likes',
              style: AppStyle.textStyle(
                14,
                isDarkMode ? AppColors.textDarkDark : AppColors.textDarkLight,
                FontWeight.w600,
              ),
            ),
          ),

          // Comments count
          Padding(
            padding: EdgeInsets.only(
              left: 12.w,
              right: 12.w,
              top: 4.h,
              bottom: 12.h,
            ),
            child: Text(
              'View all ${post['commentsCount']} comments',
              style: AppStyle.textStyle(
                14,
                isDarkMode ? AppColors.textLightDark : AppColors.textLightLight,
                FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showLogoutConfirmation(BuildContext context, bool isDarkMode) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor:
              isDarkMode ? AppColors.cardDark : AppColors.cardLight,
          title: Text(
            'Đăng xuất',
            style: AppStyle.textStyle(
              18,
              isDarkMode ? AppColors.textDarkDark : AppColors.textDarkLight,
              FontWeight.w600,
            ),
          ),
          content: Text(
            'Bạn có chắc chắn muốn đăng xuất?',
            style: AppStyle.textStyle(
              16,
              isDarkMode ? AppColors.textMediumDark : AppColors.textMediumLight,
              FontWeight.normal,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Hủy',
                style: AppStyle.textStyle(
                  16,
                  isDarkMode
                      ? AppColors.textMediumDark
                      : AppColors.textMediumLight,
                  FontWeight.normal,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                // Logout action
                final authProvider = Provider.of<AuthProvider>(
                  context,
                  listen: false,
                );
                authProvider.logout().then((_) {
                  // Navigate to login screen
                  context.go(AppConstants.routeLogin);
                });
              },
              child: Text(
                'Đăng xuất',
                style: AppStyle.textStyle(
                  16,
                  isDarkMode ? AppColors.errorDark : AppColors.errorLight,
                  FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
