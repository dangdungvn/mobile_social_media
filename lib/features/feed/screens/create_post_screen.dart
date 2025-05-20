import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/common/providers/theme_provider.dart';
import 'package:mobile/common/utils/app_colors.dart';
import 'package:mobile/common/utils/app_constants.dart';
import 'package:mobile/common/utils/app_style.dart';
import 'package:mobile/common/widgets/custom_button.dart';
import 'package:provider/provider.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final TextEditingController _postController = TextEditingController();
  final List<String> _selectedMedia = [];
  bool _isUploading = false;

  @override
  void dispose() {
    _postController.dispose();
    super.dispose();
  }

  void _selectImage() {
    // Mock image selection for UI demo
    setState(() {
      if (_selectedMedia.length < 4) {
        _selectedMedia.add(
          'https://picsum.photos/500/300?random=${_selectedMedia.length + 1}',
        );
      }
    });
  }

  void _removeMedia(int index) {
    setState(() {
      _selectedMedia.removeAt(index);
    });
  }

  void _submitPost() {
    // Simulate post submission
    setState(() {
      _isUploading = true;
    });

    // Mock API call delay
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _isUploading = false;
      });

      // Reset form and navigate back to feed
      _postController.clear();
      _selectedMedia.clear();

      // Show success snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Post created successfully!"),
          backgroundColor: AppColors.successLight,
        ),
      );

      // Navigate back to news feed
      context.go(AppConstants.routeNewsFeed);
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: isDarkMode ? AppColors.cardDark : AppColors.cardLight,
        title: Text(
          "Create Post",
          style: AppStyle.textStyle(
            18,
            isDarkMode ? AppColors.textDarkDark : AppColors.textDarkLight,
            FontWeight.w600,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            context.go(AppConstants.routeNewsFeed);
          },
          icon: Icon(
            Icons.close,
            color:
                isDarkMode ? AppColors.textDarkDark : AppColors.textDarkLight,
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 16.w),
            child: CustomButton(
              text: "Post",
              onPressed:
                  _postController.text.isNotEmpty || _selectedMedia.isNotEmpty
                      ? _submitPost
                      : () {},
              isLoading: _isUploading,
              isOutlined: false,
              isFullWidth: false,
              width: 80.w,
              height: 36.h,
            ),
          ),
        ],
        elevation: 0,
      ),
      body: Container(
        color:
            isDarkMode ? AppColors.backgroundDark : AppColors.backgroundLight,
        child: Column(
          children: [
            // User info and post input
            Container(
              padding: EdgeInsets.all(16.w),
              color: isDarkMode ? AppColors.cardDark : AppColors.cardLight,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // User avatar
                  CircleAvatar(
                    radius: 24.r,
                    backgroundImage: NetworkImage('https://i.pravatar.cc/300'),
                  ),

                  SizedBox(width: 16.w),

                  // Post input
                  Expanded(
                    child: TextField(
                      controller: _postController,
                      maxLines: 5,
                      style: AppStyle.textStyle(
                        16,
                        isDarkMode
                            ? AppColors.textDarkDark
                            : AppColors.textDarkLight,
                        FontWeight.normal,
                      ),
                      decoration: InputDecoration(
                        hintText: "What's on your mind?",
                        hintStyle: AppStyle.textStyle(
                          16,
                          isDarkMode
                              ? AppColors.textLightDark
                              : AppColors.textLightLight,
                          FontWeight.normal,
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Media preview
            if (_selectedMedia.isNotEmpty)
              Container(
                padding: EdgeInsets.all(16.w),
                color: isDarkMode ? AppColors.cardDark : AppColors.cardLight,
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 8.w,
                    mainAxisSpacing: 8.h,
                    childAspectRatio: 3 / 2,
                  ),
                  itemCount: _selectedMedia.length,
                  itemBuilder: (context, index) {
                    return Stack(
                      children: [
                        // Image/Media preview
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8.r),
                          child: Image.network(
                            _selectedMedia[index],
                            width: double.infinity,
                            height: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),

                        // Remove button
                        Positioned(
                          top: 4.h,
                          right: 4.w,
                          child: GestureDetector(
                            onTap: () => _removeMedia(index),
                            child: Container(
                              width: 24.w,
                              height: 24.w,
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.6),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.close,
                                color: Colors.white,
                                size: 16.sp,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),

            Divider(height: 1.h),

            // Media selection options
            Container(
              padding: EdgeInsets.symmetric(vertical: 8.h),
              color: isDarkMode ? AppColors.cardDark : AppColors.cardLight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _mediaButton(
                    isDarkMode,
                    Icons.photo_library,
                    "Photos",
                    AppColors.primaryLight,
                    AppColors.primaryDark,
                    _selectImage,
                  ),
                  _mediaButton(
                    isDarkMode,
                    Icons.videocam,
                    "Video",
                    AppColors.secondaryLight,
                    AppColors.secondaryDark,
                    () {},
                  ),
                  _mediaButton(
                    isDarkMode,
                    Icons.tag_faces,
                    "Feeling",
                    AppColors.accentLight,
                    AppColors.accentDark,
                    () {},
                  ),
                  _mediaButton(
                    isDarkMode,
                    Icons.location_on,
                    "Location",
                    Colors.green,
                    Colors.green.shade300,
                    () {},
                  ),
                ],
              ),
            ),

            // Post audience selector
            Container(
              padding: EdgeInsets.all(16.w),
              color:
                  isDarkMode
                      ? AppColors.backgroundDark
                      : AppColors.backgroundLight,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Post audience",
                    style: AppStyle.textStyle(
                      16,
                      isDarkMode
                          ? AppColors.textDarkDark
                          : AppColors.textDarkLight,
                      FontWeight.w600,
                    ),
                  ),

                  SizedBox(height: 16.h),

                  _audienceOption(
                    isDarkMode,
                    Icons.public,
                    "Public",
                    "Anyone on or off SocialConnect",
                    true,
                  ),

                  SizedBox(height: 8.h),

                  _audienceOption(
                    isDarkMode,
                    Icons.group,
                    "Friends",
                    "Your friends on SocialConnect",
                    false,
                  ),

                  SizedBox(height: 8.h),

                  _audienceOption(
                    isDarkMode,
                    Icons.lock,
                    "Only me",
                    "Only you can see this post",
                    false,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _mediaButton(
    bool isDarkMode,
    IconData icon,
    String label,
    Color lightColor,
    Color darkColor,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.all(8.w),
        child: Column(
          children: [
            Icon(icon, color: isDarkMode ? darkColor : lightColor, size: 24.sp),

            SizedBox(height: 4.h),

            Text(
              label,
              style: AppStyle.textStyle(
                12,
                isDarkMode
                    ? AppColors.textMediumDark
                    : AppColors.textMediumLight,
                FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _audienceOption(
    bool isDarkMode,
    IconData icon,
    String title,
    String subtitle,
    bool isSelected,
  ) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: isDarkMode ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(8.r),
        border:
            isSelected
                ? Border.all(
                  color:
                      isDarkMode
                          ? AppColors.primaryDark
                          : AppColors.primaryLight,
                  width: 2.w,
                )
                : null,
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
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color:
                  isDarkMode ? AppColors.primaryDark : AppColors.primaryLight,
            ),
          ),

          SizedBox(width: 12.w),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppStyle.textStyle(
                    16,
                    isDarkMode
                        ? AppColors.textDarkDark
                        : AppColors.textDarkLight,
                    FontWeight.w600,
                  ),
                ),

                SizedBox(height: 4.h),

                Text(
                  subtitle,
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
          ),

          if (isSelected)
            Icon(
              Icons.check_circle,
              color:
                  isDarkMode ? AppColors.primaryDark : AppColors.primaryLight,
            ),
        ],
      ),
    );
  }
}
