# YouthRoad Production Hardening Plan (Current Codebase)

This plan lists the must-do items to take the current YouthRoad Flutter + Unity app to production readiness. Each item includes concrete actions and exit criteria so work can be tracked in issues or tickets.

## P0 — Ship Blockers

| Item | Actions | Exit Criteria |
| --- | --- | --- |
| API resilience | Add Dio interceptors with capped exponential backoff for 429/5xx, timeouts, and domain error mapping shared with Unity. | Contract/unit tests cover retries & timeouts; live API integration tests pass under forced 429/5xx simulations. |
| Schema drift guards | Keep tolerant JSON aliases; add contract tests for required keys and nullable handling across policies/institutions/departments. | All API model tests pass and fail fast when required fields vanish or change type. |
| Filter normalization | Centralize sanitizer for region/category/age/status/keyword + page bounds in Flutter repository and Unity sanitizer. | Mirrored Dart/Unity tests prove identical normalization; no regressions in integration tests. |
| Onboarding sync | Make onboarding selections the single source for home/recommendation queries; gate home when onboarding incomplete. | Widget/integration tests confirm filters hydrate on cold start and home is blocked until onboarding finishes. |

## P1 — Stability & Observability

| Item | Actions | Exit Criteria |
| --- | --- | --- |
| Caching & performance | Cache institutions/departments with versioned invalidation; prefetch paginated policies; offload heavy JSON to isolates where needed. | Cache hit/miss tests, scroll/prefetch tests, and frame budget benchmarks stay within targets. |
| Security & secrets | Load API key only from env/dart-define/Unity env; optional TLS pinning if supported. | CI skips gracefully when secrets are absent; secret scanning passes; optional pinning tested against pinned host. |
| Logging & metrics | Standardize structured logs (endpoint, duration, result, request id) and wire Crashlytics/Sentry breadcrumbs for API calls. | Logs visible in staging; crash/metric events include API context; smoke tests capture logs in CI. |
| CI gates | Keep split Flutter/Unity jobs; cache pub/Gradle; treat missing UNITY_LICENSE as skip with explicit summary; enforce analyzer/format/test. | CI green with caches, analyzer passes, and Unity job logs skip reason when license is missing. |

## P2 — UX & Rollout

| Item | Actions | Exit Criteria |
| --- | --- | --- |
| Error surfaces | Add user-facing retry states for list/detail; ensure accessibility and localization. | UX tests verify readable error prompts and successful retry flows. |
| Unity ↔ Flutter bridge | Define message schema so map selection updates policy queries; add integration tests for bridge events. | Selecting a region on the map updates filters in both stacks during tests. |
| Feature flags & rollout | Introduce flags for risky features (cache, retries, bridge) and phased/staged rollout. | Staged deployments verified; flags toggle behaviors without rebuilds. |

## How to use this checklist
- Create issues from each table row and track owner/ETA there.
- Keep `TESTS.md` updated when adding or moving tests; document any new secrets or licensing requirements.
- Start with P0 before enabling new features; add observability early to measure impact.
