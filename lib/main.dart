import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/common/providers/theme_provider.dart';
import 'package:mobile/common/themes/app_theme.dart';
import 'package:mobile/common/utils/app_constants.dart';
import 'package:mobile/features/auth/providers/auth_provider.dart';
import 'package:mobile/features/auth/screens/login_screen.dart';
import 'package:mobile/features/auth/screens/register_screen.dart';
import 'package:mobile/features/auth/screens/splash_screen.dart';
import 'package:mobile/features/chat/screens/chat_detail_screen.dart';
import 'package:mobile/features/chat/screens/chat_list_screen.dart';
import 'package:mobile/features/feed/screens/news_feed_screen.dart';
import 'package:mobile/features/feed/screens/post_detail_screen.dart';
import 'package:mobile/features/profile/screens/profile_screen.dart';
import 'package:mobile/features/search/screens/search_screen.dart';
import 'package:provider/provider.dart';

import 'features/entrypoint/screens/main_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider(create: (context) => AuthProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    final router = GoRouter(
      initialLocation: AppConstants.routeSplash,
      routes: [
        GoRoute(
          path: AppConstants.routeSplash,
          builder: (context, state) => const SplashScreen(),
        ),
        GoRoute(
          path: AppConstants.routeLogin,
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: AppConstants.routeRegister,
          builder: (context, state) => const RegisterScreen(),
        ),
        GoRoute(
          path: AppConstants.routeMain,
          builder: (context, state) => const MainScreen(),
        ),
        GoRoute(
          path: AppConstants.routeNewsFeed,
          builder: (context, state) => const NewsFeedScreen(),
        ),
        GoRoute(
          path: AppConstants.routePostDetail,
          builder:
              (context, state) => PostDetailScreen(
                postId: state.pathParameters['postId'] ?? '',
              ),
        ),
        GoRoute(
          path: AppConstants.routeChat,
          builder: (context, state) => const ChatListScreen(),
        ),
        GoRoute(
          path: AppConstants.routeChatDetail,
          builder:
              (context, state) => ChatDetailScreen(
                chatId: state.pathParameters['chatId'] ?? '',
                userName:
                    state.extra is Map
                        ? (state.extra as Map)['userName'] ?? 'User'
                        : 'User',
                userAvatar:
                    state.extra is Map
                        ? (state.extra as Map)['userAvatar'] ??
                            'https://i.pravatar.cc/150'
                        : 'https://i.pravatar.cc/150',
              ),
        ),
        GoRoute(
          path: AppConstants.routeProfile,
          builder: (context, state) => const ProfileScreen(),
        ),
        GoRoute(
          path: AppConstants.routeSearch,
          builder: (context, state) => const SearchScreen(),
        ),
      ],
    );

    return ScreenUtilInit(
      designSize: const Size(390, 844), // iPhone 13 Pro dimensions
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp.router(
          title: AppConstants.appName,
          theme: AppTheme.lightTheme(),
          darkTheme: AppTheme.darkTheme(),
          themeMode:
              themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          routerConfig: router,
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}
