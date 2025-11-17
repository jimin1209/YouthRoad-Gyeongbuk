import 'package:flutter_riverpod/flutter_riverpod.dart';

final onboardingStateProvider =
    StateProvider<OnboardingState>((ref) => const OnboardingState());

class OnboardingState {
  final bool completed;
  const OnboardingState({this.completed = false});

  OnboardingState copyWith({bool? completed}) {
    return OnboardingState(completed: completed ?? this.completed);
  }
}
