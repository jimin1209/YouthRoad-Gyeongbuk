import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers.dart';
import 'storage_state.dart';

final storageCountsProvider = Provider<StorageCounts>((ref) {
  final favorites = ref.watch(favoriteIdsProvider).length;
  final compare = ref.watch(compareRepositoryProvider).ids.length;
  // Reminder 집계는 후속 작업에서 추가
  return StorageCounts(favorites: favorites, compare: compare, reminders: null);
});
