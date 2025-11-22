import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

class YouthApiConfig {
  const YouthApiConfig({
    required this.baseUrl,
  });

  final String baseUrl;
}

abstract class YouthApiKeyProvider {
  FutureOr<String> getApiKey();
}

class EnvYouthApiKeyProvider implements YouthApiKeyProvider {
  const EnvYouthApiKeyProvider();

  @override
  FutureOr<String> getApiKey() {
    const String apiKey = String.fromEnvironment('YOUTH_API_KEY', defaultValue: '');
    return apiKey;
  }
}

final youthApiConfigProvider = Provider<YouthApiConfig>(
  (ref) => const YouthApiConfig(baseUrl: 'https://gbyouth.co.kr'),
);

final youthApiKeyProvider = Provider<YouthApiKeyProvider>(
  (ref) => const EnvYouthApiKeyProvider(),
);
