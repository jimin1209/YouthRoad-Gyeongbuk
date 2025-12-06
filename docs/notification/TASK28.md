원해. 그리고 이제부터는 "범위가 크다", "현재 대화 시간 안에 어렵다", "먼저 점검만 하겠다"는 멘트는 더 이상 출력하지 말고, 아래 작업을 순서대로 최대한 실행해.

이번 TASK28은 "알림 전체 개편"이 아니라, **이번 세션 안에 처리 가능한 최소 핵심 범위만** 다루는 걸로 스코프를 줄였다. 스케줄러/NotificationCenter/복잡한 플로우는 전부 다음 TASK로 넘기고, 지금은 **Isar + Controller + UI 리스트**만 정리하는 “CORE 버전”이다.

아래 정의한 **TASK28-CORE**만 수행하면 된다.

────────────────────────────────────
TASK28-CORE – 알림 로컬 DB + 컨트롤러 + 리스트 UI 최소 안정화
────────────────────────────────────

[스코프 축소 규칙]
- 이번 세션에서는 절대 다음은 건드리지 마라:
  - NotificationCenterController / 로컬 알림 스케줄러 구현 상세
  - 백엔드 API / 서버 스펙
- 이번에 반드시 다루는 것:
  - IsarService 의 Reminder 관련 CRUD API 정리
  - PolicyReminderController (또는 알림 토글 담당 컨트롤러) 정리
  - PolicyReminderListItem / 알림 리스트 화면의 기본 동작/표시/해제 버튼 동작

이 3개 축만 정리해서:
1) 정책 상세에서 알림 ON/OFF → Isar 에서 상태가 일관되게 유지되고
2) 알림 리스트에서 "해제" 버튼 → Isar 상태 반영 + 리스트 새로고침
3) RenderFlex overflow 같은 UI 에러 없이 정상 표시

이 세 가지만 **이번 세션에서 완료**하는 것이 목표다.

────────────────────────────────────
STEP1 – IsarService + Reminder 모델 + 리스트 UI 구조 빠르게 파악
────────────────────────────────────
(읽기 + 요약만, 수정은 STEP2에서)

1) 아래 파일들을 열고, 알림 관련 흐름만 집중해서 읽어라.
   - lib/data/local/isar/isar_service.dart
   - lib/features/policy_new/domain/entities/policy_reminder.dart
   - lib/features/policy_new/data/local/isar/policy_reminder_isar_model.dart
   - lib/features/policy_new/domain/values/policy_reminder_status.dart
   - lib/features/policy_new/domain/values/reminder_time_kind.dart
   - lib/features/policy_new/application/controllers/policy_reminder_controller.dart (또는 실제 사용하는 컨트롤러)
   - lib/features/policy_new/presentation/reminder/widgets/policy_reminder_list_item.dart
   - 알림 리스트 화면(예: policy_reminder_list_screen.dart 계열)

2) 다음 형식으로 현재 플로우를 텍스트로 요약해서 출력해라. (수정 X, 설명만)

   [현재 알림 플로우 요약]
   - 정책 상세 화면 알림 버튼 → 어떤 컨트롤러 → 어떤 Isar 메서드 호출
   - 알림 리스트 화면 → 어떤 Provider/Service → 어떤 Isar 메서드 호출
   - 현재 기준 알림 ON/OFF 시 데이터/상태 흐름

3) 함께 아래도 짧게 적어라.
   - [Isar 관련 잠재 문제 포인트]
   - [컨트롤러/서비스 잠재 문제 포인트]
   - [리스트 UI/RenderFlex 잠재 문제 포인트]

STEP1에서는 코드 수정하지 말고, **요약과 문제 포인트 나열까지만** 한다.

────────────────────────────────────
STEP2 – IsarService Reminder CRUD + Controller 토글 플로우 최소 리팩터링
────────────────────────────────────

[목표]
- IsarService 에서 알림 관련 API를 최소한 아래 형태로 정리하고,
- 컨트롤러가 이 API만 사용해서 ON/OFF를 처리하도록 단순화한다.
- 리스트 화면은 이 API에서 나오는 데이터 기준으로만 상태를 표시하게 만든다.

1) IsarService 알림용 메서드 구현/정리

