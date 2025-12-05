TASK_WEB_001 — Flutter Web 빌드시 Isar(로컬 DB) 완전 비활성화 + Stub 적용

[목표]
- Web(JS) 타겟에서 Isar 관련 g.dart에서 발생하는 
  "The integer literal ... can't be represented exactly in JavaScript" 에러를 제거한다.
- 모바일/데스크톱(Windows/Linux/macOS/Android/iOS)에서는 현재 Isar 동작을 유지한다.
- Web에서는 Isar를 전혀 사용하지 않고, 대신 동일한 API 시그니처를 가진 Stub 구현을 사용한다.
- Domain / Application / UI 레이어의 타입/인터페이스를 변경하지 않는다.

────────────────────────────────────────
1. IsarService API 분석
────────────────────────────────────────
1-1. 파일 위치를 찾는다:
  - lib/data/local/isar/isar_service.dart
  - 또는 프로젝트 내에서 "class IsarService"를 global 검색

1-2. IsarService의 "공개 API" 목록을 정리한다.
  - public constructor들
  - public getter / method들 (예: `Future<Isar> get instance`, `clearAll()`, 등)
  - 이 API의 시그니처(파라미터/리턴 타입)를 정확히 기록해둔다.

1-3. 이 API를 사용하는 모든 호출 지점을 전역 검색으로 파악한다.
  - "IsarService(" / "isarService" / "isar_service.dart" import 를 기준으로 검색
  - 호출 패턴(예: `final isar = await isarService.instance;`)을 파악


────────────────────────────────────────
2. IsarService Stub 생성 (Web 전용)
────────────────────────────────────────
2-1. 다음 경로에 Stub 파일을 새로 만든다:
  - lib/data/local/isar/isar_service_stub.dart

2-2. Stub 파일에는 실제 Isar 패키지를 import 하지 않는다.
  - 즉, `import 'package:isar/isar.dart';` 금지
  - Web에서 Isar가 아예 컴파일되지 않도록 만드는 것이 목적이다.

2-3. isar_service_stub.dart의 구현은 다음 원칙을 따른다:
  - 2-3-1. IsarService 클래스의 public API 시그니처를 isar_service.dart와 100% 동일하게 맞춘다.
    - 생성자 이름, 메서드 이름, 파라미터 타입, 리턴 타입 일치
  - 2-3-2. 내부 구현은 Web 전용 dummy/no-op로 작성한다.
    - DB를 열지 않고, 파일 접근도 하지 않는다.
    - 리턴해야 하는 타입이 있으면:
      - Future<void> → `Future.value()`
      - Future<bool> → `Future.value(false)`
      - Future<List<T>> → `Future.value(const [])`
      - 기타 domain 타입 → null 허용이면 null, 아니면 기본값 혹은 throw UnsupportedError
    - 예시:
      - `Future<Isar> get instance` 같은 시그니처가 있으면,
        - Stub에서는 `Future<Never>` 또는 `Future.error(UnsupportedError('Isar is not supported on Web'))` 등으로 구현

예시 스켈레톤(실제 프로젝트에 맞게 수정할 것):

  // lib/data/local/isar/isar_service_stub.dart
  import 'dart:async';

  class IsarService {
    const IsarService();

    // 예: 실제 isar_service.dart에 이런 getter가 있다면
    // Future<Isar> get instance async { ... }
    //
    // Stub에서는 다음처럼 구현:
    Future<T> _unsupported<T>() async {
      throw UnsupportedError('Isar is not supported on Web');
    }

    Future<dynamic> get instance async => _unsupported();

    // 실제 IsarService에 정의된 나머지 public 메서드들도
    // 전부 시그니처만 동일하게 맞추고 내부는 _unsupported() 또는 no-op으로 구현
  }


────────────────────────────────────────
3. 조건부 import로 IsarService 교체
────────────────────────────────────────
3-1. 기존에 isar_service.dart를 import하는 모든 파일을 찾는다.
  - 예: 
    - lib/data/local/isar/isar_repository.dart
    - lib/features/policy_new/~~~ 등에서
      `import '../../data/local/isar/isar_service.dart';` 형태로 import 중인 곳

