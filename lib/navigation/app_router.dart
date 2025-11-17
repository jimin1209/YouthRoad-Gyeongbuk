import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../ui/screens/category/category_screen.dart';
import '../ui/screens/chatbot/chatbot_screen.dart';
import '../ui/screens/home/home_screen.dart';
import '../ui/screens/setting/setting_screen.dart';
import '../ui/screens/unity/unity_screen.dart';
import '../ui/widgets/bottom_nav.dart';
import 'route_paths.dart';

class AppRouter {
  const AppRouter();

  GoRouter router() {
    return GoRouter(
      initialLocation: RoutePaths.home,
      routes: [
        StatefulShellRoute.indexedStack(
          builder: (context, state, navigationShell) {
            return Scaffold(
              body: navigationShell,
              bottomNavigationBar: BottomNav(
                currentIndex: navigationShell.currentIndex,
                onTap: (index) {
                  navigationShell.goBranch(index,
                      initialLocation: index ==
                          navigationShell
                              .currentIndex); // prevent stacking duplicates
                },
              ),
            );
          },
          branches: [
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: RoutePaths.home,
                  builder: (context, state) => const HomeScreen(),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: RoutePaths.category,
                  builder: (context, state) => const CategoryScreen(),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: RoutePaths.chatbot,
                  builder: (context, state) => const ChatbotScreen(),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: RoutePaths.setting,
                  builder: (context, state) => const SettingScreen(),
                ),
              ],
            ),
          ],
        ),
        GoRoute(
          path: RoutePaths.unity,
          builder: (context, state) => const UnityScreen(),
        ),
        GoRoute(
          path: '/policy/:id',
          builder: (context, state) {
            final id = state.pathParameters['id']!;
            return Scaffold(
              appBar: AppBar(title: Text('정책 상세 $id')),
              body: Center(child: Text('정책 상세 페이지 (준비 중): $id')),
            );
          },
        ),
      ],
    );
  }
}
