TASK_ID: KAKAO_MAP_FIX_V1

PURPOSE:
  - 카카오맵 마커 미노출, 반경 중심 오표시, 상세 카드 미반응 문제 해결
  - 지도 초기 진입 시 즉시 이해 가능한 상태 기반 정보 표시
  - GPS 위치 기반 처리와 데이터 노출 조건을 명확하게 통일

TARGET_FILES:
  - lib/features/map_v2/kakao_map_screen.dart
  - lib/features/map_v2/kakao_map_webview.dart
  - lib/features/map_v2/kakao_map_html_builder.dart
  - lib/features/policy_new/presentation/map/youth_center_map_provider.dart
  - lib/features/policy_new/data/mappers/youth_center_mapper.dart

REQUIRED IMPLEMENTATIONS:

 [1] 정확한 반경 기준 좌표 사용
   - 현재 GPS 좌표가 유효한 경우 지도 중심 = GPS 값 사용
   - 반경 원 및 마커 클러스터링 기준도 동일 좌표 사용
   - GPS 최신 좌표는 build() 시 단 한 번만 초기화 후
     버튼 클릭 시 갱신하도록 분리

 [2] 지도 초기 상태 로딩 플로우 확립
   Flow:
     1) 위치 요청 완료
     2) 지도 영역 계산
     3) 반경 원 생성
     4) 해당 반경 내 센터/정책 조회 후 마커 표시
     5) 마커 탭 시 bottom sheet 표시

   Manifestation rules:
     - 위치 loading 상태에서는 지도에 “현재 위치 확인중...” overlay 표준화
     - GPS 실패 시 fallback 지역을 경북 중심 좌표로 지정

 [3] 마커 노출 조건 강제
   - 센터 데이터 구조 내 좌표는 geocoded_lat, geocoded_lng 사용
   - null/0인 좌표는 마커 생성 제외
   - HTML/JS 쪽에서 center_marker_list 에 push 되는 포맷은 아래로 통일:
       { lat: number, lng: number, id: string, label: string }
   - center_marker_list는 webview evaluateJavascript 기반으로 삽입

 [4] 마커 탭 → 상세 카드 호출 동작 단일화
   Rules:
     - JS에서 마커 터치 시 postMessage 호출
       message.type = "centerMarkerClick"
       message.payload = id
     - Flutter WebView listener는 위 message.type을 식별
     - 해당 ID로 detail provider 호출 후 bottom sheet 띄우기
     - 동일 마커를 반복 클릭 시 중복 bottom sheet 노출하지 않기

 [5] 반경 기준 내부 filtering 명확화
   - 반경 계산 기준 공식은 Haversine 또는 squaredDistance 기반
   - 반경(기본값) = 20km
   - 반경 내 데이터만 HTML에 포함하도록 데이터 slicing
   - 반경 외 데이터는 지도에 표시하지 않음

 [6] 지도 중심 이동 시 이벤트 반영
   - 사용자가 지도 drag → 이동된 중심 기준으로 원 재계산은 하지 않음
   - 현재 위치 버튼 클릭 시에만 업데이트
   - 지도 이동은 UI 목적, 데이터 조건까지 갱신하지 않음

 [7] bottom overflow, rebuild loop 방지
   - WebView + ConsumerStatefulWidget 조합 시
     watch() 로 변경 감지하되 map load callback 시점에만 setState 수행
   - 지도 refresh는 실제 데이터 변경 발생 시에만 수행

EXPECTED USER EXPERIENCE:
  ✔ 지도 최초 진입 시 현재 위치 기준 반경 원이 정확히 표시됨
  ✔ 반경 내 센터/정책이 바로 마커로 표시됨
  ✔ 마커 클릭 시 상세 카드 슬라이드업 표시됨
  ✔ GPS 실패 시 fallback 위치 기준 표시
  ✔ 현재 위치 업데이트는 버튼 누를 때만 수행됨
  ✔ 지도의 이동은 데이터 filtering 변화와 무관함

ACCEPTANCE CRITERIA:
  - GPS 획득 성공 → 지도 중심 = GPS
  - GPS 실패 → 지도 중심 = 경북 도청 좌표
  - 반경 원 중심과 실제 마커 중심 좌표 차 ≤ 15m
  - 반경 내 센터 목록 count == 마커 count 일치
  - markerClick 이벤트 발생 시 bottom sheet 즉시 표출
  - 동일 마커 연속 클릭 시 UI 중복 노출 없음
  - rebuild 횟수 < 3회 (initial load 기준)
  - null 좌표 센터가 HTML 혹은 지도에 절대 포함되지 않을 것
