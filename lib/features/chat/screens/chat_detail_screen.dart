import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:math' as math;
import 'package:mobile/common/providers/theme_provider.dart';
import 'package:mobile/common/utils/app_colors.dart';
import 'package:mobile/features/chat/models/chat_model.dart';
import 'package:mobile/features/chat/screens/image_viewer_screen.dart';
import 'package:mobile/features/chat/widgets/emoji_picker_view.dart';
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

class _ChatDetailScreenState extends State<ChatDetailScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isAttachmentMenuOpen = false;
  bool _isEmojiPickerOpen = false;
  bool _isSending = false;
  bool _showScrollToBottom = false;
  bool _isOtherUserTyping = false;
  late AnimationController _sendButtonController;

  // Mock messages data
  late List<MessageModel> _messages;

  @override
  void initState() {
    super.initState();
    _sendButtonController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

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
        type: MessageType.image,
        createdAt: DateTime.now().subtract(const Duration(minutes: 14)),
        status: MessageStatus.delivered,
      ),
    ];

    // Add scroll listener
    _scrollController.addListener(_scrollListener);

    // Auto scroll to bottom when keyboard opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });

    // Simulate other user typing occasionally
    Future.delayed(const Duration(seconds: 3), () {
      _simulateTyping();
    });
  }

  void _scrollListener() {
    if (_scrollController.hasClients) {
      final maxScroll = _scrollController.position.maxScrollExtent;
      final currentScroll = _scrollController.position.pixels;
      setState(() {
        _showScrollToBottom = currentScroll < maxScroll - 200;
      });
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    _sendButtonController.dispose();
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

  void _sendMessage() async {
    if (_messageController.text.trim().isEmpty) return;

    final messageContent = _messageController.text.trim();
    _messageController.clear();

    setState(() {
      _isSending = true;
      // Add the new message to the list
      _messages.add(
        MessageModel(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          roomId: widget.chatId,
          senderId: 'current_user',
          content: messageContent,
          type: MessageType.text,
          createdAt: DateTime.now(),
          status: MessageStatus.sending,
        ),
      );
    });

    // Scroll to the new message
    _scrollToBottom();

    // Simulate sending delay
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      // Update message status
      final lastIndex = _messages.length - 1;
      _messages[lastIndex] = _messages[lastIndex].copyWith(
        status: MessageStatus.sent,
      );
      _isSending = false;
    });

    // Simulate other user typing after a short delay
    Future.delayed(const Duration(seconds: 2), () {
      _simulateTyping();
    });
  }

  void _toggleAttachmentMenu() {
    setState(() {
      _isAttachmentMenuOpen = !_isAttachmentMenuOpen;
    });
  }

  void _simulateTyping() {
    setState(() {
      _isOtherUserTyping = true;
    });

    // Show typing for a few seconds
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _isOtherUserTyping = false;
        });

        // Add a reply from other user
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) {
            final replies = [
              'That sounds great!',
              'I see, interesting point.',
              'Let me think about that.',
              'Thanks for sharing this information.',
              'I agree with you on that.',
            ];

            setState(() {
              // Add reply message
              _messages.add(
                MessageModel(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  roomId: widget.chatId,
                  senderId: 'other_user',
                  content: replies[DateTime.now().second % replies.length],
                  type: MessageType.text,
                  createdAt: DateTime.now(),
                  status: MessageStatus.read,
                ),
              );
            });

            // Scroll to see new message
            _scrollToBottom();
          }
        });
      }
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
        elevation: 0,
        leadingWidth: 50.w,
        titleSpacing: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color:
                isDarkMode ? AppColors.textDarkDark : AppColors.textDarkLight,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: InkWell(
          onTap: () {
            // Navigate to user profile
          },
          child: Row(
            children: [
              // User avatar
              Container(
                width: 40.w,
                height: 40.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      isDarkMode ? Colors.teal.shade700 : Colors.teal.shade300,
                      isDarkMode ? Colors.blue.shade700 : Colors.blue.shade300,
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                padding: EdgeInsets.all(2.w),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isDarkMode ? AppColors.cardDark : Colors.white,
                      width: 2,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20.w),
                    child: Image.network(widget.userAvatar, fit: BoxFit.cover),
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              // User details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.userName,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color:
                            isDarkMode
                                ? AppColors.textDarkDark
                                : AppColors.textDarkLight,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Row(
                      children: [
                        Container(
                          width: 8.w,
                          height: 8.w,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.online,
                          ),
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          'Online',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color:
                                isDarkMode
                                    ? AppColors.textMediumDark
                                    : AppColors.textMediumLight,
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
        actions: [
          // Video call button
          Container(
            margin: EdgeInsets.symmetric(horizontal: 4.w),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color:
                  isDarkMode ? AppColors.backgroundDark : Colors.grey.shade100,
            ),
            child: IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.videocam_outlined,
                color:
                    isDarkMode ? AppColors.primaryDark : AppColors.primaryLight,
                size: 20.sp,
              ),
            ),
          ),
          // Voice call button
          Container(
            margin: EdgeInsets.symmetric(horizontal: 4.w),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color:
                  isDarkMode ? AppColors.backgroundDark : Colors.grey.shade100,
            ),
            child: IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.call_outlined,
                color:
                    isDarkMode ? AppColors.primaryDark : AppColors.primaryLight,
                size: 20.sp,
              ),
            ),
          ),
          // More options button
          Container(
            margin: EdgeInsets.only(left: 4.w, right: 8.w),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color:
                  isDarkMode ? AppColors.backgroundDark : Colors.grey.shade100,
            ),
            child: IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.more_vert,
                color:
                    isDarkMode ? AppColors.primaryDark : AppColors.primaryLight,
                size: 20.sp,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Message list
          Expanded(
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color:
                        isDarkMode
                            ? AppColors.backgroundDark
                            : AppColors.backgroundLight,
                    image: DecorationImage(
                      image: AssetImage('assets/images/chat_bg.png'),
                      // If image doesn't exist, this will create a clean background
                      onError: (exception, stackTrace) => {},
                      opacity: 0.05,
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: ListView.builder(
                    controller: _scrollController,
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 16.h,
                    ),
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      final message = _messages[index];
                      final isMe = message.senderId == 'current_user';

                      // Get previous and next messages for grouping
                      final previousMessage =
                          index > 0 ? _messages[index - 1] : null;
                      final nextMessage =
                          index < _messages.length - 1
                              ? _messages[index + 1]
                              : null;

                      // Check if the message should display a timestamp
                      final bool showTimestamp =
                          index == 0 ||
                          !_isSameDay(
                            message.createdAt,
                            previousMessage?.createdAt,
                          );

                      // Check if this message is part of a group or needs space
                      final bool isFirstInGroup =
                          previousMessage == null ||
                          previousMessage.senderId != message.senderId ||
                          _shouldSeparateMessages(
                            message.createdAt,
                            previousMessage.createdAt,
                          );

                      final bool isLastInGroup =
                          nextMessage == null ||
                          nextMessage.senderId != message.senderId ||
                          _shouldSeparateMessages(
                            nextMessage.createdAt,
                            message.createdAt,
                          );

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Show date separator if needed
                          if (showTimestamp)
                            _buildDateSeparator(message.createdAt, isDarkMode),

                          // Message bubble
                          Container(
                            margin: EdgeInsets.only(
                              top: isFirstInGroup ? 12.h : 2.h,
                              bottom: isLastInGroup ? 12.h : 2.h,
                            ),
                            child: _buildMessageItem(
                              message,
                              isMe,
                              isLastInGroup,
                              isDarkMode,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),

                // Scroll to bottom button
                if (_showScrollToBottom)
                  Positioned(
                    right: 16.w,
                    bottom: 16.h,
                    child: GestureDetector(
                      onTap: _scrollToBottom,
                      child: Container(
                        width: 40.w,
                        height: 40.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isDarkMode ? AppColors.cardDark : Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.keyboard_arrow_down,
                          color:
                              isDarkMode
                                  ? AppColors.primaryDark
                                  : AppColors.primaryLight,
                          size: 24.sp,
                        ),
                      ),
                    ),
                  ),

                // Typing indicator for other user
                if (_isOtherUserTyping)
                  Positioned(
                    left: 16.w,
                    right: 16.w,
                    bottom: 70.h,
                    child: _buildTypingIndicator(isDarkMode),
                  ),
              ],
            ),
          ),

          // Attachment menu
          if (_isAttachmentMenuOpen)
            _buildAttachmentMenu(isDarkMode), // Message input box
          Container(
            decoration: BoxDecoration(
              color: isDarkMode ? AppColors.cardDark : AppColors.cardLight,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 15,
                  offset: Offset(0, -2),
                  spreadRadius: 1,
                ),
              ],
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.r),
                topRight: Radius.circular(20.r),
              ),
            ),
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // Attachment button
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color:
                        isDarkMode
                            ? AppColors.backgroundDark
                            : Colors.grey.shade100,
                  ),
                  child: IconButton(
                    onPressed: _toggleAttachmentMenu,
                    icon: Icon(
                      Icons.add_circle_outlined,
                      color:
                          isDarkMode
                              ? AppColors.primaryDark
                              : AppColors.primaryLight,
                      size: 24.sp,
                    ),
                    padding: EdgeInsets.all(8.w),
                    constraints: BoxConstraints(),
                  ),
                ),
                SizedBox(width: 8.w),

                // Text input field
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color:
                          isDarkMode
                              ? AppColors.backgroundDark
                              : Colors.grey[100],
                      borderRadius: BorderRadius.circular(24.r),
                      border: Border.all(
                        color:
                            isDarkMode
                                ? Colors.grey.shade800
                                : Colors.grey.shade200,
                        width: 1,
                      ),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 4.h,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _messageController,
                            decoration: InputDecoration(
                              hintText: 'Type a message...',
                              hintStyle: TextStyle(
                                color:
                                    isDarkMode
                                        ? AppColors.textLightDark
                                        : AppColors.textLightLight,
                                fontSize: 16.sp,
                              ),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                vertical: 10.h,
                              ),
                            ),
                            style: TextStyle(
                              color:
                                  isDarkMode
                                      ? AppColors.textDarkDark
                                      : AppColors.textDarkLight,
                              fontSize: 16.sp,
                            ),
                            onChanged: (value) {
                              setState(() {
                                // Animate the send button
                                if (value.trim().isNotEmpty) {
                                  _sendButtonController.forward();
                                } else {
                                  _sendButtonController.reverse();
                                }
                              });
                            },
                            maxLines: 5,
                            minLines: 1,
                          ),
                        ),

                        // Emoji button
                        Container(
                          margin: EdgeInsets.only(bottom: 4.h),
                          child: IconButton(
                            onPressed: () {
                              // Show emoji picker
                              _showEmojiPicker(context, isDarkMode);
                            },
                            icon: Icon(
                              Icons.emoji_emotions_outlined,
                              color:
                                  isDarkMode
                                      ? Colors.amber
                                      : Colors.amber.shade600,
                              size: 22.sp,
                            ),
                            padding: EdgeInsets.all(4.w),
                            constraints: BoxConstraints(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 8.w),

                // Send button
                AnimatedBuilder(
                  animation: _sendButtonController,
                  builder: (context, child) {
                    return InkWell(
                      onTap: _isSending ? null : _sendMessage,
                      borderRadius: BorderRadius.circular(25.r),
                      child: Container(
                        width: 45.w,
                        height: 45.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            if (_messageController.text.trim().isNotEmpty)
                              BoxShadow(
                                color: (isDarkMode
                                        ? AppColors.buttonGradientEndDark
                                        : AppColors.buttonGradientEndLight)
                                    .withOpacity(0.4),
                                blurRadius: 8,
                                spreadRadius: 1,
                              ),
                          ],
                          gradient:
                              _messageController.text.trim().isNotEmpty
                                  ? LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      isDarkMode
                                          ? AppColors.buttonGradientStartDark
                                          : AppColors.buttonGradientStartLight,
                                      isDarkMode
                                          ? AppColors.buttonGradientEndDark
                                          : AppColors.buttonGradientEndLight,
                                    ],
                                  )
                                  : null,
                          color:
                              _messageController.text.trim().isEmpty
                                  ? isDarkMode
                                      ? Colors.grey.shade800
                                      : Colors.grey.shade300
                                  : null,
                        ),
                        child:
                            _isSending
                                ? Center(
                                  child: SizedBox(
                                    width: 20.w,
                                    height: 20.w,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white,
                                      ),
                                    ),
                                  ),
                                )
                                : Transform.rotate(
                                  angle: -0.5, // Slight rotation for style
                                  child: Icon(
                                    Icons.send_rounded,
                                    color:
                                        _messageController.text
                                                .trim()
                                                .isNotEmpty
                                            ? Colors.white
                                            : isDarkMode
                                            ? AppColors.textMediumDark
                                            : AppColors.textMediumLight,
                                    size: 20.sp,
                                  ),
                                ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          // Scroll to bottom button
          if (_showScrollToBottom)
            Container(
              margin: EdgeInsets.only(bottom: 8.h),
              child: FloatingActionButton(
                onPressed: _scrollToBottom,
                mini: true,
                backgroundColor:
                    isDarkMode ? AppColors.primaryDark : AppColors.primaryLight,
                child: Icon(
                  Icons.arrow_downward,
                  color: Colors.white,
                  size: 20.sp,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildMessageItem(
    MessageModel message,
    bool isMe,
    bool isLastInGroup,
    bool isDarkMode,
  ) {
    return Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // Avatar for other user's message
        if (!isMe && isLastInGroup)
          Container(
            width: 34.w,
            height: 34.w,
            margin: EdgeInsets.only(right: 8.w),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: isDarkMode ? AppColors.dividerDark : Colors.white,
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 5,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(17.w),
              child: Image.network(widget.userAvatar, fit: BoxFit.cover),
            ),
          )
        else if (!isMe && !isLastInGroup)
          SizedBox(width: 42.w), // Space for avatar alignment
        // Message content
        Flexible(
          child: Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.7,
            ),
            decoration: BoxDecoration(
              color: _getMessageBubbleColor(message, isMe, isDarkMode),
              borderRadius: _getMessageBubbleBorderRadius(isMe, isLastInGroup),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 8,
                  offset: Offset(0, 2),
                  spreadRadius: 1,
                ),
              ],
              gradient:
                  isMe
                      ? LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          isDarkMode
                              ? AppColors.buttonGradientStartDark
                              : AppColors.buttonGradientStartLight,
                          isDarkMode
                              ? AppColors.buttonGradientEndDark
                              : AppColors.buttonGradientEndLight,
                        ],
                      )
                      : null,
            ),
            child: Padding(
              padding:
                  message.type == MessageType.text
                      ? EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h)
                      : EdgeInsets.all(6.w),
              child: _buildMessageContent(message, isDarkMode),
            ),
          ),
        ),

        // Status indicators for my messages
        if (isMe && isLastInGroup)
          Container(
            margin: EdgeInsets.only(left: 4.w, bottom: 4.h),
            child: _getMessageStatusIcon(message, isDarkMode),
          ),
      ],
    );
  }

  Widget _buildMessageContent(MessageModel message, bool isDarkMode) {
    switch (message.type) {
      case MessageType.text:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message.content,
              style: TextStyle(
                fontSize: 15.sp,
                color:
                    message.senderId == 'current_user'
                        ? Colors.white
                        : isDarkMode
                        ? AppColors.textDarkDark
                        : AppColors.textDarkLight,
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              _formatTime(message.createdAt),
              style: TextStyle(
                fontSize: 10.sp,
                color:
                    message.senderId == 'current_user'
                        ? Colors.white.withOpacity(0.7)
                        : isDarkMode
                        ? AppColors.textLightDark
                        : AppColors.textLightLight,
              ),
            ),
          ],
        );
      case MessageType.image:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            GestureDetector(
              onTap: () {
                // Open fullscreen image viewer
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => ImageViewerScreen(
                          imageUrl: message.mediaUrl ?? '',
                          heroTag: 'chat_image_${message.id}',
                        ),
                  ),
                );
              },
              child: Hero(
                tag: 'chat_image_${message.id}',
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12.r),
                    child: Image.network(
                      message.mediaUrl ?? '',
                      fit: BoxFit.cover,
                      width: double.infinity,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Container(
                          height: 200.h,
                          width: double.infinity,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color:
                                isDarkMode
                                    ? Colors.grey.shade800
                                    : Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircularProgressIndicator(
                                value:
                                    loadingProgress.expectedTotalBytes != null
                                        ? loadingProgress
                                                .cumulativeBytesLoaded /
                                            loadingProgress.expectedTotalBytes!
                                        : null,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  isDarkMode
                                      ? AppColors.primaryDark
                                      : AppColors.primaryLight,
                                ),
                                strokeWidth: 3,
                              ),
                              SizedBox(height: 12.h),
                              Text(
                                'Loading image...',
                                style: TextStyle(
                                  color:
                                      isDarkMode
                                          ? AppColors.textMediumDark
                                          : AppColors.textMediumLight,
                                  fontSize: 12.sp,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 6.h, right: 8.w),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.photo,
                    size: 12.sp,
                    color:
                        message.senderId == 'current_user'
                            ? Colors.white.withOpacity(0.7)
                            : isDarkMode
                            ? AppColors.textLightDark
                            : AppColors.textLightLight,
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    _formatTime(message.createdAt),
                    style: TextStyle(
                      fontSize: 10.sp,
                      color:
                          message.senderId == 'current_user'
                              ? Colors.white.withOpacity(0.7)
                              : isDarkMode
                              ? AppColors.textLightDark
                              : AppColors.textLightLight,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      default:
        return Text(
          message.content,
          style: TextStyle(
            fontSize: 15.sp,
            color:
                message.senderId == 'current_user'
                    ? Colors.white
                    : isDarkMode
                    ? AppColors.textDarkDark
                    : AppColors.textDarkLight,
          ),
        );
    }
  }

  Widget _getMessageStatusIcon(MessageModel message, bool isDarkMode) {
    switch (message.status) {
      case MessageStatus.sending:
        return SizedBox(
          width: 12.w,
          height: 12.w,
          child: CircularProgressIndicator(
            strokeWidth: 1.5,
            color: Colors.white.withOpacity(0.7),
          ),
        );
      case MessageStatus.sent:
        return Icon(
          Icons.check,
          size: 12.sp,
          color: Colors.white.withOpacity(0.7),
        );
      case MessageStatus.delivered:
        return Icon(
          Icons.done_all,
          size: 12.sp,
          color: Colors.white.withOpacity(0.7),
        );
      case MessageStatus.read:
        return Icon(
          Icons.done_all,
          size: 12.sp,
          color: isDarkMode ? Colors.lightBlueAccent : Colors.blue[300],
        );
      case MessageStatus.failed:
        return Icon(Icons.error_outline, size: 12.sp, color: Colors.redAccent);
    }
  }

  Color _getMessageBubbleColor(
    MessageModel message,
    bool isMe,
    bool isDarkMode,
  ) {
    if (isMe) {
      return isDarkMode ? AppColors.primaryDark : AppColors.primaryLight;
    } else {
      return isDarkMode ? AppColors.cardDark : AppColors.cardLight;
    }
  }

  BorderRadius _getMessageBubbleBorderRadius(bool isMe, bool isLastInGroup) {
    final double radius = 20.r;
    final double cornerRadius = 24.r;
    final double smallRadius = 8.r;

    return BorderRadius.only(
      topLeft: Radius.circular(
        isMe
            ? radius
            : isLastInGroup
            ? cornerRadius
            : radius,
      ),
      topRight: Radius.circular(
        isMe
            ? isLastInGroup
                ? cornerRadius
                : radius
            : radius,
      ),
      bottomLeft: Radius.circular(isMe ? radius : smallRadius),
      bottomRight: Radius.circular(isMe ? smallRadius : radius),
    );
  }

  Widget _buildAttachmentMenu(bool isDarkMode) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: isDarkMode ? AppColors.cardDark : AppColors.cardLight,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, -5),
            spreadRadius: 1,
          ),
        ],
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24.r),
          topRight: Radius.circular(24.r),
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 40.w,
            height: 4.h,
            margin: EdgeInsets.only(bottom: 16.h),
            decoration: BoxDecoration(
              color: isDarkMode ? Colors.grey.shade700 : Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildAttachmentOption(
                icon: Icons.photo,
                label: 'Gallery',
                color: Colors.purple,
                startColor: Colors.purpleAccent,
                endColor: Colors.deepPurple,
                isDarkMode: isDarkMode,
                onTap: () {},
              ),
              _buildAttachmentOption(
                icon: Icons.camera_alt,
                label: 'Camera',
                color: Colors.blue,
                startColor: Colors.lightBlueAccent,
                endColor: Colors.blueAccent,
                isDarkMode: isDarkMode,
                onTap: () {},
              ),
              _buildAttachmentOption(
                icon: Icons.mic,
                label: 'Audio',
                color: Colors.orange,
                startColor: Colors.amber,
                endColor: Colors.deepOrange,
                isDarkMode: isDarkMode,
                onTap: () {},
              ),
              _buildAttachmentOption(
                icon: Icons.location_on,
                label: 'Location',
                color: Colors.green,
                startColor: Colors.lightGreen,
                endColor: Colors.green.shade800,
                isDarkMode: isDarkMode,
                onTap: () {},
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildAttachmentOption(
                icon: Icons.insert_drive_file,
                label: 'Document',
                color: Colors.teal,
                startColor: Colors.tealAccent,
                endColor: Colors.teal.shade700,
                isDarkMode: isDarkMode,
                onTap: () {},
              ),
              _buildAttachmentOption(
                icon: Icons.contact_page,
                label: 'Contact',
                color: Colors.pink,
                startColor: Colors.pinkAccent,
                endColor: Colors.pink.shade700,
                isDarkMode: isDarkMode,
                onTap: () {},
              ),
              _buildAttachmentOption(
                icon: Icons.poll,
                label: 'Poll',
                color: Colors.indigo,
                startColor: Colors.indigoAccent,
                endColor: Colors.indigo.shade700,
                isDarkMode: isDarkMode,
                onTap: () {},
              ),
              _buildAttachmentOption(
                icon: Icons.gif_box,
                label: 'GIF',
                color: Colors.cyan,
                startColor: Colors.cyanAccent,
                endColor: Colors.cyan.shade700,
                isDarkMode: isDarkMode,
                onTap: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAttachmentOption({
    required IconData icon,
    required String label,
    required Color color,
    required Color startColor,
    required Color endColor,
    required bool isDarkMode,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.r),
      child: Column(
        children: [
          Container(
            width: 58.w,
            height: 58.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.r),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  startColor.withOpacity(isDarkMode ? 0.7 : 1.0),
                  endColor.withOpacity(isDarkMode ? 0.7 : 1.0),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.2),
                  blurRadius: 10,
                  spreadRadius: 0,
                ),
              ],
            ),
            child: Icon(icon, color: Colors.white, size: 26.sp),
          ),
          SizedBox(height: 8.h),
          Text(
            label,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
              color:
                  isDarkMode
                      ? AppColors.textMediumDark
                      : AppColors.textMediumLight,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateSeparator(DateTime date, bool isDarkMode) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20.h),
      child: Row(
        children: [
          Expanded(
            child: Divider(
              color:
                  isDarkMode
                      ? AppColors.dividerDark.withOpacity(0.5)
                      : AppColors.dividerLight.withOpacity(0.5),
              thickness: 0.5,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
              decoration: BoxDecoration(
                color:
                    isDarkMode
                        ? Colors.grey.shade800.withOpacity(0.7)
                        : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(20.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 8,
                    spreadRadius: 1,
                  ),
                ],
                border: Border.all(
                  color:
                      isDarkMode ? Colors.grey.shade700 : Colors.grey.shade200,
                  width: 0.5,
                ),
              ),
              child: Text(
                _formatDate(date),
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                  color:
                      isDarkMode
                          ? AppColors.textMediumDark
                          : AppColors.textMediumLight,
                ),
              ),
            ),
          ),
          Expanded(
            child: Divider(
              color:
                  isDarkMode
                      ? AppColors.dividerDark.withOpacity(0.5)
                      : AppColors.dividerLight.withOpacity(0.5),
              thickness: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final messageDate = DateTime(date.year, date.month, date.day);

    if (messageDate == today) {
      return 'Today';
    } else if (messageDate == yesterday) {
      return 'Yesterday';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  String _formatTime(DateTime date) {
    return '${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }

  bool _isSameDay(DateTime? date1, DateTime? date2) {
    if (date1 == null || date2 == null) return false;
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  bool _shouldSeparateMessages(DateTime date1, DateTime date2) {
    // Separate messages if they're more than 5 minutes apart
    return date1.difference(date2).inMinutes.abs() > 5;
  }

  Widget _buildTypingIndicator(bool isDarkMode) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // User avatar
        Container(
          width: 34.w,
          height: 34.w,
          margin: EdgeInsets.only(right: 8.w),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: isDarkMode ? AppColors.dividerDark : Colors.white,
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 5,
                spreadRadius: 1,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(17.w),
            child: Image.network(widget.userAvatar, fit: BoxFit.cover),
          ),
        ),

        // Typing bubble
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          decoration: BoxDecoration(
            color: isDarkMode ? AppColors.cardDark : AppColors.cardLight,
            borderRadius: BorderRadius.circular(18.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 5,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Row(
            children: [
              _buildBouncingDot(isDarkMode, 0),
              SizedBox(width: 4.w),
              _buildBouncingDot(isDarkMode, 1),
              SizedBox(width: 4.w),
              _buildBouncingDot(isDarkMode, 2),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBouncingDot(bool isDarkMode, int index) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      builder: (context, value, child) {
        return Container(
          width: 8.w,
          height: 8.w + (4.w * math.sin((value * 2 * math.pi) + (index * 1.0))),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isDarkMode ? AppColors.primaryDark : AppColors.primaryLight,
          ),
        );
      },
    );
  }

  void _showEmojiPicker(BuildContext context, bool isDarkMode) {
    setState(() {
      _isEmojiPickerOpen = true;
    });

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder:
          (context) => EmojiPickerView(
            onEmojiSelected: (emoji) {
              // Insert emoji at current cursor position
              final text = _messageController.text;
              final textSelection = _messageController.selection;
              final newText = text.replaceRange(
                textSelection.start,
                textSelection.end,
                emoji,
              );

              // Update controller with new text and update cursor position
              final emojiLength = emoji.length;
              _messageController.value = TextEditingValue(
                text: newText,
                selection: TextSelection.collapsed(
                  offset: textSelection.baseOffset + emojiLength,
                ),
              );
            },
          ),
    ).then((_) {
      setState(() {
        _isEmojiPickerOpen = false;
      });
    });
  }
}
