import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile/common/providers/theme_provider.dart';
import 'package:mobile/common/utils/app_colors.dart';
import 'package:mobile/common/utils/app_style.dart';
import 'package:mobile/features/chat/models/chat_model.dart';
import 'package:provider/provider.dart';

class ChatDetailScreen extends StatefulWidget {
  final String chatId;
  final String userName;
  final String userAvatar;

  const ChatDetailScreen({
    super.key,
    required this.chatId,
    required this.userName,
    required this.userAvatar,
  });

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isAttachmentMenuOpen = false;
  bool _isSending = false;
  // Mock messages data
  late List<MessageModel> _messages;

  @override
  void initState() {
    super.initState();
    // Initialize messages
    _messages = [
      MessageModel(
        id: '1',
        roomId: widget.chatId,
        senderId: 'other_user',
        content: 'Xin chào, bạn khỏe không?',
        createdAt: DateTime.now().subtract(const Duration(days: 1, hours: 2)),
        type: MessageType.text,
        status: MessageStatus.read,
      ),
      MessageModel(
        id: '2',
        roomId: widget.chatId,
        senderId: 'current_user',
        content: 'Chào bạn! Tôi khỏe, còn bạn thì sao?',
        createdAt: DateTime.now().subtract(
          const Duration(days: 1, hours: 1, minutes: 55),
        ),
        type: MessageType.text,
        status: MessageStatus.read,
      ),
      MessageModel(
        id: '3',
        roomId: widget.chatId,
        senderId: 'other_user',
        content: 'Tôi cũng khỏe. Bạn có tham gia sự kiện tuần tới không?',
        createdAt: DateTime.now().subtract(
          const Duration(days: 1, hours: 1, minutes: 40),
        ),
        type: MessageType.text,
        status: MessageStatus.read,
      ),
      MessageModel(
        id: '4',
        roomId: widget.chatId,
        senderId: 'current_user',
        content: 'Có, tôi sẽ tham gia. Bạn có muốn đi cùng không?',
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
        type: MessageType.text,
        status: MessageStatus.read,
      ),
      MessageModel(
        id: '5',
        roomId: widget.chatId,
        senderId: 'other_user',
        content: 'Tuyệt vời! Gặp nhau ở đó nhé.',
        createdAt: DateTime.now().subtract(const Duration(minutes: 30)),
        type: MessageType.text,
        status: MessageStatus.read,
      ),
      MessageModel(
        id: '6',
        roomId: widget.chatId,
        senderId: 'current_user',
        content: 'Đây là một số hình ảnh từ sự kiện lần trước',
        createdAt: DateTime.now().subtract(const Duration(minutes: 15)),
        type: MessageType.text,
        status: MessageStatus.delivered,
      ),
      MessageModel(
        id: '7',
        roomId: widget.chatId,
        senderId: 'current_user',
        content: '',
        mediaUrl: 'https://picsum.photos/600/400?random=1',
        createdAt: DateTime.now().subtract(const Duration(minutes: 14)),
        type: MessageType.image,
        status: MessageStatus.delivered,
      ),
    ];

    // Scroll to bottom when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    setState(() {
      _isSending = true;
    });

    // Simulate network delay
    Future.delayed(const Duration(milliseconds: 500), () {
      final newMessage = MessageModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        roomId: widget.chatId,
        senderId: 'current_user',
        content: _messageController.text,
        createdAt: DateTime.now(),
        type: MessageType.text,
        status: MessageStatus.sent,
      );

      setState(() {
        _messages.add(newMessage);
        _messageController.clear();
        _isSending = false;
      });

      _scrollToBottom();
    });
  }

  void _sendImage() {
    setState(() {
      _isAttachmentMenuOpen = false;
      _isSending = true;
    });

    // Simulate network delay
    Future.delayed(const Duration(milliseconds: 800), () {
      final newMessage = MessageModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        roomId: widget.chatId,
        senderId: 'current_user',
        content: '',
        mediaUrl: 'https://picsum.photos/600/400?random=${_messages.length}',
        createdAt: DateTime.now(),
        type: MessageType.image,
        status: MessageStatus.sent,
      );

      setState(() {
        _messages.add(newMessage);
        _isSending = false;
      });

      _scrollToBottom();
    });
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = DateTime(now.year, now.month, now.day - 1);
    final messageDate = DateTime(dateTime.year, dateTime.month, dateTime.day);

    if (messageDate == today) {
      return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    } else if (messageDate == yesterday) {
      return 'Hôm qua, ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    } else {
      return '${dateTime.day}/${dateTime.month}, ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: isDarkMode ? AppColors.cardDark : AppColors.cardLight,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back,
            color:
                isDarkMode ? AppColors.textDarkDark : AppColors.textDarkLight,
          ),
        ),
        title: Row(
          children: [
            CircleAvatar(
              radius: 18.r,
              backgroundImage: NetworkImage(widget.userAvatar),
            ),
            SizedBox(width: 12.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.userName,
                  style: AppStyle.textStyle(
                    16,
                    isDarkMode
                        ? AppColors.textDarkDark
                        : AppColors.textDarkLight,
                    FontWeight.w600,
                  ),
                ),
                Text(
                  'Online',
                  style: AppStyle.textStyle(
                    12,
                    AppColors.primaryLight,
                    FontWeight.normal,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              // Show voice call screen
            },
            icon: Icon(
              Icons.call,
              color:
                  isDarkMode ? AppColors.textDarkDark : AppColors.textDarkLight,
            ),
          ),
          IconButton(
            onPressed: () {
              // Show video call screen
            },
            icon: Icon(
              Icons.videocam,
              color:
                  isDarkMode ? AppColors.textDarkDark : AppColors.textDarkLight,
            ),
          ),
          IconButton(
            onPressed: () {
              // Show chat settings
            },
            icon: Icon(
              Icons.more_vert,
              color:
                  isDarkMode ? AppColors.textDarkDark : AppColors.textDarkLight,
            ),
          ),
        ],
      ),
      body: Container(
        color:
            isDarkMode ? AppColors.backgroundDark : AppColors.backgroundLight,
        child: Column(
          children: [
            // Messages list
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: EdgeInsets.all(16.w),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final message = _messages[index];
                  final isMe = message.senderId == 'current_user';
                  final showTimeAbove =
                      index == 0 ||
                      _messages[index].createdAt
                              .difference(_messages[index - 1].createdAt)
                              .inMinutes >
                          30;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Time separator if needed
                      if (showTimeAbove)
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 16.h),
                          child: Center(
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 12.w,
                                vertical: 6.h,
                              ),
                              decoration: BoxDecoration(
                                color:
                                    isDarkMode
                                        ? AppColors.cardDark.withOpacity(0.6)
                                        : AppColors.cardLight.withOpacity(0.6),
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              child: Text(
                                _formatTime(message.createdAt),
                                style: AppStyle.textStyle(
                                  12,
                                  isDarkMode
                                      ? AppColors.textMediumDark
                                      : AppColors.textMediumLight,
                                  FontWeight.normal,
                                ),
                              ),
                            ),
                          ),
                        ),

                      // Message bubble
                      Align(
                        alignment:
                            isMe ? Alignment.centerRight : Alignment.centerLeft,
                        child: Container(
                          constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * 0.75,
                          ),
                          margin: EdgeInsets.symmetric(vertical: 4.h),
                          padding:
                              message.type == MessageType.image
                                  ? EdgeInsets.all(4.w)
                                  : EdgeInsets.symmetric(
                                    horizontal: 16.w,
                                    vertical: 12.h,
                                  ),
                          decoration: BoxDecoration(
                            color:
                                isMe
                                    ? isDarkMode
                                        ? AppColors.primaryDark
                                        : AppColors.primaryLight
                                    : isDarkMode
                                    ? AppColors.cardDark
                                    : AppColors.cardLight,
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                          child:
                              message.type == MessageType.image
                                  ? ClipRRect(
                                    borderRadius: BorderRadius.circular(12.r),
                                    child: Image.network(
                                      message.mediaUrl!,
                                      fit: BoxFit.cover,
                                      loadingBuilder: (
                                        context,
                                        child,
                                        loadingProgress,
                                      ) {
                                        if (loadingProgress == null) {
                                          return child;
                                        }
                                        return Container(
                                          height: 200.h,
                                          width: double.infinity,
                                          color:
                                              isDarkMode
                                                  ? AppColors.cardDark
                                                  : AppColors.cardLight,
                                          child: Center(
                                            child: CircularProgressIndicator(
                                              value:
                                                  loadingProgress
                                                              .expectedTotalBytes !=
                                                          null
                                                      ? loadingProgress
                                                              .cumulativeBytesLoaded /
                                                          loadingProgress
                                                              .expectedTotalBytes!
                                                      : null,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  )
                                  : Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        message.content,
                                        style: AppStyle.textStyle(
                                          14,
                                          isMe
                                              ? Colors.white
                                              : isDarkMode
                                              ? AppColors.textDarkDark
                                              : AppColors.textDarkLight,
                                          FontWeight.normal,
                                        ),
                                      ),
                                      SizedBox(height: 4.h),
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            _formatTime(message.createdAt),
                                            style: AppStyle.textStyle(
                                              10,
                                              isMe
                                                  ? Colors.white.withOpacity(
                                                    0.7,
                                                  )
                                                  : isDarkMode
                                                  ? AppColors.textLightDark
                                                  : AppColors.textLightLight,
                                              FontWeight.normal,
                                            ),
                                          ),
                                          if (isMe) ...[
                                            SizedBox(width: 4.w),
                                            Icon(
                                              message.status ==
                                                      MessageStatus.sent
                                                  ? Icons.check
                                                  : message.status ==
                                                      MessageStatus.delivered
                                                  ? Icons.done_all
                                                  : Icons.done_all,
                                              size: 12.sp,
                                              color:
                                                  message.status ==
                                                          MessageStatus.read
                                                      ? AppColors.accentLight
                                                      : Colors.white
                                                          .withOpacity(0.7),
                                            ),
                                          ],
                                        ],
                                      ),
                                    ],
                                  ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),

            // Attachment menu
            if (_isAttachmentMenuOpen)
              Container(
                padding: EdgeInsets.all(16.w),
                color: isDarkMode ? AppColors.cardDark : AppColors.cardLight,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildAttachmentOption(
                      isDarkMode,
                      Icons.image,
                      'Hình ảnh',
                      AppColors.primaryLight,
                      _sendImage,
                    ),
                    _buildAttachmentOption(
                      isDarkMode,
                      Icons.camera_alt,
                      'Camera',
                      AppColors.accentLight,
                      () {},
                    ),
                    _buildAttachmentOption(
                      isDarkMode,
                      Icons.video_file,
                      'Video',
                      AppColors.secondaryLight,
                      () {},
                    ),
                    _buildAttachmentOption(
                      isDarkMode,
                      Icons.insert_drive_file,
                      'Tài liệu',
                      Colors.orange,
                      () {},
                    ),
                    _buildAttachmentOption(
                      isDarkMode,
                      Icons.location_on,
                      'Vị trí',
                      Colors.green,
                      () {},
                    ),
                  ],
                ),
              ),

            // Message input area
            Container(
              padding: EdgeInsets.all(8.w),
              color: isDarkMode ? AppColors.cardDark : AppColors.cardLight,
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      setState(() {
                        _isAttachmentMenuOpen = !_isAttachmentMenuOpen;
                      });
                    },
                    icon: Icon(
                      Icons.add,
                      color:
                          isDarkMode
                              ? _isAttachmentMenuOpen
                                  ? AppColors.primaryDark
                                  : AppColors.textMediumDark
                              : _isAttachmentMenuOpen
                              ? AppColors.primaryLight
                              : AppColors.textMediumLight,
                      size: 24.sp,
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      decoration: BoxDecoration(
                        color:
                            isDarkMode
                                ? AppColors.backgroundDark
                                : AppColors.backgroundLight,
                        borderRadius: BorderRadius.circular(24.r),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _messageController,
                              style: AppStyle.textStyle(
                                14,
                                isDarkMode
                                    ? AppColors.textDarkDark
                                    : AppColors.textDarkLight,
                                FontWeight.normal,
                              ),
                              decoration: InputDecoration(
                                hintText: 'Nhập tin nhắn...',
                                hintStyle: AppStyle.textStyle(
                                  14,
                                  isDarkMode
                                      ? AppColors.textLightDark
                                      : AppColors.textLightLight,
                                  FontWeight.normal,
                                ),
                                border: InputBorder.none,
                              ),
                              maxLines: null,
                              textCapitalization: TextCapitalization.sentences,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              // Show emoji picker
                            },
                            icon: Icon(
                              Icons.emoji_emotions_outlined,
                              color:
                                  isDarkMode
                                      ? AppColors.textMediumDark
                                      : AppColors.textMediumLight,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  _messageController.text.trim().isNotEmpty || _isSending
                      ? Container(
                        decoration: BoxDecoration(
                          color:
                              isDarkMode
                                  ? AppColors.primaryDark
                                  : AppColors.primaryLight,
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          onPressed: _isSending ? null : _sendMessage,
                          icon:
                              _isSending
                                  ? SizedBox(
                                    width: 20.w,
                                    height: 20.h,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2.w,
                                    ),
                                  )
                                  : Icon(Icons.send, color: Colors.white),
                        ),
                      )
                      : IconButton(
                        onPressed: () {
                          // Record voice message
                        },
                        icon: Icon(
                          Icons.mic,
                          color:
                              isDarkMode
                                  ? AppColors.primaryDark
                                  : AppColors.primaryLight,
                          size: 24.sp,
                        ),
                      ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAttachmentOption(
    bool isDarkMode,
    IconData icon,
    String label,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 48.w,
            height: 48.w,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 24.sp),
          ),
          SizedBox(height: 8.h),
          Text(
            label,
            style: AppStyle.textStyle(
              12,
              isDarkMode ? AppColors.textMediumDark : AppColors.textMediumLight,
              FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
