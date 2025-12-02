import '../../domain/entities/policy.dart';

class PolicyCache {
  /// key: scope|page 형태
  final Map<String, List<Policy>> _cache = {};

  /// 기본 scope는 'default'
  String _keyForPage(int page, {String scope = 'default'}) => '$scope|$page';

  /// job01 하위 호환: page만 사용하는 캐시 (scope = 'default')
  List<Policy>? getPage(int page) => _cache[_keyForPage(page)];

  void savePage(int page, List<Policy> policies) {
    _cache[_keyForPage(page)] = policies;
  }

  /// job03: PolicyQuery 기반 scope 키 사용
  List<Policy>? getPageForScope(String scopeKey, int page) {
    return _cache[_keyForPage(page, scope: scopeKey)];
  }

  void savePageForScope(
    String scopeKey,
    int page,
    List<Policy> policies,
  ) {
    _cache[_keyForPage(page, scope: scopeKey)] = policies;
  }

  void clear() {
    _cache.clear();
  }
}
