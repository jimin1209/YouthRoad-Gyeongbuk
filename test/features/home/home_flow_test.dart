import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:youth_road/app/app_router.dart';
import 'package:youth_road/core/state/app_store.dart';
import 'package:youth_road/features/bookmark/controller/bookmark_controller.dart';
import 'package:youth_road/features/bookmark/data/bookmark_models.dart';
import 'package:youth_road/features/onboarding/presentation/onboarding_page.dart';
import 'package:youth_road/features/policy/controller/policy_engagement_controller.dart';
import 'package:youth_road/features/policy/controller/policy_list_controller.dart';
import 'package:youth_road/features/policy/data/models/category.dart';
import 'package:youth_road/features/policy/data/models/policy.dart';
import 'package:youth_road/features/policy/data/models/region.dart';
import 'package:youth_road/features/policy/data/policy_repository.dart';
import 'package:youth_road/features/profile/providers/user_preferences_provider.dart';

class FakePolicyRepository implements PolicyRepository {
  FakePolicyRepository(this.policies);

  final List<Policy> policies;
  String? lastRegion;
  List<String>? lastCategories;

  @override
  Future<List<Category>> getCategories() async => const [];

  @override
  Future<Policy> getPolicyDetail(String id) async {
    return policies.firstWhere((policy) => policy.id == id, orElse: () => policies.first);
  }

  @override
  Future<List<Policy>> getPolicies({
    String? region,
    int? age,
    List<String>? categories,
    String? status,
    String? keyword,
    int page = 1,
    int size = 20,
  }) async {
    lastRegion = region;
    lastCategories = categories;
    return policies;
  }

  @override
  Future<List<Region>> getRegions() async => const [];
}

class FakeEngagementController extends AsyncNotifier<PolicyEngagementState> {
  @override
  Future<PolicyEngagementState> build() async => const PolicyEngagementState();
}

class FakeBookmarkController extends AsyncNotifier<List<BookmarkEntry>> {
  @override
  Future<List<BookmarkEntry>> build() async => const [];
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('redirects to onboarding when onboarding is incomplete', (tester) async {
    final container = ProviderContainer(overrides: [
      appStoreProvider.overrideWith(
        (ref) => AppStore(initialState: const AppState(onboardingCompleted: false)),
      ),
      policyRepositoryProvider.overrideWithValue(FakePolicyRepository(const [])),
      policyEngagementControllerProvider.overrideWith(FakeEngagementController.new),
      bookmarkControllerProvider.overrideWith(FakeBookmarkController.new),
    ]);
    addTearDown(container.dispose);

    final router = container.read(routerProvider);
    final app = UncontrolledProviderScope(
      container: container,
      child: MaterialApp.router(routerConfig: router),
    );

    await tester.pumpWidget(app);
    router.go('/home');
    await tester.pumpAndSettle();

    expect(find.byType(OnboardingPage), findsOneWidget);
  });

  testWidgets('injects onboarding preferences into the first home fetch', (tester) async {
    final fakeRepo = FakePolicyRepository([
      Policy(
        id: '1',
        policyName: '청년 취업 지원',
        region: '47',
        categories: const ['EMPLOYMENT'],
      ),
    ]);

    final container = ProviderContainer(overrides: [
      appStoreProvider.overrideWith(
        (ref) => AppStore(
          initialState: const AppState(
            region: '47',
            interests: ['EMPLOYMENT'],
            onboardingCompleted: true,
          ),
        ),
      ),
      policyRepositoryProvider.overrideWithValue(fakeRepo),
      policyEngagementControllerProvider.overrideWith(FakeEngagementController.new),
      bookmarkControllerProvider.overrideWith(FakeBookmarkController.new),
    ]);
    addTearDown(container.dispose);

    container.read(userRegionProvider.notifier).state = '47';
    container.read(userInterestsProvider.notifier).state = const ['EMPLOYMENT'];
    container.read(policyFilterUseProfileProvider.notifier).state = true;
    container.read(policyFilterStateProvider.notifier).state = PolicyFilter.initial();

    final router = container.read(routerProvider);
    final app = UncontrolledProviderScope(
      container: container,
      child: MaterialApp.router(routerConfig: router),
    );

    await tester.pumpWidget(app);
    router.go('/home');
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));
    await tester.pumpAndSettle();

    expect(fakeRepo.lastRegion, '47');
    expect(fakeRepo.lastCategories, ['EMPLOYMENT']);
    expect(find.text('청년 취업 지원'), findsWidgets);
  });
}
