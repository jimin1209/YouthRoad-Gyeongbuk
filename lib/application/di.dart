import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/repositories/chat_repository.dart';
import '../data/repositories/institution_repository.dart';
import '../data/repositories/policy_repository_impl.dart';
import '../data/sources/remote/policy_remote_source.dart';
import '../domain/repositories/policy_repository.dart';
import 'services/memo_repository.dart';

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('SharedPreferences not initialized');
});

final remotePolicySourceProvider = Provider<PolicyRemoteSource>((ref) {
  final dio = ref.watch(dioProvider);
  return PolicyRemoteSource(dio);
});

final policyRepositoryProvider = Provider<PolicyRepository>((ref) {
  final remoteSource = ref.watch(remotePolicySourceProvider);
  return PolicyRepositoryImpl(remoteSource);
});

final dioProvider = Provider<Dio>((_) => Dio());

final chatRepositoryProvider = Provider<ChatRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return ChatRepository(dio);
});

final institutionRepositoryProvider = Provider<InstitutionRepository>((_) {
  return const InstitutionRepository();
});

final memoRepositoryProvider = Provider<MemoRepository>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return MemoRepository(prefs);
});
