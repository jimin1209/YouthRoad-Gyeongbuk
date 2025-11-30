import 'package:flutter_test/flutter_test.dart';
import 'package:youth_road_app/application/services/eligibility_service.dart';
import 'package:youth_road_app/domain/entities/policy.dart';

void main() {
  final service = EligibilityService();

  Policy buildPolicy({String? region}) => Policy(
        id: 'p1',
        policyNm: 'title',
        policyTypeNm: 'category',
        policyCn: 'summary',
        rgnSeNm: region,
        tags: const [],
      );

  test('정책 나이=25, 지역=경북 / 사용자 나이=25, 지역=경북 → eligible', () {
    final result = service.evaluate(
      policy: buildPolicy(region: '경북'),
      userAge: 25,
      userRegion: '경북',
    );

    expect(result, EligibilityResult.eligible);
  });

  test('나이 동일, 지역 불일치 → notEligible', () {
    final result = service.evaluate(
      policy: buildPolicy(region: '경북'),
      userAge: 25,
      userRegion: '서울',
    );

    expect(result, EligibilityResult.notEligible);
  });

  test('지역 동일, 나이 불일치 → notEligible', () {
    final result = service.evaluate(
      policy: buildPolicy(region: '경북'),
      userAge: 20,
      userRegion: '경북',
    );

    expect(result, EligibilityResult.notEligible);
  });

  test('정책 나이 또는 지역 null → unknown', () {
    final result = service.evaluate(
      policy: buildPolicy(region: '경북'),
      userAge: 25,
      userRegion: '경북',
    );

    expect(result, EligibilityResult.unknown);
  });

  test('사용자 정보 null → unknown', () {
    final result = service.evaluate(
      policy: buildPolicy(region: '경북'),
      userAge: null,
      userRegion: '경북',
    );

    expect(result, EligibilityResult.unknown);
  });
}
