import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Stores the region code selected by the user during onboarding/profile edits.
final userRegionProvider = StateProvider<String?>((ref) => null);

/// Stores the interest category codes selected by the user.
final userInterestsProvider = StateProvider<List<String>>((ref) => const []);

/// Stores the preferred age (if provided) to drive policy filtering.
final userAgeProvider = StateProvider<int?>((ref) => null);

class UserPreferencesSnapshot {
  final String? region;
  final List<String> interests;
  final int? age;
  final bool onboardingCompleted;

  const UserPreferencesSnapshot({
    this.region,
    this.interests = const [],
    this.age,
    this.onboardingCompleted = false,
  });
}

class UserPreferencesStorage {
  static const _regionKey = 'user_region';
  static const _interestsKey = 'user_interests';
  static const _ageKey = 'user_age';
  static const _onboardingKey = 'onboarding_completed';

  static Future<UserPreferencesSnapshot> load() async {
    final prefs = await SharedPreferences.getInstance();
    return UserPreferencesSnapshot(
      region: prefs.getString(_regionKey),
      interests:
          List.unmodifiable(prefs.getStringList(_interestsKey) ?? const []),
      age: prefs.getInt(_ageKey),
      onboardingCompleted: prefs.getBool(_onboardingKey) ?? false,
    );
  }

  static Future<void> save({
    String? region,
    List<String>? interests,
    int? age,
    bool? onboardingCompleted,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    if (region != null) {
      await prefs.setString(_regionKey, region);
    }
    if (interests != null) {
      await prefs.setStringList(_interestsKey, List<String>.from(interests));
    }
    if (age != null) {
      await prefs.setInt(_ageKey, age);
    }
    if (onboardingCompleted != null) {
      await prefs.setBool(_onboardingKey, onboardingCompleted);
    }
  }
}
