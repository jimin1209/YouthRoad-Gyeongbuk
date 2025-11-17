import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'core/constants/app_strings.dart';
import 'navigation/app_router.dart';
import 'theme/app_theme.dart';
import 'ui/screens/category/category_screen.dart';
import 'ui/screens/chatbot/chatbot_screen.dart';
import 'ui/screens/home/home_screen.dart';
import 'ui/screens/setting/setting_screen.dart';
import 'ui/widgets/bottom_nav.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _currentIndex = 0;
  static const List<String> _tabs = [
    '/',
    '/category',
    '/chatbot',
    '/setting',
  ];
  late final GoRouter _router = const AppRouter().router(
    builder: _buildRoutedScaffold,
  );

  void _onTabSelected(int index) {
    if (index == _currentIndex) return;
    setState(() {
      _currentIndex = index;
    });
    _router.go(_tabs[index]);
  }

  Widget _buildBody() {
    switch (_currentIndex) {
      case 0:
        return const HomeScreen();
      case 1:
        return const CategoryScreen();
      case 2:
        return const ChatbotScreen();
      case 3:
        return const SettingScreen();
      default:
        return const HomeScreen();
    }
  }

  Widget _buildRoutedScaffold(String location) {
    _syncIndexWithLocation(location);
    return Scaffold(
      body: SafeArea(child: _buildBody()),
      bottomNavigationBar: BottomNav(
        currentIndex: _currentIndex,
        onTap: _onTabSelected,
      ),
    );
  }

  void _syncIndexWithLocation(String location) {
    final index = _locationToIndex(location);
    if (index == _currentIndex) return;
    _currentIndex = index;
  }

  int _locationToIndex(String location) {
    switch (location) {
      case '/':
        return 0;
      case '/category':
        return 1;
      case '/chatbot':
        return 2;
      case '/setting':
        return 3;
      default:
        return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: AppStrings.appTitle,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      routerConfig: _router,
    );
  }
}
