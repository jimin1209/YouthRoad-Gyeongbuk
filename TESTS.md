# Test Suite Locations and Next Steps

## Current automated tests
- **Flutter unit/integration tests** live under [`test/`](./test), covering API model decoding, repository sanitization, and live YouthRoad calls when `YOUTHROAD_API_KEY` is provided (`--dart-define`). Key files:
  - [`test/core/api/policy_models_test.dart`](./test/core/api/policy_models_test.dart)
  - [`test/features/policy/data/policy_repository_test.dart`](./test/features/policy/data/policy_repository_test.dart)
  - [`test/integration/youth_api_integration_test.dart`](./test/integration/youth_api_integration_test.dart)
- **Unity EditMode tests** live under [`unity_project/Assets/Tests/EditMode/`](./unity_project/Assets/Tests/EditMode/), including sanitizer checks and live API calls gated by the `YOUTHROAD_API_KEY` environment variable.

## CI execution
- GitHub Actions runs Flutter tests in the repository root (see [`.github/workflows/ci.yml`](./.github/workflows/ci.yml)).
- Unity EditMode tests run via `game-ci/unity-test-runner` and are skipped automatically if `UNITY_LICENSE` is not provided.

## Recommended next steps
1. **Secrets wiring:** Ensure `YOUTHROAD_API_KEY` is present in repository secrets so live integration tests execute instead of skipping.
2. **Unity license (optional):** Add `UNITY_LICENSE` to run EditMode tests; otherwise they will skip by design.
3. **Monitor CI:** Re-run the CI workflow to confirm `flutter pub get` passes with the corrected `retrofit_generator` constraint and that tests now execute rather than immediately exiting.
