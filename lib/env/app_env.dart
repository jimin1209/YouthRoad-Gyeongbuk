class AppEnv {
  // Flutter build 시, --dart-define 으로 전달된 값을 읽어옵니다.
  static const youthCenterApiKey = String.fromEnvironment('YOUTH_CENTER_KEY');
  static const youthCenterApiBaseUrl = String.fromEnvironment(
    'YOUTH_CENTER_API_BASE_URL',
    defaultValue: 'https://www.youthcenter.go.kr/go/ythip',
  );
  static const youthCenterApiPath = String.fromEnvironment(
    'YOUTH_CENTER_API_PATH',
    defaultValue: '/getSpace',
  );
  static const youthApiKey = String.fromEnvironment('YOUTH_API_KEY');
  static const kakaoMapApiKey = String.fromEnvironment('KAKAO_MAP_API_KEY');
  static const kakaoRestApiKey = String.fromEnvironment('KAKAO_REST_API_KEY');
  static const chatEndpoint = String.fromEnvironment('CHAT_ENDPOINT');

  /// Kakao Map WebView baseUrl (카카오 콘솔 허용 도메인과 동일하게 설정 필요)
  static const kakaoMapBaseUrl = String.fromEnvironment(
    'KAKAO_MAP_BASE_URL',
    defaultValue: 'https://www.gbyouth.co.kr',
  );
}
