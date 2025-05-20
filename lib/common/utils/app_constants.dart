import 'package:flutter/material.dart';

class AppConstants {
  // App Name
  static const String appName = "SocialConnect";

  // Routes
  static const String routeSplash = "/";
  static const String routeOnboarding = "/onboarding";
  static const String routeLogin = "/login";
  static const String routeRegister = "/register";
  static const String routeMain = "/main";
  static const String routeNewsFeed = "/feed";
  static const String routeProfile = "/profile";
  static const String routePostDetail = "/post/:postId";
  static const String routeChat = "/chat";
  static const String routeChatDetail = "/chat/:chatId";
  static const String routeSearch = "/search";
  static const String routeNotifications = "/notifications";
  static const String routeSettings = "/settings";
  static const String routeEditProfile = "/edit-profile";
  static const String routeFriends = "/friends";
  static const String routeFollowers = "/followers";
  static const String routeFollowing = "/following";

  // Bottom Navigation Items
  static const List<Map<String, dynamic>> navItems = [
    {'label': 'Home', 'icon': Icons.home_outlined, 'activeIcon': Icons.home},
    {
      'label': 'Search',
      'icon': Icons.search_outlined,
      'activeIcon': Icons.search,
    },
    {
      'label': 'New Post',
      'icon': Icons.add_box_outlined,
      'activeIcon': Icons.add_box,
    },
    {
      'label': 'Chat',
      'icon': Icons.chat_bubble_outline,
      'activeIcon': Icons.chat_bubble,
    },
    {
      'label': 'Profile',
      'icon': Icons.person_outline,
      'activeIcon': Icons.person,
    },
  ];

  // App Text
  static const String welcomeTitle = "Welcome to SocialConnect";
  static const String welcomeSubTitle =
      "Connect with friends, share moments, and engage in meaningful discussions";
  static const String getStarted = "Get Started";

  // Demo User Data - For UI prototyping only
  static const List<Map<String, dynamic>> demoUsers = [
    {
      'id': '1',
      'name': 'Alex Johnson',
      'username': '@alexj',
      'profileImage':
          'https://xsgames.co/randomusers/assets/avatars/male/1.jpg',
      'isOnline': true,
    },
    {
      'id': '2',
      'name': 'Sophia Williams',
      'username': '@sophiaw',
      'profileImage':
          'https://xsgames.co/randomusers/assets/avatars/female/1.jpg',
      'isOnline': true,
    },
    {
      'id': '3',
      'name': 'Michael Davis',
      'username': '@michaeld',
      'profileImage':
          'https://xsgames.co/randomusers/assets/avatars/male/2.jpg',
      'isOnline': false,
    },
    {
      'id': '4',
      'name': 'Emma Wilson',
      'username': '@emmaw',
      'profileImage':
          'https://xsgames.co/randomusers/assets/avatars/female/2.jpg',
      'isOnline': true,
    },
    {
      'id': '5',
      'name': 'Daniel Taylor',
      'username': '@danielt',
      'profileImage':
          'https://xsgames.co/randomusers/assets/avatars/male/3.jpg',
      'isOnline': false,
    },
  ];

  // Demo Posts Data - For UI prototyping only
  static const List<Map<String, dynamic>> demoPosts = [
    {
      'id': '1',
      'userId': '1',
      'content':
          'Just finished reading an amazing book about artificial intelligence and its impact on our future. What are your thoughts on AI?',
      'images': [
        'https://images.unsplash.com/photo-1677442135743-d9ddf2e0f805',
      ],
      'likesCount': 42,
      'commentsCount': 8,
      'sharesCount': 5,
      'createdAt': '2023-05-15T10:30:00Z',
    },
    {
      'id': '2',
      'userId': '2',
      'content':
          'Beautiful sunset at the beach today! Nature never fails to amaze me. #sunset #beach #nature',
      'images': [
        'https://images.unsplash.com/photo-1616036740257-9449ea1f6605',
        'https://images.unsplash.com/photo-1621789098261-03be444cdb17',
      ],
      'likesCount': 128,
      'commentsCount': 24,
      'sharesCount': 12,
      'createdAt': '2023-05-14T18:15:00Z',
    },
    {
      'id': '3',
      'userId': '3',
      'content':
          'Excited to announce that I\'ll be speaking at the Tech Conference next month! If you\'re attending, let\'s meet up!',
      'images': [],
      'likesCount': 56,
      'commentsCount': 17,
      'sharesCount': 3,
      'createdAt': '2023-05-13T14:45:00Z',
    },
    {
      'id': '4',
      'userId': '4',
      'content':
          'Just tried this new restaurant downtown and the food was incredible! Highly recommend the pasta dishes.',
      'images': [
        'https://images.unsplash.com/photo-1513104890138-7c749659a591',
      ],
      'likesCount': 34,
      'commentsCount': 6,
      'sharesCount': 1,
      'createdAt': '2023-05-12T20:00:00Z',
    },
    {
      'id': '5',
      'userId': '5',
      'content':
          'Working from home has its challenges, but also many benefits. What\'s your preferred work setup?',
      'images': [
        'https://images.unsplash.com/photo-1581092160607-ee22621dd758',
      ],
      'likesCount': 48,
      'commentsCount': 15,
      'sharesCount': 2,
      'createdAt': '2023-05-11T09:00:00Z',
    },
  ];

