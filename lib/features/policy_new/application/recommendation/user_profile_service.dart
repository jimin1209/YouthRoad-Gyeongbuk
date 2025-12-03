import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/recommendation/user_profile.dart';
import '../../domain/recommendation/user_profile_repository.dart';
import '../../domain/values/policy_category.dart';
import '../../domain/values/policy_region.dart';

class UserProfileNotifier extends StateNotifier<UserProfile> {
  UserProfileNotifier({
    required this.repository,
    required PolicyRegion defaultRegion,
    this.defaultTags = const ['청년', '창업', '주거'],
  }) : super(UserProfile(region: defaultRegion, recommendTags: defaultTags));

  final UserProfileRepository repository;
  final List<String> defaultTags;

  Future<void> load() async {
    final stored = await repository.load();
    if (stored != null) {
      state = stored;
    }
  }

  Future<void> updateProfile(UserProfile profile) async {
    state = profile;
    await repository.save(profile);
  }

  Future<void> setRegion(PolicyRegion region) {
    return updateProfile(state.copyWith(region: region));
  }

  Future<void> setAge(int? age) {
    return updateProfile(state.copyWith(age: age));
  }

  Future<void> setPreferredCategories(List<PolicyCategory> categories) {
    return updateProfile(state.copyWith(preferredCategories: categories));
  }

  Future<void> setRecommendTags(List<String> tags) {
    return updateProfile(state.copyWith(recommendTags: tags));
  }
}
