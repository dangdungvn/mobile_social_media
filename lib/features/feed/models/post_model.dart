enum PostType { text, image, video, shared }

class PostMedia {
  final String url;
  final String? thumbnailUrl;
  final String type; // "image" or "video"

  PostMedia({required this.url, this.thumbnailUrl, required this.type});

  factory PostMedia.fromJson(Map<String, dynamic> json) {
    return PostMedia(
      url: json['url'],
      thumbnailUrl: json['thumbnail_url'],
      type: json['type'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'url': url, 'thumbnail_url': thumbnailUrl, 'type': type};
  }
}

class PostModel {
  final String id;
  final String userId;
  final String? username;
  final String? userProfilePicture;
  final String content;
  final List<PostMedia>? media;
  final PostType type;
  final DateTime createdAt;
  final int likeCount;
  final int commentCount;
  final int shareCount;
  final bool isLiked;
  final String? originalPostId; // For shared posts
  final String? originalPostUserId; // For shared posts

  PostModel({
    required this.id,
    required this.userId,
    this.username,
    this.userProfilePicture,
    required this.content,
    this.media,
    required this.type,
    required this.createdAt,
    this.likeCount = 0,
    this.commentCount = 0,
    this.shareCount = 0,
    this.isLiked = false,
    this.originalPostId,
    this.originalPostUserId,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    List<PostMedia>? media;
    if (json['media'] != null) {
      media =
          (json['media'] as List)
              .map((item) => PostMedia.fromJson(item))
              .toList();
    }

    return PostModel(
      id: json['id'],
      userId: json['user_id'],
      username: json['username'],
      userProfilePicture: json['user_profile_picture'],
      content: json['content'],
      media: media,
      type: PostType.values.byName(json['type']),
      createdAt: DateTime.parse(json['created_at']),
      likeCount: json['like_count'] ?? 0,
      commentCount: json['comment_count'] ?? 0,
      shareCount: json['share_count'] ?? 0,
      isLiked: json['is_liked'] ?? false,
      originalPostId: json['original_post_id'],
      originalPostUserId: json['original_post_user_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'username': username,
      'user_profile_picture': userProfilePicture,
      'content': content,
      'media': media?.map((item) => item.toJson()).toList(),
      'type': type.name,
      'created_at': createdAt.toIso8601String(),
      'like_count': likeCount,
      'comment_count': commentCount,
      'share_count': shareCount,
      'is_liked': isLiked,
      'original_post_id': originalPostId,
      'original_post_user_id': originalPostUserId,
    };
  }
}
