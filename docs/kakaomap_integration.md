# Kakao Map WebView 도메인 설정 가이드

## 증상
- WebView 콘솔에 `AccessDeniedError: domain mismatched! caller=android-app:.` 등의 메시지가 반복 출력됨.
- Kakao JS SDK가 등록된 웹 도메인과 호출 Origin이 일치하지 않을 때 발생.

## 필수 설정 (Kakao Developers 콘솔)
1. [Kakao Developers](https://developers.kakao.com/) → 내 애플리케이션 → 플랫폼 → **Web** 탭.
2. `https://dapi.kakao.com` 호출 시 Referer 로 전달되는 Origin을 등록:
   - 안드로이드 앱: `android-app://com.youthroad.app`
   - 필요 시 개발용 서브 도메인/테스트 URL도 함께 등록.
3. 사용 키는 **JavaScript 키**를 사용해야 하며, Native/REST 키를 넣으면 동작하지 않음.

## 코드 내 진단 포인트
- `lib/features/map_v2/kakao_map_html_builder.dart`에서 WebView 로드 시 `href / origin / referrer`를 로그로 전송합니다.
- Flutter 로그에서 `[KakaoMap][origin]` 로그를 확인해 실제 Referer 값을 확인하고 콘솔 등록 값과 일치하는지 점검합니다.

## 정리
- 콘솔에 등록된 웹 도메인과 WebView의 Origin이 정확히 일치해야 Kakao JS SDK가 정상 동작합니다.
- 도메인 수정 후에도 문제가 지속되면 로그에 출력되는 Origin 값을 기준으로 다시 콘솔 설정을 확인하세요.
