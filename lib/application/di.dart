import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/constants/env.dart';
import '../data/local/isar/isar_service.dart';
import '../data/repositories/chat_repository.dart';
import '../data/repositories/institution_repository.dart';
import '../data/repositories/policy_repository_hybrid.dart';
import '../data/sources/remote/policy_remote_source.dart';
import '../debug/debug_network_logger.dart';
import '../domain/repositories/policy_repository.dart';
import '../data/sources/remote/policy_remote_source.dart';
import 'services/memo_repository.dart';

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('SharedPreferences not initialized');
});

final remotePolicySourceProvider = Provider<PolicyRemoteSource>((ref) {
  final dio = ref.watch(dioProvider);
  return PolicyRemoteSource(dio, apiKey: Env.youthApiKey);
});

final policyRepositoryProvider = Provider<PolicyRepository>((ref) {
  final remoteSource = ref.watch(remotePolicySourceProvider);
  final isarService = ref.watch(isarServiceProvider);
  return HybridPolicyRepository(remoteSource, isarService);
});

final hybridPolicyRepositoryProvider = Provider<HybridPolicyRepository>((ref) {
  final repo = ref.watch(policyRepositoryProvider);
  if (repo is HybridPolicyRepository) {
    return repo;
  }
  throw StateError('policyRepositoryProvider is not HybridPolicyRepository');
});

final dioProvider = Provider<Dio>((_) {
  final dio = Dio();
  DebugNetworkLogger.instance.attachTo(dio);
  return dio;
});

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