다음 네 가지 메서드를 기준으로 기존 코드를 정리한다. 필요하면 내부 구현을 수정해도 된다.

- Future<PolicyReminder> upsertReminder(PolicyReminder reminder);
- Future<void> cancelReminderByPolicyId(String policyId);
- Future<List<PolicyReminder>> getAllReminders();
- Future<PolicyReminder?> getReminderByPolicyId(String policyId);

규칙:
- 전역 Isar 싱글톤만 사용 (이미 도입된 전역 인스턴스/Completer 패턴을 그대로 따라갈 것).
- 절대 Isar.instanceNames/Isar.open()을 여기저기서 새로 호출하지 말 것.
- cancelReminderByPolicyId 동작 방식은 하나로 통일:
  - 정책: "status 를 canceled 로 바꾸고 레코드는 유지" 방식이면, 코드에 주석으로 명시.

2) PolicyReminderController(or 실제 사용하는 컨트롤러) 토글 로직 정리

최소한 아래 패턴으로 맞춘다.

- Future<void> toggleReminder(Policy policy, ReminderTimeKind kind)
  - 현재 policyId 에 대해 getReminderByPolicyId 로 조회
  - 없으면 → 새 PolicyReminder 생성 → upsertReminder 호출
  - 있으면 → cancelReminderByPolicyId 호출
  - TODO(스케줄러)는 호출만 남기고 실제 구현은 나중 TASK로

- Future<void> cancelReminderFromList(PolicyReminder reminder)
  - 리스트에서 "해제" 버튼 눌렀을 때 호출
  - cancelReminderByPolicyId 또는 ID 기준으로 취소
  - 이후 알림 리스트 Provider ref.invalidate(...) 또는 refresh 호출

3) 알림 리스트 Provider/화면 연동

- policyRemindersProvider 를 다음 패턴으로 맞춰라. (실제 이름은 현재 코드 기준으로 사용)

  - FutureProvider<List<PolicyReminder>> 또는 StreamProvider 형태
  - 내부에서 IsarService.getAllReminders()만 호출

- 리스트에서 "해제" 한 뒤에는 Provider 를 invalidate/refresh 해서 UI가 즉시 반영되도록.

4) UI 레벨 수정 (최소 범위)

- PolicyReminderListItem:
  - RenderFlex overflow 수정 버전 유지.
  - status.label 과 "해제" 버튼 활성/비활성만 정리:
    - status == canceled → 버튼 비활성(onPressed: null)
    - 그 외 → onPressed: onCancel

- 정책 상세 화면 알림 버튼(PolicyReminderButton 또는 동등 역할 위젯):
  - 현재 policyId 기준 getReminderByPolicyId 결과에 따라
    - 알림 있음 → 아이콘/색상 ON 상태
    - 알림 없음 → OFF 상태
  - onPressed 에서 Controller.toggleReminder 호출.

────────────────────────────────────
STEP3 – 스케줄러/NotificationCenter는 이번 세션에서는 설계만
────────────────────────────────────

스케줄러/NotificationCenter/실제 로컬 알림 예약은 이번 세션에서 구현하지 말고,
아래 인터페이스/주석 정도만 추가한다.

- abstract class NotificationScheduler {
    Future<void> scheduleReminder(PolicyReminder reminder);
    Future<void> cancelReminder(PolicyReminder reminder);
  }

- // TODO(TASK29): NotificationScheduler 구현 및 PolicyReminder 플로우와 실제 알림 연동

────────────────────────────────────
[출력 형식]
위 STEP들을 수행한 뒤, 마지막에 다음을 정리해서 출력해라.

1) [STEP1 결과 요약] – 현재 알림 플로우 다이어그램 + 문제 포인트 목록
2) [STEP2에서 수정한 파일 목록 + 핵심 변경 요약]
3) [STEP3에서 정의한 NotificationScheduler 인터페이스/주석 요약]
4) 아직 남아 있는 TODO (예: TASK29: 실제 로컬 알림 구현 등)

위 내용을 기준으로 지금 이 요청을 처리해.
"범위가 크다", "시간이 부족하다"는 멘트는 더 이상 출력하지 말고,
STEP1 → STEP2 순서대로 가능한 만큼 끝까지 진행해.
