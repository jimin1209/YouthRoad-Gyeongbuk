TASK29 – 정책 알림 스케줄러(플러그인) 실제 동작 검증 및 실패 로그 정교화

[배경 / 전제]
- TASK28에서 PolicyReminder 도메인/Isar/Controller/알림 리스트 UI까지는 기본 동작이 정비되었다.
- 하지만 실제 로컬 알림 스케줄러(플러그인) 동작은
  - "정책 마감일 기준으로 올바른 시각에 푸시가 오는지"
  - "취소/변경 시 기존 알림이 잘 지워지는지"
  - "Locale/타임존/플러그인 오류를 어떻게 로깅/표시하는지"
  부분이 아직 충분히 검증되지 않았다.
- 과거에 `LocaleDataException: Locale data has not been initialized, call initializeDateFormatting(<locale>)` 와
  "Scheduled time already passed" 등 메시지도 있었기 때문에,
  스케줄러 호출 경로와 실패 로그를 한 번에 정리할 필요가 있다.

[목표]
1) 현재 사용 중인 알림 플러그인(예: flutter_local_notifications, android_alarm_manager 등)을 기준으로
   정책 알림 스케줄이 **실기기에서 정상 동작**하는지 전면 점검한다.
2) 실패 케이스(지난 시각, 권한 없음, 플러그인 오류, Locale/타임존 문제 등)에 대해
   - 내부 로그(개발자용)와
   - 사용자 피드백(스낵바/토스트 등)
   을 명확히 정리한다.
3) 알림 목록/정책 상세 화면을 동시에 열어두고 ON/OFF/취소를 반복하는 교차 시나리오에서도
   - DB/스케줄러/UI 상태가 꼬이지 않는지 검증한다.
4) 작업 후 `flutter analyze` 및 테스트(있다면 `flutter test`)를 실행해,
   알림 관련 변경으로 새 경고/에러가 생기지 않는지 확인한다.

────────────────────────────────────
[Scope]
────────────────────────────────────
1) 스케줄러/플러그인 레이어
   - NotificationGateway / NotificationScheduler / LocalNotificationService 등
   - 실제 알림 플러그인 wrapper 클래스
   - 플러그인 초기화 코드(main.dart / bootstrap / 플랫폼별 설정)

2) 알림 호출자
   - PolicyReminderService (createRemindersForPolicy, cancelReminder 등)
   - NotificationCenterController (사용자 수준 알림 센터 화면/설정)
   - 알림 ON/OFF/취소를 트리거하는 UI (정책 상세, 알림 리스트 화면)

3) 로깅/에러 처리
   - ErrorReporter / DebugLogCollector / Devtools 로그 인터페이스 등
   - 사용자-facing 메시지(SnackBar, Toast, 다이얼로그 등)

────────────────────────────────────
[선행 확인 사항]
────────────────────────────────────
1) 현재 프로젝트에서 사용하는 알림 플러그인/라이브러리 확인
   - `pubspec.yaml` 에서 notification 관련 패키지 확인:
     - 예: flutter_local_notifications, awesome_notifications, android_alarm_manager_plus 등
   - 해당 패키지를 래핑한 앱 내부 클래스:
     - NotificationGateway, LocalNotificationService, NotificationScheduler 등 명칭 검색.

2) 플랫폼 설정/초기화 점검
   - Android:
     - AndroidManifest.xml 에 권한 및 알림 채널/아이콘 설정 확인.
     - Application/Activity 레벨 초기화 코드 (필요한 경우).
   - iOS:
     - Info.plist 알림 권한 설명 키.
     - iOS 초기화/권한 요청 코드 여부.
   - Flutter:
     - main.dart / bootstrap.dart 에서 플러그인 초기화가 적절한 타이밍에 호출되는지 확인.

────────────────────────────────────
[세부 작업]
────────────────────────────────────
1) NotificationGateway / Scheduler 인터페이스 정리
   - 현재 사용 중인 게이트웨이/서비스의 public 메서드를 정리하고,
     정책 알림 플로우에서 사용하는 핵심 메서드를 확인한다:

     - Future<void> scheduleReminder(PolicyReminder reminder)
     - Future<void> cancelReminder(String reminderId 또는 PolicyReminder reminder)
     - (필요 시) Future<void> rescheduleReminder(...)

   - 이 메서드들이 PolicyReminderService / NotificationCenterController 에서
     언제, 어떤 파라미터로 호출되는지 호출 경로를 다이어그램 형식으로 주석/문서에 남긴다.

2) 시간 계산/Locale/타임존 처리 보완
   - schedule 시점 계산:
     - 마감일(DateTime deadline) + ReminderTimeKind(마감 하루 전/3일 전/7일 전/당일 등)를 사용해
       실제 스케줄 시각(DateTime scheduledAt)을 어떻게 계산하는지 점검.
     - 지난 시각일 경우:
       - 바로 예외를 던져 사용자에게 "이미 지난 시각입니다" 식으로 안내하거나,
       - schedule 호출을 생략하고 로그만 남기도록 정책 결정.
   - 타임존/Locale:
     - `scheduledAt.toLocal()` vs `toUtc()` 사용 위치 점검.
     - 필요 시 `initializeDateFormatting('ko_KR')` 호출 위치 추가:
       - 앱 전체 bootstrap 시점 1회만 실행되도록 구성.
   - "Scheduled time already passed" 와 같은 플러그인 레벨 에러를
     - 사전에 로직에서 걸러낼지,
     - catch 해서 사용자 피드백만 줄지 정책 결정 후 구현.

