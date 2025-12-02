import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../application/di.dart';
import '../router/app_router.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return const AppRouter().router();
});

List<Override> buildAppOverrides({required SharedPreferences sharedPreferences}) {
  return [
    sharedPreferencesProvider.overrideWithValue(sharedPreferences),
  ];
}
