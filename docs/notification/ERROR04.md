# ERROR04

## 증상
- 빌드 시 `lib/features/map_v2/kakao_map_screen.dart`의 `_highlightCenterMarker` 선언부에서 `Expected ')'` 구문 오류가 발생한다.
- 오류 메시지는 `{String? tooltipName},` 근처에서 괄호가 닫히지 않았음을 지적한다.

## 원인
- 위치 매개변수 `KakaoMapLatLng position` 뒤에 쉼표가 없으면 `{String? tooltipName}`가 별도 매개변수 목록으로 해석되지 않아 Dart 파서가 `)`를 기대한다.

## 해결 방법
1. 파일 `lib/features/map_v2/kakao_map_screen.dart`의 `_highlightCenterMarker` 선언부를 아래처럼 수정한다.

   **수정 전**
   ```dart
   Future<void> _highlightCenterMarker(
     String markerId,
     KakaoMapLatLng position
     {String? tooltipName},
   ) async {
   }
   ```

   **수정 후**
   ```dart
   Future<void> _highlightCenterMarker(
     String markerId,
     KakaoMapLatLng position,
     {String? tooltipName},
   ) async {
   }
   ```

2. 쉼표 추가 후 `flutter build` 또는 `flutter analyze`를 실행해 구문 오류가 사라졌는지 확인한다.

## 체크리스트
- `_highlightCenterMarker`의 위치/선택적 매개변수 사이에 쉼표가 추가되어 있는지 확인한다.
- 빌드 명령(`flutter build`·`flutter analyze`)이 구문 오류 없이 완료되는지 확인한다.
