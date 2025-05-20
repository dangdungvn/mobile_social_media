class UserModel {
  final String id;
  final String username;
  final String email;
  final String? fullName;
  final String? profilePictureUrl;
  final String? bio;
  final bool isOnline;
  final DateTime? lastSeen;
  final bool isVerified;
  final List<String>? followers;
  final List<String>? following;
  final List<String>? friendIds;

  UserModel({
    required this.id,
    required this.username,
    required this.email,
    this.fullName,
    this.profilePictureUrl,
    this.bio,
    this.isOnline = false,
    this.lastSeen,
    this.isVerified = false,
    this.followers,
    this.following,
    this.friendIds,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      fullName: json['full_name'],
      profilePictureUrl: json['profile_picture_url'],
      bio: json['bio'],
      isOnline: json['is_online'] ?? false,
      lastSeen:
          json['last_seen'] != null ? DateTime.parse(json['last_seen']) : null,
      isVerified: json['is_verified'] ?? false,
      followers:
          json['followers'] != null
              ? List<String>.from(json['followers'])
              : null,
      following:
          json['following'] != null
              ? List<String>.from(json['following'])
              : null,
      friendIds:
          json['friend_ids'] != null
              ? List<String>.from(json['friend_ids'])
              : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'full_name': fullName,
      'profile_picture_url': profilePictureUrl,
      'bio': bio,
      'is_online': isOnline,
      'last_seen': lastSeen?.toIso8601String(),
      'is_verified': isVerified,
      'followers': followers,
      'following': following,
      'friend_ids': friendIds,
    };
  }
}
