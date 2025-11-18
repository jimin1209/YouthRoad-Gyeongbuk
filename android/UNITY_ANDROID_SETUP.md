# Unity + Flutter Android 실행 가이드

- **기본 ABI**: `unity.abis=arm64-v8a` (android/gradle.properties). `flutter build apk`나 `flutter build appbundle` 시 arm64 전용으로 빌드되어 실기기(arm64) 배포에 맞춰집니다.
- **에뮬레이터(x86_64)에서 Unity 필요 시**: Unity Export > Android Library에서 Target Architecture에 `x86_64`를 추가하고, `android/unityLibrary/src/main/jniLibs/x86_64` 및 `jniStaticLibs/x86_64`가 생성된 상태에서 `./gradlew -Punity.abis=arm64-v8a,x86_64 assembleDebug`처럼 빌드하세요. missing ABI가 있을 경우 Gradle이 친절한 메시지로 실패합니다.
- **Flutter 빌드 옵션**: 에뮬레이터를 사용하지 않는 경우 `flutter build apk --target-platform android-arm64`로 빌드하면 Unity와 동일한 ABI 구성을 강제할 수 있습니다.
- **런타임 분기**: 앱 실행 시 `device_info_plus`로 ABI/에뮬레이터 여부를 확인하며, x86_64 에뮬레이터에서는 Unity 뷰와 메시 송수신을 자동으로 비활성화합니다.