3-2. 각 파일에서 기존 import를 "조건부 import"로 교체한다.
  - 기존:
      import 'package:youth_road_app/data/local/isar/isar_service.dart';
    또는 상대 경로 import:
      import '../../data/local/isar/isar_service.dart';

  - 변경 (패키지 경로는 실제 구조에 맞게 수정할 것):

      import 'package:youth_road_app/data/local/isar/isar_service_stub.dart'
          if (dart.library.io) 'package:youth_road_app/data/local/isar/isar_service.dart';

    또는 상대 경로라면:

      import 'isar_service_stub.dart'
          if (dart.library.io) 'isar_service.dart';

  - 핵심:
    - dart.library.io 가 존재하는 환경(Android/iOS/Windows/Linux/macOS, 즉 Native/VM)에서는 기존 isar_service.dart를 사용
    - Web(dart.library.io가 없는 JS 환경)에서는 isar_service_stub.dart를 사용

3-3. isar_service.dart 자체는 수정하지 않는다.
  - Native 플랫폼용 동작은 현재 그대로 유지한다.


────────────────────────────────────────
4. Isar 모델/스키마 파일의 Web 컴파일 경로에서 제거
────────────────────────────────────────
4-1. lib/data/local/isar/policy_isar_model.dart, policy_isar_model.g.dart, policy_reminder_isar_model.dart, policy_reminder_isar_model.g.dart 등
     Isar 모델/스키마 파일들을 import하는 파일을 모두 검색한다.

4-2. 이들 import가 "직접적으로" Web 빌드에 포함되지 않도록 한다.
  - 원칙:
    - Web 타겟에서 Isar 관련 파일을 import하는 것은 무조건 isar_service.dart 경유로만 이루어지도록 만들고,
    - Web 타겟에서는 isar_service_stub.dart만 import 되도록 강제한다.

4-3. 만약 UI나 UseCase, Repository 코드 안에서 g.dart 파일을 직접 import 하고 있다면, 반드시 제거한다.
  - g.dart 파일은 오직 Isar 내부 구현 경로(예: isar_service.dart)에서만 import하도록 제한한다.
  - Web에서는 isar_service.dart가 import되지 않으므로 g.dart도 자동으로 Web 빌드에서 제외된다.


────────────────────────────────────────
5. Web 타겟에서 Isar 관련 로직 안전 처리
────────────────────────────────────────
5-1. Repository / UseCase 레이어에서 Isar를 사용하는 코드가 있을 경우, kIsWeb 여부에 따라 분기하는 방식을 도입할 수 있다.
  - import:
      import 'package:flutter/foundation.dart' show kIsWeb;

  - 예시:

      Future<List<Policy>> loadCachedPolicies() async {
        if (kIsWeb) {
          // Web에서는 로컬 캐시를 사용하지 않고, 항상 빈 리스트 혹은 원격만 사용
          return [];
        }

        final isar = await _isarService.instance;
        ...
      }

5-2. Web에서 반드시 동작해야 하는 기능(정책 목록 조회, 상세 보기 등)은
  - "원격 API 기반" 흐름만으로도 동작 가능하도록 설계되어 있으므로,
  - Isar 사용 실패가 전체 기능을 막지 않도록 try/catch 또는 위와 같은 kIsWeb 분기를 넣는다.


────────────────────────────────────────
6. 빌드 및 검증
────────────────────────────────────────
6-1. 코드 수정 후 build_runner를 재실행한다.
  - flutter pub run build_runner build --delete-conflicting-outputs

6-2. Native(Android/Windows/Linux 등) 빌드 확인:
  - flutter build linux --debug (또는 기존 사용하던 타겟)
  - Isar 관련 기능(정책 캐시, 알림 등)이 기존과 동일하게 동작해야 한다.

6-3. Web 빌드 확인:
  - flutter run -d web-server --web-port=8080 \
      --dart-define=YOUTH_API_KEY=... \
      --dart-define=KAKAO_MAP_API_KEY=... \
      --dart-define=CHAT_ENDPOINT=...

  - "The integer literal ... can't be represented exactly in JavaScript" 에러가 발생하지 않아야 한다.
  - Web에서 정책 목록/상세/검색/지도/챗봇 등의 기능이 Isar 없이도 정상 동작하는지 확인한다.
  - 캐시는 동작하지 않을 수 있으나, 기능 동작이 우선이다.

[완료 조건]
- flutter run -d web-server 가 JS 정수 리터럴 관련 에러 없이 성공적으로 실행된다.
- Web에서 YouthRoad 앱의 정책 탐색/상세/검색/지도/챗봇 화면이 정상적으로 보인다.
- Native 환경(Android/리눅스)에서는 기존 Isar 기반 캐시/로컬 저장소 기능이 유지된다.
