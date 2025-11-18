import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/logging/app_logger.dart';
import 'app/app_router.dart';
import 'app/app_startup.dart';
import 'app/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppLogger.bootstrap(
    () => runApp(const ProviderScope(child: YouthRoadApp())),
  );
}

class YouthRoadApp extends ConsumerWidget {
  const YouthRoadApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final startup = ref.watch(appStartupProvider);
    final router = ref.watch(routerProvider);
    final theme = buildAppTheme();
    return startup.when(
      data: (_) => MaterialApp.router(
        title: 'Gyeongbuk Youth Policy',
        theme: theme,
        routerDelegate: router.routerDelegate,
        routeInformationParser: router.routeInformationParser,
        routeInformationProvider: router.routeInformationProvider,
      ),
      loading: () => MaterialApp(
        title: 'Gyeongbuk Youth Policy',
        theme: theme,
        home: const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
      ),
      error: (error, _) => MaterialApp(
        title: 'Gyeongbuk Youth Policy',
        theme: theme,
        home: Scaffold(
          body: Center(
            child: Text('앱을 시작할 수 없습니다. 다시 시도해주세요.'),
          ),
        ),
      ),
    );
  }
}
