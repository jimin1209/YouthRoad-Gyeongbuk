import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:youth_road/app/app_startup.dart';
import 'package:youth_road/core/state/app_store.dart';
import 'package:youth_road/features/profile/providers/user_preferences_provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('hydrates persisted preferences into the app store and providers', () async {
    SharedPreferences.setMockInitialValues({
      'user_region': '47',
      'user_interests': <String>['EMPLOYMENT', 'WELFARE'],
      'user_age': 28,
      'onboarding_completed': true,
    });

    final container = ProviderContainer();
    addTearDown(container.dispose);

    await container.read(appStartupProvider.future);

    final appState = container.read(appStoreProvider);
    expect(appState.region, '47');
    expect(appState.interests, ['EMPLOYMENT', 'WELFARE']);
    expect(appState.age, 28);
    expect(appState.onboardingCompleted, isTrue);

    expect(container.read(userRegionProvider), '47');
    expect(container.read(userInterestsProvider), ['EMPLOYMENT', 'WELFARE']);
    expect(container.read(userAgeProvider), 28);
  });
}
