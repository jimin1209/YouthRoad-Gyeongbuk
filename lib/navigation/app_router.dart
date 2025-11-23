import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../ui/screens/category/category_screen.dart';
import '../ui/screens/chatbot/chatbot_screen.dart';
import '../ui/screens/home/home_screen.dart';
import '../ui/screens/favorites/favorites_screen.dart';
import '../ui/screens/institution/department_list_screen.dart';
import '../ui/screens/institution/institution_list_screen.dart';
import '../ui/screens/map/kakao_map_screen.dart';
import '../ui/screens/map/map_with_list_screen.dart';
import '../ui/screens/policy/policy_compare_screen.dart';
import '../ui/screens/policy/policy_detail_screen.dart';
import '../ui/screens/policy/policy_list_legacy_screen.dart';
import '../ui/screens/policy/policy_list_v2_screen.dart';
import '../ui/screens/region/region_select_screen.dart';
import '../ui/screens/setting/setting_screen.dart';
import '../ui/screens/setting/setting_v2_screen.dart';
import '../ui/screens/splash/splash_screen.dart';
import '../ui/screens/unity/unity_screen.dart';
import '../ui/widgets/bottom_nav.dart';
import 'route_paths.dart';

class AppRouter {
  const AppRouter();

  GoRouter router() {
    return GoRouter(
      initialLocation: RoutePaths.splash,
      routes: [
        GoRoute(
          path: RoutePaths.splash,
          builder: (context, state) => const SplashScreen(),
        ),
        StatefulShellRoute.indexedStack(
          builder: (context, state, navigationShell) {
            return Scaffold(
              body: navigationShell,
              bottomNavigationBar: BottomNav(
                currentIndex: navigationShell.currentIndex,
                onTap: (index) {
                  navigationShell.goBranch(index,
                      initialLocation: index == navigationShell.currentIndex);
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
          path: RoutePaths.settingV2,
          builder: (context, state) => const SettingV2Screen(),
        ),
        GoRoute(
          path: RoutePaths.regionSelect,
          builder: (context, state) => const RegionSelectScreen(),
        ),
        GoRoute(
          path: RoutePaths.policyListV2,
          builder: (context, state) => const PolicyListV2Screen(),
        ),
        GoRoute(
          path: RoutePaths.policyLegacyList,
          builder: (context, state) => const PolicyListLegacyScreen(),
        ),
        GoRoute(
          path: RoutePaths.policyCompare,
          builder: (context, state) => const PolicyCompareScreen(),
        ),
        GoRoute(
          path: RoutePaths.unity,
          builder: (context, state) => const UnityScreen(),
        ),
        GoRoute(
          path: RoutePaths.googleMap,
          builder: (context, state) => const KakaoMapScreen(),
        ),
        GoRoute(
          path: RoutePaths.mapWithList,
          builder: (context, state) => const MapWithListScreen(),
        ),
        GoRoute(
          path: RoutePaths.favorites,
          name: 'FavoritesScreen',
          builder: (context, state) => const FavoritesScreen(),
        ),
        GoRoute(
          path: RoutePaths.instList,
          builder: (context, state) => const InstitutionListScreen(),
        ),
        GoRoute(
          path: '/inst/:instNo/dept/list',
          builder: (context, state) {
            final instNo = state.pathParameters['instNo'] ?? '';
            return DepartmentListScreen(instNo: instNo);
          },
        ),
        GoRoute(
          path: '/policy/:id',
          builder: (context, state) {
            final id = state.pathParameters['id'] ?? '';
            return PolicyDetailScreen(id: id);
          },
        ),
      ],
    );
  }
}
