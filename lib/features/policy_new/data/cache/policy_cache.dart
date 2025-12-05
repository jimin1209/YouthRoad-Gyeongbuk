import '../../domain/entities/policy.dart';

class PolicyCache {
  /// key: scope|page 형태
  final Map<String, CachedPolicyPage> _cache = {};

  /// 기본 scope는 'default'
  String _keyForPage(int page, {String scope = 'default'}) => '$scope|$page';

  CachedPolicyPage? _getPage(String scopeKey, int page) {
    return _cache[_keyForPage(page, scope: scopeKey)];
  }

  CacheLookupResult? getPageWithStatus(
    int page,
    Duration ttl, {
    String scope = 'default',
  }) {
    final cached = _getPage(scope, page);
    if (cached == null) return null;

    return CacheLookupResult(
      data: cached.data,
      isStale: cached.isStale(ttl),
    );
  }

  /// job01 하위 호환: page만 사용하는 캐시 (scope = 'default')
  List<Policy>? getPage(int page) => _getPage('default', page)?.data;

  void savePage(int page, List<Policy> policies) {
    _cache[_keyForPage(page)] = CachedPolicyPage(
      data: policies,
      updatedAt: DateTime.now(),
    );
  }

  /// job03: PolicyQuery 기반 scope 키 사용
  List<Policy>? getPageForScope(String scopeKey, int page) {
    return _getPage(scopeKey, page)?.data;
  }

  void savePageForScope(
    String scopeKey,
    int page,
    List<Policy> policies,
  ) {
    _cache[_keyForPage(page, scope: scopeKey)] = CachedPolicyPage(
      data: policies,
      updatedAt: DateTime.now(),
    );
  }

  void clear() {
    _cache.clear();
  }
}

class CachedPolicyPage {
  CachedPolicyPage({
    required this.data,
    required this.updatedAt,
  });

  final List<Policy> data;
  final DateTime updatedAt;

  bool isStale(Duration ttl) => DateTime.now().difference(updatedAt) > ttl;
}

class CacheLookupResult {
  CacheLookupResult({
    required this.data,
    required this.isStale,
  });

  final List<Policy> data;
  final bool isStale;
}
