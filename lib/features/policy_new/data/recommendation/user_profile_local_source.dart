import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/recommendation/user_profile.dart';

class UserProfileLocalSource {
  UserProfileLocalSource(this.prefs);

  final SharedPreferences prefs;

  static const _key = 'policy_new.user_profile';

  Future<UserProfile?> load() async {
    final jsonString = prefs.getString(_key);
    if (jsonString == null) return null;
    try {
      final jsonMap = json.decode(jsonString) as Map<String, dynamic>;
      return UserProfile.fromJson(jsonMap);
    } catch (_) {
      return null;
    }
  }

  Future<void> save(UserProfile profile) async {
    final jsonString = json.encode(profile.toJson());
    await prefs.setString(_key, jsonString);
  }

  Future<void> clear() async {
    await prefs.remove(_key);
  }
}
