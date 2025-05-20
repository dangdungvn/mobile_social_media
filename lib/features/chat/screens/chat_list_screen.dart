import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/common/providers/theme_provider.dart';
import 'package:mobile/common/utils/app_colors.dart';
import 'package:mobile/common/utils/app_constants.dart';
import 'package:mobile/common/utils/app_style.dart';
import 'package:mobile/features/chat/models/chat_model.dart';
import 'package:provider/provider.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  bool _isLoading = false;
  List<ChatRoomModel> _chatRooms = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadChats();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _loadChats() {
    setState(() {
      _isLoading = true;
    });

    // Simulate API call
    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        // Mock chat rooms data
        _chatRooms = [
          ChatRoomModel(
            id: 'chat1',
            participantIds: ['user1', 'user2'],
            lastMessageContent: 'Check out this cool design I\'m working on!',
            lastMessageTime: DateTime.now().subtract(Duration(minutes: 5)),
            unreadCount: 1,
            onlineStatus: {'user2': true},
          ),
          ChatRoomModel(
            id: 'chat2',
            participantIds: ['user1', 'user3'],
            lastMessageContent: 'Let\'s catch up tomorrow for coffee',
            lastMessageTime: DateTime.now().subtract(Duration(hours: 2)),
            unreadCount: 0,
            onlineStatus: {'user3': false},
          ),
          ChatRoomModel(
            id: 'chat3',
            participantIds: ['user1', 'user4'],
            lastMessageContent: 'The project deadline has been extended',
            lastMessageTime: DateTime.now().subtract(Duration(hours: 5)),
            unreadCount: 0,
            onlineStatus: {'user4': true},
          ),
          ChatRoomModel(
            id: 'chat4',
            participantIds: ['user1', 'user5'],
            lastMessageContent: 'Have you seen the latest announcement?',
            lastMessageTime: DateTime.now().subtract(Duration(days: 1)),
            unreadCount: 3,
            onlineStatus: {'user5': false},
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
        backgroundColor: isDarkMode ? AppColors.cardDark : AppColors.cardLight,
        title: Text(
          'Messages',
          style: AppStyle.textStyle(
            20,
            isDarkMode ? AppColors.textDarkDark : AppColors.textDarkLight,
            FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              // Show new message dialog
            },
            icon: Icon(
              Icons.add_comment,
              color:
                  isDarkMode ? AppColors.textDarkDark : AppColors.textDarkLight,
            ),
          ),
        ],
        elevation: 0,
      ),
      body: Column(
        children: [
          // Search bar
          Container(
            padding: EdgeInsets.all(16.w),
            color: isDarkMode ? AppColors.cardDark : AppColors.cardLight,
            child: TextField(
              controller: _searchController,
              style: AppStyle.textStyle(
                14,
                isDarkMode ? AppColors.textDarkDark : AppColors.textDarkLight,
                FontWeight.normal,
              ),
              decoration: InputDecoration(
                hintText: "Search messages...",
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
                  size: 20.sp,
                ),
                filled: true,
                fillColor:
                    isDarkMode
                        ? AppColors.backgroundDark
                        : AppColors.backgroundLight,
                contentPadding: EdgeInsets.symmetric(
                  vertical: 10.h,
                  horizontal: 16.w,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.r),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (value) {
                // Filter chats as user types
              },
            ),
          ),

          // Chat list
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
                    : _chatRooms.isEmpty
                    ? _buildEmptyState(isDarkMode)
                    : ListView.builder(
                      itemCount: _chatRooms.length,
                      itemBuilder: (context, index) {
                        return _buildChatTile(_chatRooms[index], isDarkMode);
                      },
                    ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(bool isDarkMode) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.chat_bubble_outline,
            size: 80.sp,
            color:
                isDarkMode ? AppColors.textLightDark : AppColors.textLightLight,
          ),
          SizedBox(height: 16.h),
          Text(
            "No conversations yet",
            style: AppStyle.textStyle(
              18,
              isDarkMode ? AppColors.textDarkDark : AppColors.textDarkLight,
              FontWeight.w600,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            "Connect with friends to start chatting",
            style: AppStyle.textStyle(
              14,
              isDarkMode ? AppColors.textLightDark : AppColors.textLightLight,
              FontWeight.normal,
            ),
          ),
          SizedBox(height: 24.h),
          ElevatedButton.icon(
            onPressed: () {
              // Navigate to search/explore page to find friends
            },
            icon: Icon(Icons.person_add),
            label: Text("Find Friends"),
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  isDarkMode ? AppColors.primaryDark : AppColors.primaryLight,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatTile(ChatRoomModel chat, bool isDarkMode) {
    // In a real app, we'd get the other participant's info from the participant IDs
    // For now, we'll mock this data
    String otherParticipantId = chat.participantIds.firstWhere(
      (id) => id != 'user1',
      orElse: () => 'unknown',
    );

    // Mock user data
    String name = 'User';
    String profilePic = 'https://i.pravatar.cc/150';
    bool isOnline = false;

    switch (otherParticipantId) {
      case 'user2':
        name = 'Sophia Williams';
        profilePic =
            'https://xsgames.co/randomusers/assets/avatars/female/1.jpg';
        isOnline = chat.onlineStatus?['user2'] ?? false;
        break;
      case 'user3':
        name = 'Michael Davis';
        profilePic = 'https://xsgames.co/randomusers/assets/avatars/male/2.jpg';
        isOnline = chat.onlineStatus?['user3'] ?? false;
        break;
      case 'user4':
        name = 'Emma Wilson';
        profilePic =
            'https://xsgames.co/randomusers/assets/avatars/female/2.jpg';
        isOnline = chat.onlineStatus?['user4'] ?? false;
        break;
      case 'user5':
        name = 'Daniel Taylor';
        profilePic = 'https://xsgames.co/randomusers/assets/avatars/male/3.jpg';
        isOnline = chat.onlineStatus?['user5'] ?? false;
        break;
    }

    // Format message time
    String formattedTime = _formatTime(chat.lastMessageTime!);

    return InkWell(
      onTap: () {
        // Navigate to chat detail screen
        context.go(
          '${AppConstants.routeChatDetail.replaceAll(':chatId', '')}${chat.id}',
          extra: {'userName': name, 'userAvatar': profilePic},
        );
      },
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: isDarkMode ? AppColors.cardDark : AppColors.cardLight,
          border: Border(
            bottom: BorderSide(
              color: isDarkMode ? Colors.black12 : Colors.grey.withOpacity(0.1),
              width: 1.h,
            ),
          ),
        ),
        child: Row(
          children: [
            // Profile picture with online indicator
            Stack(
              children: [
                Container(
                  width: 56.w,
                  height: 56.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: NetworkImage(profilePic),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                if (isOnline)
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      width: 14.w,
                      height: 14.w,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color:
                              isDarkMode
                                  ? AppColors.cardDark
                                  : AppColors.cardLight,
                          width: 2.w,
                        ),
                      ),
                    ),
                  ),
              ],
            ),

            SizedBox(width: 12.w),

            // Message content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name and time
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        name,
                        style: AppStyle.textStyle(
                          16,
                          isDarkMode
                              ? AppColors.textDarkDark
                              : AppColors.textDarkLight,
                          chat.unreadCount > 0
                              ? FontWeight.w700
                              : FontWeight.w500,
                        ),
                      ),
                      Text(
                        formattedTime,
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

                  SizedBox(height: 4.h),

                  // Last message and unread count
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          chat.lastMessageContent ?? '',
                          style: AppStyle.textStyle(
                            14,
                            chat.unreadCount > 0
                                ? (isDarkMode
                                    ? AppColors.textDarkDark
                                    : AppColors.textDarkLight)
                                : (isDarkMode
                                    ? AppColors.textMediumDark
                                    : AppColors.textMediumLight),
                            chat.unreadCount > 0
                                ? FontWeight.w500
                                : FontWeight.normal,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (chat.unreadCount > 0)
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.w,
                            vertical: 2.h,
                          ),
                          decoration: BoxDecoration(
                            color:
                                isDarkMode
                                    ? AppColors.primaryDark
                                    : AppColors.primaryLight,
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          child: Text(
                            chat.unreadCount.toString(),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.bold,
                            ),
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
    );
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(Duration(days: 1));
    final messageDate = DateTime(dateTime.year, dateTime.month, dateTime.day);

    if (messageDate == today) {
      // Today: show time
      return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    } else if (messageDate == yesterday) {
      // Yesterday
      return 'Yesterday';
    } else if (now.difference(dateTime).inDays < 7) {
      // Within the last week: show day name
      const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
      return days[dateTime.weekday - 1];
    } else {
      // Older: show date
      return '${dateTime.day.toString().padLeft(2, '0')}/${dateTime.month.toString().padLeft(2, '0')}';
    }
  }
}
