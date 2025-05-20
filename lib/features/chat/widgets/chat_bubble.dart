import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile/common/providers/theme_provider.dart';
import 'package:mobile/common/utils/app_colors_improved.dart';
import 'package:mobile/common/utils/app_style.dart';
import 'package:mobile/features/chat/models/chat_model.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:timeago/timeago.dart' as timeago;

class ChatBubble extends StatelessWidget {
  final MessageModel message;
  final bool isMe;
  final bool showTime;

  const ChatBubble({
    super.key,
    required this.message,
    required this.isMe,
    this.showTime = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          if (showTime) _buildTimeHeader(isDarkMode),

          Row(
            mainAxisAlignment:
                isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
              if (!isMe) _buildAvatar(isDarkMode),

              Flexible(
                child: Container(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.7,
                  ),
                  margin: EdgeInsets.only(
                    left: isMe ? 0 : 8.w,
                    right: isMe ? 8.w : 0,
                  ),
                  padding:
                      message.type == MessageType.text
                          ? EdgeInsets.all(12.w)
                          : EdgeInsets.all(4.w),
                  decoration: BoxDecoration(
                    color: _getBubbleColor(isDarkMode),
                    borderRadius: _getBubbleBorderRadius(),
                    boxShadow: [
                      BoxShadow(
                        color:
                            isDarkMode
                                ? Colors.black.withOpacity(0.15)
                                : Colors.black.withOpacity(0.08),
                        blurRadius: 4,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: _buildMessageContent(context, isDarkMode),
                ),
              ),

              if (isMe) _buildAvatar(isDarkMode),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTimeHeader(bool isDarkMode) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Center(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
          decoration: BoxDecoration(
            color:
                isDarkMode
                    ? AppColors.cardDark.withOpacity(0.7)
                    : AppColors.cardLight.withOpacity(0.7),
            borderRadius: BorderRadius.circular(12.r),
            boxShadow: [
              BoxShadow(
                color:
                    isDarkMode
                        ? Colors.black.withOpacity(0.1)
                        : Colors.black.withOpacity(0.05),
                blurRadius: 4,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Text(
            _formatTime(message.createdAt),
            style: AppStyle.textStyle(
              12,
              isDarkMode ? AppColors.textMediumDark : AppColors.textMediumLight,
              FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar(bool isDarkMode) {
    if (isMe) {
      return Container(
        width: 24.w,
        height: 24.w,
        margin: EdgeInsets.only(right: 4.w),
        child: Stack(
          alignment: Alignment.center,
          children: [
            if (message.status == MessageStatus.sent)
              Icon(
                Icons.check,
                size: 12.sp,
                color:
                    isDarkMode
                        ? AppColors.textMediumDark
                        : AppColors.textMediumLight,
              )
            else if (message.status == MessageStatus.delivered)
              Icon(
                Icons.done_all,
                size: 12.sp,
                color:
                    isDarkMode
                        ? AppColors.textMediumDark
                        : AppColors.textMediumLight,
              )
            else if (message.status == MessageStatus.read)
              Icon(
                Icons.done_all,
                size: 12.sp,
                color:
                    isDarkMode ? AppColors.primaryDark : AppColors.primaryLight,
              ),
          ],
        ),
      );
    }

    return Container(
      width: 28.w,
      height: 28.w,
      margin: EdgeInsets.only(left: 4.w),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors:
              isDarkMode
                  ? AppColors.secondaryGradientDark
                  : AppColors.secondaryGradientLight,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      padding: EdgeInsets.all(1.w),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14.r),
        child:
            message.senderProfilePic != null
                ? CachedNetworkImage(
                  imageUrl: message.senderProfilePic!,
                  fit: BoxFit.cover,
                  placeholder:
                      (context, url) => Container(
                        color:
                            isDarkMode
                                ? AppColors.backgroundDark
                                : AppColors.backgroundLight,
                      ),
                )
                : Container(
                  color:
                      isDarkMode
                          ? AppColors.backgroundDark
                          : AppColors.backgroundLight,
                  child: Icon(
                    Icons.person,
                    size: 16.sp,
                    color:
                        isDarkMode
                            ? AppColors.textLightDark
                            : AppColors.textLightLight,
                  ),
                ),
      ),
    );
  }

  Widget _buildMessageContent(BuildContext context, bool isDarkMode) {
    switch (message.type) {
      case MessageType.text:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.end,
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
                  _formatShortTime(message.createdAt),
                  style: AppStyle.textStyle(
                    10,
                    isMe
                        ? Colors.white70
                        : isDarkMode
                        ? AppColors.textLightDark
                        : AppColors.textLightLight,
                    FontWeight.normal,
                  ),
                ),
              ],
            ),
          ],
        );

      case MessageType.image:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8.r),
              child: CachedNetworkImage(
                imageUrl: message.mediaUrl!,
                fit: BoxFit.cover,
                width: MediaQuery.of(context).size.width * 0.6,
                placeholder:
                    (context, url) => Container(
                      height: 150.h,
                      width: MediaQuery.of(context).size.width * 0.6,
                      color:
                          isDarkMode
                              ? AppColors.backgroundDark
                              : AppColors.backgroundLight,
                      child: Center(
                        child: CircularProgressIndicator(
                          color:
                              isDarkMode
                                  ? AppColors.primaryDark
                                  : AppColors.primaryLight,
                          strokeWidth: 2.w,
                        ),
                      ),
                    ),
                errorWidget:
                    (context, url, error) => Container(
                      height: 150.h,
                      width: MediaQuery.of(context).size.width * 0.6,
                      color:
                          isDarkMode
                              ? AppColors.backgroundDark
                              : AppColors.backgroundLight,
                      child: Center(
                        child: Icon(
                          Icons.error_outline,
                          color: AppColors.errorLight,
                        ),
                      ),
                    ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 6.h, right: 6.w, left: 6.w),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (message.content.isNotEmpty) ...[
                    Flexible(
                      child: Text(
                        message.content,
                        style: AppStyle.textStyle(
                          12,
                          isMe
                              ? Colors.white70
                              : isDarkMode
                              ? AppColors.textMediumDark
                              : AppColors.textMediumLight,
                          FontWeight.normal,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(width: 8.w),
                  ],
                  Text(
                    _formatShortTime(message.createdAt),
                    style: AppStyle.textStyle(
                      10,
                      isMe
                          ? Colors.white70
                          : isDarkMode
                          ? AppColors.textLightDark
                          : AppColors.textLightLight,
                      FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );

      case MessageType.video:
        return Container(
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8.r),
          ),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            alignment: Alignment.center,
            children: [
              if (message.thumbnailUrl != null)
                CachedNetworkImage(
                  imageUrl: message.thumbnailUrl!,
                  fit: BoxFit.cover,
                  width: MediaQuery.of(context).size.width * 0.6,
                  height: 150.h,
                ),
              Container(
                width: 40.w,
                height: 40.w,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.play_arrow, color: Colors.white, size: 24.sp),
              ),
              Positioned(
                bottom: 8.h,
                right: 8.w,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                  child: Text(
                    _formatShortTime(message.createdAt),
                    style: AppStyle.textStyle(
                      10,
                      Colors.white,
                      FontWeight.normal,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );

      case MessageType.file:
        return Container(
          width: MediaQuery.of(context).size.width * 0.6,
          padding: EdgeInsets.all(8.w),
          decoration: BoxDecoration(
            color:
                isDarkMode
                    ? AppColors.backgroundDark.withOpacity(0.3)
                    : AppColors.backgroundLight.withOpacity(0.5),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Row(
            children: [
              Container(
                width: 40.w,
                height: 40.w,
                decoration: BoxDecoration(
                  color:
                      isDarkMode
                          ? AppColors.primaryDark.withOpacity(0.1)
                          : AppColors.primaryLight.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6.r),
                ),
                child: Icon(
                  Icons.insert_drive_file,
                  color:
                      isDarkMode
                          ? AppColors.primaryDark
                          : AppColors.primaryLight,
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      message.content.isEmpty
                          ? "File Document"
                          : message.content,
                      style: AppStyle.textStyle(
                        14,
                        isMe
                            ? Colors.white
                            : isDarkMode
                            ? AppColors.textDarkDark
                            : AppColors.textDarkLight,
                        FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          message.mediaUrl?.split('/').last ?? "Document",
                          style: AppStyle.textStyle(
                            10,
                            isMe
                                ? Colors.white70
                                : isDarkMode
                                ? AppColors.textLightDark
                                : AppColors.textLightLight,
                            FontWeight.normal,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          _formatShortTime(message.createdAt),
                          style: AppStyle.textStyle(
                            10,
                            isMe
                                ? Colors.white70
                                : isDarkMode
                                ? AppColors.textLightDark
                                : AppColors.textLightLight,
                            FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      default:
        return const SizedBox();
    }
  }

  Color _getBubbleColor(bool isDarkMode) {
    if (isMe) {
      return isDarkMode ? AppColors.primaryDark : AppColors.primaryLight;
    } else {
      return isDarkMode ? AppColors.cardDark : AppColors.cardLight;
    }
  }

  BorderRadius _getBubbleBorderRadius() {
    if (isMe) {
      return BorderRadius.only(
        topLeft: Radius.circular(16.r),
        topRight: Radius.circular(4.r),
        bottomLeft: Radius.circular(16.r),
        bottomRight: Radius.circular(16.r),
      );
    } else {
      return BorderRadius.only(
        topLeft: Radius.circular(4.r),
        topRight: Radius.circular(16.r),
        bottomLeft: Radius.circular(16.r),
        bottomRight: Radius.circular(16.r),
      );
    }
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = DateTime(now.year, now.month, now.day - 1);
    final messageDate = DateTime(dateTime.year, dateTime.month, dateTime.day);

    if (messageDate == today) {
      return 'Hôm nay, ${_formatHour(dateTime)}';
    } else if (messageDate == yesterday) {
      return 'Hôm qua, ${_formatHour(dateTime)}';
    } else {
      return '${dateTime.day}/${dateTime.month}, ${_formatHour(dateTime)}';
    }
  }

  String _formatShortTime(DateTime dateTime) {
    return _formatHour(dateTime);
  }

  String _formatHour(DateTime dateTime) {
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}
