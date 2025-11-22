import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../policy/model/policy_item.dart';
import '../storage/recent_storage.dart';

final recentProvider = StateNotifierProvider<RecentNotifier, List<PolicyItem>>(
  (ref) => RecentNotifier(
    RecentStorage<PolicyItem>(
      key: 'recent_policies',
      toJson: (item) => item.toJson(),
      fromJson: (json) => PolicyItem.fromJson(json),
      maxItems: 20,
    ),
  ),
);

class RecentNotifier extends StateNotifier<List<PolicyItem>> {
  RecentNotifier(this._storage) : super(const []) {
    load();
  }

  final RecentStorage<PolicyItem> _storage;

  Future<void> load() async {
    final data = await _storage.load();
    state = data;
  }

  Future<void> add(PolicyItem item) async {
    await _storage.add(item);
    await load();
  }
}