  // Demo Comments Data - For UI prototyping only
  static const List<Map<String, dynamic>> demoComments = [
    {
      'id': '1',
      'postId': '1',
      'userId': '2',
      'content':
          'I think AI has tremendous potential but also requires careful ethical considerations.',
      'parentId': null,
      'upvotes': 12,
      'downvotes': 2,
      'verified': true,
      'createdAt': '2023-05-15T11:00:00Z',
    },
    {
      'id': '2',
      'postId': '1',
      'userId': '3',
      'content':
          'What book were you reading? I\'m looking for good AI resources.',
      'parentId': null,
      'upvotes': 5,
      'downvotes': 0,
      'verified': false,
      'createdAt': '2023-05-15T11:30:00Z',
    },
    {
      'id': '3',
      'postId': '1',
      'userId': '1',
      'content': 'It\'s "Life 3.0" by Max Tegmark. Highly recommend it!',
      'parentId': '2',
      'upvotes': 4,
      'downvotes': 0,
      'verified': false,
      'createdAt': '2023-05-15T12:00:00Z',
    },
    {
      'id': '4',
      'postId': '1',
      'userId': '4',
      'content':
          'AI is definitely transforming our world, but I worry about job displacement.',
      'parentId': null,
      'upvotes': 8,
      'downvotes': 3,
      'verified': false,
      'createdAt': '2023-05-15T13:15:00Z',
    },
    {
      'id': '5',
      'postId': '1',
      'userId': '5',
      'content':
          'I believe we need to focus on reskilling initiatives to adapt to AI advancements.',
      'parentId': '4',
      'upvotes': 15,
      'downvotes': 1,
      'verified': true,
      'createdAt': '2023-05-15T14:00:00Z',
    },
  ];

  // Demo Chat Messages - For UI prototyping only
  static const List<Map<String, dynamic>> demoChatMessages = [
    {
      'id': '1',
      'roomId': '1',
      'senderId': '2',
      'receiverId': '1',
      'content': 'Hey Alex, how are you doing today?',
      'attachment': null,
      'isRead': true,
      'createdAt': '2023-05-15T09:00:00Z',
    },
    {
      'id': '2',
      'roomId': '1',
      'senderId': '1',
      'receiverId': '2',
      'content':
          'Hi Sophia! I\'m doing great, thanks for asking. How about you?',
      'attachment': null,
      'isRead': true,
      'createdAt': '2023-05-15T09:05:00Z',
    },
    {
      'id': '3',
      'roomId': '1',
      'senderId': '2',
      'receiverId': '1',
      'content': 'I\'m good too! Just working on some new projects.',
      'attachment': null,
      'isRead': true,
      'createdAt': '2023-05-15T09:10:00Z',
    },
    {
      'id': '4',
      'roomId': '1',
      'senderId': '2',
      'receiverId': '1',
      'content': 'Check out this cool design I\'m working on!',
      'attachment':
          'https://images.unsplash.com/photo-1615461475683-3748816503816',
      'isRead': true,
      'createdAt': '2023-05-15T09:15:00Z',
    },
    {
      'id': '5',
      'roomId': '1',
      'senderId': '1',
      'receiverId': '2',
      'content': 'Wow, that looks amazing! Love the color scheme.',
      'attachment': null,
      'isRead': true,
      'createdAt': '2023-05-15T09:20:00Z',
    },
  ];
}
