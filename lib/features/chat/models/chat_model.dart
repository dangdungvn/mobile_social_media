import 'package:flutter/foundation.dart';

enum MessageType { text, image, video, file }

enum MessageStatus { sent, delivered, read, failed }

class MessageModel {
  final String id;
  final String roomId;
  final String senderId;
  final String? senderName;
  final String? senderProfilePic;
  final String content;
  final String? mediaUrl;
  final String? thumbnailUrl;
  final MessageType type;
  final DateTime createdAt;
  final MessageStatus status;
  final bool isDeleted;

  MessageModel({
    required this.id,
    required this.roomId,
    required this.senderId,
    this.senderName,
    this.senderProfilePic,
    required this.content,
    this.mediaUrl,
    this.thumbnailUrl,
    required this.type,
    required this.createdAt,
    required this.status,
    this.isDeleted = false,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['id'],
      roomId: json['room_id'],
      senderId: json['sender_id'],
      senderName: json['sender_name'],
      senderProfilePic: json['sender_profile_pic'],
      content: json['content'],
      mediaUrl: json['media_url'],
      thumbnailUrl: json['thumbnail_url'],
      type: MessageType.values.byName(json['type']),
      createdAt: DateTime.parse(json['created_at']),
      status: MessageStatus.values.byName(json['status']),
      isDeleted: json['is_deleted'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'room_id': roomId,
      'sender_id': senderId,
      'sender_name': senderName,
      'sender_profile_pic': senderProfilePic,
      'content': content,
      'media_url': mediaUrl,
      'thumbnail_url': thumbnailUrl,
      'type': type.name,
      'created_at': createdAt.toIso8601String(),
      'status': status.name,
      'is_deleted': isDeleted,
    };
  }
}

class ChatRoomModel {
  final String id;
  final List<String> participantIds;
  final String? lastMessageContent;
  final DateTime? lastMessageTime;
  final int unreadCount;
  final Map<String, bool>? onlineStatus;

  ChatRoomModel({
    required this.id,
    required this.participantIds,
    this.lastMessageContent,
    this.lastMessageTime,
    this.unreadCount = 0,
    this.onlineStatus,
  });

  factory ChatRoomModel.fromJson(Map<String, dynamic> json) {
    Map<String, bool> onlineStatus = {};
    if (json['online_status'] != null) {
      json['online_status'].forEach((key, value) {
        onlineStatus[key] = value;
      });
    }

    return ChatRoomModel(
      id: json['id'],
      participantIds: List<String>.from(json['participant_ids']),
      lastMessageContent: json['last_message_content'],
      lastMessageTime:
          json['last_message_time'] != null
              ? DateTime.parse(json['last_message_time'])
              : null,
      unreadCount: json['unread_count'] ?? 0,
      onlineStatus: onlineStatus.isNotEmpty ? onlineStatus : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'participant_ids': participantIds,
      'last_message_content': lastMessageContent,
      'last_message_time': lastMessageTime?.toIso8601String(),
      'unread_count': unreadCount,
      'online_status': onlineStatus,
    };
  }
}
