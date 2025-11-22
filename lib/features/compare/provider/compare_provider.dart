import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../policy/model/policy_item.dart';
import '../storage/compare_storage.dart';

final compareProvider = StateNotifierProvider<CompareNotifier, List<PolicyItem>>(
  (ref) => CompareNotifier(
    CompareStorage<PolicyItem>(
      key: 'compare_policies',
      toJson: (item) => item.toJson(),
      fromJson: (json) => PolicyItem.fromJson(json),
      maxItems: 2,
    ),
  ),
);

class CompareNotifier extends StateNotifier<List<PolicyItem>> {
  CompareNotifier(this._storage) : super(const []) {
    load();
  }

  final CompareStorage<PolicyItem> _storage;

  Future<void> load() async {
    state = await _storage.load();
  }

  Future<void> toggle(PolicyItem item) async {
    await _storage.toggle(item);
    await load();
  }
}
