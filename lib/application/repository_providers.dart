import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/models/dept_model.dart';
import '../data/models/inst_model.dart';
import '../data/repositories/dept_repository_impl.dart';
import '../data/repositories/inst_repository_impl.dart';
import '../data/sources/remote/dept_remote_source.dart';
import '../data/sources/remote/inst_remote_source.dart';
import '../domain/repositories/dept_repository.dart';
import '../domain/repositories/inst_repository.dart';
import 'di.dart';

final instRemoteSourceProvider = Provider<InstRemoteSource>((ref) {
  final dio = ref.watch(dioProvider);
  return InstRemoteSource(dio);
});

final instRepositoryProvider = Provider<InstRepository>((ref) {
  final remote = ref.watch(instRemoteSourceProvider);
  return InstRepositoryImpl(remote);
});

final instListProvider = AutoDisposeFutureProvider<List<InstModel>>((ref) async {
  final repository = ref.watch(instRepositoryProvider);
  return repository.fetchInstList();
});

final deptRemoteSourceProvider = Provider<DeptRemoteSource>((ref) {
  final dio = ref.watch(dioProvider);
  return DeptRemoteSource(dio);
});

final deptRepositoryProvider = Provider<DeptRepository>((ref) {
  final remote = ref.watch(deptRemoteSourceProvider);
  return DeptRepositoryImpl(remote);
});

final deptListProvider = AutoDisposeFutureProvider.family<List<DeptModel>, String>(
  (ref, instNo) async {
    final repository = ref.watch(deptRepositoryProvider);
    return repository.fetchDeptList(instNo: instNo);
  },
);
