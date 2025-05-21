import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile/common/utils/app_colors.dart';
import 'package:provider/provider.dart';
import 'package:mobile/common/providers/theme_provider.dart';
import 'package:photo_view/photo_view.dart';

class ImageViewerScreen extends StatefulWidget {
  final String imageUrl;
  final String heroTag;

  const ImageViewerScreen({
    super.key,
    required this.imageUrl,
    required this.heroTag,
  });

  @override
  State<ImageViewerScreen> createState() => _ImageViewerScreenState();
}

class _ImageViewerScreenState extends State<ImageViewerScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _isControlsVisible = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _animation = Tween<double>(begin: 1.0, end: 0.0).animate(_controller);

    // Hide status bar when entering the full-screen viewer
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  @override
  void dispose() {
    // Restore status bar when leaving the full-screen viewer
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    _controller.dispose();
    super.dispose();
  }

  void _toggleControls() {
    setState(() {
      _isControlsVisible = !_isControlsVisible;
      if (_isControlsVisible) {
        _controller.reverse();
      } else {
        _controller.forward();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Photo with zoom capabilities
          GestureDetector(
            onTap: _toggleControls,
            child: Hero(
              tag: widget.heroTag,
              child: PhotoView(
                imageProvider: NetworkImage(widget.imageUrl),
                minScale: PhotoViewComputedScale.contained,
                maxScale: PhotoViewComputedScale.covered * 2.5,
                backgroundDecoration: const BoxDecoration(color: Colors.black),
                loadingBuilder:
                    (context, event) => Center(
                      child: CircularProgressIndicator(
                        value:
                            event == null
                                ? 0
                                : event.cumulativeBytesLoaded /
                                    (event.expectedTotalBytes ?? 1),
                        valueColor: AlwaysStoppedAnimation<Color>(
                          isDarkMode
                              ? AppColors.primaryDark
                              : AppColors.primaryLight,
                        ),
                      ),
                    ),
              ),
            ),
          ),

          // App bar
          FadeTransition(
            opacity: _animation.drive(CurveTween(curve: Curves.easeOut)),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: _isControlsVisible ? 80.h : 0,
              color: Colors.black.withOpacity(0.5),
              child: SafeArea(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        size: 24.sp,
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.share,
                            color: Colors.white,
                            size: 24.sp,
                          ),
                          onPressed: () {
                            // Share image functionality to be implemented
                          },
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.download,
                            color: Colors.white,
                            size: 24.sp,
                          ),
                          onPressed: () {
                            // Download image functionality to be implemented
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
