# Build stabilization (Flutter + Unity)

## Known blockers and mitigations

- **Missing `unityLibrary` export:** Android builds fail when the Unity export is absent because Gradle cannot resolve `:unityLibrary`. The Gradle settings and app module now gate Unity linkage on the folder being present. Export the Unity project to `unityLibrary/` when building a combined binary.
- **Firebase Android toolchain compatibility:** With `firebase_core 3.8.0` and `firebase_crashlytics 4.1.1`, keep the current Android Gradle Plugin/Kotlin versions and multidex enabled (already in `android/app/build.gradle`). Add your `google-services.json` only when assembling release builds; its absence does not block unit/widget tests.
- **Retrofit build_runner conflicts:** `retrofit 4.5.0` + `retrofit_generator 8.1.x` require regenerated stubs when models change. If build_runner throws conflicting outputs errors, run `flutter pub run build_runner build --delete-conflicting-outputs` to refresh the generated `*.g.dart` files without altering dependency versions.
