import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../app/app_router.dart' as app;
import '../core/api/youth_api_service.dart';
import '../core/network/dio_client.dart';
import '../features/policy/data/policy_repository.dart';

final dioProvider = Provider((ref) => createDioClient());

final youthApiServiceProvider = Provider<YouthApiService>((ref) {
  final dio = ref.watch(dioProvider);
  return YouthApiService(dio);
});

final policyRepositoryProvider = Provider<PolicyRepository>((ref) {
  final service = ref.watch(youthApiServiceProvider);
  return PolicyRepository(service);
});

/// Re-export router provider to keep a single source of truth.
final routerProvider = Provider<GoRouter>((ref) {
  return ref.read(app.routerProvider);
});
