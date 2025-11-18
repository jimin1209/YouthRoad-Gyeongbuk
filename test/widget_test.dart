import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:youth_road_app/app/app_startup.dart';
import 'package:youth_road_app/main.dart';

void main() {
  testWidgets('YouthRoadApp renders with stubbed startup', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appStartupProvider.overrideWith((ref) async {}),
        ],
        child: const YouthRoadApp(),
      ),
    );

    await tester.pump();

    expect(find.byType(YouthRoadApp), findsOneWidget);
  });
}
