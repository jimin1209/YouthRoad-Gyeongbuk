import 'policy_region.dart';

class PolicySettings {
  final int pageSize;
  final PolicyRegion defaultRegion;
  final bool enableCache;
  final String apiKey;
  final String baseUrl;
  final Duration cacheTtl;

  const PolicySettings({
    this.pageSize = 20,
    this.defaultRegion = PolicyRegion.all,
    this.enableCache = true,
    this.apiKey = '',
    this.baseUrl = 'https://gbyouth.co.kr/openapi',
    this.cacheTtl = const Duration(hours: 1),
  });
}
