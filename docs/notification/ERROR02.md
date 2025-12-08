# ERROR02

## 증상
- 빌드 시 `lib/features/policy_new/presentation/detail/widgets/policy_action_bar.dart`에서 `app_text.dart`를 찾지 못하고, 동일 파일에서 `toggleReminder` 미정의, `AppText` 미정의 오류 발생.
- `lib/features/policy_new/presentation/explore/policy_explore_screen.dart`에서는 `ref.listen` 반환값을 변수에 넣으려다 `void` 타입 오류가 발생.

## 원인
1. `policy_action_bar.dart`의 `app_text.dart` import 경로가 실제 위치(`lib/ui/theme/app_text.dart`)보다 한 단계 덜 올라가 있어 `lib/features/ui/theme`를 찾으려 함.
2. `toggleReminder` 호출 대상인 `PolicyActionController`에 해당 메서드가 존재하지 않아 UI 코드가 컴파일되지 않음.
3. Riverpod 2.x에서 `WidgetRef.listen`은 `void`를 반환하는데, 이를 `_regionSubscription`에 대입하려 하여 타입 불일치가 발생함.

## 해결 방법
1. `policy_action_bar.dart`의 import 경로를 `import '../../../../../ui/theme/app_text.dart';`로 수정한다.
2. `PolicyActionController`에 알림 토글용 헬퍼를 추가하거나, UI에서 `setReminder`/`cancelReminder` 등 기존 공개 메서드로 대체한다.
   - 예) `toggleReminder`를 추가해 리마인더가 이미 존재하면 `cancelReminder()`, 아니면 `setReminder(policy, 기본옵션)`을 호출하도록 연결.
3. `policy_explore_screen.dart`에서는 `ref.listenManual`을 사용해 `ProviderSubscription`을 받아 해제하거나, 반환값을 사용하지 않는다면 단순히 `ref.listen` 호출만 두고 `_regionSubscription` 필드를 제거한다.

## 체크리스트
- 위 3가지 수정 후 `flutter build` 또는 `flutter test`가 경로/타입 오류 없이 통과하는지 확인한다.
