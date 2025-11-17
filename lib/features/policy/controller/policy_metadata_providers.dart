import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/models/category.dart';
import '../../../providers/global_providers.dart';

final categoryListProvider = FutureProvider.autoDispose<List<Category>>((ref) async {
  final repo = ref.watch(policyRepositoryProvider);
  return repo.getCategories();
});
