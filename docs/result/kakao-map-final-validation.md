# Kakao Map Final Validation (GEORECOVER-CENTER-MARKER)

본 문서는 지오코딩 캐시 초기화 후 센터 마커가 정상 표시되는지 수동 검증할 때 사용할 체크리스트입니다. 실제 단말/에뮬레이터에서 아래 순서대로 수행해 주세요.

## 1) 캐시 초기화
```bash
adb shell pm clear com.youthroad.app
```

## 2) 실행 및 로그 수집
- 앱 실행 후 Logcat/콘솔에서 아래 로그가 순서대로 찍히는지 확인:
  - `[YCMAP] geocode requested` (지오코딩 호출 시작)
  - `[YCMAP] geocode -> ... (lat, lng)` 또는 유사 성공 로그
  - `[YCMAP] markerPoints length = N` (캐시에 기록된 수가 1 이상)
  - `[YCMAP] centerPoints=... validCenters=...`
  - `[YCMAP] centerMarkers=... policyMarkers=... merged=...`

## 3) 지도 화면 검증
- CENTER 마커가 지도에 표시됨
- CENTER 마커 탭 시 BottomSheet가 뜨고 다음 필드가 노출됨:
  - name
  - fullAddress
  - phone (전화 탭 시 dialer 호출)
  - homepageUrl (외부 브라우저 열림)
  - regionLabel
- CENTER 마커가 1개 이상이면 폴리라인이 비활성화되어야 함 (policy 마커만 있을 때만 폴리라인 표시)

## 4) 캡처 기록
- 로그 스크린샷 1장 이상 (위 YCMAP 로그 포함)
- 지도에 CENTER 마커가 표시된 화면 1장
- CENTER BottomSheet가 열린 화면 1장

## 5) 기록 (직접 입력)
- centerPoints: ______
- validCenters: ______
- policyMarkers: ______
- merged: ______
- 폴리라인 상태: □ 비활성(센터 있음) / □ 활성(센터 없음)
- 특이사항: ________________________________________________________
