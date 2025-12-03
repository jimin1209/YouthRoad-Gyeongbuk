import '../../domain/recommendation/user_profile.dart';
import '../../domain/recommendation/user_profile_repository.dart';
import 'user_profile_local_source.dart';

class UserProfileRepositoryImpl implements UserProfileRepository {
  UserProfileRepositoryImpl(this.localSource);

  final UserProfileLocalSource localSource;

  @override
  Future<UserProfile?> load() {
    return localSource.load();
  }

  @override
  Future<void> save(UserProfile profile) {
    return localSource.save(profile);
  }

  @override
  Future<void> clear() {
    return localSource.clear();
  }
}
