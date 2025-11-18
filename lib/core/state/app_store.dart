import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/profile/providers/user_preferences_provider.dart';

class AppState {
  final String? region;
  final List<String> interests;
  final int? age;
  final bool onboardingCompleted;

  const AppState({
    this.region,
    this.interests = const [],
    this.age,
    this.onboardingCompleted = false,
  });

  AppState copyWith({
    String? region,
    List<String>? interests,
    int? age,
    bool? onboardingCompleted,
  }) {
    return AppState(
      region: region ?? this.region,
      interests: interests ?? this.interests,
      age: age ?? this.age,
      onboardingCompleted: onboardingCompleted ?? this.onboardingCompleted,
    );
  }
}

class AppStore extends StateNotifier<AppState> {
  AppStore({AppState? initialState}) : super(initialState ?? const AppState());

  void hydrate(UserPreferencesSnapshot snapshot) {
    state = state.copyWith(
      region: snapshot.region,
      interests: snapshot.interests,
      age: snapshot.age,
      onboardingCompleted: snapshot.onboardingCompleted,
    );
  }

  void completeOnboarding({
    required String region,
    required List<String> interests,
    int? age,
  }) {
    state = state.copyWith(
      region: region,
      interests: interests,
      age: age,
      onboardingCompleted: true,
    );
  }
}

final appStoreProvider = StateNotifierProvider<AppStore, AppState>((ref) {
  return AppStore();
});
