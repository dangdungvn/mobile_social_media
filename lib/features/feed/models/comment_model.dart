import 'package:flutter/foundation.dart';

enum VoteType { upvote, downvote, none }

enum CommentVerification { none, correct, incorrect }

class CommentModel {
  final String id;
  final String postId;
  final String userId;
  final String? username;
  final String? userProfilePicture;
  final String content;
  final DateTime createdAt;
  final int upvotes;
  final int downvotes;
  final int score; // Upvotes - Downvotes
  final VoteType userVote;
  final String? parentId; // For threaded comments
  final int childCount;
  final bool isEdited;
  final CommentVerification verification;

  CommentModel({
    required this.id,
    required this.postId,
    required this.userId,
    this.username,
    this.userProfilePicture,
    required this.content,
    required this.createdAt,
    this.upvotes = 0,
    this.downvotes = 0,
    this.score = 0,
    this.userVote = VoteType.none,
    this.parentId,
    this.childCount = 0,
    this.isEdited = false,
    this.verification = CommentVerification.none,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      id: json['id'],
      postId: json['post_id'],
      userId: json['user_id'],
      username: json['username'],
      userProfilePicture: json['user_profile_picture'],
      content: json['content'],
      createdAt: DateTime.parse(json['created_at']),
      upvotes: json['upvotes'] ?? 0,
      downvotes: json['downvotes'] ?? 0,
      score: json['score'] ?? 0,
      userVote:
          json['user_vote'] != null
              ? VoteType.values.byName(json['user_vote'])
              : VoteType.none,
      parentId: json['parent_id'],
      childCount: json['child_count'] ?? 0,
      isEdited: json['is_edited'] ?? false,
      verification:
          json['verification'] != null
              ? CommentVerification.values.byName(json['verification'])
              : CommentVerification.none,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'post_id': postId,
      'user_id': userId,
      'username': username,
      'user_profile_picture': userProfilePicture,
      'content': content,
      'created_at': createdAt.toIso8601String(),
      'upvotes': upvotes,
      'downvotes': downvotes,
      'score': score,
      'user_vote': userVote.name,
      'parent_id': parentId,
      'child_count': childCount,
      'is_edited': isEdited,
      'verification': verification.name,
    };
  }
}
