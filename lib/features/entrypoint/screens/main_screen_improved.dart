import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile/common/providers/theme_provider.dart';
import 'package:mobile/common/utils/app_colors_improved.dart';
import 'package:mobile/common/utils/app_constants.dart';
import 'package:mobile/features/feed/screens/create_post_screen.dart';
import 'package:mobile/features/feed/screens/news_feed_screen.dart';
import 'package:mobile/features/search/screens/search_screen.dart';
import 'package:mobile/features/chat/screens/chat_list_screen.dart';
import 'package:mobile/features/profile/screens/profile_screen.dart';
import 'package:mobile/features/entrypoint/widgets/custom_bottom_nav_bar.dart';
import 'package:mobile/features/entrypoint/widgets/create_post_modal_sheet.dart';
import 'package:provider/provider.dart';

class MainScreenImproved extends StatefulWidget {
  const MainScreenImproved({super.key});

  @override
  State<MainScreenImproved> createState() => _MainScreenImprovedState();
}

class _MainScreenImprovedState extends State<MainScreenImproved>
    with TickerProviderStateMixin {
  int _selectedIndex = 0;
  late AnimationController _animationController;

  final List<Widget> _screens = [
    const NewsFeedScreen(),
    const SearchScreen(),
    const CreatePostScreen(),
    const ChatListScreen(),
    const ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;

    return Scaffold(
      body: Stack(
        children: [
          // Page content
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: _screens[_selectedIndex],
          ), // Bottom navigation bar
          Positioned(
            left: 0,
            right: 0,
            bottom: 16, // Adjusted for better visual appearance
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 8.0,
                vertical: 4.0, // Reduced vertical padding to save space
              ),
              child: CustomBottomNavBar(
                selectedIndex: _selectedIndex,
                onTabSelected: (index) {
                  if (index == 2) {
                    _showCreatePostOptions();
                  } else {
                    setState(() => _selectedIndex = index);
                  }
                },
                onCreatePostTap: _showCreatePostOptions,
              ),
            ),
          ),
        ],
      ),
      extendBody: true, // Important for transparent nav bar
    );
  }

  void _showCreatePostOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return CreatePostModalSheet(
          onOptionSelected: (option) {
            Navigator.pop(context);
            setState(() {
              _selectedIndex = 2; // Switch to create post screen
            });
            // In a real app, we'd pass data to the create post screen
            // to indicate what type of post to create (text, photo, video)
          },
        );
      },
    );
  }
}
