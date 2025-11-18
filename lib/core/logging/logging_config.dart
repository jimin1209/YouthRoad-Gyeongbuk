/// Centralized switches for remote logging backends so that build-time
/// configuration can select Crashlytics or Sentry without touching call sites.
class LoggingConfig {
  /// Enable Firebase Crashlytics integration at build time.
  static const bool useCrashlytics =
      bool.fromEnvironment('USE_CRASHLYTICS', defaultValue: false);

  /// Enable Sentry integration at build time.
  static const bool useSentry =
      bool.fromEnvironment('USE_SENTRY', defaultValue: false);

  /// Optional Sentry DSN provided via `--dart-define` so sensitive values stay
  /// out of source control.
  static const String sentryDsn =
      String.fromEnvironment('SENTRY_DSN', defaultValue: '');
}
