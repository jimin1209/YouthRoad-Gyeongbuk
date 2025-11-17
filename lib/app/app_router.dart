import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../features/onboarding/presentation/onboarding_page.dart';
import '../features/policy/presentation/policy_detail_page.dart';
import '../features/policy/presentation/policy_list_page.dart';
import '../features/search/presentation/policy_search_page.dart';
import '../features/bookmark/presentation/bookmark_page.dart';
import '../features/unity/presentation/unity_map_page.dart';
import '../features/onboarding/presentation/splash_page.dart';
import '../features/home/home_page.dart';
import '../features/settings/settings_page.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        name: 'splash',
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: '/onboarding',
        name: 'onboarding',
        builder: (context, state) => const OnboardingPage(),
      ),
      GoRoute(
        path: '/home',
        name: 'home',
        builder: (context, state) => const HomePage(),
        routes: [
          GoRoute(
            path: 'policy/:id',
            name: 'policy_detail',
            builder: (context, state) {
              final id = state.pathParameters['id']!;
              return PolicyDetailPage(policyId: id);
            },
          ),
          GoRoute(
            path: 'search',
            name: 'policy_search',
            builder: (context, state) => const PolicySearchPage(),
          ),
          GoRoute(
            path: 'bookmarks',
            name: 'bookmarks',
            builder: (context, state) => const BookmarkPage(),
          ),
          GoRoute(
            path: 'unity-map',
            name: 'unity_map',
            builder: (context, state) {
              String? regionCode;
              String? regionName;
              final extra = state.extra;
              if (extra is Map<String, dynamic>) {
                regionCode = extra['regionCode'] as String?;
                regionName = extra['regionName'] as String?;
              }
              return UnityMapPage(
                initialRegionCode: regionCode,
                initialRegionName: regionName,
              );
            },
          ),
          GoRoute(
            path: 'settings',
            name: 'settings',
            builder: (context, state) => const SettingsPage(),
          ),
        ],
      ),
    ],
  );
});
