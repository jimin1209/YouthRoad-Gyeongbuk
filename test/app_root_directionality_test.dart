import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:youth_road_app/app.dart';
import 'package:youth_road_app/navigation/route_paths.dart';

void main() {
  testWidgets('App provides Directionality at root', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: App(),
      ),
    );

    expect(find.byType(Directionality), findsWidgets);
  });

  testWidgets('App uses GoRouter via MaterialApp.router', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: App(),
      ),
    );

    final materialAppFinder = find.byType(MaterialApp);
    expect(materialAppFinder, findsOneWidget);

    final materialApp = tester.widget<MaterialApp>(materialAppFinder);

    expect(materialApp.routerConfig, isNotNull);
    expect(materialApp.routerConfig, isA<GoRouter>());
  });

  testWidgets('GoRouter has initial route configured', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: App(),
      ),
    );

    final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
    final router = materialApp.routerConfig as GoRouter;

    // ★★★ 최신 안전한 방식 (GoRouter v12~v13 기준)
    final initialUri = router.routeInformationProvider.value.uri.toString();

    expect(initialUri, RoutePaths.splash);
  });
}
