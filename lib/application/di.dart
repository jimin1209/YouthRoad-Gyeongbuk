import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Isar Local DB
import 'package:youth_road_app/data/local/isar/isar_service.dart';

// Core & Sources
import '../core/constants/env.dart';
import '../data/repositories/swr_policy_repository.dart';
import '../data/sources/local/policy_cache_source.dart';
import '../data/sources/remote/policy_remote_source.dart';

// Repositories
import '../data/repositories/chat_repository.dart';
import '../data/repositories/institution_repository.dart';

// Domain abstraction
import '../domain/repositories/policy_repository.dart';

// Networking
import '../core/network/app_dio.dart';

// Local services
import 'services/memo_repository.dart';

import 'package:dio/dio.dart';

/// SharedPreferences Provider
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('SharedPreferences not initialized');
});

/// Dio Provider (with Network Logger)
final dioProvider = Provider<Dio>((ref) {
  return createAppDio();
});

/// IsarService Provider
final isarServiceProvider = Provider<IsarService>((ref) {
  final service = IsarService();
  ref.onDispose(service.close);
  return service;
});

/// Remote Source Provider
final policyRemoteSourceProvider = Provider<PolicyRemoteSource>((ref) {
  final dio = ref.watch(dioProvider);
  return PolicyRemoteSource(
    dio,
    apiKey: Env.youthApiKey,
    baseUrl: Env.policyApiBaseUrl,
  );
});

final policyCacheSourceProvider = Provider<PolicyCacheSource>((ref) {
  final isar = ref.watch(isarServiceProvider);
  return PolicyCacheSource(isar);
});

/// Stale-while-revalidate Policy Repository (Cache + API)
final policyRepositoryProvider = Provider<PolicyRepository>((ref) {
  final remote = ref.watch(policyRemoteSourceProvider);
  final cache = ref.watch(policyCacheSourceProvider);
  return SwrPolicyRepository(remote, cache);
});

/// For components expecting the abstract interface
final policyRepositoryInterfaceProvider = Provider<PolicyRepository>((ref) {
  return ref.watch(policyRepositoryProvider);
});

/// Chat repo
final chatRepositoryProvider = Provider<ChatRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return ChatRepository(dio);
});

/// Institution repo
final institutionRepositoryProvider = Provider<InstitutionRepository>((ref) {
  return ref.watch(_institutionRepositoryProvider);
});

final _institutionRepositoryProvider = Provider<InstitutionRepository>((ref) {
  return const InstitutionRepository();
});

/// Memo repo
final memoRepositoryProvider = Provider<MemoRepository>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return MemoRepository(prefs);
});
