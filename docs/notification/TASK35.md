TASK35 – 정책 비교 화면 핀치 줌(확대/축소) 지원

[배경]
- 정책 비교 화면에서 텍스트/테이블이 길고 정보량이 많아,
  한 화면에 모두 보기 어렵고 글자가 작게 느껴진다.
- 현재는 두 손가락 핀치 제스처(줌 인/줌 아웃)가 전혀 동작하지 않는다.

[목표]
- 정책 비교 화면의 "비교 테이블 영역"에 대해
  두 손가락 핀치 제스처로 확대/축소를 지원한다.
- 상단 앱바/하단 탭 바는 확대/축소 대상에서 제외하고,
  테이블/내용 부분만 확대/축소되도록 구현한다.

[수정 후보 파일]
- 비교 화면 본문:
  - lib/features/policy_new/presentation/compare/policy_compare_screen.dart
    또는 유사 파일 (정확한 비교 화면 위젯 파일 기준으로 적용)
- 필요 시 비교 테이블 전용 위젯:
  - lib/features/policy_new/presentation/compare/widgets/**_compare_table.dart 등

[구현 방향]

1) 비교 테이블 영역 분리
   - 현재 비교 화면에서 "하이라이트 분석/요약/진행 상태/자격/혜택/링크…" 등
     행렬 형태로 렌더링되는 본문 영역을 하나의 Widget(예: CompareContentView)으로 묶는다.
   - 이 본문 위젯을 InteractiveViewer의 child로 사용한다.

2) InteractiveViewer 적용
   - 비교 화면 body 구조 예시:

     - Scaffold(
         appBar: ...,
         body: Column(
           children: [
             // (옵션) 상단 정책 카드 요약 등 고정 영역
             Expanded(
               child: InteractiveViewer(
                 minScale: 1.0,
                 maxScale: 2.5,        // 필요 시 3.0까지 허용
                 boundaryMargin: EdgeInsets.all(32),
                 clipBehavior: Clip.none,
                 child: SingleChildScrollView(
                   scrollDirection: Axis.vertical,
                   child: SingleChildScrollView(
                     scrollDirection: Axis.horizontal,
                     child: CompareContentView(...),
                   ),
                 ),
               ),
             ),
           ],
         ),
       );

   - 핵심 포인트:
     - InteractiveViewer 안쪽에 세로/가로 스크롤을 모두 허용하기 위해
       중첩 SingleChildScrollView 사용(세로 + 가로).
     - constrained / boundaryMargin / clipBehavior 설정으로
       확대 시 잘리지 않도록 조정한다.

3) 제스처/스크롤 충돌 방지
   - InteractiveViewer의 기본 동작은 핀치 제스처를 우선 처리하고,
     일반 1-포인터 드래그는 내부 child(ScrollView)로 전달된다.
   - 실제 동작에서 세로 스크롤이 지나치게 둔해지면:
     - minScale 1.0일 때는 스크롤이 자연스럽게 되도록
       child 쪽 스크롤 가능 영역을 충분히 준다(패딩/여백 조정).
   - 필요 시 panEnabled 옵션 검토:
     - panEnabled: true 유지 (기본값)로 두고,
       별도 GestureDetector는 추가하지 않는다.

4) 레이아웃/오버플로우 확인
   - 확대 시 비교 테이블이 화면 밖으로 나가도
     스크롤로 탐색 가능해야 하며,
     RenderFlex overflow 경고가 발생하지 않아야 한다.
   - 테스트 해상도:
     - FHD(1080x1920) 세로 기준 안드로이드 실기기에서 검증.

[Acceptance Criteria]

1) 기능
   - 비교 화면 진입 후, 비교 테이블 영역에서
     두 손가락 핀치 인/아웃 제스처로 콘텐츠가 확대/축소된다.
   - minScale에서 원본 크기, maxScale에서 충분히 크게 보인다(약 2.0~2.5배).
   - 확대 상태에서도 세로/가로 스크롤로 모든 행/열을 살펴볼 수 있다.

2) 레이아웃/사용성
   - 상단 앱바, 하단 네비게이션 바, 탭 바 등은 확대/축소 대상이 아니다.
   - 확대/축소/스크롤 과정에서 RenderFlex overflow, yellow-black stripe 등의
     레이아웃 에러가 발생하지 않는다.
   - 비교 대상 정책 수가 많아도(예: 4개 이상) 테이블이 정상적으로 확대/축소된다.

3) 안정성
   - 다른 탭(추천/탐색/보관함)에서의 스크롤/제스처 동작에는 영향이 없다.
   - flutter analyze 기준 새 경고/에러가 추가되지 않는다.
