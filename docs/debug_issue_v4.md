```text
당신은 Flutter + Riverpod + Dio/Retrofit + Unity 연동 앱(YouthRoad-Gyeongbuk)의 AI 페어 프로그래머입니다.
현재 Provider 디버그 패널, Network 디버그 패널, Unity 디버그 패널, Log 패널에 여러 오류와 UI 문제가 있습니다.
아래 요구사항을 순서대로 모두 구현·수정해 주세요.

========================================================
공통 전제
========================================================
- 릴리즈 빌드에서는 기술적인 에러/스택트레이스를 절대 노출하지 않습니다.
- 디버그 빌드(kDebugMode)에서는 디버깅이 편하도록 정보를 명확하게 제공합니다.
- 기존 구조(Provider, Riverpod, DebugOverlay 등)는 유지하되, 에러 처리·UI를 개선합니다.

========================================================
TASK 1 – PolicyList Provider 안정화 + 사용자용 에러 UI
========================================================
상황:
- AutoDisposeAsyncNotifierProviderImpl<PolicyListNotifier, List<Policy>> 실패 시
  거대한 파란 에러화면 + bottom overflow 발생.

목표:
1) Provider 실패 시 앱 크래시를 방지합니다.
2) 실제 사용자 화면에는 간단한 메시지 + 재시도 버튼만 표시합니다.
3) 상세 에러·스택트레이스는 디버그 패널에서만 확인하도록 합니다.

구체 작업:
1. 코드베이스에서 "PolicyListNotifier" 를 검색하여 AutoDisposeAsyncNotifier<List<Policy>> 정의 파일을 엽니다.
2. build() 또는 정책 목록을 로드하는 메서드에 try/catch 를 추가합니다.
   - ref.read(...) 로 PolicyRepository 를 읽고 실제 API 를 호출합니다.
   - 예외 발생 시:
     - logger(이미 사용 중인 로거)를 이용해 에러와 stacktrace 를 기록합니다.
     - AsyncValue.error 에는 "정책을 불러오지 못했습니다." 와 같은 간단한 사용자 메시지만 저장합니다.
       (DioError, SocketException 등의 상세 타입은 UI로 올리지 말고 로그에만 남깁니다.)
3. 정책 목록 v2 화면에서 PolicyList Provider 를 구독하는 위젯을 찾습니다.
   - "policyListNotifierProvider" 또는 유사 이름으로 검색합니다.
   - AsyncValue.when / maybeWhen 사용 시:
     - data 상태: 기존처럼 정책 카드 리스트를 렌더링합니다.
     - loading 상태: 로딩 인디케이터 또는 스켈레톤을 표시합니다.
     - error 상태:
       - 기존처럼 exception 전문을 Text 로 출력하지 않습니다.
       - GlobalErrorView(또는 동일 역할의 공통 에러 위젯)를 사용하여
         "정책을 불러오지 못했습니다. 다시 시도해 주세요." 메시지와 "다시 시도" 버튼을 보여줍니다.
       - "다시 시도" 버튼은 ref.invalidate(policyListNotifierProvider) 또는 해당 provider 를 refresh 하는 방식으로 구현합니다.
4. 이 사용자용 에러 UI는 릴리즈 빌드에서도 그대로 사용 가능해야 하며,
   기술적인 타입명/스택트레이스는 절대 사용자 화면에 직접 노출되지 않아야 합니다.

========================================================
TASK 2 – Provider DebugOverlay 개선 (리스트 + 클릭 시 상세 보기)
========================================================
상황:
- 현재 Provider 에러는 파란 전체화면에 거대 폰트로 출력되어 가독성이 떨어집니다.
- 텍스트가 화면을 넘쳐 overflow 가 발생하며, 디버깅 효율이 낮습니다.
- 원하는 동작: Provider 목록을 아이템화하여 요약으로 보여주고,
  각 item 을 클릭하면 전체 에러와 스택트레이스를 스크롤 가능한 패널에서 한 번에 보이게 합니다.

목표:
1) Provider 이상 상태를 요약 형태의 리스트로 표시합니다.
2) Provider item 클릭 시 해당 Provider 의 전체 에러 및 스택트레이스를 표시합니다.
3) 상세 화면은 스크롤 가능해야 하고 overflow 가 없어야 합니다.
4) 이 기능은 debug 모드(kDebugMode) 전용입니다.

구체 작업:
1. "DebugOverlay" 또는 "Debug Overlay" 문자열을 검색하여 DebugOverlay 구현 파일을 찾습니다.
2. Provider 탭의 UI를 확인합니다. 현재 Provider 상태를 열거하는 부분에서:
   - Provider 이름, 상태(LOADING / DATA / ERROR), 메시지 등을 수집하는 로직을 파악합니다.
3. Provider 탭 본문을 다음 구조로 수정합니다.
   - ListView.builder 를 사용하여 각 Provider 상태를 한 줄 아이템으로 렌더링합니다.
     - 각 item 은 다음 정보를 표시합니다:
       - Provider 이름 (짧게)
       - 현재 상태 (LOADING / DATA / ERROR)
       - ERROR 인 경우 에러 메시지의 첫 1~2줄(80~100자 정도)만 미리보기로 표시
4. 각 item 의 onTap 에서 상세 패널을 띄웁니다.
   - showModalBottomSheet 또는 showDialog 를 사용합니다.
   - 상세 패널 구조 예시는 다음과 같이 구현합니다(코드 스타일만 참고):

     SafeArea(
       child: Scaffold(
         appBar: AppBar(title: Text(providerName)),
         body: SingleChildScrollView(
           padding: EdgeInsets.all(16),
           child: Column(
             crossAxisAlignment: CrossAxisAlignment.start,
             children: [
               Text(
                 'State: ERROR', // 실제 상태에 맞게 표시
                 style: TextStyle(fontWeight: FontWeight.bold),
               ),
               SizedBox(height: 8),
               SelectableText(      // 복사하기 쉽게 SelectableText 사용을 권장
                 fullErrorMessage,  // Exception 전문 + stacktrace 등 전체 문자열
                 style: TextStyle(fontSize: 14),
               ),
             ],
           ),
         ),
       ),
     )

   - fullErrorMessage 는 Provider 에서 잡힌 예외와 스택트레이스를 문자열로 합친 값입니다.
5. 기존 파란 대형 에러 화면(Provider 타입/메시지를 거대 폰트로 표시하는 전면 뷰)은:
   - 더 이상 직접 사용하지 않거나,
   - 위와 같은 “상세 보기 패널” 형태로 대체하고 일반적인 텍스트 크기(14~18pt)로 축소합니다.
6. Provider 디버그 기능 전체(Provider 탭·상세 보기)는 kDebugMode 조건문으로 감싸
   릴리즈 빌드에서는 표시되지 않도록 합니다.

========================================================
TASK 3 – Network 디버그 패널 Material 에러 수정
========================================================
상황:
- DebugOverlay → Network 탭에서 다음 Flutter 에러가 발생합니다.
  "No Material widget found. ChoiceChip requires a Material ancestor"

목표:
1) Network 탭 내 ChoiceChip/FilterChip/ActionChip 위에 항상 Material 조상이 존재하도록 합니다.
2) DebugOverlay 의 모든 탭(Provider / Network / Unity)에서 런타임 에러 없이 동작하도록 합니다.

구체 작업:
1. DebugOverlay 파일에서 Network 탭 구현 부분을 찾습니다.
   - ChoiceChip, FilterChip, ActionChip 등을 사용하는 위젯을 확인합니다.
2. Network 탭의 최상단을 Material 로 감쌉니다. 예:

   Widget buildNetworkTab(BuildContext context) {
     return Material(
       color: Colors.transparent, // 기존 배경 유지
       child: /* 기존 network 디버그 UI (ChoiceChip 등) */,
     );
   }

3. 필요하다면 DebugOverlay 전체를 Material + Scaffold 구조로 감싸도 됩니다.
   중요한 점은 ChoiceChip 계열 위젯 위에 Material 조상 위젯이 반드시 존재해야 한다는 것입니다.
4. 앱을 실행하고 DebugOverlay 를 연 뒤,
   Provider / Network / Unity 탭을 모두 오가며 에러가 발생하지 않는지 확인합니다.

========================================================
TASK 4 – Unity 디버그 탭 플레이스홀더 정리
========================================================
상황:
- Unity 탭이 현재 "No Unity events yet." 만 표시되어,
  사용자/개발자가 보기엔 마치 오류처럼 느껴질 수 있습니다.

목표:
- "아직 이벤트가 없을 뿐, 정상 상태" 라는 것을 명확히 전달하는 플레이스홀더로 변경합니다.

구체 작업:
1. Unity 탭 UI 를 다음과 같은 구조로 수정합니다.

   Column(
     mainAxisAlignment: MainAxisAlignment.center,
     crossAxisAlignment: CrossAxisAlignment.center,
     children: [
       Text(
         'No Unity events yet.',
         style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
       ),
       SizedBox(height: 8),
       Text(
         '이 탭은 Unity 디버그용입니다.\n아직 수집된 Unity 이벤트가 없습니다.',
         textAlign: TextAlign.center,
       ),
     ],
   )

2. 색상과 레이아웃은 “정상 상태의 안내”처럼 보이도록 설정하고,
   경고 느낌의 강렬한 색상은 피합니다.

========================================================
TASK 5 – Debug 모드 Log 패널 개선 (로그 리스트 + 상세 보기)
========================================================
상황:
- 현재 디버그 모드에서 로그가 한 화면에 길게 출력되어
  한눈에 구조를 파악하기 어렵고 스크롤도 불편합니다.
- 원하는 동작:
  각 로그를 “한 줄짜리 아이템”으로 요약해서 리스트로 보여주고,
  아이템을 클릭하면 해당 로그 전체 내용을 한 번에 확인할 수 있는 상세 화면(또는 바텀시트)을 띄우고 싶습니다.

목표:
1) 디버그 모드에서 확인하는 Log 뷰(또는 새 Log 탭)를
   “로그 리스트 + 상세 보기” 구조로 변경합니다.
2) 각 로그는 요약 텍스트만 리스트에 표시합니다.
3) 아이템을 탭하면 전체 로그 문자열을 스크롤 가능한 상세 패널로 표시합니다.
4) 로그는 시간순으로 정렬되고, 최신 로그가 상단에 보이도록 합니다.
5) 이 기능은 kDebugMode 에서만 활성화합니다.

구체 작업:
1. 코드베이스에서 DebugOverlay 또는 로그 관련 위젯을 검색합니다.
   - "DebugOverlay", "Log", "Logger" 등의 키워드를 사용합니다.
   - 별도의 Log 탭이 없다면, DebugOverlay 에 "Log" 탭을 새로 추가해도 됩니다.

2. 로그 수집 방식 정의:
   - 이미 사용 중인 logger(예: logger, talker, debugPrint override 등)가 있으면,
     해당 logger 의 출력 문자열을 in-memory 리스트에 저장하도록 합니다.
   - 예시로 다음과 같은 모델을 정의합니다.

     class DebugLogEntry {
       final DateTime timestamp;
       final String message;
       DebugLogEntry(this.timestamp, this.message);
     }

   - 새 로그가 발생할 때마다 `List<DebugLogEntry>` 에 추가하고,
     최대 개수(예: 500개)를 넘으면 오래된 로그부터 제거합니다.
   - 이 리스트는 Provider 또는 전역 싱글톤으로 관리해도 됩니다.

3. Log 탭(혹은 기존 로그 뷰)의 UI를 다음 구조로 변경합니다.
   - 전체를 ListView.builder 로 렌더링합니다.
   - 각 item 은 다음 정보를 간단히 보여줍니다.
     - 시각 (HH:mm:ss)
     - 메시지 첫 줄 또는 앞부분(80~100자까지 잘라서)
   - 예시는 다음과 같습니다.

     ListView.builder(
       itemCount: logs.length,
       itemBuilder: (context, index) {
         final log = logs[index];
         final preview = log.message.split('\n').first;
         return ListTile(
           title: Text(
             preview,
             maxLines: 1,
             overflow: TextOverflow.ellipsis,
           ),
           subtitle: Text(
             log.timestamp.toLocal().toString(),
             style: TextStyle(fontSize: 12),
           ),
           onTap: () {
             // 상세 보기 호출
           },
         );
       },
     )

4. item 탭 시 상세 로그 보기 구현:
   - showModalBottomSheet 또는 showDialog 를 사용해 상세 패널을 띄웁니다.
   - 상세 패널 구조 예시는 아래와 같습니다.

     void showLogDetail(BuildContext context, DebugLogEntry log) {
       showModalBottomSheet(
         context: context,
         isScrollControlled: true,
         builder: (context) {
           return SafeArea(
             child: DraggableScrollableSheet(
               expand: false,
               initialChildSize: 0.7,
               minChildSize: 0.4,
               maxChildSize: 0.95,
               builder: (context, scrollController) {
                 return Scaffold(
                   appBar: AppBar(
                     title: const Text('Log Detail'),
                   ),
                   body: SingleChildScrollView(
                     controller: scrollController,
                     padding: const EdgeInsets.all(16),
                     child: Column(
                       crossAxisAlignment: CrossAxisAlignment.start,
                       children: [
                         Text(
                           log.timestamp.toLocal().toString(),
                           style: const TextStyle(fontWeight: FontWeight.bold),
                         ),
                         const SizedBox(height: 8),
                         SelectableText(
                           log.message,
                           style: const TextStyle(fontSize: 14),
                         ),
                       ],
                     ),
                   ),
                 );
               },
             ),
           );
         },
       );
     }

   - 메시지는 SelectableText 로 두어 복사하기 쉽게 합니다.
   - 긴 로그도 스크롤로 전부 볼 수 있어야 합니다.

5. 로그 정렬:
   - logs 리스트는 최신 로그가 맨 앞에 오도록 관리하거나,
     ListView.builder 에서 logs.reversed 를 사용할 수 있습니다.
   - 최신 로그가 화면 상단에 보이도록 구현합니다.

6. kDebugMode 적용:
   - 전체 로그 수집 로직과 Log 탭/버튼 표시는 kDebugMode 조건문으로 감싸
     릴리즈 빌드에서는 이 기능이 전혀 보이지 않도록 합니다.

========================================================
Acceptance Criteria (최종 결과)
========================================================
- [ ] 정책 PolicyList Provider 실패 시 앱이 크래시하지 않는다.
- [ ] 실제 사용자 화면에는 단순 에러 메시지 + 재시도 버튼만 보인다.
- [ ] Provider 디버그 패널에서 Provider 목록이 요약 정보로 나열되고,
      item 클릭 시 전체 에러/스택트레이스가 스크롤 가능한 상세 패널로 보인다.
- [ ] Provider 디버그 패널에서 더 이상 텍스트 overflow (BOTTOM OVERFLOWED) 문제가 발생하지 않는다.
- [ ] DebugOverlay → Network 탭에서 Material 관련 에러("No Material widget found")가 발생하지 않는다.
- [ ] Unity 탭은 "No Unity events yet."와 함께 정상적인 플레이스홀더 설명을 표시하고, 별다른 에러 없이 동작한다.
- [ ] 디버그 모드 Log 패널이 “로그 리스트 + 상세 보기” 구조로 동작하며,
      각 로그를 한 줄 요약 아이템으로 보고 클릭 시 전체 내용을 확인할 수 있다.
- [ ] 최신 로그가 로그 리스트 상단에 보인다.
- [ ] 릴리즈 빌드에서는 디버깅용 상세 에러 정보 및 Log 패널 기능이 전혀 노출되지 않는다.
```