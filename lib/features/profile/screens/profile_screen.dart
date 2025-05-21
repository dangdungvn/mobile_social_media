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
              expandedHeight: 280.h,
              floating: true,
              pinned: true,
              backgroundColor:
                  isDarkMode ? AppColors.cardDark : AppColors.cardLight,
              elevation: 0,
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color:
                      isDarkMode
                          ? AppColors.textDarkDark
                          : AppColors.textDarkLight,
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
              actions: [
                // Theme toggle button
                Container(
                  margin: EdgeInsets.only(right: 8.w),
                  decoration: BoxDecoration(
                    color:
                        isDarkMode
                            ? AppColors.backgroundDark.withOpacity(0.4)
                            : AppColors.backgroundLight.withOpacity(0.7),
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
                // Settings button
                Container(
                  margin: EdgeInsets.only(right: 8.w),
                  decoration: BoxDecoration(
                    color:
                        isDarkMode
                            ? AppColors.backgroundDark.withOpacity(0.4)
                            : AppColors.backgroundLight.withOpacity(0.7),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    onPressed: () {
                      // Navigate to settings
                    },
                    icon: Icon(
                      Icons.settings,
                      color:
                          isDarkMode
                              ? AppColors.textDarkDark
                              : AppColors.textDarkLight,
                      size: 22.sp,
                    ),
                  ),
                ),
              ],
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  children: [
                    // Cover photo
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              isDarkMode
                                  ? AppColors.buttonGradientStartDark
                                  : AppColors.buttonGradientStartLight,
                              isDarkMode
                                  ? AppColors.buttonGradientEndDark
                                  : AppColors.buttonGradientEndLight,
                            ],
                          ),
                        ),
                        child: Opacity(
                          opacity: 0.3,
                          child: Image.network(
                            'https://images.unsplash.com/photo-1553095066-5014bc7b7f2d?q=80&w=2071&auto=format&fit=crop',
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Center(
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),

                    // Profile info content with gradient overlay
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.7),
                            ],
                            stops: const [0.6, 1.0],
                          ),
                        ),
                      ),
                    ),

                    // Back button
                    Positioned(
                      top: 40.h,
                      left: 16.w,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.3),
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          onPressed: () {
                            // Navigate back
                          },
                          icon: Icon(Icons.arrow_back, color: Colors.white),
                        ),
                      ),
                    ),

                    // Profile picture and name
                    Positioned(
                      bottom: 70.h,
                      left: 16.w,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          // Profile picture with border
                          Container(
                            width: 100.w,
                            height: 100.w,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color:
                                    isDarkMode
                                        ? AppColors.cardDark
                                        : Colors.white,
                                width: 4,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.3),
                                  blurRadius: 10,
                                  spreadRadius: 0,
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(50.r),
                              child: Image.network(
                                _user.profilePictureUrl!,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          SizedBox(width: 16.w),
                          // Username and verification
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    _user.fullName!,
                                    style: TextStyle(
                                      fontSize: 22.sp,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      shadows: [
                                        Shadow(
                                          blurRadius: 3,
                                          color: Colors.black.withOpacity(0.5),
                                          offset: const Offset(0, 1),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: 4.w),
                                  if (_user.isVerified)
                                    Icon(
                                      Icons.verified,
                                      color: AppColors.verified,
                                      size: 18.sp,
                                    ),
                                ],
                              ),
                              SizedBox(height: 2.h),
                              Text(
                                "@${_user.username}",
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  color: Colors.white.withOpacity(0.9),
                                  shadows: [
                                    Shadow(
                                      blurRadius: 3,
                                      color: Colors.black.withOpacity(0.5),
                                      offset: const Offset(0, 1),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Bio section
            SliverToBoxAdapter(
              child: Container(
                color: isDarkMode ? AppColors.cardDark : AppColors.cardLight,
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Bio text
                    if (_user.bio != null && _user.bio!.isNotEmpty)
                      Text(
                        _user.bio!,
                        style: TextStyle(
                          fontSize: 14.sp,
                          color:
                              isDarkMode
                                  ? AppColors.textMediumDark
                                  : AppColors.textMediumLight,
                          height: 1.4,
                        ),
                      ),

                    SizedBox(height: 16.h),

                    // Stats row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStatItem(
                          context: context,
                          count: _userPosts.length,
                          label: "Posts",
                          isDarkMode: isDarkMode,
                        ),
                        _buildStatItem(
                          context: context,
                          count: _user.followers?.length ?? 0,
                          label: "Followers",
                          isDarkMode: isDarkMode,
                        ),
                        _buildStatItem(
                          context: context,
                          count: _user.following?.length ?? 0,
                          label: "Following",
                          isDarkMode: isDarkMode,
                        ),
                      ],
                    ),

                    SizedBox(height: 16.h),

                    // Action buttons row
                    Row(
                      children: [
                        // Edit Profile button
                        Expanded(
                          child: Container(
                            height: 40.h,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.r),
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
                                          ? AppColors.primaryDark.withOpacity(
                                            0.3,
                                          )
                                          : AppColors.primaryLight.withOpacity(
                                            0.3,
                                          ),
                                  blurRadius: 8,
                                  spreadRadius: 0,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Text(
                                "Edit Profile",
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),

                        SizedBox(width: 12.w),

                        // Share Profile button
                        Container(
                          height: 40.h,
                          width: 40.h,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color:
                                isDarkMode
                                    ? AppColors.backgroundDark
                                    : AppColors.backgroundLight,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 8,
                                spreadRadius: 0,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Icon(
                              Icons.share_outlined,
                              color:
                                  isDarkMode
                                      ? AppColors.textMediumDark
                                      : AppColors.textMediumLight,
                              size: 20.sp,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Tab bar
            SliverPersistentHeader(
              delegate: _SliverAppBarDelegate(
                TabBar(
                  controller: _tabController,
                  labelColor:
                      isDarkMode
                          ? AppColors.primaryDark
                          : AppColors.primaryLight,
                  unselectedLabelColor:
                      isDarkMode
                          ? AppColors.textMediumDark
                          : AppColors.textMediumLight,
                  indicatorColor:
                      isDarkMode
                          ? AppColors.primaryDark
                          : AppColors.primaryLight,
                  indicatorWeight: 3.0,
                  tabs: [
                    Tab(icon: Icon(Icons.grid_on_rounded)),
                    Tab(icon: Icon(Icons.bookmark_border)),
                    Tab(icon: Icon(Icons.person_pin_outlined)),
                  ],
                ),
                isDarkMode: isDarkMode,
              ),
              pinned: true,
            ),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: [
            // Posts Tab
            _buildPostsGrid(isDarkMode),

            // Saved Tab
            _buildSavedGrid(isDarkMode),

            // Tagged Tab
            _buildTaggedGrid(isDarkMode),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem({
    required BuildContext context,
    required int count,
    required String label,
    required bool isDarkMode,
  }) {
    return Column(
      children: [
        Text(
          "$count",
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color:
                isDarkMode ? AppColors.textDarkDark : AppColors.textDarkLight,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          label,
          style: TextStyle(
            fontSize: 14.sp,
            color:
                isDarkMode
                    ? AppColors.textMediumDark
                    : AppColors.textMediumLight,
          ),
        ),
      ],
    );
  }

  Widget _buildPostsGrid(bool isDarkMode) {
    return GridView.builder(
      padding: EdgeInsets.all(1.w),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 2.w,
        mainAxisSpacing: 2.w,
      ),
      itemCount: _userPosts.length,
      itemBuilder: (context, index) {
        final post = _userPosts[index];
        return InkWell(
          onTap: () {
            // Navigate to post details
          },
          child: Container(
            decoration: BoxDecoration(
              color:
                  isDarkMode
                      ? AppColors.backgroundDark
                      : AppColors.backgroundLight,
              image:
                  post['imageUrl'] != null ||
                          (post['imageUrls'] != null &&
                              (post['imageUrls'] as List).isNotEmpty)
                      ? DecorationImage(
                        image: NetworkImage(
                          post['imageUrl'] ?? post['imageUrls'][0],
                        ),
                        fit: BoxFit.cover,
                      )
                      : null,
            ),
            child:
                post['type'] == 'gallery'
                    ? Align(
                      alignment: Alignment.topRight,
                      child: Container(
                        margin: EdgeInsets.all(4.w),
                        padding: EdgeInsets.all(2.w),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                        child: Icon(
                          Icons.collections,
                          color: Colors.white,
                          size: 14.sp,
                        ),
                      ),
                    )
                    : post['imageUrl'] == null
                    ? Center(
                      child: Icon(
                        Icons.article_outlined,
                        color:
                            isDarkMode
                                ? AppColors.textMediumDark
                                : AppColors.textMediumLight,
                        size: 24.sp,
                      ),
                    )
                    : null,
          ),
        );
      },
    );
  }

  Widget _buildSavedGrid(bool isDarkMode) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.bookmark_border,
            size: 64.sp,
            color:
                isDarkMode ? AppColors.textLightDark : AppColors.textLightLight,
          ),
          SizedBox(height: 16.h),
          Text(
            "No Saved Posts",
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color:
                  isDarkMode ? AppColors.textDarkDark : AppColors.textDarkLight,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            "Items you save will appear here",
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

  Widget _buildTaggedGrid(bool isDarkMode) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.person_pin_outlined,
            size: 64.sp,
            color:
                isDarkMode ? AppColors.textLightDark : AppColors.textLightLight,
          ),
          SizedBox(height: 16.h),
          Text(
            "No Tagged Posts",
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color:
                  isDarkMode ? AppColors.textDarkDark : AppColors.textDarkLight,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            "When people tag you, it will appear here",
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
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar _tabBar;
  final bool isDarkMode;

  _SliverAppBarDelegate(this._tabBar, {required this.isDarkMode});

  @override
  double get minExtent => _tabBar.preferredSize.height;

  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      color: isDarkMode ? AppColors.cardDark : AppColors.cardLight,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return oldDelegate.isDarkMode != isDarkMode;
  }
}
