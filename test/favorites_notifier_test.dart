import 'package:flutter_test/flutter_test.dart';
import 'package:riverpod/riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:youth_road_app/application/notifiers/favorites_notifier.dart';
import 'package:youth_road_app/application/providers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  ProviderContainer createContainer(SharedPreferences prefs) {
    return ProviderContainer(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
      ],
    );
  }

  group('FavoritesNotifier', () {
    test('toggle adds when not present', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      final container = createContainer(prefs);

      final notifier = container.read(favoritesProvider.notifier);
      notifier.toggle('p1');

      expect(container.read(favoritesProvider), {'p1'});
      expect(prefs.getStringList('favorites'), ['p1']);
    });

    test('toggle removes when present', () async {
      SharedPreferences.setMockInitialValues({
        'favorites': ['p1'],
      });
      final prefs = await SharedPreferences.getInstance();
      final container = createContainer(prefs);

      final notifier = container.read(favoritesProvider.notifier);
      notifier.toggle('p1');

      expect(container.read(favoritesProvider), <String>{});
      expect(prefs.getStringList('favorites'), isEmpty);
    });

    test('persists across restarts', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      var container = createContainer(prefs);

      final notifier = container.read(favoritesProvider.notifier);
      notifier.add('p2');

      expect(prefs.getStringList('favorites'), ['p2']);

      container.dispose();
      container = createContainer(prefs);

      expect(container.read(favoritesProvider), {'p2'});
    });

    test('does not allow duplicates', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      final container = createContainer(prefs);

      final notifier = container.read(favoritesProvider.notifier);
      notifier.add('p3');
      notifier.add('p3');

      expect(container.read(favoritesProvider), {'p3'});
      expect(prefs.getStringList('favorites'), ['p3']);
    });

    test('clear works for empty and non-empty states', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      final container = createContainer(prefs);

      final notifier = container.read(favoritesProvider.notifier);
      notifier.clear();
      expect(container.read(favoritesProvider), <String>{});
      expect(prefs.getStringList('favorites'), isEmpty);

      notifier.add('p4');
      notifier.add('p5');
      notifier.clear();

      expect(container.read(favoritesProvider), <String>{});
      expect(prefs.getStringList('favorites'), isEmpty);
    });
  });
}
