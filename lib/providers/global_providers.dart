import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../app/app_router.dart' as app;
import '../core/network/dio_client.dart';
import '../features/policy/data/policy_repository.dart';

final dioProvider = Provider((ref) => createDioClient());

final policyRepositoryProvider = Provider<PolicyRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return PolicyRepository(dio);
});

/// Re-export router provider to keep a single source of truth.
final routerProvider = Provider<GoRouter>((ref) {
  return ref.read(app.routerProvider);
});
