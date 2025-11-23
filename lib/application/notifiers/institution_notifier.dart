import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/api/models/institution_model.dart';
import '../../data/repositories/inst_repository_impl.dart';
import '../../data/sources/remote/institution_remote_source.dart';
import '../di.dart';

final institutionNotifierProvider =
    AutoDisposeAsyncNotifierProvider<InstitutionNotifier, List<InstitutionModel>>(
  InstitutionNotifier.new,
);

class InstitutionNotifier extends AutoDisposeAsyncNotifier<List<InstitutionModel>> {
  String _keyword = '';

  @override
  FutureOr<List<InstitutionModel>> build() {
    return _fetch();
  }

  Future<void> search(String keyword) async {
    _keyword = keyword;
    state = const AsyncLoading();
    state = await AsyncValue.guard(_fetch);
  }

  Future<List<InstitutionModel>> _fetch() async {
    final dio = ref.read(dioProvider);
    final repository = InstRepositoryImpl(null, InstitutionRemoteSource(dio));
    final items = await repository.getInstitutions(keyword: _keyword);
    return items;
  }
}
