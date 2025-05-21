import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
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
  final FocusNode _focusNode = FocusNode();

  // Mock search results
  List<UserModel> _userResults = [];
  List<PostModel> _postResults = [];
  final List<String> _tagResults = [
    'technology',
    'design',
    'flutter',
    'mobile',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(_handleTabSelection);
  }

  void _handleTabSelection() {
    if (_tabController.indexIsChanging) {
      _focusNode.unfocus();
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _tabController.removeListener(_handleTabSelection);
    _tabController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _performSearch() {
    if (_searchController.text.isEmpty) return;

    setState(() {
      _isLoading = true;
      _currentQuery = _searchController.text;
      _hasSearched = true;
    });

    // Simulate API call (would be replaced with real API call)
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
      appBar: AppBar(
        elevation: 0,
        backgroundColor: isDarkMode ? AppColors.cardDark : AppColors.cardLight,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color:
                isDarkMode ? AppColors.textDarkDark : AppColors.textDarkLight,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Tìm kiếm',
          style: AppStyle.textStyle(
            18,
            isDarkMode ? AppColors.textDarkDark : AppColors.textDarkLight,
            FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Search bar
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
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
                      focusNode: _focusNode,
                      style: AppStyle.textStyle(
                        14,
                        isDarkMode
                            ? AppColors.textDarkDark
                            : AppColors.textDarkLight,
                        FontWeight.normal,
                      ),
                      decoration: InputDecoration(
                        hintText: "Tìm kiếm người dùng, bài viết, hashtag...",
                        hintStyle: AppStyle.textStyle(
                          14,
                          isDarkMode
                              ? AppColors.textLightDark
                              : AppColors.textLightLight,
                          FontWeight.normal,
                        ),
                        prefixIcon: Icon(
                          CupertinoIcons.search,
                          color:
                              isDarkMode
                                  ? AppColors.textLightDark
                                  : AppColors.textLightLight,
                          size: 20.sp,
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
                                    CupertinoIcons.clear_circled_solid,
                                    color:
                                        isDarkMode
                                            ? AppColors.textLightDark
                                            : AppColors.textLightLight,
                                    size: 18.sp,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _searchController.clear();
                                      _hasSearched = false;
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
                    child: GestureDetector(
                      onTap: _performSearch,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 8.h,
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topRight,
                            end: Alignment.bottomLeft,
                            colors: [
                              isDarkMode
                                  ? AppColors.primaryDark
                                  : AppColors.primaryLight,
                              isDarkMode
                                  ? AppColors.accentDark
                                  : AppColors.accentLight,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: Text(
                          "Tìm",
                          style: AppStyle.textStyle(
                            14,
                            Colors.white,
                            FontWeight.w600,
                          ),
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
                    isDarkMode ? AppColors.primaryDark : AppColors.primaryLight,
                unselectedLabelColor:
                    isDarkMode
                        ? AppColors.textMediumDark
                        : AppColors.textMediumLight,
                indicatorColor:
                    isDarkMode ? AppColors.primaryDark : AppColors.primaryLight,
                indicatorSize: TabBarIndicatorSize.label,
                tabs: [
                  Tab(text: "Tất cả"),
                  Tab(text: "Người"),
                  Tab(text: "Bài viết"),
                  Tab(text: "Hashtag"),
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
                        _buildHashtagResults(isDarkMode),
                      ],
                    ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchSuggestions(bool isDarkMode) {
    return ListView(
      padding: EdgeInsets.all(16.w),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Tìm kiếm gần đây",
              style: AppStyle.textStyle(
                16,
                isDarkMode ? AppColors.textDarkDark : AppColors.textDarkLight,
                FontWeight.w600,
              ),
            ),
            GestureDetector(
              onTap: () {
                // Xóa lịch sử tìm kiếm
              },
              child: Text(
                "Xóa tất cả",
                style: AppStyle.textStyle(
                  13,
                  isDarkMode ? AppColors.primaryDark : AppColors.primaryLight,
                  FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 16.h),

        // Recent searches
        _buildRecentSearchItem("Jane Smith", isDarkMode, CupertinoIcons.person),
        _buildRecentSearchItem(
          "#technology",
          isDarkMode,
          CupertinoIcons.number,
        ),
        _buildRecentSearchItem("Blockchain", isDarkMode, CupertinoIcons.search),

        SizedBox(height: 24.h),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Xu hướng",
              style: AppStyle.textStyle(
                16,
                isDarkMode ? AppColors.textDarkDark : AppColors.textDarkLight,
                FontWeight.w600,
              ),
            ),
            Icon(
              CupertinoIcons.flame_fill,
              color: AppColors.secondaryLight,
              size: 20.sp,
            ),
          ],
        ),

        SizedBox(height: 16.h),

        // Trending topics
        _buildTrendingTopicItem("#WorldNewsToday", "10K bài viết", isDarkMode),
        _buildTrendingTopicItem(
          "#TechnologyTrends",
          "8.5K bài viết",
          isDarkMode,
        ),
        _buildTrendingTopicItem(
          "#SustainableLiving",
          "6.2K bài viết",
          isDarkMode,
        ),
        _buildTrendingTopicItem(
          "#DigitalArtGallery",
          "5.7K bài viết",
          isDarkMode,
        ),
      ],
    );
  }

  Widget _buildRecentSearchItem(String text, bool isDarkMode, IconData icon) {
    return Dismissible(
      key: Key(text),
      background: Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20.0),
        color: AppColors.errorLight,
        child: Icon(CupertinoIcons.delete, color: Colors.white),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        // Xóa mục tìm kiếm gần đây
      },
      child: InkWell(
        onTap: () {
          // Set search text
          _searchController.text =
              text.startsWith("#") ? text.substring(1) : text;
          _performSearch();
        },
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 12.h),
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
              SizedBox(width: 16.w),
              Expanded(
                child: Text(
                  text,
                  style: AppStyle.textStyle(
                    14,
                    isDarkMode
                        ? AppColors.textMediumDark
                        : AppColors.textMediumLight,
                    FontWeight.normal,
                  ),
                ),
              ),
              Icon(
                CupertinoIcons.arrow_up_left,
                color:
                    isDarkMode
                        ? AppColors.textLightDark
                        : AppColors.textLightLight,
                size: 18.sp,
              ),
            ],
          ),
        ),
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
            Container(
              width: 40.w,
              height: 40.w,
              decoration: BoxDecoration(
                color: isDarkMode ? AppColors.cardDark : AppColors.cardLight,
                borderRadius: BorderRadius.circular(8.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: Center(
                child: Icon(
                  CupertinoIcons.number_square,
                  color: AppColors.primaryLight,
                ),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
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
            ),
            Icon(
              CupertinoIcons.arrow_up_right_square,
              color: AppColors.accentLight,
              size: 24.sp,
            ),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Người",
                style: AppStyle.textStyle(
                  16,
                  isDarkMode ? AppColors.textDarkDark : AppColors.textDarkLight,
                  FontWeight.w600,
                ),
              ),
              if (_userResults.length > 2)
                GestureDetector(
                  onTap: () {
                    _tabController.animateTo(1); // Switch to People tab
                  },
                  child: Text(
                    "Xem tất cả",
                    style: AppStyle.textStyle(
                      13,
                      isDarkMode
                          ? AppColors.primaryDark
                          : AppColors.primaryLight,
                      FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: 12.h),
          ...List.generate(
            _userResults.length > 2 ? 2 : _userResults.length,
            (index) => SearchResultUserItem(user: _userResults[index]),
          ),
        ],

        SizedBox(height: 24.h),

        // Posts section
        if (_postResults.isNotEmpty) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Bài viết",
                style: AppStyle.textStyle(
                  16,
                  isDarkMode ? AppColors.textDarkDark : AppColors.textDarkLight,
                  FontWeight.w600,
                ),
              ),
              if (_postResults.length > 1)
                GestureDetector(
                  onTap: () {
                    _tabController.animateTo(2); // Switch to Posts tab
                  },
                  child: Text(
                    "Xem tất cả",
                    style: AppStyle.textStyle(
                      13,
                      isDarkMode
                          ? AppColors.primaryDark
                          : AppColors.primaryLight,
                      FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: 12.h),
          ...List.generate(
            _postResults.length > 1 ? 1 : _postResults.length,
            (index) => Column(
              children: [
                PostCard(post: _postResults[index]),
                SizedBox(height: 8.h),
              ],
            ),
          ),
        ],

        SizedBox(height: 24.h),

        // Hashtags section
        if (_tagResults.isNotEmpty) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Hashtag",
                style: AppStyle.textStyle(
                  16,
                  isDarkMode ? AppColors.textDarkDark : AppColors.textDarkLight,
                  FontWeight.w600,
                ),
              ),
              GestureDetector(
                onTap: () {
                  _tabController.animateTo(3); // Switch to Hashtags tab
                },
                child: Text(
                  "Xem tất cả",
                  style: AppStyle.textStyle(
                    13,
                    isDarkMode ? AppColors.primaryDark : AppColors.primaryLight,
                    FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          _buildHashtagGrid(isDarkMode, limit: 4),
        ],

        // No results message
        if (_userResults.isEmpty && _postResults.isEmpty)
          _buildNoResultsMessage(isDarkMode),
      ],
    );
  }

  Widget _buildPeopleResults(bool isDarkMode) {
    if (_userResults.isEmpty) {
      return _buildNoResultsMessage(
        isDarkMode,
        icon: CupertinoIcons.person_alt_circle,
        message: "Không tìm thấy người dùng nào với từ khóa \"$_currentQuery\"",
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
      return _buildNoResultsMessage(
        isDarkMode,
        icon: CupertinoIcons.doc_text,
        message: "Không tìm thấy bài viết nào với từ khóa \"$_currentQuery\"",
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

  Widget _buildHashtagResults(bool isDarkMode) {
    if (_tagResults.isEmpty) {
      return _buildNoResultsMessage(
        isDarkMode,
        icon: CupertinoIcons.number_square,
        message: "Không tìm thấy hashtag nào với từ khóa \"$_currentQuery\"",
      );
    }

    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Trending hashtags',
            style: AppStyle.textStyle(
              16,
              isDarkMode ? AppColors.textDarkDark : AppColors.textDarkLight,
              FontWeight.w600,
            ),
          ),
          SizedBox(height: 16.h),
          _buildHashtagGrid(isDarkMode),
        ],
      ),
    );
  }

  Widget _buildHashtagGrid(bool isDarkMode, {int? limit}) {
    final displayTags =
        limit != null ? _tagResults.take(limit).toList() : _tagResults;

    return GridView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 2.5,
        crossAxisSpacing: 12.w,
        mainAxisSpacing: 12.h,
      ),
      itemCount: displayTags.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            _searchController.text = displayTags[index];
            _performSearch();
          },
          child: Container(
            decoration: BoxDecoration(
              color: isDarkMode ? AppColors.cardDark : AppColors.cardLight,
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(
                color:
                    isDarkMode ? AppColors.dividerDark : AppColors.dividerLight,
              ),
            ),
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: Row(
              children: [
                Container(
                  width: 32.w,
                  height: 32.w,
                  decoration: BoxDecoration(
                    color:
                        isDarkMode
                            ? AppColors.primaryDark.withOpacity(0.1)
                            : AppColors.primaryLight.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Icon(
                      CupertinoIcons.number,
                      size: 16.sp,
                      color:
                          isDarkMode
                              ? AppColors.primaryDark
                              : AppColors.primaryLight,
                    ),
                  ),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: Text(
                    '#${displayTags[index]}',
                    style: AppStyle.textStyle(
                      13,
                      isDarkMode
                          ? AppColors.textDarkDark
                          : AppColors.textDarkLight,
                      FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildNoResultsMessage(
    bool isDarkMode, {
    IconData icon = CupertinoIcons.search,
    String? message,
  }) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80.w,
              height: 80.w,
              decoration: BoxDecoration(
                color:
                    isDarkMode ? AppColors.cardDark : AppColors.backgroundLight,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Icon(
                icon,
                size: 40.sp,
                color:
                    isDarkMode
                        ? AppColors.textLightDark
                        : AppColors.textLightLight,
              ),
            ),
            SizedBox(height: 24.h),
            Text(
              message ??
                  "Không tìm thấy kết quả nào với từ khóa \"$_currentQuery\"",
              style: AppStyle.textStyle(
                16,
                isDarkMode
                    ? AppColors.textMediumDark
                    : AppColors.textMediumLight,
                FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 12.h),
            Text(
              "Hãy thử với từ khóa khác",
              style: AppStyle.textStyle(
                14,
                isDarkMode ? AppColors.textLightDark : AppColors.textLightLight,
                FontWeight.normal,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
