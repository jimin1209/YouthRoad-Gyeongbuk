class Env {
  Env._();

  static const kakaoMapApiKey = String.fromEnvironment(
    'KAKAO_MAP_API_KEY',
    defaultValue: '',
  );

  static const chatEndpoint = String.fromEnvironment(
    'CHAT_ENDPOINT',
    defaultValue: '',
  );

  static const youthApiKey = String.fromEnvironment(
    'YOUTH_API_KEY',
    defaultValue: '',
  );

  static const policyApiBaseUrl = String.fromEnvironment(
    'POLICY_API_BASE_URL',
    defaultValue: 'https://worker.youthroad-chat.workers.dev',
  );
}