3) 실패 케이스 로깅/피드백 정리
   - NotificationGateway 내부에서 모든 schedule/cancel 호출을 try/catch 로 감싸고,
     다음과 같은 구분된 로그 구조를 만든다:

     - 원인 종류(enum 또는 상수):
       - invalidTime (과거 시각)
       - permissionDenied (알림 권한 없음)
       - pluginError (플러그인 예외)
       - unknown (기타)
     - 로그 내용:
       - 어떤 policyId / reminderId 였는지
       - requestedTime / now
       - 예외 메시지/스택(개발자용)

   - 사용자 피드백:
     - invalidTime:
       - "이미 지난 시각은 알림으로 등록할 수 없습니다." 등의 스낵바 메시지.
     - permissionDenied:
       - "알림 권한이 꺼져 있습니다. 설정에서 권한을 켜주세요."와 같이 안내,
       - 필요 시 설정 화면으로 이동하는 버튼 제공.
     - pluginError/unknown:
       - "알림 등록 중 문제가 발생했습니다. 잠시 후 다시 시도해주세요." 등 일반 메시지 +
         내부 로그에는 상세 정보 기록.

4) 알림 목록/상세 교차 시나리오 로직 점검
   - PolicyReminderService / NotificationCenterController 수준에서
     - 동일 reminderId 에 대해 schedule/cancel 이 중복 호출되더라도
       DB/스케줄러 상태가 꼬이지 않도록 방어 로직을 넣는다.
   - 예:
     - 취소 요청 시 해당 reminder 가 이미 DB/스케줄러에 없으면
       - 예외 대신 "id 없음" 정도만 로그로 남기고 조용히 무시.
     - ON/OFF rapid toggle 시에도 마지막 상태 기준으로만 남도록 처리.

5) flutter analyze / flutter test 실행
   - 작업 마무리 시점에 아래 명령 실행:

     - flutter analyze
     - flutter test   (테스트가 없다면 스킵 가능하나, 있으면 반드시 실행)

   - 분석/테스트 결과 중 새로 생긴 경고/에러가 있으면,
     - TASK29 범위 내에서 해결 가능하면 즉시 수정.
     - 아닐 경우, 별도 TODO/TASK 로 남기고 요약에 명시.

────────────────────────────────────
[실기기 테스트 시나리오]
────────────────────────────────────
(실제 Android 기기 기준, iOS는 환경 되면 동일 시나리오 반복)

1) 기본 알림 예약
   - 마감일이 2~3일 이상 남은 정책 선택.
   - "마감 하루 전" 옵션으로 알림 설정.
   - 앱을 완전히 종료한 뒤, 지정 시간에 실제 알림이 오는지 확인.
   - 여러 정책에 대해 중복 알림 설정, 알림이 각각 잘 오는지 확인.

2) 즉시/과거 시각 예외
   - 이미 마감일이 지난 정책 또는
     - "마감 당일"인데 실제 시간은 마감시각 이후인 경우.
   - 알림 설정 시:
     - 사용자에게 적절한 안내(이미 지난 시각) 표시,
     - 내부 로깅이 남는지 확인.

3) 취소/변경
   - 동일 정책에 대해 여러 옵션(1일 전, 3일 전)을 번갈아 설정/취소.
   - 알림 목록과 정책 상세의 상태가 항상 일치하는지 확인.
   - 취소 후 실제 알림이 더 이상 오지 않는지 실기기에서 검증.

4) 목록/상세 동시 열기 교차 시나리오
   - A. 정책 상세 화면 + B. 알림 목록 화면을 번갈아 열어놓고
     - 상세에서 알림 ON → 목록 확인
     - 목록에서 취소 → 상세 재진입
     - 상세에서 또 ON/OFF 반복
   - 이 과정에서
     - 중복 알림,
     - 상태 꼬임,
     - 예외 로그 발생 여부를 확인.

5) 권한 거부 시나리오
   - 디바이스 설정에서 앱 알림 권한을 끈 뒤,
   - 알림 설정 시도:
     - 사용자 안내 메시지와 내부 로그가 정상적으로 동작하는지 확인.

────────────────────────────────────
[Acceptance Criteria]
────────────────────────────────────
1) 실기기에서:
   - 정상적인 조건(미래 시각)으로 설정한 알림은 지정 시각에 실제로 도착한다.
   - 취소/변경 후에는 이전에 예약된 알림이 더 이상 오지 않는다.

2) 에러/예외 상황:
   - 과거 시각, 권한 없음, 플러그인 예외 등에서
     - 앱이 크래시하지 않고,
     - 사용자에게 명확한 메시지가 표시되며,
     - Devtools/로그에는 원인을 파악할 수 있는 정보가 남는다.

3) 알림 목록/상세 동시 사용 시
   - ON/OFF/취소를 반복해도
     - DB(PolicyReminder), 목록 UI, 상세 화면 상태가 서로 불일치하지 않는다.

4) flutter analyze / flutter test
   - 두 명령 실행 결과, 알림 관련 변경으로 인한 새로운 에러가 없어야 한다.
   - 남는 경고/문제는 요약에 명시하고 필요 시 후속 TASK로 분리한다.
