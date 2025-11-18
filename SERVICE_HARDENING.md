# YouthRoad Production Hardening Plan

This checklist focuses on bringing the YouthRoad Flutter + Unity application to production readiness. Items are organized by priority and include verification methods to make CI-friendly.

## 1) API Reliability & Resilience (P0)
- **Retry/backoff for YouthRoad endpoints**: Add Dio interceptors with capped exponential backoff for 429/5xx; propagate user-friendly errors. Verify via unit tests with fake clients and CI integration smoke tests.
- **Timeout & cancellation**: Set connect/read timeouts and ensure cancellation when views dispose. Add widget/integration tests that cancel in-flight requests without crashes.
- **Schema drift guards**: Keep tolerant JSON decoding (field aliases), plus contract tests that fail fast when required keys disappear.
- **Global error mapping**: Map HTTP/network exceptions to domain errors reused by Flutter controllers and Unity scripts.

## 2) Input & Filter Consistency (P0)
- **Single sanitizer** for region/category/age/status/keyword across Flutter repository and Unity sanitizer; enforce page bounds. Cover with mirrored unit tests on both stacks.
- **Onboarding sync**: Persist selections and hydrate home feeds on cold start; add widget/integration tests to confirm onboarding completion gate and filter propagation.

## 3) Offline & Performance (P1)
- **Caching**: Response caching for static lists (institutions/departments); memory + disk with versioned invalidation. Add cache-hit/miss tests and measure latency.
- **Pagination prefetch**: Implement paged list prefetch with graceful loading placeholders; test scroll-based fetch sequences.
- **Isolate/compute for parsing**: Move heavy JSON parsing off UI thread; benchmark with Golden/Frame tests.

## 4) Security & Secrets (P1)
- **Secret handling**: Load API key from env/dart-define/Unity env only; avoid hardcoding. Add CI checks ensuring missing secrets skip safely with logs.
- **TLS/pinning (if supported)**: Optional certificate pinning with fallback metrics; e2e test against pinned host.

## 5) Observability (P1)
- **Structured logging**: Standardize log fields (request id, endpoint, duration, result) across Flutter/Unity; add log sampling.
- **Metrics & crash reporting**: Wire Crashlytics/Sentry with breadcrumb context for API calls; add opt-in analytics for filter usage. Validate via smoke tests in CI and staging.

## 6) CI/CD & Quality Gates (P1)
- **GitHub Actions**: Keep split Flutter/Unity jobs; add pub/Gradle caches. Treat Unity license absence as skip with explicit summary. Fail on analyzer/lint/test; add minimal integration tests behind secrets.
- **Static analysis**: Enforce `flutter analyze`, Dart/Unity formatters, and security linters. Add pre-commit configs and CI steps.
- **Release gating**: Add staging deployment workflow and app bundle signing checks.

## 7) UX & State Robustness (P2)
- **Error surfaces**: User-facing error states with retry for lists/detail; UX tests to ensure accessible messaging.
- **State consistency**: Centralized store for filters/bookmarks; concurrency-safe updates; widget tests for rapid navigation.
- **Unity ↔ Flutter bridge**: Define message schema for map selection → policy query; write integration tests for bridge events.

## 8) Documentation & Runbooks (P2)
- **TESTS.md updates**: Keep instructions for running unit/integration tests with required secrets/licenses.
- **Incident playbooks**: Document steps for API outage, key rotation, and cache invalidation.

## 9) Rollout Strategy (P2)
- **Feature flags** for risky changes (e.g., cache, retries, map sync); manage via remote config or build-time toggles.
- **A/B or phased rollouts** to measure latency/error impacts before full release.

Use this plan to prioritize the next sprints; start with P0 items to stabilize network paths and filter/state correctness, then proceed to performance, observability, and UX polish.
