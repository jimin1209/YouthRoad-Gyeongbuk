import 'user_profile.dart';

abstract class UserProfileRepository {
  Future<UserProfile?> load();
  Future<void> save(UserProfile profile);
  Future<void> clear();
}
