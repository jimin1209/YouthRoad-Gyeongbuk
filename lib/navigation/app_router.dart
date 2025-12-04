import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:youth_road_app/app/splash/splash_page.dart';

import '../ui/screens/category/category_screen.dart';
import '../ui/screens/chatbot/chatbot_screen.dart';
import '../features/policy_new/presentation/screens/policy_feed_home_screen.dart';
import '../ui/screens/favorites/favorites_screen.dart';
import '../ui/screens/institution/department_list_screen.dart';
import '../ui/screens/institution/institution_list_screen.dart';
import '../features/map_v2/kakao_map_screen.dart';
import '../features/map_v2/kakao_map_test_page.dart';
import '../features/map_v2/map_with_list_screen.dart';
import '../ui/screens/compare/compare_screen.dart';
import '../legacy/policy/ui/screens/policy/policy_compare_screen.dart';
import '../legacy/policy/ui/screens/policy/policy_detail_v2_screen.dart';
import '../legacy/policy/ui/screens/policy/policy_list_legacy_screen.dart';
import '../legacy/policy/ui/screens/policy/policy_webview_page.dart';
import '../ui/screens/region/region_select_screen.dart';
import '../ui/screens/setting/setting_screen.dart';
import '../ui/screens/setting/setting_v2_screen.dart';
import '../ui/widgets/bottom_nav.dart';
import '../ui/widgets/global_error_view.dart';
import '../ui/screens/policy/policy_search_screen.dart';
import 'route_paths.dart';
import 'motion_transitions.dart';

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
                  builder: (context, state) => const PolicyFeedHomeScreen(),
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
          pageBuilder: (context, state) => buildSlideFadePage(
            key: state.pageKey,
            child: const SettingV2Screen(),
            transitionDuration: const Duration(milliseconds: 230),
            reverseDuration: const Duration(milliseconds: 180),
          ),
        ),
        GoRoute(
          path: RoutePaths.regionSelect,
          pageBuilder: (context, state) => buildSlideFadePage(
            key: state.pageKey,
            child: const RegionSelectScreen(),
          ),
        ),
        GoRoute(
          path: RoutePaths.policyListV2,
          pageBuilder: (context, state) => buildSlideFadePage(
            key: state.pageKey,
            child: const PolicyFeedHomeScreen(),
          ),
        ),
        GoRoute(
          path: RoutePaths.policyLegacyList,
          pageBuilder: (context, state) => buildSlideFadePage(
            key: state.pageKey,
            child: const PolicyListLegacyScreen(),
            reverseDuration: const Duration(milliseconds: 180),
          ),
        ),
        GoRoute(
          path: RoutePaths.policyCompare,
          pageBuilder: (context, state) => buildSlideFadePage(
            key: state.pageKey,
            child: const PolicyCompareScreen(),
          ),
        ),
        GoRoute(
          path: RoutePaths.compare,
          pageBuilder: (context, state) => buildSlideFadePage(
            key: state.pageKey,
            child: const CompareScreen(),
          ),
        ),
        GoRoute(
          path: RoutePaths.googleMap,
          pageBuilder: (context, state) => buildSlideFadePage(
            key: state.pageKey,
            child: const KakaoMapScreen(),
          ),
        ),
        GoRoute(
          path: RoutePaths.mapWithList,
          pageBuilder: (context, state) => buildSlideFadePage(
            key: state.pageKey,
            child: const MapWithListScreen(),
          ),
        ),
        GoRoute(
          path: RoutePaths.mapTest,
          pageBuilder: (context, state) => buildSlideFadePage(
            key: state.pageKey,
            child: const KakaoMapTestPage(),
          ),
        ),
        GoRoute(
          path: RoutePaths.favorites,
          name: 'FavoritesScreen',
          pageBuilder: (context, state) => buildSlideFadePage(
            key: state.pageKey,
            child: const FavoritesScreen(),
          ),
        ),
        GoRoute(
          path: RoutePaths.search,
          pageBuilder: (context, state) => buildSearchOverlayPage(
            key: state.pageKey,
            child: const PolicySearchScreen(),
          ),
        ),
        GoRoute(
          path: RoutePaths.instList,
          pageBuilder: (context, state) => buildSlideFadePage(
            key: state.pageKey,
            child: const InstitutionListScreen(),
          ),
        ),
        GoRoute(
          path: '/inst/:instNo/dept/list',
          pageBuilder: (context, state) {
            final instNo = state.pathParameters['instNo'] ?? '';
            return buildSlideFadePage(
              key: state.pageKey,
              child: DepartmentListScreen(instNo: instNo),
            );
          },
        ),
        GoRoute(
          path: '/policy/:id',
          pageBuilder: (context, state) {
            final id = state.pathParameters['id'] ?? '';
            return buildSlideFadePage(
              key: state.pageKey,
              child: PolicyDetailV2Screen(id: id),
            );
          },
        ),
        GoRoute(
          path: RoutePaths.policyWebview,
          pageBuilder: (context, state) {
            String title = '정책 상세';
            String url = '';

            final extra = state.extra;
            if (extra is Map) {
              title = extra['title'] as String? ?? title;
              url = extra['url'] as String? ?? url;
            }

            url =
                url.isNotEmpty ? url : (state.uri.queryParameters['url'] ?? '');

            return buildSlideFadePage(
              key: state.pageKey,
              child: PolicyWebviewPage(title: title, url: url),
              transitionDuration: const Duration(milliseconds: 230),
              reverseDuration: const Duration(milliseconds: 180),
            );
          },
        ),
      ],
    );
  }
}
