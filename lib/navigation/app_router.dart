import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../ui/screens/category/category_screen.dart';
import '../ui/screens/chatbot/chatbot_screen.dart';
import '../ui/screens/home/home_screen.dart';
import '../ui/screens/setting/setting_screen.dart';

class AppRouter {
  const AppRouter();

  GoRouter router({
    required Widget Function(String matchedLocation) builder,
  }) {
    return GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => builder(state.matchedLocation),
        ),
        GoRoute(
          path: '/category',
          builder: (context, state) => builder(state.matchedLocation),
        ),
        GoRoute(
          path: '/chatbot',
          builder: (context, state) => builder(state.matchedLocation),
        ),
        GoRoute(
          path: '/setting',
          builder: (context, state) => builder(state.matchedLocation),
        ),
      ],
    );
  }
}
