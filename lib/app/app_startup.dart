import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../features/onboarding/controller/onboarding_controller.dart';
import '../features/policy/controller/policy_list_controller.dart';
import '../features/profile/providers/user_preferences_provider.dart';
import '../core/state/app_store.dart';

/// Loads persisted onboarding and preference data so that routing and filters
/// are hydrated before the rest of the app renders.
final appStartupProvider = FutureProvider<void>((ref) async {
  final snapshot = await UserPreferencesStorage.load();
  ref.read(userRegionProvider.notifier).state = snapshot.region;
  ref.read(userInterestsProvider.notifier).state = snapshot.interests;
  ref.read(userAgeProvider.notifier).state = snapshot.age;
  ref.read(appStoreProvider.notifier).hydrate(snapshot);

  final onboardingNotifier = ref.read(onboardingStateProvider.notifier);
  onboardingNotifier.state =
      onboardingNotifier.state.copyWith(completed: snapshot.onboardingCompleted);

  if (snapshot.region != null ||
      snapshot.interests.isNotEmpty ||
      snapshot.age != null) {
    ref.read(policyFilterUseProfileProvider.notifier).state = true;
    ref.read(policyFilterStateProvider.notifier).state = PolicyFilter.initial();
  }
});
