# ERROR06

## 증상
- `lib/features/map_v2/kakao_map_screen.dart`에서 `CenterListBottomSheet`에 연결한 `_onCenterCardTap` 콜백이 존재하지 않아 빌드가 중단된다.
- 같은 파일에서 `KakaoMapMarker` 생성 시 `lat`/`lng` named parameter를 전달하고, `KakaoMapPolyline`에 `strokeWidth`를 넘겨 최신 시그니처와 맞지 않는다는 오류가 발생한다.
- `PolicyStatusFilter`에 `queryValue` getter가 없다고 간주되어 `base_feed_controller.dart`의 디버그 로그 문자열 보간 부분이 모두 컴파일 에러를 일으킨다.

## 원인
1. `KakaoMapMarker`가 `position: KakaoMapLatLng`을 받도록 API가 변경됐지만, 지도 화면은 여전히 `lat`/`lng` 개별 파라미터와 `marker.lat`/`marker.lng` 게터를 사용하고 있다.
2. 경로/폴리라인 관련 API도 `strokeWidth` 대신 `strokeWeight`를 사용하도록 바뀌었는데, 기존 명칭을 그대로 호출하고 있다.
3. 지도 하단 카드 클릭 시 지도를 이동/하이라이트하려는 `_onCenterCardTap` 핸들러가 선언되지 않았다.
4. `PolicyStatusFilter`의 확장에 정의된 `queryValue`를 import하지 않았거나, 확장 자체가 누락돼 상태 로그 포맷팅 시 getter를 찾지 못한다.

## 해결 방법
1. 지도 마커 생성과 좌표 변환 로직을 `position: KakaoMapLatLng(lat, lng)` 기반으로 전환하고, 폴리라인 옵션은 `strokeWeight`를 사용한다. `markers.map((m) => m.position)` 형태로 경계 계산 로직도 수정한다.
2. `_onCenterCardTap(CenterMarkerPoint center, int index)`를 `KakaoMapScreenState`에 추가해 선택한 센터 좌표로 카메라를 이동시키고, 필요하면 툴팁/선택 상태를 갱신하도록 구현한다.
3. `PolicyStatusFilter` 확장을 제공하는 `policy_status_filter.dart`를 확실히 import하거나, 확장이 없다면 해당 파일에 `queryValue` getter를 추가해 API/로그가 일관된 값을 사용하도록 만든다.

## 체크리스트
- 위 수정 후 `flutter test` 또는 `flutter build`가 `kakao_map_screen.dart`와 관련된 파라미터/게터 에러 없이 통과한다.
- 지도 카드 탭 시 카메라 이동과 툴팁 표시가 정상 동작하며, 비교/필터 관련 페이지에서 상태 로그가 깨지지 않는다.
