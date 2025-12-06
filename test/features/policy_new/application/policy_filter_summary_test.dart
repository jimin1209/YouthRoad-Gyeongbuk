import 'package:flutter_test/flutter_test.dart';
import 'package:youth_road_app/features/policy_new/application/filters/policy_filter_summary.dart';
import 'package:youth_road_app/features/policy_new/application/filters/policy_filter_ui_state.dart';
import 'package:youth_road_app/features/policy_new/domain/values/policy_category.dart';
import 'package:youth_road_app/features/policy_new/domain/values/policy_sort.dart';

void main() {
  group('PolicyFilterSummary', () {
    test('요약 문자열에 선택된 조건이 포함된다', () {
      const filter = PolicyFilterUiState(
        keyword: '청년',
        category: PolicyCategory.employment,
        tags: ['태그1', '태그2'],
        showOnlyOngoing: true,
        showOnlyOnline: true,
        sort: PolicySortOption.deadline,
      );

      final summary = buildPolicyFilterSummary(filter);

      expect(summary, contains('검색어 "청년"'));
      expect(summary, contains('태그(태그1, 태그2)'));
      expect(summary, contains('취업'));
      expect(summary, contains('모집중만'));
      expect(summary, contains('온라인 참여'));
      expect(summary, contains('마감임박'));
    });

    test('조건 요약은 지역과 검색어를 명시한다', () {
      const filter = PolicyFilterUiState(
        province: '경상북도',
        city: '포항시',
        keyword: '주거',
        sort: PolicySortOption.popularity,
      );

      final conditionSummary = buildPolicyFilterConditionSummary(filter);

      expect(conditionSummary, contains('경북 포항시'));
      expect(conditionSummary, contains('검색어 "주거"'));
      expect(conditionSummary, contains('인기순'));
    });
  });
}
