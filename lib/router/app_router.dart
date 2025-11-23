import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../data/model/policy_models.dart';
import '../feature/dept/dept_list_screen.dart';
import '../feature/inst/inst_list_screen.dart';
import '../feature/map/map_screen.dart';
import '../feature/policy/policy_detail_screen.dart';
import '../feature/policy/policy_list_screen.dart';
import '../feature/policy/policy_webview_screen.dart';
import '../feature/region/region_select_screen.dart';
import '../feature/settings/settings_screen.dart';
import '../feature/splash/splash_screen.dart';
import '../features/ai/ui/ai_chat_page.dart';
import '../features/home/ui/home_hub_page.dart';
import '../features/map/ui/map_with_list_page.dart';
import '../features/map/ui/google_map_page.dart';
import '../features/policy/model/policy_item.dart' as v2_model;
import '../features/policy/ui/detail/policy_detail_page.dart' as v2_detail;
import '../features/policy/ui/compare/policy_compare_page.dart' as v2_compare;
import '../features/policy/ui/list/policy_list_page.dart' as v2_list;
import '../features/settings/ui/settings_v2.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const HomeHubPage(),
      ),
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/region/select',
        builder: (context, state) => const RegionSelectScreen(),
      ),
      GoRoute(
        path: '/policy/list',
        builder: (context, state) => const PolicyListScreen(),
      ),
      GoRoute(
        path: '/policy/list/v2',
        builder: (context, state) => const v2_list.PolicyListPage(),
      ),
      GoRoute(
        path: '/policy/detail/:id',
        builder: (context, state) {
          final String id = state.pathParameters['id'] ?? '';
          if (state.extra is v2_model.PolicyItem) {
            return v2_detail.PolicyDetailPage(item: state.extra as v2_model.PolicyItem);
          }
          final PolicyItem? legacy = state.extra is PolicyItem ? state.extra as PolicyItem : null;
          if (legacy != null) {
            return v2_detail.PolicyDetailPage(
              item: v2_model.PolicyItem(
                id: legacy.no,
                title: legacy.policyNm,
                description: legacy.policyCn,
                instNm: legacy.sprvsnInstNm ?? legacy.operInstNm,
                deptNm: legacy.policyTypeNm,
                policyType: legacy.policyTypeNm,
                region: legacy.rgnSeNm,
                startDate: legacy.policyBgngYmd,
                endDate: legacy.policyEndYmd,
                url: legacy.dtlLinkUrl,
                applyAbleYn: legacy.aplyPsbltyYn,
                instTel: legacy.policyEnq,
              ),
            );
          }
          return v2_detail.PolicyDetailPage(
            item: v2_model.PolicyItem(id: id, title: '정책 상세', description: ''),
          );
        },
        routes: [
          GoRoute(
            path: 'web',
            builder: (context, state) {
              final String url = state.extra as String? ?? '';
              return PolicyWebViewScreen(url: url);
            },
          ),
        ],
      ),
      GoRoute(
        path: '/inst/list',
        builder: (context, state) => const InstListScreen(),
      ),
      GoRoute(
        path: '/inst/:instNo/dept/list',
        builder: (context, state) {
          final String instNo = state.pathParameters['instNo'] ?? '';
          return DeptListScreen(instNo: instNo);
        },
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: '/settings/v2',
        builder: (context, state) => const SettingsV2Page(),
      ),
      GoRoute(
        path: '/map',
        builder: (context, state) => const MapScreen(),
      ),
      GoRoute(
        path: '/map_explore',
        builder: (context, state) => const GoogleMapPage(),
      ),
      GoRoute(
        path: '/google_map',
        builder: (context, state) => const GoogleMapPage(),
      ),
      GoRoute(
        path: '/ai_chat',
        builder: (context, state) => const AiChatPage(),
      ),
      GoRoute(
        path: '/policy/compare',
        builder: (context, state) {
          final items = state.extra is List<v2_model.PolicyItem> ? state.extra as List<v2_model.PolicyItem> : <v2_model.PolicyItem>[];
          return v2_compare.PolicyComparePage(items: items);
        },
      ),
    ],
  );
});
