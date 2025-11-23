import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/repositories/chat_repository.dart';
import '../data/repositories/institution_repository.dart';
import '../data/repositories/policy_repository_impl.dart';
import '../data/sources/local/local_policy_source.dart';
import '../domain/repositories/policy_repository.dart';

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('SharedPreferences not initialized');
});

final localPolicySourceProvider = Provider<LocalPolicySource>((_) {
  return LocalPolicySource();
});

final policyRepositoryProvider = Provider<PolicyRepository>((ref) {
  final source = ref.watch(localPolicySourceProvider);
  return PolicyRepositoryImpl(source);
});

final dioProvider = Provider<Dio>((_) => Dio());

final chatRepositoryProvider = Provider<ChatRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return ChatRepository(dio);
});

final institutionRepositoryProvider = Provider<InstitutionRepository>((_) {
  return const InstitutionRepository();
});
