class AppEnv {
  // Flutter build 시, --dart-define 으로 전달된 값을 읽어옵니다.
  static const youthCenterApiKey = String.fromEnvironment('YOUTH_CENTER_KEY');
  static const youthApiKey = String.fromEnvironment('YOUTH_API_KEY');
  static const kakaoMapApiKey = String.fromEnvironment('KAKAO_MAP_API_KEY');
  static const kakaoRestApiKey = String.fromEnvironment('KAKAO_REST_API_KEY');
  static const chatEndpoint = String.fromEnvironment('CHAT_ENDPOINT');
}
