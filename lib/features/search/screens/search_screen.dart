import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile/common/providers/theme_provider.dart';
import 'package:mobile/common/utils/app_colors.dart';
import 'package:mobile/common/utils/app_style.dart';
import 'package:mobile/features/auth/models/user_model.dart';
import 'package:mobile/features/feed/models/post_model.dart';
import 'package:mobile/features/feed/widgets/post_card.dart';
import 'package:mobile/features/search/widgets/search_result_user_item.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  bool _isLoading = false;
  bool _hasSearched = false;
  String _currentQuery = '';
  late TabController _tabController;

  // Mock search results
  List<UserModel> _userResults = [];
  List<PostModel> _postResults = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  void _performSearch() {
    if (_searchController.text.isEmpty) return;

    setState(() {
      _isLoading = true;
      _currentQuery = _searchController.text;
      _hasSearched = true;
    });

    // Simulate API call
    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        // Mock user results
        _userResults = [
          UserModel(
            id: 'user1',
            username: 'john_doe',
            email: 'john@example.com',
            fullName: 'John Doe',
            profilePictureUrl: 'https://i.pravatar.cc/150?img=1',
            bio: 'Software developer and tech enthusiast',
            isVerified: true,
          ),
          UserModel(
            id: 'user2',
            username: 'jane_smith',
            email: 'jane@example.com',
            fullName: 'Jane Smith',
            profilePictureUrl: 'https://i.pravatar.cc/150?img=5',
            bio: 'Digital marketing specialist',
            isOnline: true,
          ),
          UserModel(
            id: 'user3',
            username: 'mike_johnson',
            email: 'mike@example.com',
            fullName: 'Mike Johnson',
            profilePictureUrl: 'https://i.pravatar.cc/150?img=8',
            bio: 'Photographer and traveler',
          ),
        ];

        // Mock post results
        _postResults = [
          PostModel(
            id: 'post1',
            userId: 'user1',
            username: 'John Doe',
            userProfilePicture: 'https://i.pravatar.cc/150?img=1',
            content:
                'Just finished reading an amazing book on artificial intelligence. It\'s incredible how far we\'ve come in this field! #AI #Technology',
            type: PostType.text,
            createdAt: DateTime.now().subtract(Duration(days: 2)),
            likeCount: 42,
            commentCount: 8,
            shareCount: 3,
          ),
          PostModel(
            id: 'post2',
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
            createdAt: DateTime.now().subtract(Duration(days: 3)),
            likeCount: 156,
            commentCount: 23,
            shareCount: 12,
          ),
        ];

        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;

    return Scaffold(
      backgroundColor:
          isDarkMode ? AppColors.backgroundDark : AppColors.backgroundLight,
      body: SafeArea(
        child: Column(
          children: [
            // Search bar
            Container(
              padding: EdgeInsets.all(16.w),
              color: isDarkMode ? AppColors.cardDark : AppColors.cardLight,
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 46.h,
                      decoration: BoxDecoration(
                        color:
                            isDarkMode
                                ? AppColors.backgroundDark
                                : AppColors.backgroundLight,
                        borderRadius: BorderRadius.circular(23.r),
                        border: Border.all(
                          color:
                              isDarkMode
                                  ? AppColors.dividerDark
                                  : AppColors.dividerLight,
                          width: 1,
                        ),
                      ),
                      child: TextField(
                        controller: _searchController,
                        style: AppStyle.textStyle(
                          14,
                          isDarkMode
                              ? AppColors.textDarkDark
                              : AppColors.textDarkLight,
                          FontWeight.normal,
                        ),
                        decoration: InputDecoration(
                          hintText: "Search people, posts, hashtags...",
                          hintStyle: AppStyle.textStyle(
                            14,
                            isDarkMode
                                ? AppColors.textLightDark
                                : AppColors.textLightLight,
                            FontWeight.normal,
                          ),
                          prefixIcon: Icon(
                            Icons.search,
                            color:
                                isDarkMode
                                    ? AppColors.textLightDark
                                    : AppColors.textLightLight,
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 12.h,
                            horizontal: 16.w,
                          ),
                          suffixIcon:
                              _searchController.text.isNotEmpty
                                  ? IconButton(
                                    icon: Icon(
                                      Icons.clear,
                                      color:
                                          isDarkMode
                                              ? AppColors.textLightDark
                                              : AppColors.textLightLight,
                                      size: 18.sp,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _searchController.clear();
                                      });
                                    },
                                  )
                                  : null,
                        ),
                        textInputAction: TextInputAction.search,
                        onSubmitted: (_) => _performSearch(),
                        onChanged: (value) {
                          setState(() {});
                        },
                      ),
                    ),
                  ),

                  if (_searchController.text.isNotEmpty)
                    Padding(
                      padding: EdgeInsets.only(left: 12.w),
                      child: TextButton(
                        onPressed: _performSearch,
                        child: Text(
                          "Search",
                          style: AppStyle.textStyle(
                            14,
                            isDarkMode
                                ? AppColors.primaryDark
                                : AppColors.primaryLight,
                            FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // Tab bar for search results
            if (_hasSearched)
              Container(
                color: isDarkMode ? AppColors.cardDark : AppColors.cardLight,
                child: TabBar(
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
                  tabs: [
                    Tab(text: "Top"),
                    Tab(text: "People"),
                    Tab(text: "Posts"),
                  ],
                ),
              ),

            // Search results or suggestions
            Expanded(
              child:
                  _isLoading
                      ? Center(
                        child: CircularProgressIndicator(
                          color:
                              isDarkMode
                                  ? AppColors.primaryDark
                                  : AppColors.primaryLight,
                        ),
                      )
                      : !_hasSearched
                      ? _buildSearchSuggestions(isDarkMode)
                      : TabBarView(
                        controller: _tabController,
                        children: [
                          _buildTopResults(isDarkMode),
                          _buildPeopleResults(isDarkMode),
                          _buildPostResults(isDarkMode),
                        ],
                      ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchSuggestions(bool isDarkMode) {
    return Container(
      color: isDarkMode ? AppColors.backgroundDark : AppColors.backgroundLight,
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Recent Searches",
            style: AppStyle.textStyle(
              16,
              isDarkMode ? AppColors.textDarkDark : AppColors.textDarkLight,
              FontWeight.w600,
            ),
          ),

          SizedBox(height: 16.h),

          // Recent searches
          _buildRecentSearchItem("Jane Smith", isDarkMode, Icons.person),
          _buildRecentSearchItem("#technology", isDarkMode, Icons.tag),
          _buildRecentSearchItem("Blockchain", isDarkMode, Icons.search),

          SizedBox(height: 24.h),

          Text(
            "Trending Topics",
            style: AppStyle.textStyle(
              16,
              isDarkMode ? AppColors.textDarkDark : AppColors.textDarkLight,
              FontWeight.w600,
            ),
          ),

          SizedBox(height: 16.h),

          // Trending topics
          _buildTrendingTopicItem("#WorldNewsToday", "10K posts", isDarkMode),
          _buildTrendingTopicItem(
            "#TechnologyTrends",
            "8.5K posts",
            isDarkMode,
          ),
          _buildTrendingTopicItem(
            "#SustainableLiving",
            "6.2K posts",
            isDarkMode,
          ),
          _buildTrendingTopicItem(
            "#DigitalArtGallery",
            "5.7K posts",
            isDarkMode,
          ),
        ],
      ),
    );
  }

  Widget _buildRecentSearchItem(String text, bool isDarkMode, IconData icon) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        children: [
          Icon(
            icon,
            color:
                isDarkMode
                    ? AppColors.textMediumDark
                    : AppColors.textMediumLight,
            size: 18.sp,
          ),

          SizedBox(width: 12.w),

          Text(
            text,
            style: AppStyle.textStyle(
              14,
              isDarkMode ? AppColors.textMediumDark : AppColors.textMediumLight,
              FontWeight.normal,
            ),
          ),

          Spacer(),

          GestureDetector(
            onTap: () {
              // Set search text
              _searchController.text =
                  text.startsWith("#") ? text.substring(1) : text;
              _performSearch();
            },
            child: Icon(
              Icons.north_west,
              color:
                  isDarkMode
                      ? AppColors.textLightDark
                      : AppColors.textLightLight,
              size: 18.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrendingTopicItem(
    String hashtag,
    String postCount,
    bool isDarkMode,
  ) {
    return GestureDetector(
      onTap: () {
        // Set search text
        _searchController.text =
            hashtag.startsWith("#") ? hashtag.substring(1) : hashtag;
        _performSearch();
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.h),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color:
                  isDarkMode ? AppColors.dividerDark : AppColors.dividerLight,
              width: 1,
            ),
          ),
        ),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  hashtag,
                  style: AppStyle.textStyle(
                    14,
                    isDarkMode
                        ? AppColors.textDarkDark
                        : AppColors.textDarkLight,
                    FontWeight.w600,
                  ),
                ),

                SizedBox(height: 4.h),

                Text(
                  postCount,
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

            Spacer(),

            Icon(Icons.trending_up, color: AppColors.accentLight),
          ],
        ),
      ),
    );
  }

  Widget _buildTopResults(bool isDarkMode) {
    return ListView(
      padding: EdgeInsets.all(16.w),
      children: [
        // Users section
        if (_userResults.isNotEmpty) ...[
          Text(
            "People",
            style: AppStyle.textStyle(
              16,
              isDarkMode ? AppColors.textDarkDark : AppColors.textDarkLight,
              FontWeight.w600,
            ),
          ),

          SizedBox(height: 12.h),

          ...List.generate(
            _userResults.length > 2 ? 2 : _userResults.length,
            (index) => SearchResultUserItem(user: _userResults[index]),
          ),

          if (_userResults.length > 2)
            Padding(
              padding: EdgeInsets.only(top: 8.h, bottom: 16.h),
              child: TextButton(
                onPressed: () {
                  _tabController.animateTo(1); // Switch to People tab
                },
                child: Text(
                  "See all people results",
                  style: AppStyle.textStyle(
                    14,
                    isDarkMode ? AppColors.primaryDark : AppColors.primaryLight,
                    FontWeight.w600,
                  ),
                ),
              ),
            ),
        ],

        SizedBox(height: 16.h),

        // Posts section
        if (_postResults.isNotEmpty) ...[
          Text(
            "Posts",
            style: AppStyle.textStyle(
              16,
              isDarkMode ? AppColors.textDarkDark : AppColors.textDarkLight,
              FontWeight.w600,
            ),
          ),

          SizedBox(height: 12.h),

          ...List.generate(
            _postResults.length > 2 ? 2 : _postResults.length,
            (index) => Column(
              children: [
                PostCard(post: _postResults[index]),
                SizedBox(height: 8.h),
              ],
            ),
          ),

          if (_postResults.length > 2)
            Padding(
              padding: EdgeInsets.only(top: 8.h),
              child: TextButton(
                onPressed: () {
                  _tabController.animateTo(2); // Switch to Posts tab
                },
                child: Text(
                  "See all post results",
                  style: AppStyle.textStyle(
                    14,
                    isDarkMode ? AppColors.primaryDark : AppColors.primaryLight,
                    FontWeight.w600,
                  ),
                ),
              ),
            ),
        ],

        // No results message
        if (_userResults.isEmpty && _postResults.isEmpty)
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.search_off,
                  size: 64.sp,
                  color:
                      isDarkMode
                          ? AppColors.textLightDark
                          : AppColors.textLightLight,
                ),

                SizedBox(height: 16.h),

                Text(
                  "No results found for \"$_currentQuery\"",
                  style: AppStyle.textStyle(
                    16,
                    isDarkMode
                        ? AppColors.textMediumDark
                        : AppColors.textMediumLight,
                    FontWeight.w500,
                  ),
                ),

                SizedBox(height: 8.h),

                Text(
                  "Try different keywords or check spelling",
                  style: AppStyle.textStyle(
                    14,
                    isDarkMode
                        ? AppColors.textLightDark
                        : AppColors.textLightLight,
                    FontWeight.normal,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildPeopleResults(bool isDarkMode) {
    if (_userResults.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.person_off,
              size: 64.sp,
              color:
                  isDarkMode
                      ? AppColors.textLightDark
                      : AppColors.textLightLight,
            ),

            SizedBox(height: 16.h),

            Text(
              "No people found for \"$_currentQuery\"",
              style: AppStyle.textStyle(
                16,
                isDarkMode
                    ? AppColors.textMediumDark
                    : AppColors.textMediumLight,
                FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(16.w),
      itemCount: _userResults.length,
      itemBuilder: (context, index) {
        return SearchResultUserItem(user: _userResults[index]);
      },
    );
  }

  Widget _buildPostResults(bool isDarkMode) {
    if (_postResults.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.article_outlined,
              size: 64.sp,
              color:
                  isDarkMode
                      ? AppColors.textLightDark
                      : AppColors.textLightLight,
            ),

            SizedBox(height: 16.h),

            Text(
              "No posts found for \"$_currentQuery\"",
              style: AppStyle.textStyle(
                16,
                isDarkMode
                    ? AppColors.textMediumDark
                    : AppColors.textMediumLight,
                FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      itemCount: _postResults.length,
      itemBuilder: (context, index) {
        return PostCard(post: _postResults[index]);
      },
    );
  }
}
