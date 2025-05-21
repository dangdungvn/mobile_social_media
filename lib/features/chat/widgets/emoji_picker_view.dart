import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile/common/utils/app_colors.dart';
import 'package:mobile/common/providers/theme_provider.dart';
import 'package:provider/provider.dart';

class EmojiPickerView extends StatefulWidget {
  final Function(String) onEmojiSelected;

  const EmojiPickerView({
    super.key,
    required this.onEmojiSelected,
  });

  @override
  State<EmojiPickerView> createState() => _EmojiPickerViewState();
}

class _EmojiPickerViewState extends State<EmojiPickerView> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<String> _emojiCategories = ['😃', '🐱', '🍎', '⚽', '🚗', '💡', '⏱️'];
  
  // Sample emojis - in a real app you'd have a more comprehensive list
  final Map<String, List<String>> _emojis = {
    '😃': ['😀', '😃', '😄', '😁', '😆', '😅', '🤣', '😂', '🙂', '🙃', '😉', '😊', '😇', '😍', '🥰', '😘', '😗', '😚', '😙', '🥲'],
    '🐱': ['🐶', '🐱', '🐭', '🐹', '🐰', '🦊', '🐻', '🐼', '🐻‍❄️', '🐨', '🐯', '🦁', '🐮', '🐷', '🐸', '🐵', '🙈', '🙉', '🙊'],
    '🍎': ['🍎', '🍐', '🍊', '🍋', '🍌', '🍉', '🍇', '🍓', '🫐', '🍈', '🍒', '🍑', '🥭', '🍍', '🥥', '🥝', '🍅', '🍆', '🥑'],
    '⚽': ['⚽', '🏀', '🏈', '⚾', '🥎', '🎾', '🏐', '🏉', '🥏', '🎱', '🪀', '🏓', '🏸', '🏒', '🏑', '🥍', '🏏', '🪃', '🥅'],
    '🚗': ['🚗', '🚕', '🚙', '🚌', '🚎', '🏎', '🚓', '🚑', '🚒', '🚐', '🛻', '🚚', '🚛', '🚜', '🛵', '🏍', '🛺', '🚲', '🛴'],
    '💡': ['💡', '🔦', '🧯', '🛢', '💸', '💵', '💴', '💶', '💷', '💰', '💳', '💎', '⚖️', '🪜', '🧰', '🔧', '🔨', '⚒️', '🛠️'],
    '⏱️': ['⏱️', '⌚', '⏰', '⌛', '⏳', '🕰️', '🕛', '🕧', '🕐', '🕜', '🕑', '🕝', '🕒', '🕞', '🕓', '🕟', '🕔', '🕠', '🕕', '🕡'],
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _emojiCategories.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;
    final backgroundColor = isDarkMode ? AppColors.cardDark : AppColors.cardLight;
    final tabBarColor = isDarkMode ? AppColors.backgroundDark : AppColors.backgroundLight;
    final indicatorColor = isDarkMode ? AppColors.primaryDark : AppColors.primaryLight;
    
    return Container(
      height: 300.h,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24.r),
          topRight: Radius.circular(24.r),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 1,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Drag handle
          Container(
            margin: EdgeInsets.only(top: 8.h),
            width: 40.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: isDarkMode 
                ? Colors.grey.shade700 
                : Colors.grey.shade400,
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),
          
          // Search bar
          Padding(
            padding: EdgeInsets.all(12.w),
            child: Container(
              height: 40.h,
              decoration: BoxDecoration(
                color: isDarkMode 
                  ? Colors.grey.shade800 
                  : Colors.grey.shade200,
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search emoji',
                  hintStyle: TextStyle(
                    fontSize: 14.sp,
                    color: isDarkMode 
                      ? Colors.grey.shade400 
                      : Colors.grey.shade600,
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    size: 20.sp,
                    color: isDarkMode 
                      ? Colors.grey.shade400 
                      : Colors.grey.shade600,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 10.h,
                    horizontal: 16.w,
                  ),
                ),
              ),
            ),
          ),
          
          // Tab Bar for emoji categories
          Container(
            color: tabBarColor,
            child: TabBar(
              controller: _tabController,
              indicatorColor: indicatorColor,
              indicatorWeight: 3,
              labelPadding: EdgeInsets.symmetric(vertical: 8.h),
              tabs: _emojiCategories.map((emoji) => 
                Text(
                  emoji,
                  style: TextStyle(fontSize: 22.sp),
                )
              ).toList(),
            ),
          ),
          
          // Emoji grid
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: _emojiCategories.map((category) {
                return GridView.builder(
                  padding: EdgeInsets.all(8.w),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 8,
                    childAspectRatio: 1,
                    mainAxisSpacing: 4.h,
                    crossAxisSpacing: 4.w,
                  ),
                  itemCount: _emojis[category]?.length ?? 0,
                  itemBuilder: (context, index) {
                    final emoji = _emojis[category]?[index] ?? '';
                    return InkWell(
                      onTap: () => widget.onEmojiSelected(emoji),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Center(
                          child: Text(
                            emoji,
                            style: TextStyle(
                              fontSize: 24.sp,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              }).toList(),
            ),
          ),

          // Recently used emojis
          Container(
            height: 50.h,
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            decoration: BoxDecoration(
              color: tabBarColor,
              border: Border(
                top: BorderSide(
                  color: isDarkMode 
                    ? Colors.grey.shade800 
                    : Colors.grey.shade300,
                  width: 1,
                ),
              ),
            ),
            child: Row(
              children: [
                Text(
                  'Recently used:',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: isDarkMode 
                      ? Colors.grey.shade400 
                      : Colors.grey.shade600,
                  ),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: ['😍', '👍', '❤️', '😂', '🔥', '✨', '🎉'].map((emoji) => 
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 4.w),
                        child: InkWell(
                          onTap: () => widget.onEmojiSelected(emoji),
                          child: Text(
                            emoji,
                            style: TextStyle(fontSize: 22.sp),
                          ),
                        ),
                      )
                    ).toList(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
