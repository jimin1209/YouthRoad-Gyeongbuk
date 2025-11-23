import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:youth_road_app/application/notifiers/compare_notifier.dart';
import 'package:youth_road_app/application/providers.dart';
import 'package:youth_road_app/data/models/policy_filter.dart';
import 'package:youth_road_app/domain/entities/policy.dart';
import 'package:youth_road_app/domain/repositories/policy_repository.dart';

class _FakePolicyRepository implements PolicyRepository {
  _FakePolicyRepository(this._policies);

  final Map<String, Policy> _policies;

  @override
  Future<Policy> fetchPolicyById(String id) async {
    final policy = _policies[id];
    if (policy == null) {
      throw Exception('Not found');
    }
    return policy;
  }

  @override
  Future<List<Policy>> fetchPolicies({PolicyFilter filter = const PolicyFilter()}) async {
    return _policies.values.toList();
  }

  @override
  Future<List<Policy>> fetchSimilarPolicies(String id) async {
    return [];
  }
}

Policy _policy(String id) => Policy(
      id: id,
      title: 'title$id',
      category: 'cat',
      summary: 'summary',
      tags: const [],
    );

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late SharedPreferences prefs;
  late ProviderContainer container;
  final repo = _FakePolicyRepository({
    '1': _policy('1'),
    '2': _policy('2'),
    '3': _policy('3'),
  });

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();
    container = ProviderContainer(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
        policyRepositoryProvider.overrideWithValue(repo),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  test('adds items and trims to max two while preventing duplicates', () async {
    final notifier = container.read(compareProvider.notifier);

    await notifier.add('1');
    await notifier.add('2');
    await notifier.add('1');
    await notifier.add('3');

    final policies = await container.read(compareProvider.future);
    expect(policies.map((p) => p.id), ['2', '3']);
    expect(prefs.getStringList('compare'), ['2', '3']);
  });

  test('toggle removes existing ids and adds new ones', () async {
    final notifier = container.read(compareProvider.notifier);

    await notifier.toggle('1');
    await notifier.toggle('2');
    await notifier.toggle('1');

    final policies = await container.read(compareProvider.future);
    expect(policies.map((p) => p.id), ['2']);
  });

  test('persistence restores compare list on new notifier', () async {
    final notifier = container.read(compareProvider.notifier);
    await notifier.add('1');
    await notifier.add('2');
    await container.read(compareProvider.future);

    final newContainer = ProviderContainer(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
        policyRepositoryProvider.overrideWithValue(repo),
      ],
    );
    addTearDown(newContainer.dispose);

    final restored = await newContainer.read(compareProvider.future);
    expect(restored.map((p) => p.id), ['1', '2']);
  });

  test('clear removes all stored ids', () async {
    final notifier = container.read(compareProvider.notifier);
    await notifier.add('1');
    await container.read(compareProvider.future);

    await notifier.clear();

    final restored = await container.read(compareProvider.future);
    expect(restored, isEmpty);
    expect(prefs.getStringList('compare'), isNull);
  });

  test('initial stored values are normalized to two unique ids', () async {
    container.dispose();
    SharedPreferences.setMockInitialValues({
      'compare': ['1', '1', '2', '3'],
    });
    prefs = await SharedPreferences.getInstance();
    container = ProviderContainer(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
        policyRepositoryProvider.overrideWithValue(repo),
      ],
    );

    final restored = await container.read(compareProvider.future);
    expect(restored.map((p) => p.id), ['2', '3']);
    expect(prefs.getStringList('compare'), ['2', '3']);
  });
}
