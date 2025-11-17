import 'package:flutter/material.dart';

import 'core/constants/app_strings.dart';
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

  void _onTabSelected(int index) {
    if (index == _currentIndex) return;
    setState(() {
      _currentIndex = index;
    });
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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppStrings.appTitle,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: Scaffold(
        body: SafeArea(child: _buildBody()),
        bottomNavigationBar: BottomNav(
          currentIndex: _currentIndex,
          onTap: _onTabSelected,
        ),
      ),
    );
  }
}
