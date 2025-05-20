import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/common/providers/theme_provider.dart';
import 'package:mobile/common/utils/app_colors.dart';
import 'package:mobile/common/utils/app_style.dart';
import 'package:mobile/features/feed/models/comment_model.dart';
import 'package:mobile/features/feed/models/post_model.dart';
import 'package:mobile/features/feed/widgets/comment_item.dart';
import 'package:mobile/features/feed/widgets/post_card.dart';
import 'package:provider/provider.dart';

class PostDetailScreen extends StatefulWidget {
  final String postId;

  const PostDetailScreen({super.key, required this.postId});

  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  final TextEditingController _commentController = TextEditingController();
  bool _isLoading = false;
  late PostModel _post;
  List<CommentModel> _comments = [];
  String _commentSortOption = "Top"; // Default sort option (Top, New, Old)

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;

    if (_isLoading) {
      return Scaffold(
        backgroundColor:
            isDarkMode ? AppColors.backgroundDark : AppColors.backgroundLight,
        appBar: AppBar(
          backgroundColor:
              isDarkMode ? AppColors.cardDark : AppColors.cardLight,
          leading: IconButton(
            onPressed: () => context.pop(),
            icon: Icon(
              Icons.arrow_back,
              color:
                  isDarkMode ? AppColors.textDarkDark : AppColors.textDarkLight,
            ),
          ),
          title: Text(
            "Post",
            style: AppStyle.textStyle(
              18,
              isDarkMode ? AppColors.textDarkDark : AppColors.textDarkLight,
              FontWeight.w600,
            ),
          ),
          elevation: 0,
        ),
        body: Center(
          child: CircularProgressIndicator(
            color: isDarkMode ? AppColors.primaryDark : AppColors.primaryLight,
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor:
          isDarkMode ? AppColors.backgroundDark : AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: isDarkMode ? AppColors.cardDark : AppColors.cardLight,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: Icon(
            Icons.arrow_back,
            color:
                isDarkMode ? AppColors.textDarkDark : AppColors.textDarkLight,
          ),
        ),
        title: Text(
          "Post",
          style: AppStyle.textStyle(
            18,
            isDarkMode ? AppColors.textDarkDark : AppColors.textDarkLight,
            FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              // Share post
            },
            icon: Icon(
              Icons.share_outlined,
              color:
                  isDarkMode ? AppColors.textDarkDark : AppColors.textDarkLight,
            ),
          ),
          IconButton(
            onPressed: () {
              // More options
            },
            icon: Icon(
              Icons.more_vert,
              color:
                  isDarkMode ? AppColors.textDarkDark : AppColors.textDarkLight,
            ),
          ),
        ],
        elevation: 0,
      ),
      body: Column(
        children: [
          // Post content
          Expanded(
            child: ListView(
              children: [
                // Post card
                PostCard(post: _post),

                SizedBox(height: 8.h),

                // Comments section
                Container(
                  color: isDarkMode ? AppColors.cardDark : AppColors.cardLight,
                  padding: EdgeInsets.all(16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Comments header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Comments (${_post.commentCount})",
                            style: AppStyle.textStyle(
                              16,
                              isDarkMode
                                  ? AppColors.textDarkDark
                                  : AppColors.textDarkLight,
                              FontWeight.w600,
                            ),
                          ),

                          // Sort dropdown
                          PopupMenuButton<String>(
                            onSelected: (value) {
                              setState(() {
                                _commentSortOption = value;
                                _sortComments();
                              });
                            },
                            itemBuilder:
                                (context) => [
                                  PopupMenuItem(
                                    value: "Top",
                                    child: Text(
                                      "Top Comments",
                                      style: TextStyle(
                                        color:
                                            _commentSortOption == "Top"
                                                ? isDarkMode
                                                    ? AppColors.primaryDark
                                                    : AppColors.primaryLight
                                                : isDarkMode
                                                ? AppColors.textMediumDark
                                                : AppColors.textMediumLight,
                                        fontWeight:
                                            _commentSortOption == "Top"
                                                ? FontWeight.w600
                                                : FontWeight.normal,
                                      ),
                                    ),
                                  ),
                                  PopupMenuItem(
                                    value: "New",
                                    child: Text(
                                      "Newest First",
                                      style: TextStyle(
                                        color:
                                            _commentSortOption == "New"
                                                ? isDarkMode
                                                    ? AppColors.primaryDark
                                                    : AppColors.primaryLight
                                                : isDarkMode
                                                ? AppColors.textMediumDark
                                                : AppColors.textMediumLight,
                                        fontWeight:
                                            _commentSortOption == "New"
                                                ? FontWeight.w600
                                                : FontWeight.normal,
                                      ),
                                    ),
                                  ),
                                  PopupMenuItem(
                                    value: "Old",
                                    child: Text(
                                      "Oldest First",
                                      style: TextStyle(
                                        color:
                                            _commentSortOption == "Old"
                                                ? isDarkMode
                                                    ? AppColors.primaryDark
                                                    : AppColors.primaryLight
                                                : isDarkMode
                                                ? AppColors.textMediumDark
                                                : AppColors.textMediumLight,
                                        fontWeight:
                                            _commentSortOption == "Old"
                                                ? FontWeight.w600
                                                : FontWeight.normal,
                                      ),
                                    ),
                                  ),
                                ],
                            child: Row(
                              children: [
                                Text(
                                  "Sort by: $_commentSortOption",
                                  style: AppStyle.textStyle(
                                    14,
                                    isDarkMode
                                        ? AppColors.textMediumDark
                                        : AppColors.textMediumLight,
                                    FontWeight.normal,
                                  ),
                                ),
                                Icon(
                                  Icons.arrow_drop_down,
                                  color:
                                      isDarkMode
                                          ? AppColors.textMediumDark
                                          : AppColors.textMediumLight,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 16.h),

                      // Top-level comments
                      ..._buildCommentList(null),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Comment input field
          Container(
            padding: EdgeInsets.all(12.w),
            color: isDarkMode ? AppColors.cardDark : AppColors.cardLight,
            child: SafeArea(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // User avatar
                  Container(
                    width: 36.w,
                    height: 36.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: NetworkImage('https://i.pravatar.cc/150?img=65'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),

                  SizedBox(width: 12.w),

                  // Comment text field
                  Expanded(
                    child: TextField(
                      controller: _commentController,
                      minLines: 1,
                      maxLines: 5,
                      style: AppStyle.textStyle(
                        14,
                        isDarkMode
                            ? AppColors.textDarkDark
                            : AppColors.textDarkLight,
                        FontWeight.normal,
                      ),
                      decoration: InputDecoration(
                        hintText: "Write a comment...",
                        hintStyle: AppStyle.textStyle(
                          14,
                          isDarkMode
                              ? AppColors.textLightDark
                              : AppColors.textLightLight,
                          FontWeight.normal,
                        ),
                        filled: true,
                        fillColor:
                            isDarkMode
                                ? AppColors.backgroundDark
                                : AppColors.backgroundLight,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24.r),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 10.h,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            Icons.photo_camera,
                            color:
                                isDarkMode
                                    ? AppColors.textMediumDark
                                    : AppColors.textMediumLight,
                          ),
                          onPressed: () {
                            // Add photo to comment
                          },
                        ),
                      ),
                    ),
                  ),

                  SizedBox(width: 8.w),

                  // Send button
                  GestureDetector(
                    onTap:
                        _commentController.text.isNotEmpty ? _addComment : null,
                    child: Container(
                      width: 40.w,
                      height: 40.w,
                      decoration: BoxDecoration(
                        color:
                            _commentController.text.isNotEmpty
                                ? isDarkMode
                                    ? AppColors.primaryDark
                                    : AppColors.primaryLight
                                : isDarkMode
                                ? AppColors.backgroundDark
                                : AppColors.backgroundLight,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.send,
                        color:
                            _commentController.text.isNotEmpty
                                ? Colors.white
                                : isDarkMode
                                ? AppColors.textLightDark
                                : AppColors.textLightLight,
                        size: 20.sp,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _loadPostData();
  }

  void _addComment() {
    if (_commentController.text.isEmpty) return;

    setState(() {
      // In a real app, send to API
      CommentModel newComment = CommentModel(
        id: 'comment${_comments.length + 1}',
        postId: widget.postId,
        userId: 'current-user',
        username: 'You',
        userProfilePicture: 'https://i.pravatar.cc/150?img=65',
        content: _commentController.text,
        createdAt: DateTime.now(),
        upvotes: 1, // Auto upvote own comment
        downvotes: 0,
        score: 1,
      );

      _comments.insert(0, newComment);
      _post = _post.copyWith(commentCount: _post.commentCount + 1);
      _commentController.clear();
    });
  }

  List<Widget> _buildCommentList(String? parentId) {
    List<Widget> commentWidgets = [];

    // Filter comments by parent ID
    final filteredComments =
        _comments.where((comment) => comment.parentId == parentId).toList();

    for (var comment in filteredComments) {
      // Add the comment
      commentWidgets.add(
        CommentItem(
          comment: comment,
          onVote: _voteComment,
          onReply: _replyToComment,
        ),
      );

      // Add child comments (replies) if any
      if (_comments.any((c) => c.parentId == comment.id)) {
        commentWidgets.add(
          Padding(
            padding: EdgeInsets.only(left: 36.w),
            child: Column(children: _buildCommentList(comment.id)),
          ),
        );
      }
    }

    return commentWidgets;
  }

  Widget _buildReplySheet(BuildContext context, CommentModel comment) {
    final isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;

    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      decoration: BoxDecoration(
        color: isDarkMode ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16.r),
          topRight: Radius.circular(16.r),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Replying to ${comment.username}",
              style: AppStyle.textStyle(
                16,
                isDarkMode ? AppColors.textDarkDark : AppColors.textDarkLight,
                FontWeight.w600,
              ),
            ),

            SizedBox(height: 8.h),

            // Original comment
            Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color:
                    isDarkMode
                        ? AppColors.backgroundDark
                        : AppColors.backgroundLight,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Text(
                comment.content,
                style: AppStyle.textStyle(
                  14,
                  isDarkMode
                      ? AppColors.textMediumDark
                      : AppColors.textMediumLight,
                  FontWeight.normal,
                ),
              ),
            ),

            SizedBox(height: 16.h),

            // Reply input field
            Row(
              children: [
                Expanded(
                  child: TextField(
                    autofocus: true,
                    decoration: InputDecoration(
                      hintText: "Write a reply...",
                      hintStyle: AppStyle.textStyle(
                        14,
                        isDarkMode
                            ? AppColors.textLightDark
                            : AppColors.textLightLight,
                        FontWeight.normal,
                      ),
                      filled: true,
                      fillColor:
                          isDarkMode
                              ? AppColors.backgroundDark
                              : AppColors.backgroundLight,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24.r),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 10.h,
                      ),
                    ),
                  ),
                ),

                SizedBox(width: 8.w),

                Container(
                  width: 40.w,
                  height: 40.w,
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.send, color: Colors.white, size: 20.sp),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _loadPostData() {
    setState(() {
      _isLoading = true;
    });

    // In a real app, fetch the post from API using widget.postId
    // For UI demo, use mock data
    _post = PostModel(
      id: widget.postId,
      userId: 'user1',
      username: 'John Doe',
      userProfilePicture: 'https://i.pravatar.cc/150?img=1',
      content:
          'Just finished reading an amazing book on artificial intelligence. It\'s incredible how far we\'ve come in this field! What do you all think about the future of AI? #AI #Technology #Future',
      type: PostType.text,
      createdAt: DateTime.now().subtract(Duration(hours: 5)),
      likeCount: 128,
      commentCount: 24,
      shareCount: 16,
    );

    // Mock comments
    _comments = [
      CommentModel(
        id: 'comment1',
        postId: widget.postId,
        userId: 'user2',
        username: 'Jane Smith',
        userProfilePicture: 'https://i.pravatar.cc/150?img=5',
        content:
            'I think AI will revolutionize every industry but we need to be careful with ethical considerations.',
        createdAt: DateTime.now().subtract(Duration(hours: 4, minutes: 25)),
        upvotes: 45,
        downvotes: 2,
        score: 43,
        verification: CommentVerification.correct,
      ),
      CommentModel(
        id: 'comment2',
        postId: widget.postId,
        userId: 'user3',
        username: 'Mike Johnson',
        userProfilePicture: 'https://i.pravatar.cc/150?img=8',
        content:
            'I disagree. AI will never fully replace human creativity and intuition.',
        createdAt: DateTime.now().subtract(Duration(hours: 3, minutes: 15)),
        upvotes: 18,
        downvotes: 24,
        score: -6,
        verification: CommentVerification.incorrect,
      ),
      CommentModel(
        id: 'comment3',
        postId: widget.postId,
        userId: 'user4',
        username: 'Sarah Williams',
        userProfilePicture: 'https://i.pravatar.cc/150?img=9',
        content: 'Which book were you reading? I\'d love some recommendations.',
        createdAt: DateTime.now().subtract(Duration(hours: 2, minutes: 30)),
        upvotes: 12,
        downvotes: 0,
        score: 12,
      ),
      CommentModel(
        id: 'comment4',
        postId: widget.postId,
        userId: 'user1',
        username: 'John Doe',
        userProfilePicture: 'https://i.pravatar.cc/150?img=1',
        content:
            'I was reading "The Alignment Problem" by Brian Christian. Highly recommend it!',
        createdAt: DateTime.now().subtract(Duration(hours: 1, minutes: 45)),
        upvotes: 8,
        downvotes: 0,
        score: 8,
        parentId: 'comment3',
      ),
      CommentModel(
        id: 'comment5',
        postId: widget.postId,
        userId: 'user5',
        username: 'David Brown',
        userProfilePicture: 'https://i.pravatar.cc/150?img=12',
        content:
            'AI will create more jobs than it displaces, but they will be different kinds of jobs.',
        createdAt: DateTime.now().subtract(Duration(hours: 1)),
        upvotes: 32,
        downvotes: 5,
        score: 27,
      ),
      CommentModel(
        id: 'comment6',
        postId: widget.postId,
        userId: 'user6',
        username: 'Emily Davis',
        userProfilePicture: 'https://i.pravatar.cc/150?img=25',
        content: 'Thanks for the recommendation! Adding it to my reading list.',
        createdAt: DateTime.now().subtract(Duration(minutes: 30)),
        upvotes: 3,
        downvotes: 0,
        score: 3,
        parentId: 'comment4',
      ),
    ];

    // Sort comments
    _sortComments();

    setState(() {
      _isLoading = false;
    });
  }

  void _replyToComment(String commentId) {
    // In a real app, show a reply UI targeting the specific comment
    // For demo, just focus the comment field
    FocusScope.of(context).requestFocus(FocusNode());
    _commentController.text = '';

    final comment = _comments.firstWhere((c) => c.id == commentId);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildReplySheet(context, comment),
    );
  }

  void _sortComments() {
    switch (_commentSortOption) {
      case "Top":
        _comments.sort((a, b) => b.score.compareTo(a.score));
        break;
      case "New":
        _comments.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
      case "Old":
        _comments.sort((a, b) => a.createdAt.compareTo(b.createdAt));
        break;
    }
  }

  void _voteComment(String commentId, VoteType voteType) {
    setState(() {
      final index = _comments.indexWhere((comment) => comment.id == commentId);
      if (index != -1) {
        final comment = _comments[index];

        // Calculate new values
        int newUpvotes = comment.upvotes;
        int newDownvotes = comment.downvotes;
        VoteType newUserVote = voteType;

        // Handle upvote
        if (voteType == VoteType.upvote) {
          if (comment.userVote == VoteType.upvote) {
            // Cancel upvote
            newUpvotes--;
            newUserVote = VoteType.none;
          } else if (comment.userVote == VoteType.downvote) {
            // Change from downvote to upvote
            newDownvotes--;
            newUpvotes++;
            newUserVote = VoteType.upvote;
          } else {
            // New upvote
            newUpvotes++;
            newUserVote = VoteType.upvote;
          }
        }
        // Handle downvote
        else if (voteType == VoteType.downvote) {
          if (comment.userVote == VoteType.downvote) {
            // Cancel downvote
            newDownvotes--;
            newUserVote = VoteType.none;
          } else if (comment.userVote == VoteType.upvote) {
            // Change from upvote to downvote
            newUpvotes--;
            newDownvotes++;
            newUserVote = VoteType.downvote;
          } else {
            // New downvote
            newDownvotes++;
            newUserVote = VoteType.downvote;
          }
        }

        // Update comment
        _comments[index] = comment.copyWith(
          upvotes: newUpvotes,
          downvotes: newDownvotes,
          score: newUpvotes - newDownvotes,
          userVote: newUserVote,
        );

        // Re-sort if necessary
        if (_commentSortOption == "Top") {
          _sortComments();
        }
      }
    });
  }
}

// Extension for CommentModel to allow creating copies with modified fields
extension CommentModelExtension on CommentModel {
  CommentModel copyWith({
    String? id,
    String? postId,
    String? userId,
    String? username,
    String? userProfilePicture,
    String? content,
    DateTime? createdAt,
    int? upvotes,
    int? downvotes,
    int? score,
    VoteType? userVote,
    String? parentId,
    int? childCount,
    bool? isEdited,
    CommentVerification? verification,
  }) {
    return CommentModel(
      id: id ?? this.id,
      postId: postId ?? this.postId,
      userId: userId ?? this.userId,
      username: username ?? this.username,
      userProfilePicture: userProfilePicture ?? this.userProfilePicture,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      upvotes: upvotes ?? this.upvotes,
      downvotes: downvotes ?? this.downvotes,
      score: score ?? this.score,
      userVote: userVote ?? this.userVote,
      parentId: parentId ?? this.parentId,
      childCount: childCount ?? this.childCount,
      isEdited: isEdited ?? this.isEdited,
      verification: verification ?? this.verification,
    );
  }
}

// Extension for PostModel to allow creating copies with modified fields
extension PostModelExtension on PostModel {
  PostModel copyWith({
    String? id,
    String? userId,
    String? username,
    String? userProfilePicture,
    String? content,
    List<PostMedia>? media,
    PostType? type,
    DateTime? createdAt,
    int? likeCount,
    int? commentCount,
    int? shareCount,
    bool? isLiked,
    String? originalPostId,
    String? originalPostUserId,
  }) {
    return PostModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      username: username ?? this.username,
      userProfilePicture: userProfilePicture ?? this.userProfilePicture,
      content: content ?? this.content,
      media: media ?? this.media,
      type: type ?? this.type,
      createdAt: createdAt ?? this.createdAt,
      likeCount: likeCount ?? this.likeCount,
      commentCount: commentCount ?? this.commentCount,
      shareCount: shareCount ?? this.shareCount,
      isLiked: isLiked ?? this.isLiked,
      originalPostId: originalPostId ?? this.originalPostId,
      originalPostUserId: originalPostUserId ?? this.originalPostUserId,
    );
  }
}
