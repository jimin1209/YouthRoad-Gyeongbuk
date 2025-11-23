class Env {
  Env._();

  static const kakaoMapApiKey = String.fromEnvironment(
    'KAKAO_MAP_API_KEY',
    defaultValue: '',
  );

  static const chatEndpoint = String.fromEnvironment(
    'CHAT_ENDPOINT',
    defaultValue: 'https://jsonplaceholder.typicode.com/posts/1',
  );
}
