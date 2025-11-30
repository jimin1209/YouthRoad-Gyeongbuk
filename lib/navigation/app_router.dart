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
import '../ui/screens/compare/compare_screen.dart';
import '../ui/screens/policy/policy_compare_screen.dart';
import '../ui/screens/policy/policy_detail_v2_screen.dart';
import '../ui/screens/policy/policy_list_legacy_screen.dart';
import '../ui/screens/policy/policy_webview_page.dart';
import '../ui/screens/region/region_select_screen.dart';
import '../ui/screens/setting/setting_screen.dart';
import '../ui/screens/setting/setting_v2_screen.dart';
import '../app/splash/splash_page.dart';
import '../features/policy/ui/policy_list_page.dart';
import '../ui/screens/unity/unity_screen.dart';
import '../ui/widgets/bottom_nav.dart';
import '../ui/widgets/global_error_view.dart';
import 'route_paths.dart';

class AppRouter {
  const AppRouter();

  GoRouter router() {
    return GoRouter(
      initialLocation: RoutePaths.splash,
      errorBuilder: (context, state) {
        return Scaffold(
          body: GlobalErrorView(
            message: state.error?.toString() ?? '페이지를 불러오지 못했습니다.',
            onRetry: () => context.go(RoutePaths.home),
          ),
        );
      },
      routes: [
        GoRoute(
          path: RoutePaths.splash,
          builder: (context, state) => const SplashPage(),
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
          builder: (context, state) => const PolicyListPage(),
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
          path: RoutePaths.compare,
          builder: (context, state) => const CompareScreen(),
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
            return PolicyDetailV2Screen(id: id);
          },
        ),
        GoRoute(
          path: RoutePaths.policyWebview,
          builder: (context, state) {
            String title = '정책 상세';
            String url = '';

            final extra = state.extra;
            if (extra is Map) {
              title = extra['title'] as String? ?? title;
              url = extra['url'] as String? ?? url;
            }

            url = url.isNotEmpty
                ? url
                : (state.uri.queryParameters['url'] ?? '');

            return PolicyWebviewPage(title: title, url: url);
          },
        ),
      ],
    );
  }
}
