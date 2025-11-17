import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../policy/data/models/region.dart';
import '../../../providers/global_providers.dart';

final regionListProvider =
    FutureProvider.autoDispose<List<Region>>((ref) async {
  final repo = ref.watch(policyRepositoryProvider);
  return repo.getRegions();
});

final selectedRegionProvider = StateProvider<String?>((ref) => null);
